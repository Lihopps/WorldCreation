local asteroid_util = require("__space-age__.prototypes.planet.asteroid-spawn-definitions")

local moon=require("creator.moon")

local moon_density = { 0, 0.10, 0.25 }

local corps = {}

function corps.make_planet(system_name,backers,gen,distance_from_parent,angle,position,orbit_distance,distance,n_angle)
    local name = backers[gen:random(#backers)]
    local planet = {
        local_distance = distance_from_parent,
        local_angle = angle,
        position = position,     --cartesian position depuis le centre du graph, avant décalge dans le system
        orbit_distance = orbit_distance,
        children = {},

        type = "planet",
        name = "lihop-planet-" .. name,
        localised_name = name,
        draw_orbit = false,
        distance = distance,
        orientation = n_angle,


        icon = "__space-age__/graphics/icons/vulcanus.png",
        starmap_icon = "__space-age__/graphics/icons/starmap-planet-vulcanus.png",
        starmap_icon_size = 512,
        magnitude = 1,
        gravity_pull = 3.7,
        solar_power_in_space=100,
        asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.nauvis_vulcanus, 0.9),
        
        
        map_gen_settings = data.raw.planet.vulcanus.map_gen_settings,
        surface_properties = {
          ["day-night-cycle"] = 58.7 * (24 * hour),
          ["magnetic-field"] = 1,
          ["solar-power"] = 500,
          pressure = 0,
          gravity = 3.7,
        }
    }

    planet.map_gen_settings.autoplace_controls["copper-ore"]={frequency=6,size=6,richness=6}
    planet.map_gen_settings.autoplace_settings["entity"]["settings"]["copper-ore"]={frequency=6,size=6,richness=6}

    --ici on peut creer une moon si besoin
    if gen:random() < moon_density[gen:random(1, 3)] then
        --log(serpent.block(galaxy_objects[parent_name]))
        
        local planet_moon = moon.make_moon(system_name,planet.name, { distance = distance, angle = n_angle }, 5, gen:random(),  gen,backers)
        table.insert(planet.children, planet_moon)
        local route = {
            type = "space-connection",
            name = planet.name .. "-to-" .. planet_moon.name,
            subgroup = "planet-connections",
            order = "h",
            from = planet.name,
            to = planet_moon.name,
            length = 5000,
            asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.gleba_aquilo)
        }
        table.insert(planet.children, route)
    end
    return planet
end

return corps
