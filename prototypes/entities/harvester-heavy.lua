local hit_effects = require("__base__/prototypes/entity/hit-effects")
local sounds = require("__base__/prototypes/entity/sounds")

data:extend({

    {
        type = "recipe",
        name = "lihop-harvester-heavy",
        enabled = lihop_debug,
        energy_required = 2,
        ingredients =
        {
            { type = "item", name = "big-mining-drill",      amount = 5 },
            { type = "item", name = "steel-plate",           amount = 100 },
            { type = "item", name = "low-density-structure", amount = 20 }

        },
        results = { { type = "item", name = "lihop-harvester-heavy", amount = 1 } }
    },
    {
        type = "item",
        name = "lihop-harvester-heavy",
        icon = "__base__/graphics/icons/assembling-machine-1.png",
        icon_size = 64,
        subgroup = "extraction-machine",
        order = "a[items]-c[infinity-miner]",
        place_result = "lihop-harvester-heavy",
        stack_size = 20,
        weight = 50 * kg
    },
    {
        type = "assembling-machine",
        name = "lihop-harvester-heavy",
        icon = "__base__/graphics/icons/assembling-machine-1.png",
        icon_size = 64,
        flags = { "placeable-neutral", "placeable-player", "player-creation" },
        minable = { mining_time = 0.2, result = "lihop-harvester-heavy" },
        factoriopedia_alternative = "lihop-harvester-heavy",
        max_health = 350,
        corpse = "medium-remnants",
        dying_explosion = "medium-explosion",
        alert_icon_shift = util.by_pixel(-3, -12),
        placeable_by = { item = "lihop-harvester-heavy", count = 1 },
        surface_conditions={{property="gravity",min=0,max=0}},
        resistances =
        {
            {
                type = "fire",
                percent = 70
            }
        },
        fluid_boxes_off_when_no_fluid_recipe = false,
        fluid_boxes =
        {
            {
                production_type = "output",
                pipe_picture = assembler2pipepictures(),
                pipe_covers = pipecoverspictures(),
                volume = 1000,
                pipe_connections = { { flow_direction = "output", direction = defines.direction.north, position = { 0, -1. } } },
                secondary_draw_orders = { north = -1 }
            },

        },
        collision_box = { { -1.2, -1.2 }, { 1.2, 1.2 } },
        selection_box = { { -1.5, -1.5 }, { 1.5, 1.5 } },
        damaged_trigger_effect = hit_effects.entity(),
        graphics_set = data.raw["assembling-machine"]["assembling-machine-1"].graphics_set,
        open_sound = sounds.machine_open,
        close_sound = sounds.machine_close,
        vehicle_impact_sound = sounds.generic_impact,
        working_sound =
        {
            sound =
            {
                {
                    filename = "__base__/sound/assembling-machine-t2-1.ogg",
                    volume = 0.45
                }
            },
            audible_distance_modifier = 0.5,
            fade_in_ticks = 4,
            fade_out_ticks = 20
        },
        crafting_categories = { "lihop-harvesting-heavy" },
        crafting_speed = 1,
        energy_source =
        {
            type = "electric",
            usage_priority = "secondary-input",
            emissions_per_minute = { pollution = 12 }
        },
        energy_usage = "200kW",
        module_slots = 2,
        allowed_effects = { "speed", "productivity", "consumption", "pollution"}
    },
})
