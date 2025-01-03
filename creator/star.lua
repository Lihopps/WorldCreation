-- min magnitude = 1  <= temperature =100 donc rouge  (naine rouge)
-- max magnitude = 12 <= temperature =300 donc bleu (geante bleu)

local util = require("util.util")
local asteroids = require("creator.asteroids")

local function star_power(temperature)
    return util.map(temperature,100,300,600,1500)
end

local function star_color(temperature)
    local step=(300-100)/4
    if temperature>=100+0*step and temperature<100+1*step then
        return {r=1,g=util.map(temperature,100+0*step,100+1*step,0,1),b=0,a=1}
    elseif temperature>=100+1*step and temperature<100+2*step then
        return {r=1,g=1,b=util.map(temperature,100+1*step,100+2*step,0,1),a=1}
    elseif temperature>=100+2*step and temperature<100+3*step then
        return {r=util.map(temperature,100+2*step,100+3*step,1,0),g=1,b=1,a=1}
    elseif temperature>=100+3*step and temperature<100+4*step then
        return {r=0,g=util.map(temperature,100+3*step,100+4*step,1,0),b=1,a=1}
    end
end

local function star_size(temperature)
    return util.map(temperature,100,300,1,12)
end

local star={}

function star.make_dyson_site(old_star)
    local old_star=table.deepcopy(old_star)
    local star = {
        local_distance = old_star.local_distance,
        local_angle = old_star.local_angle,
        position = old_star.position, --cartesian position depuis le centre du graph, avant décalge dans le system
        orbit_distance = 0,
        children = old_star.children,

        type = "planet",
        name = old_star.name,
        localised_name = old_star.localised_name,
        order = old_star.order,
        subgroup = old_star.subgroup,
        draw_orbit = false,
        distance = old_star.distance,
        orientation = old_star.orientation,
        icons = old_star.icons,
        magnitude = old_star.magnitude,
        starmap_icons = old_star.starmap_icons,
        gravity_pull = old_star.grivity_pull,
        solar_power_in_space = old_star.solar_power_in_space,

        --asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.nauvis_vulcanus, 0.9),

        map_gen_settings = {
            default_enable_all_autoplace_controls = false,
            autoplace_settings = {
                tile = {
                    treat_missing_as_default = false,
                    settings = {
                        ["empty-space"] = {},
                        -- ["space-platform-foundation"]={}
                    }
                }
            },
            property_expression_names = {},
            starting_points = { { x = 0, y = 0 } },
            seed = 1,
            starting_area = 1,
            peaceful_mode = false,
            no_enemies_mode = false,
            cliff_settings = {
                name = "",
                control = "",
                cliff_elevation_0 = 0,
                cliff_elevation_interval = 0,
                cliff_smoothing = 0,
                richness = 1
            }
        },
        surface_properties = {
            ["day-night-cycle"] = 0,
            ["solar-power"] = old_star.solar_power_in_space,
            ["magnetic-field"] = 1000,
            dyson_sphere_site = 1,
            pressure = 100000, --4000
            gravity = 1000, --40     => 1
            --robot comsuption = 100*gravity/(pression)  gravity=pression*rc/100
        },
        player_effects = {
            {
                type = "direct",
                action_delivery =
                {
                    type = "instant",
                    target_effects =
                    {
                        type = "nested-result",
                        action =
                        {
                            type = "area",
                            radius = 5,
                            entity_flags = { "breaths-air" },
                            action_delivery =
                            {
                                type = "instant",
                                target_effects =
                                {
                                    type = "damage",
                                    damage = { amount = 30, type = "poison" }
                                }
                            }
                        }
                    }
                }
            }
        },
        ticks_between_player_effects = 60


    }
    return star
end


function star.make_star(system)
local asteroids_spawn,asteroid_influence,spawn_data=asteroids.spawn_star()
local magnitude=star_size(system.star_temperature)
local star = {
            local_distance = 0,
            local_angle = 0,
            position = {x=0,y=0},
            orbit_distance = 0,
            is_not_in_route=true,

            type = "space-location",
            name = "lihopstar-" .. system.localised_name,
            description="Star : "..system.star_temperature,
            localised_name = system.localised_name,
            localised_description = "[fluid=fusion-plasma]",
            icons ={
                {
                icon= "__WorldCreation__/graphics/icons/starmap-star.png",
                tint=star_color(system.star_temperature),
                icon_size=512,
                }
            },
            magnitude = magnitude,
            starmap_icons={
                {
                icon= "__WorldCreation__/graphics/icons/starmap-star.png",
                tint=star_color(system.star_temperature),
                icon_size=512,
                }
            },
            order = "0",
            subgroup = system.name,
            draw_orbit = false,
            gravity_pull = -10,
            solar_power_in_space= star_power(system.star_temperature),
            distance = system.location.distance,
            orientation = system.location.angle,
           
            label_orientation = 0.15,
            asteroid_spawn_definitions = asteroids_spawn,
            asteroid_spawn_influence=util.map(magnitude,1,12,0.3,0.6),
            spawn_data=spawn_data
        }
    return star
end

return star