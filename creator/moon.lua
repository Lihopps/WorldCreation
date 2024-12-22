local asteroid_util = require("__space-age__.prototypes.planet.asteroid-spawn-definitions")
local coord = require("util.coordonnee")
local map_gen=require("creator.map-gen")
local util=require("util.util")

local robot_cons={1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,3,3,3,4,4,5}

local corps = {}

--systeme.make_corps(parent_name, parent_location, distance_from_parent, angle, type, density, gen)
--moon.make_moon(planet.name, { distance = distance, angle = n_angle }, 5, gen:random(), "moon",0, gen)
function corps.make_moon(global_map_gen,system,planet,system_name,parent_name, parent_location, distance_from_parent, angle, gen, backers)
    local orbit_distance = 1
    orbit_distance = distance_from_parent
    distance_from_parent = 2

    local p_angle = coord.angle_convert(parent_location.angle)
    local parent_position = coord.polaire_to_cart(parent_location.distance, p_angle)

    local c_angle = coord.angle_convert(angle)
    local position = coord.polaire_to_cart(distance_from_parent, c_angle)

    local cart_pos = { x = parent_position.x + position.x, y = parent_position.y + position.y }


    local distance = math.sqrt(cart_pos.x * cart_pos.x + cart_pos.y * cart_pos.y)
    local n_angle = coord.angle_convertf(coord.get_angle_from_cart(cart_pos))


   
    local name = backers[gen:random(#backers)]
    local name_gen=map_gen.get_planet_type(global_map_gen,system,distance_from_parent,gen)--"vulcanus"
    local robot_comsuption=robot_cons[gen:random(1,#robot_cons)]
    local pressure=gen:random(500,5000)
    local magnetic_field=gen:random(5,100)
    local gravity=pressure*robot_comsuption/100
    local magnitude=util.map(gravity,5,250,0.5,0.8)


    local moon = {
        local_distance = distance_from_parent,
        local_angle = angle,
        position = position,     --cartesian position depuis le centre du graph, avant décalge dans le system
        orbit_distance = orbit_distance,
        is_not_in_route=true,
        moon=true,

        type = "planet",
        name = "lihop-moon-" .. name,
        localised_name = name,
        draw_orbit = false,
        distance = distance,
        orientation = n_angle,
        subgroup=system_name,
        order="[a]"..parent_name.."lihop-moon-" .. name,

        icon = global_map_gen.graphics[name_gen][gen:random(1,#global_map_gen.graphics[name_gen])].icon or global_map_gen.planet[name_gen].icon,
        starmap_icon = global_map_gen.graphics[name_gen][gen:random(1,#global_map_gen.graphics[name_gen])].starmap_icon or global_map_gen.planet[name_gen].starmap_icon,
        starmap_icon_size = global_map_gen.graphics[name_gen][gen:random(1,#global_map_gen.graphics[name_gen])].starmap_icon_size or global_map_gen.planet[name_gen].starmap_icon_size,
        magnitude = magnitude,
        gravity_pull = 10*magnitude,
        solar_power_in_space=planet.solar_power_in_space,
        
        asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.nauvis_vulcanus, 0.9),
        
        map_gen_settings = map_gen.tweak(data.raw.planet[name_gen].map_gen_settings),
        surface_properties = {
          ["day-night-cycle"] = gen:random(10,100) * (24 * hour),
          ["solar-power"] = math.floor(util.constraints(planet.solar_power_in_space-gen:random(50,200),1,10000000)),
          ["magnetic-field"] = magnetic_field,
          size_surface=map_gen.get_size_from_planet_magnitude(magnitude),
          pressure = pressure,--4000
          gravity = gravity,--40     => 1
          --robot comsuption = 100*gravity/(pression)  gravity=pression*rc/100  
        }
    }
    return moon
end

return corps
