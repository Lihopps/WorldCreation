--100=2*la distance du edge pour une sprite de 4096 starmap_edge_1  avec echelle a 3200
--edge a 50

--orbit_1=10.25
--orbit_2=14.25
--orbit_3=19.25
--orbit_4=25.5
--orbit_5=39.5
--orbit_6~=44.25


local backers=require("__WorldCreation__.backers")
local routes=require("creator.routes")
local coord=require("util.coordonnee")

local asteroid_util = require("__space-age__.prototypes.planet.asteroid-spawn-definitions")

local orbit = { 10.25, 14.25, 19.25, 25.5, 39.5 }
local planet_density = { 0.25, 0.5, 0.8 }
local moon_density = { 0, 0.10, 0.25 }

math.randomseed(0)

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

local systems = {}

local function make_corps(parent_name,parent_location, distance_from_parent, angle, type,density)
  local p_angle = coord.angle_convert(parent_location.angle)
  local parent_position = coord.polaire_to_cart(parent_location.distance, p_angle)

  local c_angle = coord.angle_convert(angle)
  local position = coord.polaire_to_cart(distance_from_parent, c_angle)

  local cart_pos = { x = parent_position.x + position.x, y = parent_position.y + position.y }


  local distance = math.sqrt(cart_pos.x * cart_pos.x + cart_pos.y * cart_pos.y)
  local n_angle = coord.angle_convertf(coord.get_angle_from_cart(cart_pos))
  if type == "planet" then
    local corps = {
      local_distance=distance_from_parent,
      local_angle=angle,
      position=position,  --cartesian position in system

      type = "planet",
      name = "lihop-planet-"..backers[math.random(#backers)],
      draw_orbit = false,
      icon = "__space-age__/graphics/icons/vulcanus.png",
      starmap_icon = "__space-age__/graphics/icons/starmap-planet-vulcanus.png",
      starmap_icon_size = 512,
      gravity_pull = 3.7,
      distance = distance,
      orientation = n_angle,
      magnitude = 1,
      map_gen_settings = data.raw.planet.vulcanus.map_gen_settings,
      asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.nauvis_vulcanus, 0.9),
      surface_properties = {
        -- Mercury (水星)
        ["day-night-cycle"] = 58.7 * (24 * hour),
        ["magnetic-field"] = 1,
        ["solar-power"] = 500,
        pressure = 0,
        gravity = 3.7,
      }
    }
    --ici on peut creer une moon si besoin
    -- penser a créer la route direct
    return corps
  elseif type=="moon" then
  elseif type=="asteroids_belt" then
  elseif type=="edge" then
    local edge={
          local_distance=distance_from_parent,
          local_angle=angle,
          position=position,

          type = "space-location", 
          name = parent_name.."-edge", 
          icon = "__space-age__/graphics/icons/solar-system-edge.png",       
          order = "f[solar-system-edge]",      
          subgroup = "planets",        
          draw_orbit = false,
          gravity_pull = -10,       
          distance = distance,
          orientation = n_angle,      
          magnitude = 1.0, 
          label_orientation = 0.15,      
          asteroid_spawn_influence = 1,       
          asteroid_spawn_definitions = asteroid_util.spawn_definitions( 
              asteroid_util.aquilo_solar_system_edge,
              0.9
          )
      }
    return edge

  end
end

local function create_system(location)
  local system = {
    name = "lihop-system-"..backers[math.random(#backers)],
    density = math.random(3),
    location=location,
    children = {}
  }

  --sprite de l'etoile
  table.insert(data.raw["utility-sprites"]["default"]["starmap_star"].layers, {
    filename = "__core__/graphics/icons/starmap-star.png",
    size = 512,
    scale = math.random(),
    shift = coord.position_to_layer(location.distance, location.angle),
  })

  --edge  50 de distance
  table.insert(system.children, make_corps(system.name,location, 50, math.random(), "edge"))
  table.insert(data.raw["utility-sprites"]["default"]["starmap_star"].layers, {
    filename = "__WorldCreation__/graphics/icons/starmap_edge_1.png",
    size = 4096,
    scale = 1,
    shift = coord.position_to_layer(location.distance, location.angle),
  })
  
 


  for i = 1, #orbit do
    if math.random() < planet_density[system.density] then
      table.insert(system.children, make_corps(system.name,location, orbit[i], math.random(), "planet",system.density))
      --sprite pour l'orbit
      table.insert(data.raw["utility-sprites"]["default"]["starmap_star"].layers, {
        filename = "__WorldCreation__/graphics/icons/starmap_orbit_"..i..".png",
        size = 4096,
        scale = 1,
        shift = coord.position_to_layer(location.distance, location.angle),
      })
    end
  end
  routes.add_system_route(system)
  systems[system.name] = system
end

local function create_systems()
  for i = 1, 1 do
    local location = {
      distance = math.random(150, 300),
      angle = math.random()
    }
    create_system(location)
  end
end

local function create_galaxy()
  create_systems()
  --create_routes()
end




create_galaxy()

local debloque={}

--add planet and all object
for name, system in pairs(systems) do
  for _, object in pairs(system.children) do
    data:extend { object }
    table.insert(debloque,{
        type = "unlock-space-location",
        space_location = object.name
      })

  end
end

data:extend{
{
    type = "technology",
    name = "planet-discovery-lihop",
    icons = util.technology_icon_constant_planet("__space-age__/graphics/technology/vulcanus.png"),
    icon_size = 256,
    essential = true,
    effects =debloque,
    prerequisites = {"space-platform-thruster"},
    unit =
    {
      count = 1000,
      ingredients =
      {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"chemical-science-pack", 1},
        {"space-science-pack", 1}
      },
      time = 60
    }
  },
}
--add routes
