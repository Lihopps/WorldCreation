landing_pad = table.deepcopy(data.raw["cargo-landing-pad"]["cargo-landing-pad"])
landing_pad.minable = { mining_time = 0.1, result = "wc-cargo-landing-pad" }
landing_pad.name = "wc-cargo-landing-pad"
landing_pad.launch_to_space_platforms=false
landing_pad.surface_conditions = { { property = "gravity", min = 0, max = 0 } }

landing_pad_item = table.deepcopy(data.raw["item"]["cargo-landing-pad"])
landing_pad_item.name = "wc-cargo-landing-pad"
landing_pad_item.icon = "__base__/graphics/icons/assembling-machine-1.png"
landing_pad_item.icon_size = 64
landing_pad_item.place_result = "wc-cargo-landing-pad"

landing_pad_recipe = table.deepcopy(data.raw["recipe"]["cargo-landing-pad"])
landing_pad_recipe.enabled = lihop_debug
landing_pad_recipe.name = "wc-cargo-landing-pad"
landing_pad_recipe.results = { { type = "item", name = "wc-cargo-landing-pad", amount = 1 } }

data:extend({ landing_pad_item, landing_pad_recipe, landing_pad })
