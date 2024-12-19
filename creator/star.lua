-- min magnitude = 1  <= temperature =100 donc rouge  (naine rouge)
-- max magnitude = 12 <= temperature =300 donc bleu (geante bleu)

local util = require("util.util")

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

function star.make_star(system)

local star = {
            local_distance = 0,
            local_angle = 0,
            position = {x=0,y=0},
            orbit_distance = 0,
            is_not_in_route=true,

            type = "space-location",
            name = "lihop-star-" .. system.localised_name,
            description="Star : "..system.star_temperature,
            localised_name = system.localised_name,
            icons ={
                {
                icon= "__WorldCreation__/graphics/icons/starmap-star.png",
                tint=star_color(system.star_temperature),
                icon_size=512,
                }
            },
            magnitude = star_size(system.star_temperature),
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
            asteroid_spawn_influence = 0.2,
            asteroid_spawn_definitions = nil
        }
    return star
end

return star