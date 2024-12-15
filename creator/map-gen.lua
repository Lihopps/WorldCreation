local default_map_gen_settings=require("__base__/prototypes/planet/planet-map-gen")

local blacklist={
    nauvis=true,
    vulcanus=true,
    gleba=true,
    fulgora=true,
    aquilo=true,
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

local function create_standard_map_gen_settings()
    return default_map_gen_settings.nauvis()
end 


local map_gen={}

function map_gen.clear_and_collect()
    --recuperer les map_gen
    --supprimer toutes les planets/space-location et space-connection sauf nauvis et cie
    local global_map_gen={}
    for name,planet in pairs(data.raw.planet) do
        global_map_gen[name]=planet.map_gen_settings or create_standard_map_gen_settings()
        if not blacklist[name] then
            data.raw.planet[name]=nil
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
    return global_map_gen
end


return map_gen

