# Emergency lights script (standalone)

## Commands:
/toggleELS - Showing/hiding the ELS panel in the right bottom of your screen

## Config.voertuigen
```
Config.voertuigen = {
    {
        model = 'vehicle_name', 
        blauw = {}, -- blue lights
        groen = {}, -- green lights
        oranje = {}, -- orange lights
        werk = {}, -- white lights/ search lights
        volgachter = {}, -- follow sign in the back (police vehicle)
        stopvoor = {}, -- stop sign in the front (police vehicle)
        stopachter = {}, -- stop sign in the back (police vehicle)
        -- extraOn ={},
        pitje = {}, -- for enabeling/ disabeling the pit in the roof (police vehicle)
        sirene = '', -- politie/ambulance
        controller = '', -- politie/ambulance
    },
}
```
