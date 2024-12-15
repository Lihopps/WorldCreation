local galaxy=require("creator.galaxy")
local map_gen=require("creator.map-gen")

if data.raw["utility-sprites"] and data.raw["utility-sprites"]["default"] then
  data.raw["utility-sprites"]["default"]["starmap_star"] = {
    type = "sprite",
    layers = {
      {
        filename = "__core__/graphics/icons/starmap-star.png",
        size = 512,
        scale = 0.5,
        shift = { 0, 0 },
        draw_as_light = true,
      },
    },
  }
end

local seed = 0
local global_map_gen=map_gen.clear_and_collect()
galaxy.create_galaxy(seed,global_map_gen)
