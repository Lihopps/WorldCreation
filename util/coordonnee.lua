local util=require("util.util")

local coord={}


function coord.angle_convert(angle)
  return util.map(angle, 0, 1, 0, 2 * math.pi)
end
function coord.angle_convertf(angle)
  return util.map(angle, 0, 2 * math.pi, 0, 1)
end

function coord.polaire_to_cart(distance, angle)
  return { x = distance * math.cos(angle), y = distance * math.sin(angle) }
end

function coord.position_to_layer(distance, angle)
  local cart = coord.polaire_to_cart(distance, coord.angle_convert(angle) - math.pi / 2)
  --log(serpent.block(cart))
  return { util.map(cart.x, 0, 100, 0, 3200), util.map(cart.y, 0, 100, 0, 3200) }
end

function coord.get_angle_from_cart(cart_pos)
  if cart_pos.x > 0 and cart_pos.y >= 0 then
    return math.atan(cart_pos.y / cart_pos.x)
  elseif cart_pos.x > 0 and cart_pos.y < 0 then
    return math.atan(cart_pos.y / cart_pos.x) + 2 * math.pi
  elseif cart_pos.x < 0 then
    return math.atan(cart_pos.y / cart_pos.x) + math.pi
  elseif cart_pos.x == 0 and cart_pos.y > 0 then
    return math.pi / 2
  elseif cart_pos.x == 0 and cart_pos.y < 0 then
    return 3 * math.pi / 2
  end
end

return coord