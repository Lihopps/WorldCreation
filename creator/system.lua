--100=2*la distance du edge pour une sprite de 4096 starmap_edge_1  avec echelle a 3200
--edge a 50

--orbit_1=10.25
--orbit_2=14.75
--orbit_3=19.25
--orbit_4=25.5
--orbit_5=39.5
--orbit_6~=44.25

local asteroid_util = require("__space-age__.prototypes.planet.asteroid-spawn-definitions")

local coord = require("util.coordonnee")
local backers = require("__WorldCreation__.backers")
local routes = require("creator.routes")

local orbit = { 10.25, 14.75, 19.25, 25.5, 39.5 }
local planet_density = { 0.25, 0.5, 0.8 }
local moon_density = { 0, 0.10, 0.25 }
local asteroids_belt_distance=31.5  -- 4.5 orbit


local systeme={}

function systeme.make_corps(parent_name, parent_location, distance_from_parent, angle, type, density,gen)
  local orbit_distance=1
  if type=="asteroids_belt" then
    orbit_distance=4.5
    distance_from_parent=asteroids_belt_distance
  elseif type=="edge" then
    orbit_distance=10
    distance_from_parent=50
  elseif type=="moon" then
    orbit_distance=distance_from_parent
    distance_from_parent=2
  else
    orbit_distance=distance_from_parent
    distance_from_parent=orbit[distance_from_parent]
  end
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
      orbit_distance=orbit_distance,
      children={},

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
    if gen:random()<1 then--moon_density[gen:random(1,3)] then
      --log(serpent.block(galaxy_objects[parent_name]))
      local moon=systeme.make_corps(corps.name, {distance=distance,angle=n_angle}, 5, gen:random(), "moon", 0,gen)
      table.insert(corps.children, moon)
      local route = {
        type = "space-connection",
        name = corps.name .. "-to-" .. moon.name,
        subgroup = "planet-connections",
        icon = "__space-age__/graphics/icons/solar-system-edge.png",
        order = "h",
        from=corps.name,
        to=moon.name,
        length = 5000,
        asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.gleba_aquilo)
      }
      table.insert(corps.children,route)
    end
    return corps
  elseif type == "moon" then
    local name = backers[gen:random(#backers)]
    local moon = {
      local_distance = distance_from_parent,
      local_angle = angle,
      position = position, --cartesian position depuis le centre du graph, avant décalge dans le system
      orbit_distance=orbit_distance,
      moon=true,

      type = "planet",
      name = "lihop-moon-" .. name,
      localised_name = name,
      draw_orbit = false,
      icon = "__space-age__/graphics/icons/vulcanus.png",
      starmap_icon = "__space-age__/graphics/icons/starmap-planet-vulcanus.png",
      starmap_icon_size = 512,
      distance = distance,
      orientation = n_angle,
      magnitude = 0.2,
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
    return moon
  elseif type == "asteroids_belt" then
    local name = backers[gen:random(#backers)]
    local belt = {
      local_distance = distance_from_parent,
      local_angle = angle,
      position = position, --cartesian position depuis le centre du graph, avant décalge dans le system
      orbit_distance=orbit_distance,

      type = "space-location",
      name = "lihop-asteroids_belt-" .. name,
      localised_name = name,
      draw_orbit = false,
      icon = "__space-age__/graphics/icons/vulcanus.png",
      starmap_icon = "__space-age__/graphics/icons/starmap-planet-vulcanus.png",
      starmap_icon_size = 512,
      distance = distance,
      orientation = n_angle,
      fly_condition=true,
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
    return belt
  elseif type == "edge" then
    local edge = {
      local_distance = distance_from_parent,
      local_angle = angle,
      position = position,
      orbit_distance=orbit_distance,

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
      asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.aquilo_solar_system_edge,0.9)
    }
    return edge
  end
end



function systeme.create_routes_in_system(galaxy_objects)
  --add routes in system
  for name, system in pairs(galaxy_objects) do
    if name ~= "galaxy_routes" and name ~= "solar-system" then
      if #system.children==2 then
        local asteroid_spawn_definitions=routes.asteroids_spawn(system.belt,system.children[1],system.children[2])
        local route = {
            type = "space-connection",
            name = system.children[1].name .. "-to-" .. system.children[2].name,
            subgroup = "planet-connections",
            icon = "__space-age__/graphics/icons/solar-system-edge.png",
            from = system.children[1].name,
            to = system.children[2].name,
            order = "h",
            length = 40000,
            asteroid_spawn_definitions = asteroid_spawn_definitions--asteroid_util.spawn_definitions(asteroid_util.gleba_aquilo)
          }
          table.insert(system.children, route)
      else 
        local system_route = routes.create_system_route(system)
        --log(serpent.block(system_route))
        for _, edge in pairs(system_route) do
          local asteroid_spawn_definitions=routes.asteroids_spawn(system.belt,edge[1],edge[2])
          local route = {
            type = "space-connection",
            name = edge[1].name .. "-to-" .. edge[2].name,
            subgroup = "planet-connections",
            icon = "__space-age__/graphics/icons/solar-system-edge.png",
            from = edge[1].name,
            to = edge[2].name,
            order = "h",
            length = 40000,
            asteroid_spawn_definitions = asteroid_spawn_definitions--asteroid_util.spawn_definitions(asteroid_util.gleba_aquilo)
          }
          table.insert(system.children, route)
        end
      end
    end
  end
end



function systeme.create_system(galaxy_objects,location,gen)
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

  --add coprs (planet/moon)
  for i = 1, #orbit do
    if gen:random() < planet_density[system.density] then
      table.insert(system.children, systeme.make_corps(system.name, location, i, gen:random(), "planet", system.density,gen))
      --sprite pour l'orbit
      table.insert(data.raw["utility-sprites"]["default"]["starmap_star"].layers, {
        filename = "__WorldCreation__/graphics/icons/starmap_orbit_" .. i .. ".png",
        size = 4096,
        scale = 1,
        shift = coord.position_to_layer(location.distance, location.angle),
      })
    end
  end

  --add asteroids belt
  if system.density<3 then
    system.belt=true
    table.insert(system.children, systeme.make_corps(system.name, location, 0, gen:random(), "asteroids_belt", system.density,gen)) 
    table.insert(data.raw["utility-sprites"]["default"]["starmap_star"].layers, {
          filename = "__WorldCreation__/graphics/icons/starmap_asteroid_belt.png",
          size = 4096,
          scale = 1,
          shift = coord.position_to_layer(location.distance, location.angle),
        })
  end

  galaxy_objects[system.name] = system
end



return systeme