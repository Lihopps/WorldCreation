local util={}

function util.map(n, start1, stop1, start2, stop2)
  return ((n - start1) / (stop1 - start1)) * (stop2 - start2) + start2;
end


function util.determiant(a,b,c,d,e,f,g,h,i)
    return a*e*i+b*f*g+c*d*h-c*e*g-b*d*i-a*f*h
end

function util.distance(point_A,point_B)
    local d=((point_A.position.x-point_B.position.x)*(point_A.position.x-point_B.position.x))+((point_A.position.y-point_B.position.y)*(point_A.position.y-point_B.position.y))
   
    return math.sqrt(d)
end


function util.distance2(point_A,point_B)
    local d=((point_A.x-point_B.x)*(point_A.x-point_B.x))+((point_A.y-point_B.y)*(point_A.y-point_B.y))
   
    return math.sqrt(d)
end

function util.in_circle(sommet,circle_data)
    if util.distance(sommet,circle_data) < circle_data.rayon then
        return true
    else
        return false
    end
end

function util.split (inputstr, sep)
   if sep == nil then
      sep = "%s"
   end
   local t={}
   for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
      table.insert(t, str)
   end
   return t
end

function util.constraints(value,min,max)
    if value<min then
        return min
    end
    if value>max then
        return max
    end
    return value
end


return util