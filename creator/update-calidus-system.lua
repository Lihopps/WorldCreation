local star = require("creator.star")

local update = {}

function update.update(galaxy_objects)
    galaxy_objects["lihop-system-Calidus"] = { name = "lihop-system-Calidus", localised_name = "Calidus", position = { x = 0, y = 0 }, location = { distance = 0, angle = 0 }, children = {}, star_temperature = 140 }
    local star = {
        local_distance = 0,
        local_angle = 0,
        position = { x = 0, y = 0 }, --cartesian position depuis le centre du graph, avant décalge dans le system
        orbit_distance = 0,
        children = {},

        type = "planet",
        name = "lihopstar-Calidus",
        localised_name = "Calidus",
        draw_orbit = false,
        distance = 0,
        orientation = 0,
        icons = {
            {
                icon = "__WorldCreation__/graphics/icons/starmap-star.png",
                tint = { r = 1, g = 0.8, b = 0, a = 1 },
                icon_size = 512,
            }
        },
        magnitude = 3.2,
        starmap_icons = {
            {
                icon = "__WorldCreation__/graphics/icons/starmap-star.png",
                tint = { r = 1, g = 0.8, b = 0, a = 1 },
                icon_size = 512,
            }
        },
        gravity_pull = 10 * 3.2,
        solar_power_in_space = 780,

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
            ["solar-power"] = 780,
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





    table.insert(galaxy_objects["lihop-system-Calidus"].children, star) --star.make_star(galaxy_objects["lihop-system-Calidus"]))
    table.insert(galaxy_objects["lihop-system-Calidus"].children,
        {
            type = "space-connection",
            name = "lihopstar-Calidus" .. "-to-" .. "vulcanus",
            subgroup = "lihop-system-Calidus",
            from = "lihopstar-Calidus",
            to = "vulcanus",
            order = "[d]",
            length = 1000, --100,
            asteroid_spawn_definitions = nil
        })

    data.raw.planet["vulcanus"].subgroup = "lihop-system-Calidus"
    data.raw.planet["vulcanus"].order = "1[1]"
    data.raw.planet["nauvis"].subgroup = "lihop-system-Calidus"
    data.raw.planet["nauvis"].order = "1[2]"
    data.raw.planet["gleba"].subgroup = "lihop-system-Calidus"
    data.raw.planet["gleba"].order = "1[3]"
    data.raw.planet["fulgora"].subgroup = "lihop-system-Calidus"
    data.raw.planet["fulgora"].order = "1[4]"
    data.raw.planet["aquilo"].subgroup = "lihop-system-Calidus"
    data.raw.planet["aquilo"].order = "1[5]"
    data.raw["space-location"]["solar-system-edge"].subgroup = "lihop-system-Calidus"
    data.raw["space-location"]["solar-system-edge"].order = "[c]0"
    data.raw["space-location"]["shattered-planet"].subgroup = "lihop-system-Calidus"
    data.raw["space-location"]["shattered-planet"].order = "[c]1"

    local connection = {
        ["nauvis-vulcanus"] = true,
        ["nauvis-gleba"] = true,
        ["nauvis-fulgora"] = true,
        ["vulcanus-gleba"] = true,
        ["gleba-fulgora"] = true,
        ["gleba-aquilo"] = true,
        ["fulgora-aquilo"] = true,
        ["aquilo-solar-system-edge"] = true,
        ["solar-system-edge-shattered-planet"] = true,
    }
    for name, _ in pairs(connection) do
        data.raw["space-connection"][name].subgroup = "lihop-system-Calidus"
        data.raw["space-connection"][name].order = "[d]"
    end
end

return update
