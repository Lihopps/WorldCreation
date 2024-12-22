local function color_sprites(array, tint)
    for _, dat in pairs(array) do
        if dat.layers then
            color_sprites(dat.layers, tint)
        else
            dat.tint = tint
        end
    end
    return array
end

local tint = { r = 250 / 255, g = 250 / 255, b = 250 / 255, a = 1.000 }

local plasma_pipe = table.deepcopy(data.raw["pipe"]["pipe"])
plasma_pipe.minable = { mining_time = 0.1, result = "plasma_pipe" }
plasma_pipe.name = "plasma_pipe"
plasma_pipe.fluid_box["filter"] = "fusion-plasma"
for _, pipe_connection in pairs(plasma_pipe.fluid_box.pipe_connections) do
    pipe_connection.connection_type = "normal"
    pipe_connection.connection_category = "fusion-plasma"
end
plasma_pipe.surface_conditions = { { property = "gravity", min = 0, max = 0 } }
plasma_pipe.pictures = color_sprites(plasma_pipe.pictures, tint)

local plasma_pipe_item = table.deepcopy(data.raw["item"]["pipe"])
plasma_pipe_item.name = "plasma_pipe"
plasma_pipe_item.icon = "__base__/graphics/icons/assembling-machine-1.png"
plasma_pipe_item.icon_size = 64
plasma_pipe_item.place_result = "plasma_pipe"

local plasma_pipe_recipe = table.deepcopy(data.raw["recipe"]["pipe"])
plasma_pipe_recipe.enabled = true
plasma_pipe_recipe.name = "plasma_pipe"
plasma_pipe_recipe.results = { { type = "item", name = "plasma_pipe", amount = 1 } }

data:extend({ plasma_pipe_item, plasma_pipe_recipe, plasma_pipe })

local plasma_pipe_ground = table.deepcopy(data.raw["pipe-to-ground"]["pipe-to-ground"])
plasma_pipe_ground.minable = { mining_time = 0.1, result = "plasma_pipe-to-ground" }
plasma_pipe_ground.name = "plasma_pipe-to-ground"
plasma_pipe_ground.fluid_box["filter"] = "fusion-plasma"
for _, pipe_connection in pairs(plasma_pipe_ground.fluid_box.pipe_connections) do
    pipe_connection.connection_category = "fusion-plasma"
end
plasma_pipe_ground.surface_conditions = { { property = "gravity", min = 0, max = 0 } }
plasma_pipe_ground.pictures = color_sprites(plasma_pipe_ground.pictures, tint)
plasma_pipe_ground.fluid_box.pipe_covers = color_sprites(plasma_pipe_ground.fluid_box.pipe_covers, tint)
plasma_pipe_ground.fluid_box.pipe_connections[2].max_underground_distance = 15

local plasma_pipe__ground_item = table.deepcopy(data.raw["item"]["pipe-to-ground"])
plasma_pipe__ground_item.name = "plasma_pipe-to-ground"
plasma_pipe__ground_item.icon = "__base__/graphics/icons/assembling-machine-1.png"
plasma_pipe__ground_item.icon_size = 64
plasma_pipe__ground_item.place_result = "plasma_pipe-to-ground"

local plasma_pipe_ground_recipe = table.deepcopy(data.raw["recipe"]["pipe-to-ground"])
plasma_pipe_ground_recipe.enabled = true
plasma_pipe_ground_recipe.name = "plasma_pipe-to-ground"
plasma_pipe_ground_recipe.results = { { type = "item", name = "plasma_pipe-to-ground", amount = 1 } }

data:extend({ plasma_pipe__ground_item, plasma_pipe_ground_recipe, plasma_pipe_ground })

local plasma_silo = table.deepcopy(data.raw["storage-tank"]["storage-tank"])
plasma_silo.minable = { mining_time = 0.1, result = "plasma_silo" }
plasma_silo.name = "plasma_silo"
plasma_silo.fluid_box["filter"] = "fusion-plasma"
plasma_silo.fluid_box.volume = 50000
plasma_silo.fluid_box.pipe_connections =
{
    { direction = defines.direction.north, position = { 0, -1 }, connection_category = "fusion-plasma" },
    { direction = defines.direction.east,  position = {  1, 0 }, connection_category = "fusion-plasma" },
    { direction = defines.direction.south, position = {  0, 1 }, connection_category = "fusion-plasma" },
    { direction = defines.direction.west,  position = { -1, 0 }, connection_category = "fusion-plasma" }
}

plasma_silo.surface_conditions = { { property = "gravity", min = 0, max = 0 } }
plasma_silo.pictures = color_sprites(plasma_silo.pictures, tint)

local plasma_silo_item = table.deepcopy(data.raw["item"]["storage-tank"])
plasma_silo_item.name = "plasma_silo"
plasma_silo_item.icon = "__base__/graphics/icons/assembling-machine-1.png"
plasma_silo_item.icon_size = 64
plasma_silo_item.place_result = "plasma_silo"

local plasma_silo_recipe = table.deepcopy(data.raw["recipe"]["storage-tank"])
plasma_silo_recipe.enabled = true
plasma_silo_recipe.name = "plasma_silo"
plasma_silo_recipe.results = { { type = "item", name = "plasma_silo", amount = 1 } }

data:extend({ plasma_silo_item, plasma_silo_recipe, plasma_silo })
