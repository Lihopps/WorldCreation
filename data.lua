
local galaxy=require("creator.galaxy")


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
galaxy.create_galaxy(seed)







