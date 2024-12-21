local asteroid_util = require("__space-age__.prototypes.planet.asteroid-spawn-definitions")

local moon=require("creator.moon")
local map_gen=require("creator.map-gen")
local util=require("util.util")

local moon_density = { 0, 0.10, 0.25 }
local robot_cons={1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,3,3,3,4,4,5}

local corps = {}

function corps.make_planet(global_map_gen,system,system_name,backers,gen,distance_from_parent,angle,position,orbit_distance,distance,n_angle)
    local name = backers[gen:random(#backers)]
    local name_gen=map_gen.get_planet_type(global_map_gen,system,distance_from_parent,gen)--"vulcanus"
    local robot_comsuption=robot_cons[gen:random(1,#robot_cons)]
    local pressure=gen:random(500,5000)
    local magnetic_field=gen:random(5,100)
    local gravity=pressure*robot_comsuption/100
    local magnitude=util.map(gravity,5,250,0.95,1.5)
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


        icon = global_map_gen.graphics[name_gen][gen:random(1,#global_map_gen.graphics[name_gen])].icon or global_map_gen.planet[name_gen].icon,
        starmap_icon = global_map_gen.graphics[name_gen][gen:random(1,#global_map_gen.graphics[name_gen])].starmap_icon or global_map_gen.planet[name_gen].starmap_icon,
        starmap_icon_size = global_map_gen.graphics[name_gen][gen:random(1,#global_map_gen.graphics[name_gen])].starmap_icon_size or global_map_gen.planet[name_gen].starmap_icon_size,
        magnitude = magnitude,
        gravity_pull = 10*magnitude,
        solar_power_in_space=map_gen.get_solar_power_in_space(system,distance_from_parent),
        asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.nauvis_vulcanus, 0.9),
        
        
        map_gen_settings = data.raw.planet[name_gen].map_gen_settings,
        surface_properties = {
          ["day-night-cycle"] = 58.7 * (24 * hour),
          ["solar-power"] = map_gen.get_solar_power_surface(system,distance_from_parent,gen),
          ["magnetic-field"] = magnetic_field,
          size_surface=map_gen.get_size_from_planet_magnitude(magnitude),
          pressure = pressure,--4000
          gravity = gravity,--40     => 1
          --robot comsuption = 100*gravity/(pression)  gravity=pression*rc/100  
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
            subgroup = system_name,
            order = "[d]",
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
