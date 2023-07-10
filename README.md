# Emergency lights script (standalone)

## Commands:
/toggleELS - Showing/hiding the ELS panel in the right bottom of your screen

## Controls:
`NUMPAD 7` - Blue lights </br>
`NUMPAD 8` - Siren </br>
`NUMPAD 9` - Orange lights

`NUMPAD 4` - Follow sign in the back </br>
`NUMPAD 5` - Stop sign in the front </br>
`NUMPAD 6` - Stop sign in the back

`NUMPAD -` - (white) work lights </br>
`NUMPAD +` - Green lights

`PAGE UP` - Enable/ disable pit

## Config.voertuigen
```
Config.voertuigen = {
    {
        model = 'vehicle_name',     -- spawn name
        blauw = {},                 -- blue lights
        groen = {},                 -- green lights
        oranje = {},                -- orange lights
        werk = {},                  -- white lights/ search lights
        volgachter = {},            -- follow sign in the back (police vehicle)
        stopvoor = {},              -- stop sign in the front (police vehicle)
        stopachter = {},            -- stop sign in the back (police vehicle)
        pitje = {},                 -- for enabeling/ disabeling the pit in the roof (police vehicle)
        sirene = '',                -- politie/ambulance
        controller = '',            -- politie/ambulance
    },
}
```
