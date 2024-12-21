local star=require("creator.star")

local update={}

function update.update(galaxy_objects)
    galaxy_objects["lihop-system-Calidus"] = { name = "lihop-system-Calidus", localised_name = "Calidus", position = { x = 0, y = 0 }, location = { distance = 0, angle = 0 }, children = {}, star_temperature = 140 }
    table.insert(galaxy_objects["lihop-system-Calidus"].children, star.make_star(galaxy_objects["lihop-system-Calidus"]))
    table.insert(galaxy_objects["lihop-system-Calidus"].children,
    {
      type = "space-connection",
      name = "lihop-star-Calidus" .. "-to-" .. "vulcanus",
      subgroup = "lihop-system-Calidus",
      from = "lihop-star-Calidus",
      to = "vulcanus",
      order = "[d]",
      length = 20000,
      asteroid_spawn_definitions =nil
    })

    data.raw.planet["vulcanus"].subgroup="lihop-system-Calidus"
    data.raw.planet["vulcanus"].order="1[1]"
    data.raw.planet["nauvis"].subgroup="lihop-system-Calidus"
    data.raw.planet["nauvis"].order="1[2]"
    data.raw.planet["gleba"].subgroup="lihop-system-Calidus"
    data.raw.planet["gleba"].order="1[3]"
    data.raw.planet["fulgora"].subgroup="lihop-system-Calidus"
    data.raw.planet["fulgora"].order="1[4]"
    data.raw.planet["aquilo"].subgroup="lihop-system-Calidus"
    data.raw.planet["aquilo"].order="1[5]"
    data.raw["space-location"]["solar-system-edge"].subgroup="lihop-system-Calidus"
    data.raw["space-location"]["solar-system-edge"].order="[c]0"
    data.raw["space-location"]["shattered-planet"].subgroup="lihop-system-Calidus"
    data.raw["space-location"]["shattered-planet"].order="[c]1"
    
    local connection ={
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
    for name,_ in pairs(connection) do
        data.raw["space-connection"][name].subgroup="lihop-system-Calidus"
        data.raw["space-connection"][name].order="[d]"
    end
    
end

return update