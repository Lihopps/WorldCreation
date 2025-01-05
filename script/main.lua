local util=require("util.util")

local main={}

function main.on_init()
    settings.global["visible-planets-enable-rotation"].value=false
end

function main.on_configuration_changed(e)
    
end

main.events={

}

return main
