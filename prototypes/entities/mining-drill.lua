require ("__base__.prototypes.entity.pipecovers")
--This is a placeholder file, a rescaled version of the old miner graphic.
local hit_effects = require ("__base__.prototypes.entity.hit-effects")
local sounds = require("__base__.prototypes.entity.sounds")

data:extend({
    
    {
        type = "recipe",
        name = "lihop-mining-drill",
        enabled = lihop_debug,
        energy_required = 2,
        ingredients =
        {
            { type = "item", name = "big-mining-drill",      amount = 5 },
            { type = "item", name = "steel-plate",           amount = 100 },
            { type = "item", name = "low-density-structure", amount = 20 }

        },
        results = { { type = "item", name = "lihop-mining-drill", amount = 1 } }
    },
    {
        type = "item",
        name = "lihop-mining-drill",
        icon = "__base__/graphics/icons/assembling-machine-1.png",
        icon_size = 64,
        subgroup = "extraction-machine",
        order = "a[items]-c[infinity-miner]",
        place_result = "lihop-mining-drill",
        stack_size = 20,
        weight = 50 * kg
    },
   
})
