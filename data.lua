lihop_debug=true

require("creator.noise")

require("categories.group")
require("prototypes.technologies")
require("prototypes.entities.entities")
require("prototypes.items.items")
require("prototypes.fluids.fluids")
require("prototypes.resources.resource")


worldCreation_planet_graphics={}
worldCreation_gazeous_field={light={},heavy={}}

---Add graphics set for planet type like
---@param name string : name of the planet type like (ex : vulcanus)
---@param icon string : path to the file
---@param starmap_icon string : path to the file
---@param starmap_icon_size number : size of the starmap_icon
function wc_add_graphics_asset(name,icon,starmap_icon,starmap_icon_size)
    
    if not worldCreation_planet_graphics[name] then
        worldCreation_planet_graphics[name]={}
    end
    table.insert(worldCreation_planet_graphics[name],{
        icon=icon,
        starmap_icon=starmap_icon or icon,
        starmap_icon_size=starmap_icon_size
    })
end

---Add graphics set for planet type like 
---@param name string : FluidID
---@param type string : light or heavy (juste one type by planet)
function wc_add_gazeous_field(type,name)
    table.insert(worldCreation_gazeous_field[type],name)
end


--add basemod like planet graphics
local base_planet = {"gazeous","asteroids_belt"}--"vulcanus","gleba","nauvis","fulgora","aquilo"}
for _,name in pairs(base_planet) do
    for i=1,1 do
        local base="__WorldCreation__/graphics/icons/corps/"..name.."/icon-"
        wc_add_graphics_asset(name,base..i..".png",base..i.."-starmap.png",512)
    end
end

local gazeous_fiel={
    water="heavy",
    ["sulfuric-acid"]="heavy",
    ["lithium-brine"]="heavy",
    
    steam="light",
    ammonia="light",
    fluorine="light",
   
}
for name,type in pairs(gazeous_fiel) do
    wc_add_gazeous_field(type,name)
end


local plasma_silo = table.deepcopy(data.raw["rocket-silo"]["rocket-silo"])
plasma_silo.minable = { mining_time = 0.1, result = "rocket-silo2" }
plasma_silo.name = "rocket-silo2"
plasma_silo.launch_to_space_platforms=false
plasma_silo.to_be_inserted_to_rocket_inventory_size=1
plasma_silo.logistic_trash_inventory_size=1
plasma_silo.inventory_size=1
plasma_silo.fixed_recipe = "lihop-rocket-to-part"
plasma_silo.rocket_parts_required = 1
plasma_silo.prefer_packed_cargo_units=true
plasma_silo.surface_conditions = { { property = "gravity", min = 0, max = 1000 } }

local plasma_silo_item = table.deepcopy(data.raw["item"]["rocket-silo"])
plasma_silo_item.name = "rocket-silo2"
plasma_silo_item.icon = "__base__/graphics/icons/assembling-machine-1.png"
plasma_silo_item.icon_size = 64
plasma_silo_item.place_result = "rocket-silo2"

local plasma_silo_recipe = table.deepcopy(data.raw["recipe"]["rocket-silo"])
plasma_silo_recipe.enabled = lihop_debug
plasma_silo_recipe.name = "rocket-silo2"
plasma_silo_recipe.results = { { type = "item", name = "rocket-silo2", amount = 1 } }

data:extend({ plasma_silo_item, plasma_silo_recipe, plasma_silo })

plasma_silo = table.deepcopy(data.raw["cargo-landing-pad"]["cargo-landing-pad"])
plasma_silo.minable = { mining_time = 0.1, result = "cargo-landing-pad2" }
plasma_silo.name = "cargo-landing-pad2"
plasma_silo.launch_to_space_platforms=false
plasma_silo.surface_conditions = { { property = "gravity", min = 0, max = 0 } }

plasma_silo_item = table.deepcopy(data.raw["item"]["cargo-landing-pad"])
plasma_silo_item.name = "cargo-landing-pad2"
plasma_silo_item.icon = "__base__/graphics/icons/assembling-machine-1.png"
plasma_silo_item.icon_size = 64
plasma_silo_item.place_result = "cargo-landing-pad2"

plasma_silo_recipe = table.deepcopy(data.raw["recipe"]["cargo-landing-pad"])
plasma_silo_recipe.enabled = lihop_debug
plasma_silo_recipe.name = "cargo-landing-pad2"
plasma_silo_recipe.results = { { type = "item", name = "cargo-landing-pad2", amount = 1 } }

data:extend({ plasma_silo_item, plasma_silo_recipe, plasma_silo })




--thanks to 
--hay_guise planet radius
