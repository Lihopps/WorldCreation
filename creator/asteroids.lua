local asteroid_util = require("__space-age__.prototypes.planet.asteroid-spawn-definitions")


local belt_multiplier = 3
local star_multiplier = 0.3

--asteroid_util.spawn_definitions(asteroid_util.nauvis_gleba, 0.9),
local function empty_spawn()
    return nil, 0.05
end

local function get_planet_spawn(name)
    return table.deepcopy(data.raw.planet.asteroid_spawn_definitions)
end

local function get_connection_spawn(name)
    return table.deepcopy(data.raw["space-connection"][name].asteroid_spawn_definitions)
end

local function tweak(spawn_points, key, value)
    for i, spawn_ast in pairs(spawn_points) do
        spawn_ast[key] = value
    end
    return spawn_points
end


local function get(tbl,type)
    if tbl then
        if tbl[type] then
            return tbl[type][1].probability
        else
            return nil
        end
    else
        return nil
    end
end

local function getr(tbl,type)
    if tbl then
        if tbl[type] then
            return tbl[type][1].ratios
        else
            return nil
        end
    else
        return nil
    end

end

local asteroid = {}

function asteroid.spawn_connection_edge_to_edge()
    --le vide spacial
    return empty_spawn()
end

function asteroid.spawn_connection_inner_to_inner(belt, from, to)
    local div=1000
    local gen = mwc(math.random(1, 10))
    local data = {
        probability_on_range_chunk =
        {
            { position = 0.1, probability = get(from.spawn_data,"probability_on_range_chunk") or 0, angle_when_stopped = 1 },
            { position = 0.2, probability = gen:random() / div,                                             angle_when_stopped = 1 },
            { position = 0.3, probability = gen:random() / div,                                             angle_when_stopped = 1 },
            { position = 0.4, probability = gen:random() / div,                                             angle_when_stopped = 1 },
            { position = 0.5, probability = gen:random() / div,                                             angle_when_stopped = 1 },
            { position = 0.6, probability = gen:random() / div,                                             angle_when_stopped = 1 },
            { position = 0.7, probability = gen:random() / div,                                             angle_when_stopped = 1 },
            { position = 0.8, probability = gen:random() / div,                                             angle_when_stopped = 1 },
            { position = 0.9, probability = get(to.spawn_data,"probability_on_range_chunk") or 0,   angle_when_stopped = 1 },
        },
        probability_on_range_medium =
        {
            { position = 0.1, probability = get(from.spawn_data,"probability_on_range_medium") or 0, angle_when_stopped = 1 },
            { position = 0.2, probability = gen:random() / div,                                             angle_when_stopped = 1 },
            { position = 0.3, probability = gen:random() / div,                                             angle_when_stopped = 1 },
            { position = 0.4, probability = gen:random() / div,                                             angle_when_stopped = 1 },
            { position = 0.5, probability = gen:random() / div,                                             angle_when_stopped = 1 },
            { position = 0.6, probability = gen:random() / div,                                             angle_when_stopped = 1 },
            { position = 0.7, probability = gen:random() / div,                                             angle_when_stopped = 1 },
            { position = 0.8, probability = gen:random() / div,                                             angle_when_stopped = 1 },
            { position = 0.9, probability = get(to.spawn_data,"probability_on_range_medium") or 0,   angle_when_stopped = 1 },
        
        },
        probability_on_range_big =
        {
            { position = 0.1, probability = get(from.spawn_data,"probability_on_range_big") or 0, angle_when_stopped = 1 },
            { position = 0.2, probability = gen:random() / div,                                             angle_when_stopped = 1 },
            { position = 0.3, probability = gen:random() / div,                                             angle_when_stopped = 1 },
            { position = 0.4, probability = gen:random() / div,                                             angle_when_stopped = 1 },
            { position = 0.5, probability = gen:random() / div,                                             angle_when_stopped = 1 },
            { position = 0.6, probability = gen:random() / div,                                             angle_when_stopped = 1 },
            { position = 0.7, probability = gen:random() / div,                                             angle_when_stopped = 1 },
            { position = 0.8, probability = gen:random() / div,                                             angle_when_stopped = 1 },
            { position = 0.9, probability = get(to.spawn_data,"probability_on_range_big") or 0,   angle_when_stopped = 1 },
        
        },
        probability_on_range_huge =
        {
            { position = 0.1, probability = get(from.spawn_data,"probability_on_range_huge") or 0, angle_when_stopped = 1 },
            { position = 0.2, probability = gen:random() / div,                                             angle_when_stopped = 1 },
            { position = 0.3, probability = gen:random() / div,                                             angle_when_stopped = 1 },
            { position = 0.4, probability = gen:random() / div,                                             angle_when_stopped = 1 },
            { position = 0.5, probability = gen:random() / div,                                             angle_when_stopped = 1 },
            { position = 0.6, probability = gen:random() / div,                                             angle_when_stopped = 1 },
            { position = 0.7, probability = gen:random() / div,                                             angle_when_stopped = 1 },
            { position = 0.8, probability = gen:random() / div,                                             angle_when_stopped = 1 },
            { position = 0.9, probability = get(to.spawn_data,"probability_on_range_huge") or 0,   angle_when_stopped = 1 },
        
        },
        type_ratios =
        {
            { position = 0.1, ratios = getr(from.spawn_data,"type_ratios") or { 1, 1, 1, 0 } },
            { position = 0.2, ratios = { gen:random(0, 10), gen:random(0, 10), gen:random(0, 10), 0 } },
            { position = 0.3, ratios = { gen:random(0, 10), gen:random(0, 10), gen:random(0, 10), 0 } },
            { position = 0.4, ratios = { gen:random(0, 10), gen:random(0, 10), gen:random(0, 10), 0 } },
            { position = 0.5, ratios = { gen:random(0, 10), gen:random(0, 10), gen:random(0, 10), 0 } },
            { position = 0.6, ratios = { gen:random(0, 10), gen:random(0, 10), gen:random(0, 10), 0 } },
            { position = 0.7, ratios = { gen:random(0, 10), gen:random(0, 10), gen:random(0, 10), 0 } },
            { position = 0.8, ratios = { gen:random(0, 10), gen:random(0, 10), gen:random(0, 10), 0 } },
            { position = 0.9, ratios = getr(to.spawn_data,"type_ratios") or { 1, 1, 1, 0 } },
        }
    }

    local size={"chunk","medium","big","huge"}
    for i=0,3 do
        if math.random()<0.3 then
            local j = math.random(1,#size)
            data["probability_on_range_"..size[j]]=nil
            table.remove(size,j)
        end
    end

    --if belt on way
    if belt then
        if math.min(from.orbit_distance, to.orbit_distance) < 4.5 and math.max(from.orbit_distance, to.orbit_distance) > 4.5 then
            log("routes in asteroids")
            for _,p in pairs(size) do
                p="probability_on_range_"..p
                for i=3,7 do
                    data[p][i].probability=data[p][i].probability*belt_multiplier*10
                end
            end
        end
    end


    local spawn = asteroid_util.spawn_definitions(data)
    --log(serpent.block(spawn))
    return spawn
end

function asteroid.spawn_planet(name_gen)
    local planet_div=0.8
    local gen = mwc(math.random(1, 10))
    local data = {
        probability_on_range_medium =
        {
            { position = 0.1, probability = planet_div*gen:random() / 100, angle_when_stopped = 1 },
        },
        probability_on_range_big =
        {
            { position = 0.1, probability = planet_div*gen:random() / 100 , angle_when_stopped = 1 },
        },
        type_ratios =
        {
            { position = 0.1, ratios = { gen:random(0, 10), gen:random(0, 10), gen:random(0, 10), 0 } },
        }
    }

    local spawn = asteroid_util.spawn_definitions(data,0.1)
    --log(serpent.block(spawn))
    return spawn,0.3,data
end

function asteroid.spawn_edge()
    --debut/fin du vide
    return empty_spawn()
end

function asteroid.spawn_belt()
    --que du huge ou big
    --tres frequent
    --beaucoup d'angle
    --pas vite du tout
    local gen = mwc(math.random(1, 10))
    local data = {
        probability_on_range_big =
        {
            { position = 0.1, probability = belt_multiplier * gen:random() / 100, angle_when_stopped = 1 },
        },
        probability_on_range_huge =
        {
            { position = 0.1, probability = belt_multiplier * gen:random() / 100, angle_when_stopped = 1 },
        },
        type_ratios =
        {
            { position = 0.1, ratios = { gen:random(0, 10), gen:random(0, 10), gen:random(0, 10), 0 } },
        }
    }

    local spawn = asteroid_util.spawn_definitions(data, 0.1)
    spawn = tweak(spawn, "speed", 0.25 * meter / second)
    spawn = tweak(spawn, "angle_when_stopped", 1)
    return spawn, 0.3, data
end

function asteroid.spawn_star() --et gazeuse
    --de tout
    --tres tres peu fréquent
    --angle 1
    --tres vite tel l'emeu
    local gen = mwc(math.random(1, 10))
    local data = {
        probability_on_range_small =
        {
            { position = 0.1, probability = star_multiplier * gen:random() / 100, angle_when_stopped = 1 },
        },
        probability_on_range_medium =
        {
            { position = 0.1, probability = star_multiplier * gen:random() / 100, angle_when_stopped = 1 },
        },
        probability_on_range_big =
        {
            { position = 0.1, probability = star_multiplier * gen:random() / 100, angle_when_stopped = 1 },
        },
        probability_on_range_huge =
        {
            { position = 0.1, probability = star_multiplier * gen:random() / 100, angle_when_stopped = 1 },
        },
        type_ratios =
        {
            { position = 0.1, ratios = { gen:random(0, 10), gen:random(0, 10), gen:random(0, 10), 0 } },
        }
    }
    local spawn = asteroid_util.spawn_definitions(data, 0.1)
    spawn = tweak(spawn, "speed", 0.3)
    spawn = tweak(spawn, "angle_when_stopped", 1)
    return spawn, 0.3, data
end

return asteroid
