local util = require("util.util")
local function on_rocket_launch_ordered(e)
    if e.rocket and e.rocket.valid and e.rocket_silo then
        if e.rocket.cargo_pod and e.rocket_silo.name == "rocket-silo2" then
            local inv = e.rocket.cargo_pod.get_inventory(defines.inventory.cargo_unit)
            if not inv then return end

            local surface = e.rocket_silo.surface
            if surface then
                local platform = surface.platform
                if platform then
                    local sl = platform.space_location
                    if sl then
                        --game.print("chk1")
                        local name = sl.name
                        local item = inv[1]
                        if item.valid_for_read then
                            --game.print("chk2")
                            --game.print(item.name)
                            if item.prototype.rocket_launch_products then
                                local data = util.split(item.prototype.rocket_launch_products[1].name, "-")
                                --game.print(serpent.block(data))
                                if #data > 2 then
                                    if data[#data - 1] == "ioning" then
                                        --game.print("chk3")
                                        if data[#data] == "star" then
                                            --game.print("chk4")
                                            if string.find(name, "lihopstar") then
                                                --game.print("chk5")
                                                --all good
                                                return
                                            end
                                        elseif data[#data] == "belt" then
                                            --game.print("chk6")
                                            if string.find(name, "asteroids_belt") then
                                                --game.print("chk7")
                                                --all good
                                                return
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end

            --si on arrive c'est pas bon docn on clear pour cancel la ionisation
            game.print("Item in cargo can't be ionised hear")
            inv.clear()
        else
            game.print("no cargo pod detected!")
        end
    end
end

local rocket = {}

rocket.events = {
    [defines.events.on_rocket_launch_ordered] = on_rocket_launch_ordered,

}

return rocket
