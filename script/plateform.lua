local util=require("util.util")

local function change_state_plasma_havester(platforme,state)
    local filter={ name = {"lihop-harvester-plasma"}}
    local harvesters=platforme.surface.find_entities_filtered(filter) 
    if not harvesters then return end
    for _,harvester in pairs(harvesters) do
        harvester.active=state
    end
end

local function set_recipe(platforme,n)
    local filter={ name = {"lihop-harvester-heavy","lihop-harvester-light"}}
    local harvesters=platforme.surface.find_entities_filtered(filter) 
    if not harvesters then return end
    for _,harvester in pairs(harvesters) do
        if n==0 then
            --game.print(platforme.space_location.localised_description)
            local fluids=util.split(platforme.space_location.localised_description,"\n")
            if util.split(harvester.name,"-")[3]=="heavy" then
                local recipe_name=util.split(fluids[1],"=")[2]
                recipe_name="lihop-harvesting-" .. util.split(recipe_name,"]")[1]
                harvester.set_recipe(recipe_name)
            else
                --game.print(fluids[2])
                if fluids[2] then
                    
                    local recipe_name=util.split(fluids[2],"=")[2]
                    recipe_name="lihop-harvesting-" .. util.split(recipe_name,"]")[1]
                    harvester.set_recipe(recipe_name)
                else
                    harvester.clear_fluid_inside()
                    harvester.set_recipe()
                end
            end
        else
            harvester.clear_fluid_inside()
            harvester.set_recipe()
        end
    end

end

local function on_space_platform_changed_state(e)
    local platforme=e.platform
    if not platforme then return end
    if platforme.space_location then 
        if string.find(platforme.space_location.name,"lihopgazeous")  then
            set_recipe(platforme,0)
        elseif string.find(platforme.space_location.name,"lihopstar-") then
            change_state_plasma_havester(platforme,true)
        else
            --reset factories
            set_recipe(platforme,1)
            change_state_plasma_havester(platforme,false)
        end
    else
        --reset factories
        set_recipe(platforme,1)
        change_state_plasma_havester(platforme,false)

    end
end



local plateform={}


plateform.events={
	[defines.events.on_space_platform_changed_state]=on_space_platform_changed_state,

}

return plateform