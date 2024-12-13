local asteroid_util = require("__space-age__.prototypes.planet.asteroid-spawn-definitions")

local coord=require("util.coordonnee")
local util=require("util.util")

local routes={}

local function make_supertriangle()
    local offset=2
    local dist=(50/math.cos(math.pi/3))+offset
    local position=coord.polaire_to_cart(dist,0*120/360)
    log(serpent.block(position))
    local point_A={
        position=position,  --cartesian position in system
        name = "point_A",
    }
    position=coord.polaire_to_cart(dist,1*120/360)
    local point_B={
        position=position,  --cartesian position in system
        name = "point_B",
    }
    position=coord.polaire_to_cart(dist,2*120/360)
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
    local x=(1/2*delta)*util.determiant(a,pa.position.y,1,d,pb.position.y,1,g,pc.position.y,1)
    local y=-(1/2*delta)*util.determiant(a,pa.position.x,1,d,pb.position.x,1,g,pc.position.x,1)
    local centre={x=x,y=y}
    local rayon=(util.distance(pa,pb)+util.distance(pb,pc)+util.distance(pc,pa))/(2*delta)
    return {position=centre,rayon=rayon}
end

function routes.triangulation(system)
    local supertriangle=make_supertriangle()
    local triangles={supertriangle}
    log(serpent.block(supertriangle))
    for _,sommet in pairs(system.children) do
        if not sommet.moon then
            local badTriangles={}
        
            for _,triangle in pairs(triangles) do
                local cercle_data= cercle_circonscrit( triangle )
                log(serpent.block(cercle_data))
                if util.in_circle(sommet,cercle_data) then
                    table.insert(badTriangles,triangle)
                end
            end
            log(serpent.block(badTriangles))
            local polygon ={}
            for _,triangle in pairs(badTriangles) do
               for _,edge in pairs(triangle.edge) do
                    for _,tri in pairs(badTriangles) do
                        for _,ed in pairs(tri.edge) do
                            if (edge[1].name==ed[1].name and edge[2].name==ed[2].name) or  (edge[1].name==ed[2].name and edge[2].name==ed[1].name) then
                                goto shared
                            end
                        end
                    end
                    -- si on arrive ici c'est que pas shared
                    table.insert(polygon,edge)

                    ::shared::
               end
            end
            log(serpent.block(badTriangles))
            for _,tri in pairs(badTriangles) do
                for j=#triangles,1,-1 do
                    if tri.name==triangles[j].name then
                        table.remove(triangles,j)
                    end
                end
            end
            for _,edge in pairs(polygon) do 
                local triangle={
                    sommet.name.."-"..edge[1].name.."-"..edge[2].name,
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
    log(serpent.block(triangles))
    for i=#triangles,1,-1 do
        for _,edge in pairs(triangles[i].edge) do
            for _,ed in pairs(supertriangle.edge) do
                if (edge[1].name==ed[1].name and edge[2].name==ed[2].name) or  (edge[1].name==ed[2].name and edge[2].name==ed[1].name) then
                    table.remove(triangles,i)
                    goto pass
                end
            end
        end
        ::pass::
    end
    log(serpent.block(triangles))
    return triangles
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

function routes.add_system_route(system)
    local space_routes = routes.triangulation(system)
    log(serpent.block(space_routes))
    local final_space_route=routes.make_final_routes(space_routes)
    log(serpent.block(final_space_route))
    for _,edge in pairs(final_space_route) do
        data:extend {{
            type = "space-connection",  
            name = edge[1].name.."-to-"..edge[2].name,  
            subgroup = "planet-connections",  
            icon = "__space-age__/graphics/icons/solar-system-edge.png",  
            from = edge[1].name,  
            to = edge[2].name,  
            order = "h",  
            length = settings.startup["space-connection-gleba-sye-nauvis-ne-length"].value or 40000,  
            asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.gleba_aquilo)
  }}

    end

end

return routes