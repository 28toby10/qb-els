local display = true
local hardclose = false
local kleur = {}
local activatie = nil
local groen,werk,oranje,blauw = false,false,false,false
local laatsteVeh = nil
local sirene = false
local count_bcast_timer = 0
local delay_bcast_timer = 200

local count_sndclean_timer = 0
local delay_sndclean_timer = 400

local actv_ind_timer = false
local count_ind_timer = 0
local delay_ind_timer = 180

local actv_lxsrnmute_temp = false
local srntone_temp = 0
local dsrn_mute = true

local state_indic = {}
local state_lxsiren = {}
local state_pwrcall = {}
local state_airmanu = {}

local ind_state_o = 0
local ind_state_l = 1
local ind_state_r = 2
local ind_state_h = 3

local snd_lxsiren = {}
local snd_pwrcall = {}
local snd_airmanu = {}
local biep = false
local koranje = 118 -- NUMPAD 9
local kblauw = 117 -- NUMPAD 7
local kgroen = 97 -- NUMPAD +
local ksirene = 111 -- NUMPAD 8
local kwerk = 96 -- NUMPAD -
local kstop = 110 -- NUMPAD 5
local kstop2 = 109 -- NUMPAD 6
local kvolg = 108 -- NUMPAD 4
local kpitje = 208 -- PAGE UP
local tmprst = false
local lastupdatenui = true
local lastvoertuig = nil
-- RegisterCommand("elsmuis", function(source, args)
--     SetNuiFocus(false,true)
--     -- SetDisplay(not display)
-- end)
RegisterCommand("toggleELS", function(source, args)
   
    if hardclose then
        hardclose = false
    else
        hardclose = true
    end
    --print(hardclose)
end)
--very important cb 

RegisterNetEvent("qb-els:mn:checks")
AddEventHandler("qb-els:mn:checks",function()
    if hardclose and tmprst then
        hardclose = false
        tmprst = false
    end
end)

RegisterNetEvent("qb-els:mn:hideui")
AddEventHandler("qb-els:mn:hideui",function()
    if not hardclose then
        tmprst = true
        hardclose = true
    end
end)

RegisterNetEvent('qb-els:mn:resetui')
AddEventHandler('qb-els:mn:resetui', function()
    SetNuiFocus(false, false)
    hardclose = false
    tmprst = false
end)

-- this cb is used as the main route to transfer data back 
-- and also where we hanld the data sent from js
RegisterNUICallback("main", function(data)
    chat(data.text, {0,255,0})
    SetDisplay(false)
end)

RegisterNetEvent("qb-els:lichten")
AddEventHandler("qb-els:lichten",function(lichten,voertuig)
    local vehname = GetEntityModel(voertuig)
    SetVehicleAutoRepairDisabled(voertuig,true)
    for k,v in ipairs(Config.voertuigen) do
        if vehname == GetHashKey(v.model) then
            if #v['blauw'] == 0 and lichten == 'blauw' then
                if kleur['blauw'] then
        
                kleur['blauw'] = false
                kleur['sirene'] = false
                sirene = false
                else
                
                    kleur['blauw'] = true
                end
            else
                
                PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
                if lichten == 'sirene' then
                    lichten = 'blauw'
                    if sirene then
                        SetLxSirenStateForVeh(voertuig, 0)
                        sirene = false
                        kleur['sirene'] = false
                        state_lxsiren[voertuig] =false
                    else
                    SetLxSirenStateForVeh(voertuig, 1)
                    sirene = true
                    kleur['sirene'] = true
                    state_lxsiren[voertuig] =true
                    end
                    for i=1, #v[lichten], 1 do
                            SetVehicleExtra(voertuig,v[lichten][i],0)
                    end	
                    kleur['blauw'] = true
                else
                    if lichten == 'blauw' and sirene then
                    SetLxSirenStateForVeh(voertuig, 0)
                    state_lxsiren[voertuig] =false
                    sirene = false 
                    kleur['sirene'] = false
                    end

                    if v[lichten] ~= nil then
                    for i=1, #v[lichten], 1 do
                        if IsVehicleExtraTurnedOn(voertuig,v[lichten][i])then
                            kleur[lichten] = false 
                            SetVehicleExtra(voertuig,v[lichten][i],1)
                        else
                            kleur[lichten]=true    
                            SetVehicleExtra(voertuig,v[lichten][i],0)
                   
                        end
                    end	
                end
                 end
                 if kleur['volgachter'] or kleur['stopvoor'] then
                    biep = true
                else
                    biep = false 
                end
                count_bcast_timer = delay_bcast_timer
            end
            end

           
    end
    if kleur['blauw'] or kleur['stopachter'] or kleur['stopvoor'] or kleur['volgachter'] or kleur['groen'] or kleur['oranje'] or kleur['werk'] then
        SetVehicleSiren(voertuig, true)
    else
        SetLxSirenStateForVeh(voertuig, 0)
        SetVehicleSiren(voertuig, false)
    end
end)

