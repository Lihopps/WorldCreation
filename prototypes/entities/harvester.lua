require ("__base__.prototypes.entity.pipecovers")
--This is a placeholder file, a rescaled version of the old miner graphic.
local hit_effects = require ("__base__.prototypes.entity.hit-effects")
local sounds = require("__base__.prototypes.entity.sounds")

data:extend({
    
    {
        type = "recipe",
        name = "lihop-harvester",
        enabled = lihop_debug,
        energy_required = 2,
        ingredients =
        {
            { type = "item", name = "big-mining-drill",      amount = 5 },
            { type = "item", name = "steel-plate",           amount = 100 },
            { type = "item", name = "low-density-structure", amount = 20 }

        },
        results = { { type = "item", name = "lihop-harvester", amount = 1 } }
    },
    {
        type = "item",
        name = "lihop-harvester",
        icon = "__base__/graphics/icons/assembling-machine-1.png",
        icon_size = 64,
        subgroup = "extraction-machine",
        order = "a[items]-c[infinity-miner]",
        place_result = "lihop-harvester",
        stack_size = 20,
        weight = 50 * kg
    },
   {
    type = "assembling-machine",
    name = "lihop-harvester",
    icon = "__space-age__/graphics/icons/cryogenic-plant.png",
    flags = {"placeable-neutral","player-creation"},
    minable = {mining_time = 0.2, result = "lihop-harvester"},
    max_health = 350,
    corpse = "big-remnants",
    dying_explosion = "big-explosion",
    --circuit_wire_max_distance = assembling_machine_circuit_wire_max_distance,
    --circuit_connector = circuit_connector_definitions["cryogenic-plant"],
    collision_box = {{-2.4, -2.4}, {2.4, 2.4}},
    heating_energy = "100kW",
    selection_box = {{-2.5, -2.5}, {2.5, 2.5}},
    damaged_trigger_effect = hit_effects.entity(),
    drawing_box_vertical_extension = 0.4,
    module_slots = 2,
    icons_positioning =
    {
      {inventory_index = defines.inventory.furnace_modules, shift = {0, 0.95}, max_icons_per_row = 4}
    },
    icon_draw_specification = {scale = 2, shift = {0, -0.3}},
    allowed_effects = {"consumption", "speed", "productivity", "pollution", "quality"},
    crafting_categories = {"lihop-harvesting"},
    crafting_speed = 2,
    energy_source =
    {
      type = "electric",
      usage_priority = "secondary-input",
      emissions_per_minute = { pollution = 6 }
    },
    energy_usage = "1500kW",
    graphics_set = require("__space-age__.prototypes.entity.cryogenic-plant-pictures").graphics_set,
    open_sound = sounds.metal_large_open,
    close_sound = sounds.metal_large_close,
    working_sound =
    {
      sound =
      {
        filename = "__space-age__/sound/entity/cryogenic-plant/cryogenic-plant.ogg", volume = 0.8
      },
      --idle_sound = { filename = "__base__/sound/idle1.ogg", volume = 0.3 },
      fade_in_ticks = 4,
      fade_out_ticks = 30,
      sound_accents =
      {
        { sound = { variations = sound_variations("__space-age__/sound/entity/cryogenic-plant/cp-smoke-mask-puff", 2, 0.35 )}, frame = 11, audible_distance_modifier = 0.8 },
        { sound = { variations = sound_variations("__space-age__/sound/entity/cryogenic-plant/cp-smoke-mask-puff", 2, 0.3 )}, frame = 130, audible_distance_modifier = 0.8 },
        { sound = { filename = "__space-age__/sound/entity/cryogenic-plant/cp-anim3-bubbles-rise.ogg", volume = 0.9 }, frame = 14, audible_distance_modifier = 0.3 },
        { sound = { filename = "__space-age__/sound/entity/cryogenic-plant/cp-anim3-bubbles-fall.ogg", volume = 0.7 }, frame = 62, audible_distance_modifier = 0.3},
        { sound = { filename = "__space-age__/sound/entity/cryogenic-plant/cp-anim3-bubbles-rise.ogg", volume = 0.9 }, frame = 110, audible_distance_modifier = 0.3 },
        { sound = { filename = "__space-age__/sound/entity/cryogenic-plant/cp-anim3-bubbles-fall.ogg", volume = 0.7 }, frame = 158, audible_distance_modifier = 0.3 },
        { sound = { filename = "__space-age__/sound/entity/cryogenic-plant/cp-anim5-gears.ogg", volume = 0.25 }, frame = 51, audible_distance_modifier = 0.4 },
        { sound = { filename = "__space-age__/sound/entity/cryogenic-plant/cp-anim5-gears.ogg", volume = 0.2 }, frame = 151, audible_distance_modifier = 0.4 },
        { sound = { variations = sound_variations("__space-age__/sound/entity/cryogenic-plant/cp-anim6-open", 2, 0.6 )}, frame = 3, audible_distance_modifier = 0.4 },
        { sound = { filename = "__space-age__/sound/entity/cryogenic-plant/cp-anim6-close.ogg", volume = 0.7 }, frame = 33, audible_distance_modifier = 0.4 },
        { sound = { filename = "__space-age__/sound/entity/cryogenic-plant/cp-anim6-slide-down.ogg", volume = 0.55 }, frame = 42, audible_distance_modifier = 0.4 },
        { sound = { filename = "__space-age__/sound/entity/cryogenic-plant/cp-anim6-slide-up.ogg", volume = 0.6 }, frame = 126, audible_distance_modifier = 0.4 },
        { sound = { filename = "__space-age__/sound/entity/cryogenic-plant/cp-anim6-slide-stop.ogg", volume = 0.4 }, frame = 146, audible_distance_modifier = 0.4 },
      },
      max_sounds_per_type = 2
    },
    fluid_boxes =
    {
      {
        production_type = "output",
        pipe_covers = pipecoverspictures(),
        always_draw_covers = false,
        volume = 100,
        pipe_connections = {{ flow_direction="output", direction = defines.direction.north, position = {-2, -2} }}
      },
      {
        production_type = "output",
        pipe_picture =  require("__space-age__.prototypes.entity.cryogenic-plant-pictures").pipe_picture,
        pipe_picture_frozen =  require("__space-age__.prototypes.entity.cryogenic-plant-pictures").pipe_picture_frozen,
        always_draw_covers = false, -- fighting against FluidBoxPrototype::always_draw_covers crazy default
        pipe_covers = pipecoverspictures(),
        volume = 100,
        pipe_connections = {{ flow_direction="output", direction = defines.direction.north, position = {0, -2} }}
      },
      {
        production_type = "output",
        pipe_covers = pipecoverspictures(),
        always_draw_covers = false,
        volume = 100,
        filter="fusion-plasma",
        pipe_connections = {{ flow_direction="output", direction = defines.direction.north, position = {2, -2} ,connection_category = "fusion-plasma"}}
      }
    },
    fluid_boxes_off_when_no_fluid_recipe = true,
    water_reflection =
    {
      pictures = util.sprite_load("__space-age__/graphics/entity/foundry/foundry-reflection",
      {
          scale = 5,
          shift = {0,2}
      }),
      rotate = false,
    }
  },
})
