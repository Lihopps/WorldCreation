local coord =require("util.coordonnee")

local test={}


function test.on_entity_build(e)
    local surface=e.entity.surface
    local mgs=surface.map_gen_settings
    local json=helpers.table_to_json(mgs)
    helpers.write_file("map.json",json)

    local c=surface.get_resource_counts()
    json=helpers.table_to_json(c)
    helpers.write_file("c.json",json)
end

function test.test()
    game.print(math.fmod(1.12,1))

end

return test