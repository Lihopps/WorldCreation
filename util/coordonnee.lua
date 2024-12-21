local util=require("util.util")

local coord={}


-- function coord.angle_convert(angle)
--   return util.map(angle, 0, 1, 0, 2 * math.pi)
-- end
-- function coord.angle_convertf(angle)
--   return util.map(angle, 0, 2 * math.pi, 0, 1)
-- end

function coord.angle_convert(angle)
  angle=math.fmod(angle,1)
  local n_angle=0
  if angle >= 0 and angle < 90/360 then 
    n_angle=util.map(angle, 0, 90/360, math.pi/2, 0)
  elseif angle >=90/360 and angle<180/360 then
    n_angle= util.map(angle, 90/360, 180/360, 2*math.pi,3*math.pi/2 )
  elseif angle >=180/360 and angle<270/360 then
    n_angle= util.map(angle, 180/360, 270/360, 3*math.pi/2, math.pi)
  elseif angle >=270/360 and angle <1 then
    n_angle= util.map(angle, 270/360, 360/360, math.pi, math.pi/2)
  end
  --log(n_angle)
  return n_angle
end

function coord.angle_convertf(angle)
  angle=math.fmod(angle,2*math.pi)
  local n_angle=0
  if angle >= 0 and angle < math.pi/2 then 
    n_angle= util.map(angle, 0, math.pi/2, 90/360, 0)
  elseif angle >=math.pi/2 and angle<math.pi then
    n_angle= util.map(angle, math.pi/2, math.pi, 360/360,270/360 )
  elseif angle >=math.pi and angle<3*math.pi/2 then
    n_angle= util.map(angle, math.pi, 3*math.pi/2, 270/360, 180/360)
  elseif angle >=3*math.pi/2 and angle <2*math.pi then
    n_angle= util.map(angle, 3*math.pi/2, 2*math.pi, 180/360, 90/360)
  end
  --log(n_angle)
  if n_angle==1 then
    n_angle=0
  end
  return n_angle
end

function coord.polaire_to_cart(distance, angle)

  return { x = distance * math.cos(angle), y = distance * math.sin(angle) }
end

function coord.position_to_layer(distance, angle)
  local cart = coord.polaire_to_cart(distance, coord.angle_convert(angle) )
  --log(serpent.block(cart))
  return { util.map(cart.x, 0, 100, 0, 3200), -util.map(cart.y, 0, 100, 0, 3200) }
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
  elseif cart_pos.x==0 and cart_pos.y==0 then
    return 0
  end
end

function coord.cart_to_polaire(position)
  local polaire={
    distance=math.sqrt(position.x*position.x+position.y*position.y),
    angle= coord.angle_convertf(coord.get_angle_from_cart(position))
  }
  return polaire
end

function coord.create_system_location(max_system,gen)
  local points_cart={{x=0,y=0}}
  local max=0
  --log(serpent.block(points_cart))
  while #points_cart<max_system and max<5000 do
    local new_point={x=gen:random(-500,500),y=gen:random(-500,500)}
    local overlap=false
    for _,point in pairs(points_cart) do
      --log(serpent.block(point))
      --log(serpent.block(new_point))
      if util.distance2(new_point,point)<(50+50+2) then
        overlap=true
        break
      end
    end
    max=max+1
    if not overlap then
      table.insert(points_cart,new_point)
      max=0
    end
    
  end
  --table.insert(points,coord.cart_to_polaire({x=-150,y=0}))
  table.remove(points_cart,1)
  local points={}
  for _,point in pairs(points_cart) do
    table.insert(points,coord.cart_to_polaire(point))
  end
  log(#points.."/"..max_system)
  return points

end
return coord