RegisterNUICallback("toggle", function(data)
    local playerped = PlayerPedId()		
	if IsPedInAnyVehicle(playerped, false) then	
        local veh = GetVehiclePedIsUsing(playerped)	
        
        if GetPedInVehicleSeat(veh, -1) == playerped then
            SetVehicleAutoRepairDisabled(veh,true)
            if GetVehicleClass(veh) == 18 then
                TriggerEvent("qb-els:lichten",data.value,veh)
            end
        end
    end
end)

RegisterNUICallback("error", function(data)
    chat(data.error, {255,0,0})
    SetDisplay(false)
end)

function SetDisplay(bool)
    display = bool
    SetNuiFocus(bool,bool)
    SendNUIMessage({
        type = "ui",
        status = bool,
    })
end
local clsdoprn = false
function SetDisplay2(bool,kleur,voertuig)
    display = bool
    if lastvoertuig ~= voertuig then
        local vehname = GetEntityModel(voertuig)
        for k,v in ipairs(Config.voertuigen) do
            if vehname == GetHashKey(v.model) then
                scherm = v.controller
                lastvoertuig = v.controller
                break
            end
        end
    else
        scherm = lastvoertuig
    end
    if lastupdatenui or bool ~= clsdoprn then
        SendNUIMessage({
            type = "ui",
            status = bool,
            kleur=kleur,
            scherm=scherm,
        })
        lastupdatenui = false
        clsdoprn = bool
    end
end

RegisterNetEvent("qb-els:lichtenForceC")
AddEventHandler("qb-els:lichtenForceC",function(voertuig)
CheckLichten(veh)
end)

function CheckLichten (veh)
    local vehname = GetEntityModel(veh)
   
    if IsVehicleSirenOn(veh) then
        
        for k,v in ipairs(Config.voertuigen) do
            if state_lxsiren[veh] ~= nil then
                if state_lxsiren[veh] ~= true then
                    kleur['sirene'] = false
                else
                    kleur['sirene'] = true
                end
            end
            if vehname == GetHashKey(v.model) then
                if #v.blauw ~= 0 then
                    for i=1, #v.blauw, 1 do
                        if IsVehicleExtraTurnedOn(veh,v.blauw[i])then
                            kleur['blauw'] = true
                            
                        break
                        else
                            kleur['blauw'] = false
                        end
                    end
                else   
                    kleur['blauw'] = false
                end 

                if #v.groen ~= 0 then
                for i=1, #v.groen, 1 do
                    if IsVehicleExtraTurnedOn(veh,v.groen[i])then
                        kleur['groen'] = true
                    break
                    else
                        kleur['groen'] = false
                    end
                end
                else   
                    kleur['groen'] = false
                end 
                if #v.oranje ~= 0 then
                    for i=1, #v.oranje, 1 do
                        if IsVehicleExtraTurnedOn(veh,v.oranje[i])then
                            kleur['oranje'] = true
                        break
                        else
                            kleur['oranje'] = false
                        end
                    end
                end
                if #v.werk ~= 0 then
                    for i=1, #v.werk, 1 do
                        if IsVehicleExtraTurnedOn(veh,v.werk[i])then
                            kleur['werk'] = true
                        break
                        else
                            kleur['werk'] = false
                        end
                    end
                else   
                    kleur['werk'] = false
                end 
                if v.stopvoor ~= nil then
                if #v.stopvoor ~= 0  then
                    for i=1, #v.stopvoor, 1 do
                        if IsVehicleExtraTurnedOn(veh,v.stopvoor[i])then
                            kleur['stopvoor'] = true
                            --print(kleur['stopvoor'])
                            biep = true
                        break
                        else
                            kleur['stopvoor'] = false
                            biep = false
                        end
                    end
                else
                    kleur['stopvoor'] = false
                    biep = false
                end
            end
            if v.volgachter ~= nil then
                if #v.volgachter ~= 0 then
                    for i=1, #v.volgachter, 1 do
                        if IsVehicleExtraTurnedOn(veh,v.volgachter[i])then
                            kleur['volgachter'] = true
                            biep = true
                        break
                        else
                            kleur['volgachter'] = false
                            biep = false
                        end
                    end
                else   
                    kleur['volgachter'] = false
                    biep = false
                end 
            end
                if v.stopachter ~= nil then
                if #v.stopachter ~= 0 then
                    for i=1, #v.stopachter, 1 do
                        if IsVehicleExtraTurnedOn(veh,v.stopachter[i])then
                            kleur['stopachter'] = true
                            
                        break
                        else
                            kleur['stopachter'] = false
                           
                        end
                    end
                else   
                    kleur['stopachter'] = false
                    biep = false
                end 
            end
            end

        end
    else
       
        for i=1,12,1 do
            if DoesExtraExist(veh,i) then
            if IsVehicleExtraTurnedOn(veh,i) then
                SetVehicleExtra(veh,i,1)
            end
        end
        
        end
        for k,v in ipairs(Config.voertuigen) do
            if GetHashKey(v.model) == vehname then
                if v.extraOn ~= nil then
                    if #v.extraOn > 0 then
                        for i=1,#v.extraOn,1 do
                            SetVehicleExtra(veh,v.extraOn[i],0)
                        end
                    end
                end
            end
        end
        kleur = {}
    end
