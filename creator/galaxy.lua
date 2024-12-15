require("util.randomlua")
local asteroid_util = require("__space-age__.prototypes.planet.asteroid-spawn-definitions")

local coord = require("util.coordonnee")
local system = require("creator.system")
local routes = require("creator.routes")

local function add_system_to_game(system,debloque)
  for _, object in pairs(system.children) do
        data:extend { object }
        if object.type == "planet" or object.type == "space-location" then
          table.insert(debloque, {
            type = "unlock-space-location",
            space_location = object.name
          })
        end
        if object.type=="planet" and not object.moon and #object.children>0 then
          add_system_to_game(object,debloque)
        end
      end
end

local function create_galaxy_objects(galaxy_objects,max_system, gen,global_map_gen)
  local points = coord.create_system_location(max_system, gen)
  for i = 1, #points do
    local location = {
      distance = points[i].distance, 
      angle = points[i].angle,     
    }
    --log(serpent.block(location))
    system.create_system(galaxy_objects,location,gen,global_map_gen)
  end
  galaxy_objects["solar-system"] = { name = "solar-system", localised_name = "solar-system", position = { x = 0, y = 0 }, location = { distance = 0, angle = 0 }, children = {} }
end

local function create_and_add_system_edge_from_route(edge,galaxy_objects,gen)
  --edge  50 de distance
  --log(serpent.block(edge))
  local system_1 = galaxy_objects[edge[1].name]
  local system_2 = galaxy_objects[edge[2].name]
  --log(serpent.block(system_1))
  --log(serpent.block(system_2))
  local system_1_cart = coord.polaire_to_cart(system_1.location.distance, coord.angle_convert(system_1.location.angle))
  local system_2_cart = coord.polaire_to_cart(system_2.location.distance, coord.angle_convert(system_2.location.angle))
  --log(serpent.block(system_1_cart))
  --log(serpent.block(system_2_cart))
  local dx = system_2_cart.x - system_1_cart.x
  local dy = system_2_cart.y - system_1_cart.y
  --log(serpent.block(dx))
  --log(serpent.block(dy))
  local angle_b = coord.get_angle_from_cart({ x = dx, y = dy })
  local angle = coord.angle_convertf(angle_b)

  table.insert(galaxy_objects[edge[1].name].children,
    system.make_corps(system_1.localised_name .. "-to-" .. system_2.localised_name, system_1.location, 50, angle, "edge",0,gen))
  table.insert(data.raw["utility-sprites"]["default"]["starmap_star"].layers, {
    filename = "__WorldCreation__/graphics/icons/starmap_edge_1.png",
    size = 4096,
    scale = 1,
    shift = coord.position_to_layer(system_1.location.distance, system_1.location.angle),
  })

  angle = coord.angle_convertf(angle_b + math.pi)
  table.insert(galaxy_objects[edge[2].name].children,
    system.make_corps(system_2.localised_name .. "-to-" .. system_1.localised_name, system_2.location, 50, angle, "edge",0,gen))
  table.insert(data.raw["utility-sprites"]["default"]["starmap_star"].layers, {
    filename = "__WorldCreation__/graphics/icons/starmap_edge_1.png",
    size = 4096,
    scale = 1,
    shift = coord.position_to_layer(system_2.location.distance, system_2.location.angle),
  })

  local route = {
    type = "space-connection",
    name = system_1.localised_name .. "-to-" .. system_2.localised_name,
    subgroup = "planet-connections",
    icon = "__space-age__/graphics/icons/solar-system-edge.png",
    order = "h",
    length = 100000,
    asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.gleba_aquilo)
  }

  if system_1_cart.y >= system_2_cart.y then
    route.from = "lihop-system-" .. system_1.localised_name .. "-to-" .. system_2.localised_name .. "-edge"
    route.to = "lihop-system-" .. system_2.localised_name .. "-to-" .. system_1.localised_name .. "-edge"
  else
    route.from = "lihop-system-" .. system_2.localised_name .. "-to-" .. system_1.localised_name .. "-edge"
    route.to = "lihop-system-" .. system_1.localised_name .. "-to-" .. system_2.localised_name .. "-edge"
  end
  table.insert(galaxy_objects["galaxy_routes"], route)
end


local function create_routes_between_system(galaxy_objects,gen)
  local galaxy_routes = routes.create_galaxy_routes(galaxy_objects)
  galaxy_objects["galaxy_routes"] = {}
  for _, edge in pairs(galaxy_routes) do
    --add les deux edges et ajoute la route
    create_and_add_system_edge_from_route(edge,galaxy_objects,gen)
  end
end

local function create_routes_for_edge_in_system(galaxy_objects)
  for name, system in pairs(galaxy_objects) do
    if name ~= "galaxy_routes" then
      for _, child in pairs(system.children) do
        if child.type == "space-location" and string.find(child.name, "edge") then
          if name == "solar-system" then -- on creer les edges sur Aquilo
            local route = {
              type = "space-connection",
              name = "aquilo" .. "-to-" .. child.name,
              subgroup = "planet-connections",
              icon = "__space-age__/graphics/icons/solar-system-edge.png",
              from = "aquilo",
              to = child.name,
              order = "h",
              length = 40000,
              asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.gleba_aquilo)
            }
            --log(serpent.block(route))
            table.insert(galaxy_objects[name].children, route)
          else -- on creer sur la planet la plus loin du centre (peut etre changer car sinon c'est le bordel)
            local distance = 0
            local planet_name = ""
            for _, planet in pairs(system.children) do
              if (not planet.moon and planet.type == "planet") or (planet.type=="space-location" and string.find(planet.name,"asteroids_belt")) then
                if planet.local_distance > distance then
                  planet_name = planet.name
                  distance = planet.local_distance
                end
              end
            end
            --on creer la connexion
            local route = {
              type = "space-connection",
              name = planet_name .. "-to-" .. child.name,
              subgroup = "planet-connections",
              icon = "__space-age__/graphics/icons/solar-system-edge.png",
              from = planet_name,
              to = child.name,
              order = "h",
              length = 40000,
              asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.gleba_aquilo)
            }
            --log(serpent.block(route))
            table.insert(galaxy_objects[name].children, route)
          end
        end
      end
    end
  end
end

local function add_galaxy_to_game(galaxy_objects,debloque)
  --add planet and all object
  for name, system in pairs(galaxy_objects) do
    --log(name)
    if name == "galaxy_routes" then
      for _, route in pairs(system) do
        data:extend { route }
      end
    else
      add_system_to_game(system,debloque)
    end
  end

     data:extend {
  {
    type = "technology",
    name = "planet-discovery-lihop",
    icons = util.technology_icon_constant_planet("__space-age__/graphics/technology/vulcanus.png"),
    icon_size = 256,
    essential = true,
    effects = debloque,
    prerequisites = { "space-platform-thruster" },
    unit =
    {
      count = 1000,
      ingredients =
      {
        { "automation-science-pack", 1 },
        { "logistic-science-pack",   1 },
        { "chemical-science-pack",   1 },
        { "space-science-pack",      1 }
      },
      time = 60
    }
  },
}

end

local galaxy={}

function galaxy.create_galaxy(seed,global_map_gen)
    local gen = mwc(seed)
    local max_system = gen:random(2, 10)
    local galaxy_objects={}
    create_galaxy_objects(galaxy_objects,max_system,gen,global_map_gen)
    system.create_routes_in_system(galaxy_objects)
    create_routes_between_system(galaxy_objects,gen)
    create_routes_for_edge_in_system(galaxy_objects)
    
    local debloque={}
    add_galaxy_to_game(galaxy_objects,debloque)
end

return galaxy