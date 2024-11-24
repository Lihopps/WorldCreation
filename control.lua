-- local handler = require("__core__.lualib.event_handler")

-- handler.add_libraries({
--   	require("__flib__.gui"),
-- 	require("script.main"),
-- 	require("script.surface"),
-- 	require("script.entity"),
-- 	require("script.teleporter_gui"),
-- })
local mapge={
    default_enable_all_autoplace_controls= false,
    autoplace_controls= {
        aquilo_crude_oil= {
            frequency= 1,
            size= 1,
            richness= 1
        },
        fluorine_vent= {
            frequency= 1,
            size= 1,
            richness= 1
        },
        lithium_brine= {
            frequency= 1,
            size= 1,
            richness= 1
        },
        ["lihop-ressource-iron-plate"]= {
                    frequency= 500,
                    size= 500,
                    richness= 500
                },
		
    },
    autoplace_settings= {
        decorative= {
            treat_missing_as_default= true,
            settings= {
                ["aqulio-ice-decal-blue"]= {
                    frequency= 1,
                    size= 1,
                    richness= 1
                },
                ["aqulio-snowy-decal"]= {
                    frequency= 1,
                    size= 1,
                    richness= 1
                },
                ["floating-iceberg-large"]= {
                    frequency= 1,
                    size= 1,
                    richness= 1
                },
                ["floating-iceberg-small"]= {
                    frequency= 1,
                    size= 1,
                    richness= 1
                },
                ["lithium-iceberg-medium"]= {
                    frequency= 1,
                    size= 1,
                    richness= 1
                },
                ["lithium-iceberg-small"]= {
                    frequency= 1,
                    size= 1,
                    richness= 1
                },
                ["lithium-iceberg-tiny"]= {
                    frequency= 1,
                    size= 1,
                    richness= 1
                },
                ["snow-drift-decal"]= {
                    frequency= 1,
                    size= 1,
                    richness= 1
                },
               
            }
        },
        entity= {
            treat_missing_as_default= true,
            settings= {
                ["crude-oil"]= {
                    frequency= 1,
                    size= 1,
                    richness= 1
                },
                
                ["fluorine-vent"]= {
                    frequency= 1,
                    size= 1,
                    richness= 1
                },
                ["lithium-brine"]= {
                    frequency= 1,
                    size= 1,
                    richness= 1
                },
                 ["lihop-ressource-iron-plate"]= {
                    frequency= 500,
                    size= 500,
                    richness= 500
                },
                ["lithium-iceberg-big"]= {
                    frequency= 1,
                    size= 1,
                    richness= 1
                },
                ["lithium-iceberg-huge"]= {
                    frequency= 1,
                    size= 1,
                    richness= 1
                },
            }
        },
        tile= {
            treat_missing_as_default= true,
            settings= {
                ["ammoniacal-ocean"]= {
                    frequency= 1,
                    size= 1,
                    richness= 1
                },
                ["ammoniacal-ocean-2"]= {
                    frequency= 1,
                    size= 1,
                    richness= 1
                },
                ["brash-ice"]= {
                    frequency= 1,
                    size= 1,
                    richness= 1
                },
                ["ice-rough"]= {
                    frequency= 1,
                    size= 1,
                    richness= 1
                },
                ["ice-smooth"]= {
                    frequency= 1,
                    size= 1,
                    richness= 1
                },
                ["snow-crests"]= {
                    frequency= 1,
                    size= 1,
                    richness= 1
                },
                ["snow-flat"]= {
                    frequency= 1,
                    size= 1,
                    richness= 1
                },
                ["snow-lumpy"]= {
                    frequency= 1,
                    size= 1,
                    richness= 1
                },
                ["snow-patchy"]= {
                    frequency= 1,
                    size= 1,
                    richness= 1
                },
				
            }
        }
    },
   
}

local function create_surf()
	local surf=game.create_surface("test",mapge)
    surf.set_property("lihop-iron-plate", 1)
end
local function create_surf2()
	local surf=game.create_surface("test2",mapge)
    surf.set_property("lihop-iron-plate", 0)
end

script.on_event({
	defines.events.on_built_entity,

}, function(e)
	local entity = e.entity or e.created_entity
	local entity_name = entity.name
	if entity_name == "assembling-machine-1" then
		create_surf()
	end
    if entity_name == "assembling-machine-2" then
		create_surf2()
	end


end)

script.on_event({
	defines.events.on_chunk_generated,

}, function(e)
	--swap resources
    if e.surface.get_property("lihop-iron-plate")==1 then
    local irons=e.surface.find_entities_filtered{area = e.area, name = "lihop-ressource-iron-plate"}
    if not irons then return end
    for _,iron in pairs(irons) do
        game.print("ici")
        local newiron=e.surface.create_entity{name="lihop-ressource-copper-plate",position=iron.position}
        newiron.amount=iron.amount
        iron.destroy()
    end
    end
end)