end

local curplyrped = nil
local curplyrinveh = nil
local curplyrveh = nil
Citizen.CreateThread(function()
	while true do
		curplyrped = PlayerPedId()
		curplyrinveh = IsPedInAnyVehicle(curplyrped, false)
		curplyrveh = GetVehiclePedIsUsing(curplyrped)	
		Citizen.Wait(2000)
	end
end)

Citizen.CreateThread(function()
    while true do
        if curplyrped ~= nil and curplyrveh ~= nil and (curplyrinveh ~= nil and curplyrinveh) then
            local veh = curplyrveh	
            if hardclose ~= true then
                    local vehname = GetEntityModel(veh)
                    if GetPedInVehicleSeat(veh, -1) == curplyrped then
                        if GetVehicleClass(veh) == 18 then
                            DisableVehicleImpactExplosionActivation(veh,true)
                            if laatsteVeh ~= GetVehicleIndexFromEntityIndex(veh) then
                                laatsteVeh = GetVehicleIndexFromEntityIndex(veh)
                                CheckLichten(veh)  
                            end
                            if kleur['blauw'] ~= true then
                                SetVehicleRadioEnabled(veh, true)
                            else
                                SetVehRadioStation(veh, "OFF")
                                SetVehicleRadioEnabled(veh, false)
                            end
                            SetDisplay2(true,kleur,veh)
                            --lastupdatenui = true
                        end
                    end
                else
                SetDisplay2(false,false,false)
                --lastupdatenui = true
            end
            if GetPedInVehicleSeat(veh, -1) == curplyrped then
                if IsControlJustReleased(0,koranje) and GetLastInputMethod(2) then
                    TriggerEvent("qb-els:lichten",'oranje',veh)
                    lastupdatenui = true
                end
                if IsControlJustReleased(0,kblauw) and GetLastInputMethod(2) then
                    TriggerEvent("qb-els:lichten",'blauw',veh) 
                    lastupdatenui = true
                end
                if IsControlJustReleased(0,ksirene) and GetLastInputMethod(2) then
                    TriggerEvent("qb-els:lichten",'sirene',veh)
                    lastupdatenui = true
                end
                if IsControlJustReleased(0,kstop) and GetLastInputMethod(2) then
                    TriggerEvent("qb-els:lichten",'stopvoor',veh)
                    lastupdatenui = true
                end
                if IsControlJustReleased(0,kwerk) and GetLastInputMethod(2) then
                    TriggerEvent("qb-els:lichten",'werk',veh)
                    lastupdatenui = true
                end
                if IsControlJustReleased(0,kvolg) and GetLastInputMethod(2) then
                    TriggerEvent("qb-els:lichten",'volgachter',veh)
                    lastupdatenui = true
                end
                if IsControlJustReleased(0,kpitje) and GetLastInputMethod(2) then
                    TriggerEvent("qb-els:pitje",veh)
                    lastupdatenui = true
                end
                if IsControlJustReleased(0,kgroen) and GetLastInputMethod(2) then
                    TriggerEvent("qb-els:lichten",'groen',veh)
                    lastupdatenui = true
                end
                if IsControlJustReleased(0,kstop2) and GetLastInputMethod(2) then
                    TriggerEvent("qb-els:lichten",'stopachter',veh)
                    lastupdatenui = true
                end
            end
        else
            SetDisplay2(false, kleur)
            Citizen.Wait(500)
        end
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('qb-els:pitje')
AddEventHandler('qb-els:pitje',function(veh)
    local vehname = GetEntityModel(veh)
    for k,v in ipairs(Config.voertuigen) do
        if GetHashKey(v.model) == vehname then
            if v.pitje ~= nil then
                if #v.pitje > 0 then
                    for i=1,#v.pitje,1 do
                        if IsVehicleExtraTurnedOn(veh,v.pitje[i]) then
                            SetVehicleExtra(veh,v.pitje[i],1)
                        else
                            SetVehicleExtra(veh,v.pitje[i],0)
                        end
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
	while true do
        if curplyrped ~= nil and curplyrveh ~= nil and curplyrinveh ~= nil then
            if curplyrinveh then
                local veh = curplyrveh
                local vehname = GetEntityModel(veh)
                if GetPedInVehicleSeat(veh, -1) == curplyrped then
                    if GetVehicleClass(veh) == 18 then
                        if biep then
                            TriggerServerEvent('InteractSound_SV:PlayWithinDistance',1.0, 'beep', 0.05)
                            Citizen.Wait(500)
                        end
                    end
                end
            end
            Citizen.Wait(500)
        else
            Citizen.Wait(2000)
        end
    end
end)