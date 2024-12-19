local asteroid_util = require("__space-age__.prototypes.planet.asteroid-spawn-definitions")
local coord = require("util.coordonnee")

local corps = {}

--systeme.make_corps(parent_name, parent_location, distance_from_parent, angle, type, density, gen)
--moon.make_moon(planet.name, { distance = distance, angle = n_angle }, 5, gen:random(), "moon",0, gen)
function corps.make_moon(system_name,parent_name, parent_location, distance_from_parent, angle, gen, backers)
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

        icon = "__space-age__/graphics/icons/vulcanus.png",
        starmap_icon = "__space-age__/graphics/icons/starmap-planet-vulcanus.png",
        starmap_icon_size = 512,
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
end

return corps
