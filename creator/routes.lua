local asteroid_util = require("__space-age__.prototypes.planet.asteroid-spawn-definitions")

local coord=require("util.coordonnee")
local util=require("util.util")

local routes={}

local function make_supertriangle(state)
    local offset=2
    local d=500
    if state==1 then
        d=1000
    end

    local dist=d--(d/math.cos(math.pi/3))+offset
    local position=coord.polaire_to_cart(dist,0)
    local point_A={
        position=position,  --cartesian position in system
        name = "point_A",
    }
    position=coord.polaire_to_cart(dist,2*math.pi/3)
    local point_B={
        position=position,  --cartesian position in system
        name = "point_B",
    }
    position=coord.polaire_to_cart(dist,4*math.pi/3)
    local point_C={
        position=position,  --cartesian position in system
        name = "point_C",
    }
    
    return {name=point_A.name.."-"..point_B.name.."-"..point_C.name,sommet={point_A,point_B,point_C},edge={{point_A,point_B},{point_B,point_C},{point_C,point_A}}}
end

local function cercle_circonscrit(triangle)
    local pa=triangle.sommet[1]
    local pb=triangle.sommet[2]
    local pc=triangle.sommet[3]
    
    local delta= util.determiant(pa.position.x,pa.position.y,1,pb.position.x,pb.position.y,1,pc.position.x,pc.position.y,1)
    local a=pa.position.x*pa.position.x+pa.position.y*pa.position.y
    local d=pb.position.x*pb.position.x+pb.position.y*pb.position.y
    local g=pc.position.x*pc.position.x+pc.position.y*pc.position.y
    local x=(1/(2*delta))*util.determiant(a,pa.position.y,1,d,pb.position.y,1,g,pc.position.y,1)
    local y=-(1/(2*delta))*util.determiant(a,pa.position.x,1,d,pb.position.x,1,g,pc.position.x,1)
    local centre={x=x,y=y}
    
    local rayon=(util.distance(pa,pb)*util.distance(pb,pc)*util.distance(pc,pa))/(2*delta)
    --log(serpent.block(rayon))
    --log(serpent.block(centre))
    return {position=centre,rayon=rayon}
end

function routes.triangulation(system,state)
    local supertriangle=make_supertriangle(state)
    local triangles={supertriangle}
    local points={}
    if state==0 then
        points=system.children
    elseif state==1 then
        points=system
        --log(serpent.block(points))
    end
    
    for _,sommet in pairs(points) do
        --log(serpent.block(sommet))
        if not sommet.is_not_in_route then
            local badTriangles={}
            local polygon ={}
            for _,triangle in pairs(triangles) do
                local cercle_data= cercle_circonscrit( triangle )
                --log(serpent.block(triangle))
                --log(serpent.block(cercle_data))
                --log(serpent.block(sommet))
                if util.in_circle(sommet,cercle_data) then
                    table.insert(badTriangles,triangle)
                    for _,edge in pairs(triangle.edge) do
                        table.insert(polygon,edge)
                    end
                end
            end

            for _,tri in pairs(badTriangles) do
                for j=#triangles,1,-1 do
                    if tri.name==triangles[j].name then
                        table.remove(triangles,j)
                    end
                end
            end
            --log(serpent.block(polygon))
            for _,edge in pairs(polygon) do 
                local triangle={
                    name=sommet.name.."-"..edge[1].name.."-"..edge[2].name,
                    sommet={
                        sommet,edge[1],edge[2]
                    },
                    edge={
                        {sommet,edge[1]},
                        {edge[1],edge[2]},
                        {edge[2],sommet}
                    }
                }
                table.insert(triangles,triangle)
            end

        end

    end
    --log(serpent.block(triangles))
    local final_triangles={}
    for _,triangle in pairs(triangles) do
        if not string.match(triangle.name, "point_") then
            table.insert(final_triangles,triangle)
        end
    end
    --log(serpent.block(final_triangles))
    return final_triangles
end

function routes.make_final_routes(space_routes)
    local final_routes={}
    for _,triangle in pairs(space_routes) do
        for _,edge in pairs(triangle.edge) do
            for _,route in pairs(final_routes) do
                if (edge[1].name==route[1].name and edge[2].name==route[2].name) or  (edge[1].name==route[2].name and edge[2].name==route[1].name) then
                    goto pass2
                end
            end
            table.insert(final_routes,edge)
            ::pass2::
        end
    end
    return final_routes
end

function routes.create_system_route(system)
    local space_routes = routes.triangulation(system,0)
    local final_space_route=routes.make_final_routes(space_routes)
    return final_space_route
end

function routes.create_galaxy_routes(galaxy_objects)
--galaxy_objects assuming il n'y a que des systems dedans
  --log(serpent.block(galaxy_objects))
    local tmp_galaxy_objects=table.deepcopy(galaxy_objects)
    tmp_galaxy_objects["calidus"] = {name="solar-system",position={x=0,y=0},location={distance=0,angle=0}}
    local galaxy_routes = routes.triangulation(galaxy_objects,1)
    --log(serpent.block(galaxy_routes))
    local final_galaxy_routes=routes.make_final_routes(galaxy_routes)
    --log(serpent.block(final_galaxy_routes))
    return final_galaxy_routes



end

function routes.asteroids_spawn(belt,planet_1,planet_2)
    if belt then
        --log(serpent.block(planet_1))
        --log(serpent.block(planet_2))
        if math.min(planet_1.orbit_distance,planet_2.orbit_distance)<4.5 and math.max(planet_1.orbit_distance,planet_2.orbit_distance)>4.5 then
            log("routes in asteroids")
            return asteroid_util.spawn_definitions(asteroid_util.gleba_aquilo)
        end
    end
    return asteroid_util.spawn_definitions(asteroid_util.gleba_aquilo)
end

return routes