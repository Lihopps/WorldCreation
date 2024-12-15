--100=2*la distance du edge pour une sprite de 4096 starmap_edge_1  avec echelle a 3200
--edge a 50

--orbit_1=10.25
--orbit_2=14.75
--orbit_3=19.25
--orbit_4=25.5
--orbit_5=39.5
--orbit_6~=44.25

require("util.randomlua")

local backers = require("__WorldCreation__.backers")
local routes = require("creator.routes")
local coord = require("util.coordonnee")

local asteroid_util = require("__space-age__.prototypes.planet.asteroid-spawn-definitions")

local seed = 0
local gen = mwc(seed)

local orbit = { 10.25, 14.75, 19.25, 25.5, 39.5 }
local planet_density = { 0.25, 0.5, 0.8 }
local moon_density = { 0, 0.10, 0.25 }

local max_system = gen:random(2, 10)


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

local galaxy_objects = {}


local function make_corps(parent_name, parent_location, distance_from_parent, angle, type, density)
  local p_angle = coord.angle_convert(parent_location.angle)
  local parent_position = coord.polaire_to_cart(parent_location.distance, p_angle)

  local c_angle = coord.angle_convert(angle)
  local position = coord.polaire_to_cart(distance_from_parent, c_angle)

  local cart_pos = { x = parent_position.x + position.x, y = parent_position.y + position.y }


  local distance = math.sqrt(cart_pos.x * cart_pos.x + cart_pos.y * cart_pos.y)
  local n_angle = coord.angle_convertf(coord.get_angle_from_cart(cart_pos))
  if type == "planet" then
    local name = backers[gen:random(#backers)]
    local corps = {
      local_distance = distance_from_parent,
      local_angle = angle,
      position = position, --cartesian position depuis le centre du graph, avant décalge dans le system

      type = "planet",
      name = "lihop-planet-" .. name,
      localised_name = name,
      draw_orbit = false,
      icon = "__space-age__/graphics/icons/vulcanus.png",
      starmap_icon = "__space-age__/graphics/icons/starmap-planet-vulcanus.png",
      starmap_icon_size = 512,
      distance = distance,
      orientation = n_angle,
      magnitude = 1,
      gravity_pull = 3.7,
      asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.nauvis_vulcanus, 0.9),
      --map_gen_settings = data.raw.planet.vulcanus.map_gen_settings,
      -- surface_properties = {
      --   -- Mercury (水星)
      --   ["day-night-cycle"] = 58.7 * (24 * hour),
      --   ["magnetic-field"] = 1,
      --   ["solar-power"] = 500,
      --   pressure = 0,
      --   gravity = 3.7,
      --}
    }
    --ici on peut creer une moon si besoin
    -- penser a créer la route direct
    return corps
  elseif type == "moon" then
  elseif type == "asteroids_belt" then
  elseif type == "edge" then
    local edge = {
      local_distance = distance_from_parent,
      local_angle = angle,
      position = position,

      type = "space-location",
      name = "lihop-system-" .. parent_name .. "-edge",
      localised_name = parent_name .. "-edge",
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
  local name = backers[gen:random(#backers)]
  local system = {
    name = "lihop-system-" .. name,
    localised_name = name,
    density = gen:random(3),
    location = location,
    position = coord.polaire_to_cart(location.distance, coord.angle_convert(location.angle)),
    children = {}
  }
  --log(serpent.block(system))
  --sprite de l'etoile
  table.insert(data.raw["utility-sprites"]["default"]["starmap_star"].layers, {
    filename = "__core__/graphics/icons/starmap-star.png",
    size = 512,
    scale = gen:random(),
    shift = coord.position_to_layer(location.distance, location.angle),
  })

  --add coprs (planet/moon/ asteroids belt)
  for i = 1, #orbit do
    if gen:random() < planet_density[system.density] then
      table.insert(system.children, make_corps(system.name, location, orbit[i], gen:random(), "planet", system.density))
      --sprite pour l'orbit
      table.insert(data.raw["utility-sprites"]["default"]["starmap_star"].layers, {
        filename = "__WorldCreation__/graphics/icons/starmap_orbit_" .. i .. ".png",
        size = 4096,
        scale = 1,
        shift = coord.position_to_layer(location.distance, location.angle),
      })
    end
  end



  galaxy_objects[system.name] = system
end

local function create_galaxy_objects()
  local points = coord.create_system_location(max_system, gen)
  for i = 1, #points do
    local location = {
      distance = points[i].distance, --gen:random(120, 200)
      angle = points[i].angle,       --gen:random()
    }
    --log(serpent.block(location))
    create_system(location)
  end
  galaxy_objects["solar-system"] = { name = "solar-system", localised_name = "solar-system", position = { x = 0, y = 0 }, location = { distance = 0, angle = 0 }, children = {} }
end

local function create_and_add_system_edge_from_route(edge)
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
    make_corps(system_1.localised_name .. "-to-" .. system_2.localised_name, system_1.location, 50, angle, "edge"))
  table.insert(data.raw["utility-sprites"]["default"]["starmap_star"].layers, {
    filename = "__WorldCreation__/graphics/icons/starmap_edge_1.png",
    size = 4096,
    scale = 1,
    shift = coord.position_to_layer(system_1.location.distance, system_1.location.angle),
  })

  angle = coord.angle_convertf(angle_b + math.pi)
  table.insert(galaxy_objects[edge[2].name].children,
    make_corps(system_2.localised_name .. "-to-" .. system_1.localised_name, system_2.location, 50, angle, "edge"))
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

local function create_routes_between_system()
  local galaxy_routes = routes.create_galaxy_routes(galaxy_objects)
  galaxy_objects["galaxy_routes"] = {}
  for _, edge in pairs(galaxy_routes) do
    --add les deux edges et ajoute la route
    create_and_add_system_edge_from_route(edge)
  end
end

local function create_routes_in_system()
  --add routes in system
  for name, system in pairs(galaxy_objects) do
    if name ~= "galaxy_routes" and name ~= "solar-system" then
      local system_route = routes.create_system_route(system)
      --log(serpent.block(system_route))
      for _, edge in pairs(system_route) do
        local route = {
          type = "space-connection",
          name = edge[1].name .. "-to-" .. edge[2].name,
          subgroup = "planet-connections",
          icon = "__space-age__/graphics/icons/solar-system-edge.png",
          from = edge[1].name,
          to = edge[2].name,
          order = "h",
          length = 40000,
          asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.gleba_aquilo)
        }
        table.insert(system.children, route)
      end
    end
  end
end

local function create_routes_for_edge_in_system()
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
              if not planet.moon and planet.type == "planet" then
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

local function create_galaxy()
  create_galaxy_objects()
  create_routes_in_system()
  create_routes_between_system()
  create_routes_for_edge_in_system()
end


local debloque = {}
local function add_galaxy_to_game()
  --add planet and all object
  for name, system in pairs(galaxy_objects) do
    --log(name)
    if name == "galaxy_routes" then
      for _, route in pairs(system) do
        data:extend { route }
      end
    else
      for _, object in pairs(system.children) do
        data:extend { object }
        if object.type == "planet" or object.type == "space-location" then
          table.insert(debloque, {
            type = "unlock-space-location",
            space_location = object.name
          })
        end
      end
    end
  end
end


create_galaxy()
add_galaxy_to_game()





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
