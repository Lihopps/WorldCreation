local util=require("util.util")

local main={}

function main.on_init()
    util.set_size({surface_index="nauvis"})
end

function main.on_configuration_changed(e)
    
end

main.events={

}

return main
