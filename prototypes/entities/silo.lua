local silo = table.deepcopy(data.raw["rocket-silo"]["rocket-silo"])
silo.minable = { mining_time = 0.1, result = "wc-rocket-silo" }
silo.name = "wc-rocket-silo"
silo.launch_to_space_platforms=false
silo.to_be_inserted_to_rocket_inventory_size=1
silo.logistic_trash_inventory_size=1
silo.inventory_size=1
silo.fixed_recipe = "lihop-rocket-to-part"
silo.rocket_parts_required = 1
silo.prefer_packed_cargo_units=true
silo.surface_conditions = { { property = "gravity", min = 0, max = 1000 } }

local silo_item = table.deepcopy(data.raw["item"]["rocket-silo"])
silo_item.name = "wc-rocket-silo"
silo_item.icon = "__base__/graphics/icons/assembling-machine-1.png"
silo_item.icon_size = 64
silo_item.place_result = "wc-rocket-silo"

local silo_recipe = table.deepcopy(data.raw["recipe"]["rocket-silo"])
silo_recipe.enabled = lihop_debug
silo_recipe.name = "wc-rocket-silo"
silo_recipe.results = { { type = "item", name = "wc-rocket-silo", amount = 1 } }

data:extend({ silo_item, silo_recipe, silo })