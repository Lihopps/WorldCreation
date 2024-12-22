local resource_autoplace = require("__core__/lualib/resource-autoplace")
local sounds = require("__base__/prototypes/entity/sounds")

resource_autoplace.initialize_patch_set("iron-ore", true)

local stone_driving_sound =
{
  sound =
  {
    filename = "__base__/sound/driving/vehicle-surface-stone.ogg", volume = 0.8,
    advanced_volume_control = {fades = {fade_in = {curve_type = "cosine", from = {control = 0.5, volume_percentage = 0.0}, to = {1.5, 100.0 }}}}
  },
  fade_ticks = 6
}

local function resource(resource_parameters, autoplace_parameters)
  return
  {
    type = "resource",
    name = resource_parameters.name,
    icon = data.raw["item"][resource_parameters.name].icon,
    flags = {"placeable-neutral"},
    order="a-b-"..resource_parameters.order,
    tree_removal_probability = 0.8,
    tree_removal_max_distance = 32 * 32,
    minable = resource_parameters.minable or
    {
      --mining_particle = resource_parameters.name .. "-particle",
      mining_time = resource_parameters.mining_time,
      result = resource_parameters.name
    },
    category = resource_parameters.category,
    subgroup = resource_parameters.subgroup,
    walking_sound = resource_parameters.walking_sound,
    driving_sound = resource_parameters.driving_sound,
    collision_mask = resource_parameters.collision_mask,
    collision_box = {{-0.1, -0.1}, {0.1, 0.1}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
    autoplace = resource_autoplace.resource_autoplace_settings
    {
      name = resource_parameters.name,
      order = resource_parameters.order,
      base_density = autoplace_parameters.base_density,
      base_spots_per_km = autoplace_parameters.base_spots_per_km2,
      has_starting_area_placement = true,
      regular_rq_factor_multiplier = autoplace_parameters.regular_rq_factor_multiplier,
      starting_rq_factor_multiplier = autoplace_parameters.starting_rq_factor_multiplier,
      candidate_spot_count = autoplace_parameters.candidate_spot_count,
      tile_restriction = autoplace_parameters.tile_restriction
    },
    stage_counts = {15000, 9500, 5500, 2900, 1300, 400, 150, 80},
    stages =
    {
      sheet =
      {
        filename = "__WorldCreation__/graphics/entity/" .. resource_parameters.name .. "/" .. resource_parameters.name .. ".png",
        priority = "extra-high",
        size = 128,
        frame_count = 8,
        variation_count = 8,
        scale = 0.5
      }
    },
    map_color = resource_parameters.map_color,
    mining_visualisation_tint = resource_parameters.mining_visualisation_tint,
    factoriopedia_simulation = resource_parameters.factoriopedia_simulation
  }
end


data:extend({
  {
    type = "autoplace-control",
    name = "holmium-ore",
    localised_name = {"", "[item=holmium-ore] ", {"item-name.holmium-ore"}},
    richness = true,
    order = "f-a",
    category = "resource"
  },
    resource(
    {
      name = "holmium-ore",
      order = "f",
      map_color = {250/255,  164/255, 232/255},
      mining_time = 1,
      walking_sound = sounds.ore,
      driving_sound = stone_driving_sound,
      mining_visualisation_tint = {r = 250/255, g = 164/255, b = 232/255, a = 1.000}, -- rgb(250, 164, 232)
      --factoriopedia_simulation = simulations.factoriopedia_stone,
    },
    {
      base_density = 4,
      regular_rq_factor_multiplier = 1.0,
      starting_rq_factor_multiplier = 1.1
    }
  ),
  {
    type = "autoplace-control",
    name = "sulfur",
    localised_name = {"", "[item=sulfur] ", {"item-name.sulfur"}},
    richness = true,
    order = "f-b",
    category = "resource"
  },
    resource(
    {
      name = "sulfur",
      order = "f",
      map_color = {242/255, 223/255, 58/255},
      mining_time = 1,
      walking_sound = sounds.ore,
      driving_sound = stone_driving_sound,
      mining_visualisation_tint = {r = 242/255, g = 223/255, b = 58/255, a = 1.000}, -- rgb(242, 223, 58)
      --factoriopedia_simulation = simulations.factoriopedia_stone,
    },
    {
      base_density = 3,
      regular_rq_factor_multiplier = 0.8,
      starting_rq_factor_multiplier = 0.7
    }
  ),
})