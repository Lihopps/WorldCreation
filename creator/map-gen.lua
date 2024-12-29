local util=require("util.util")
local default_map_gen_settings=require("__base__/prototypes/planet/planet-map-gen")

local blacklist={
    nauvis=true,
    vulcanus=true,
    gleba=true,
    fulgora=true,
    aquilo=true,
    ["space-location-unknown"]=true,
    ["solar-system-edge"]=true,
    ["shattered-planet"]=true,
    ["nauvis-vulcanus"]=true,
    ["nauvis-gleba"]=true,
    ["nauvis-fulgora"]=true,
    ["vulcanus-gleba"]=true,
    ["gleba-fulgora"]=true,
    ["gleba-aquilo"]=true,
    ["fulgora-aquilo"]=true,
    ["aquilo-solar-system-edge"]=true,
    ["solar-system-edge-shattered-planet"]=true,
}

local spawn_base={
    ["vulcanus"]={max=300,min=150,weight=2},
    ["gleba"]={max=175,min=75,weight=1},
    ["nauvis"]={max=125,min=25,weight=2},
    ["fulgora"]={max=125,min=25,weight=1},
    ["aquilo"]={max=30,min=0,weight=1},
}


local function update_by_mod(global_map_gen)
    --base mod (i.e calidus system)
    --if not global_map_gen.planet["gazeous"] then global_map_gen.planet["gazeous"]={} end
    for name,data in pairs(spawn_base) do
        if global_map_gen.planet[name] then
            global_map_gen.spawn_data[name]=data
            if not global_map_gen.graphics[name] then
                global_map_gen.graphics[name]={}
            end
            table.insert(global_map_gen.graphics[name],{
                icon=global_map_gen.planet[name].icon,
                starmap_icon = global_map_gen.planet[name].starmap_icon,
                starmap_icon_size = global_map_gen.planet[name].starmap_icon_size,
            })
        end
    end

    -- add mod
    if mods["tintin"] then

    end
    
    ---get le global graphics
    for name,graphics_data in pairs(worldCreation_planet_graphics) do
        if not global_map_gen.graphics[name] then
            global_map_gen.graphics[name]={}
        end
        for i=1,#graphics_data do
        table.insert(global_map_gen.graphics[name],{
            icon=graphics_data[i].icon,
            starmap_icon = graphics_data[i].starmap_icon,
            starmap_icon_size = graphics_data[i].starmap_icon_size,
        })
        end
    end

    -- make consistancy (for each spawn_data check if planet sinon on deletes)
    for name,spawn_d in pairs(global_map_gen.spawn_data) do
        if not global_map_gen.planet[name] then
            global_map_gen.spawn_data[name]=nil
        end
    end

    return global_map_gen
end



local map_gen={}

function map_gen.get_size_from_planet_magnitude(magnitude)
    return util.constraints(util.map(magnitude,0.95,1.2,5000,20000),1000,50000)
end

function map_gen.get_temp_by_distance(system,distance_from_parent,type)
    -- temp=-a*pos+b
    -- pos=0 => b = system.star_temperature  
    -- pos = 50 (edge)  => temp = 0  ==> a*50=system.star_temperature 
    if type=="exp" then
        local b=system.star_temperature
        local a=0.11
        local c=0.12
        return b*math.exp(-c*distance_from_parent)
    else
        local b=system.star_temperature
        local a=system.star_temperature/50
        return -a*distance_from_parent+b
    end
end

function map_gen.get_solar_power_in_space(system,distance_from_parent)
    local temp=map_gen.get_temp_by_distance(system,distance_from_parent,"exp")
    local power=util.map(temp,100,300,600,1500)
    return math.floor(power)--util.map(distance_from_parent,0,50,temp,1)
end

function map_gen.get_solar_power_surface(system,distance_from_parent,gen)
    local power_in_space=map_gen.get_solar_power_in_space(system,distance_from_parent)
    local power = util.constraints(power_in_space-gen:random(50,200),1,10000000)
    return math.floor(power)
end


function map_gen.get_planet_type(global_map_gen,system,distance_from_parent,gen)
    local temp=map_gen.get_temp_by_distance(system,distance_from_parent,"linear")
    local planets={}
    for name,spawn_data in pairs(global_map_gen.spawn_data) do
        if temp>=spawn_data.min and temp<=spawn_data.max then
            for i=0,spawn_data.weight do
                table.insert(planets,name)
            end
        end
    end
    return planets[gen:random(1,#planets)]
end


function map_gen.clear_and_collect()
    --recuperer les map_gen
    --supprimer toutes les planets/space-location et space-connection sauf nauvis et cie
    local global_map_gen={planet={},spawn_data={},graphics={}} --planet : string=>planetprototype,spawn_data : string=>{max,min,weight}, graphics : string =>{icon,starmap_icon,size}
    for name,planet in pairs(data.raw.planet) do
        global_map_gen.planet[name]=table.deepcopy(data.raw.planet[name])
        if not blacklist[name] then
            data.raw.planet[name]=nil
        else
            data.raw.planet[name].surface_properties["size_surface"]=map_gen.get_size_from_planet_magnitude(data.raw.planet[name].magnitude)
        end
    end
    for name,_ in pairs(data.raw["space-connection"]) do
        if not blacklist[name] then
            data.raw["space-connection"][name]=nil
        end
    end
    for name,_ in pairs(data.raw["space-location"]) do
        if not blacklist[name] then
            data.raw["space-location"][name]=nil
        end
    end
    global_map_gen=update_by_mod(global_map_gen)

    return global_map_gen
end

function map_gen.tweak(map_gen_settings)
    local mgs=table.deepcopy(map_gen_settings)
    mgs.autoplace_settings["entity"].treat_missing_as_default=false
    if math.random()<0.1 then
   
        mgs.autoplace_controls["holmium-ore"]={}
        mgs.autoplace_settings["entity"]["settings"]["holmium-ore"]={}
        mgs.autoplace_controls["sulfur"]={}
        mgs.autoplace_settings["entity"]["settings"]["sulfur"]={}
    end

    return mgs
end

function map_gen.get_gazeous_field(gen)
    local light = worldCreation_gazeous_field["light"][gen:random(1,#worldCreation_gazeous_field["light"])]
    local heavy =worldCreation_gazeous_field["heavy"][gen:random(1,#worldCreation_gazeous_field["heavy"])]
    local str_l="[fluid="..light.."]"
    local str_h="[fluid="..heavy.."]"
    return str_h.."\n"..str_l
end

return map_gen

