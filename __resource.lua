  
resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

client_scripts {'config.lua',
                "nui.lua",
                "visualsettings.dat",
                "client.lua"
            }
server_scripts {"server.lua"}

ui_page "html/index.html"
files {
    "html/img/*.png",
    'html/index.html',
    'html/index.js',
    'html/index.css',
    'html/reset.css',
}