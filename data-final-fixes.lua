local superbarrel = require("util.superbarrel")
local asteroids=require("creator.asteroids")
local routes = require("creator.routes")
local star = require("creator.star")

--create space-connection icon and space connection spawn def
data.raw.planet["aquilo"].orbit_distance=5
for name, prototype in pairs(data.raw["space-connection"]) do
  local from = data.raw["space-location"][prototype.from] or data.raw["planet"][prototype.from]
  local to = data.raw["space-location"][prototype.to] or data.raw["planet"][prototype.to]
  if (not prototype.icon) and (not prototype.icons) and from and (from.icon or from.icons[1].icon) and to and (to.icon or to.icons[1].icon) then
    local from_size = from.icon_size or 64
    local from_tint = from.tint or { r = 1, g = 1, b = 1, a = 1 }
    if from.icons then
      from_size = from.icons[1].icon_size or 64
      from_tint = from.icons[1].tint
    end

    local to_size = to.icon_size or 64
    local to_tint = to.tint or { r = 1, g = 1, b = 1, a = 1 }
    if to.icons then
      to_size = to.icons[1].icon_size or 64
      to_tint = to.icons[1].tint
    end
    prototype.icons =
    {
      { icon = "__space-age__/graphics/icons/planet-route.png" },
      { icon = from.icon or from.icons[1].icon,                tint = from_tint, icon_size = from_size, scale = 0.333 * (64 / (from_size)), shift = { -6, -6 } },
      { icon = to.icon or to.icons[1].icon,                    tint = to_tint,   icon_size = to_size,   scale = 0.333 * (64 / (to_size)),   shift = { 6, 6 } }
    }
  end

  if prototype.need_spanwdef and from and to then
    prototype.asteroid_spawn_definitions=asteroids.spawn_connection_inner_to_inner(prototype.belt,from,to)
  end

  if not prototype.length then
    prototype.length=routes.length(from,to)
  end
end


--choose a least one site for dyson sphere
local stars={}
for name,star in pairs(data.raw["space-location"]) do
  if string.find(name,"lihopstar") then
   table.insert(stars,name)
  end
end

for i=1,math.min(3,#stars) do
  local spot=math.random(1,#stars)
  local star=star.make_dyson_site(data.raw["space-location"][stars[spot]])
  data.raw["space-location"][stars[spot]]=nil
  data:extend({star})
end



--worldCreation_gazeous_field={light={},heavy={}}
--add harvesting light and heavy recipe and create super barrel
for _, h_fluid in pairs(worldCreation_gazeous_field["heavy"]) do
  for _, l_fluid in pairs(worldCreation_gazeous_field["light"]) do
    local h_temp = data.raw["fluid"][h_fluid].max_temperature or data.raw["fluid"][h_fluid].default_temperature
    local l_temp = data.raw["fluid"][l_fluid].max_temperature or data.raw["fluid"][l_fluid].default_temperature
    local name="lihop-harvesting-" .. h_fluid.."-"..l_fluid
    data:extend({
      {
        type = "recipe",
        name = name,
        enabled = lihop_debug,
        surface_conditions = { { property = "gravity", min = 0, max = 0 } },
        category = "lihop-harvesting",
        energy_required = 2,
        ingredients = {},
        subgroup = "fluid-recipes",
        order = "z",
        main_product=h_fluid,
        results = { 
          { type = "fluid",fluidbox_index=1, name = h_fluid, amount = 100, temperature = h_temp },
          { type = "fluid",fluidbox_index=2, name = l_fluid, amount = 100, temperature = l_temp }
        }
      },
    })
    
    table.insert(data.raw.technology["lihop-harvester-l"].effects,{
        type = "unlock-recipe",
        recipe = name
    })
  end
end

for type,fluids in pairs(worldCreation_gazeous_field) do
  for _,h_fluid in pairs(fluids) do
    local fluidproto = data.raw["fluid"][h_fluid]
    local h_temp = data.raw["fluid"][h_fluid].max_temperature or data.raw["fluid"][h_fluid].default_temperature
    superbarrel.create_all(fluidproto, h_temp)
  end
end

data:extend({
{
        type = "recipe",
        name = "lihop-harvesting-fusion-plasma",
        enabled = lihop_debug,
        surface_conditions = { { property = "gravity", min = 0, max = 0 } },
        category = "lihop-harvesting",
        energy_required = 2,
        subgroup = "fluid-recipes",
        order = "z",
        ingredients = {},
        results = { { type = "fluid",fluidbox_index=3, name = "fusion-plasma", amount = 100, temperature = data.raw["fluid"]["fusion-plasma"].max_temperature } }
},
})







-- add tile prop for planet size
for name, tile in pairs(data.raw.tile) do
  if name == "out-of-map" then
    tile.autoplace = { probability_expression = "if(distance < planet_size, -1000, 1)" }
  elseif name == "empty-space" then
    tile.autoplace = { probability_expression = "if(distance < planet_size+5, -1000, 1)" }
  else
    if tile.autoplace and tile.autoplace.probability_expression then
      tile.autoplace.probability_expression = "if(distance < planet_size, " ..tile.autoplace.probability_expression .. ", -1000)"
    end
  end
end

for name, planet in pairs(data.raw.planet) do
  local map_settings = planet.map_gen_settings
  if not map_settings then
    log("skipping planet with no mapgen settings: " .. name)
    goto continue
  end

  map_settings.autoplace_settings.tile.settings["out-of-map"] = {}
  map_settings.autoplace_settings.tile.settings["empty-space"] = {}
  local planet_scale = planet.surface_properties.size_surface or 5000
  map_settings.property_expression_names["planet_size"] = planet_scale

  if not map_settings.territory_settings then goto continue end
  local expr_name = map_settings.territory_settings.territory_index_expression
  if not expr_name then goto continue end

  local new_expr_name = expr_name .. "_with_radius"

  local new_expr = data.raw["noise-expression"][new_expr_name]
  if not new_expr then
    data:extend {
      {
        type = "noise-expression",
        name = new_expr_name,
        expression = expr_name .. " - (distance >= planet_size-32)"
      }
    }
  end

  map_settings.territory_settings.territory_index_expression = new_expr_name


  ::continue::
end
