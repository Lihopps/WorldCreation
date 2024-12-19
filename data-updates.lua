local galaxy=require("creator.galaxy")
local map_gen=require("creator.map-gen")

if data.raw["utility-sprites"] and data.raw["utility-sprites"]["default"] then
  data.raw["utility-sprites"]["default"]["starmap_star"] = {
    type = "sprite",
    layers = {
      
    },
  }
end


local seed = 0
local global_map_gen={}--map_gen.clear_and_collect()
galaxy.create_galaxy(seed,global_map_gen)
