--100=2*la distance du edge pour une sprite de 4096 starmap_edge_1  avec echelle a 3200
--edge a 50

--orbit_1=10.25
--orbit_2=14.75
--orbit_3=19.25
--orbit_4=25.5
--orbit_5=39.5
--orbit_6~=44.25
local asteroid = require("creator.asteroids")


local asteroid_util = require("__space-age__.prototypes.planet.asteroid-spawn-definitions")

local coord = require("util.coordonnee")
local backers = require("__WorldCreation__.backers")
local routes = require("creator.routes")
local corps = require("creator.planet")
local star = require("creator.star")
local util = require("util.util")

local orbit = { 10.25, 14.75, 19.25, 25.5, 39.5 }
local planet_density = { 0.25, 0.5, 0.8 }

local asteroids_belt_distance = 31.5 -- 4.5 orbit


local systeme = {}

function systeme.make_corps(parent_name, parent_location, distance_from_parent, angle, type, density, gen)
    local orbit_distance = 1
    if type == "asteroids_belt" then
        orbit_distance = 4.5
        distance_from_parent = asteroids_belt_distance
    elseif type == "edge" then
        orbit_distance = 10
        distance_from_parent = 50
    else
        orbit_distance = distance_from_parent
        distance_from_parent = orbit[distance_from_parent]
    end
    local p_angle = coord.angle_convert(parent_location.angle)
    local parent_position = coord.polaire_to_cart(parent_location.distance, p_angle)

    local c_angle = coord.angle_convert(angle)
    local position = coord.polaire_to_cart(distance_from_parent, c_angle)

    local cart_pos = { x = parent_position.x + position.x, y = parent_position.y + position.y }


    local distance = math.sqrt(cart_pos.x * cart_pos.x + cart_pos.y * cart_pos.y)
    local n_angle = coord.angle_convertf(coord.get_angle_from_cart(cart_pos))
    if type == "planet" then
        local planet = corps.make_planet(parent_name,backers, gen, distance_from_parent, angle, position, orbit_distance, distance, n_angle)
        planet.subgroup=parent_name
        planet.order="[a]"..planet.name
        return planet
    elseif type == "asteroids_belt" then
        local name = backers[gen:random(#backers)]
        local belt = {
            local_distance = distance_from_parent,
            local_angle = angle,
            position = position, --cartesian position depuis le centre du graph, avant décalge dans le system
            orbit_distance = orbit_distance,

            type = "space-location",
            name = "lihop-asteroids_belt-" .. name,
            localised_name = name,
            draw_orbit = false,
            icon = "__space-age__/graphics/icons/vulcanus.png",
            starmap_icon = "__space-age__/graphics/icons/starmap-planet-vulcanus.png",
            starmap_icon_size = 512,
            distance = distance,
            orientation = n_angle,
            fly_condition = true,
            subgroup=parent_name,
            order="[b]",
            magnitude = 1,
            gravity_pull = 3.7,
            asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.nauvis_vulcanus, 0.9),
        }
        return belt
    elseif type == "edge" then
        local edge = {
            local_distance = distance_from_parent,
            local_angle = angle,
            position = position,
            orbit_distance = orbit_distance,

            type = "space-location",
            name = "lihop-system-" .. parent_name .. "-edge",
            localised_name = parent_name .. "-edge",
            icon = "__space-age__/graphics/icons/solar-system-edge.png",
            order = "[c]",
            subgroup = "lihop-system-"..util.split(parent_name,"-")[1],
            draw_orbit = false,
            gravity_pull = -10,
            distance = distance,

            orientation = n_angle,
            magnitude = 1.0,
            label_orientation = 0.15,
            asteroid_spawn_influence = 1,
            asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.aquilo_solar_system_edge, 0.9)
        }
        return edge
    end
end

function systeme.create_routes_in_system(galaxy_objects)
    --add routes in system
    for name, system in pairs(galaxy_objects) do
        if name ~= "galaxy_routes" and name ~= "Calidus" then
            if #system.children == 3 then
                local asteroid_spawn_definitions = routes.asteroids_spawn(system.belt, system.children[2],
                    system.children[3])
                local route = {
                    type = "space-connection",
                    name = system.children[2].name .. "-to-" .. system.children[3].name,
                    subgroup = "planet-connections",
                    from = system.children[2].name,
                    to = system.children[3].name,
                    order = "h",
                    length = 40000,
                    asteroid_spawn_definitions =asteroid_spawn_definitions 
                }
                table.insert(system.children, route)
            else
                local system_route = routes.create_system_route(system)
                --log(serpent.block(system_route))
                for _, edge in pairs(system_route) do
                    local asteroid_spawn_definitions = routes.asteroids_spawn(system.belt, edge[1], edge[2])
                    local route = {
                        type = "space-connection",
                        name = edge[1].name .. "-to-" .. edge[2].name,
                        subgroup = "planet-connections",
                        from = edge[1].name,
                        to = edge[2].name,
                        order = "h",
                        length = 40000,
                        asteroid_spawn_definitions =asteroid_spawn_definitions
                    }
                    table.insert(system.children, route)
                end
            end

            --add space-connection for star
            local nearest_planet = nil
            local distance = 50
            for _, planet in pairs(system.children) do
                if (not planet.moon and planet.type == "planet") or (planet.type == "space-location" and string.find(planet.name, "asteroids_belt")) then
                    if planet.local_distance < distance then
                        nearest_planet = planet.name
                        distance = planet.local_distance
                    end
                end
            end
            local star = "lihop-star-" .. system.localised_name
            local route = {
                type = "space-connection",
                name = star .. "-to-" .. nearest_planet,
                subgroup = "planet-connections",
                from = star,
                to = nearest_planet,
                order = "h",
                length = 20000,
                asteroid_spawn_definitions =asteroid_spawn_definitions --asteroid_util.spawn_definitions(asteroid_util.gleba_aquilo)
            }
            table.insert(system.children, route)
        end
    end
end

function systeme.create_system(number,galaxy_objects, location, gen, global_map_gen)
    local name = backers[gen:random(#backers)]
    
    local system = {
        name = "lihop-system-" .. name,
        localised_name = name,
        density = gen:random(3),
        location = location,
        position = coord.polaire_to_cart(location.distance, coord.angle_convert(location.angle)),
        star_temperature = gen:random(100, 300),
        children = {}
    }
    data:extend({
        {
        type = "item-subgroup",
        name = system.name,
        group = "planets",
        order = tostring(number),
        }
    })
    --log(serpent.block(system))
    --sprite de l'etoile
    -- table.insert(data.raw["utility-sprites"]["default"]["starmap_star"].layers, {
    --     filename = "__core__/graphics/icons/starmap-star.png",
    --     size = 512,
    --     scale = gen:random(),
    --     shift = coord.position_to_layer(location.distance, location.angle),
    -- })
    table.insert(system.children, star.make_star(system))



    --add coprs (planet/moon)
    for i = 1, #orbit do
        if gen:random() < planet_density[system.density] then
            table.insert(system.children,systeme.make_corps(system.name, location, i, gen:random(), "planet", system.density, gen))
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
    if system.density < 3 then
        system.belt = true
        table.insert(system.children,
            systeme.make_corps(system.name, location, 0, gen:random(), "asteroids_belt", system.density, gen))
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
