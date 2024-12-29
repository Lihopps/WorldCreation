local util=require("util.util")


local function on_surface_created(e)
	if not game.surfaces[e.surface_index] then return end

	--game.surfaces[e.surface_index].map_gen_settings.default_enable_all_autoplace_controls=false
	if not game.surfaces[e.surface_index].planet then return end
	if not game.surfaces[e.surface_index].planet.prototype.surface_properties then return end
	if game.surfaces[e.surface_index].planet.prototype.surface_properties.dyson_sphere_site==1 then
		game.surfaces[e.surface_index].create_global_electric_network()
	end
end

local function on_chunk_generated(e)

	if not e.surface then return end
	if not e.surface.planet then return end
	if not e.surface.planet.prototype.surface_properties then return end
	if e.surface.planet.prototype.surface_properties.dyson_sphere_site==1 and e.position.x==0 and e.position.y==0 then 
		local tiles={}
		for i=-5,5 do
			for j=-5,5 do
				table.insert(tiles,{name="space-platform-foundation",position={x=i,y=j}})
			end
		end
		e.surface.set_tiles(tiles,true,true,true)
		--game.surfaces[e.surface_index].clear_hidden_tiles()
	end



end

local function on_marked_for_deconstruction(e)
	if not e.entity then return end
	if e.entity.name=="cargo-pod-container" then
		local inv=e.entity.get_inventory(defines.inventory.cargo_unit)
		local spider,index=inv.find_item_stack("spidertron")
		if spider then
			local spider_entity=e.entity.surface.create_entity{name="spidertron", position=e.entity.position,force=e.entity.force,item=spider}
			if spider_entity then
				
				--copy grid from item
				spider_entity.grid.clear()
				if spider.grid then 
					for _,equipment in pairs(spider.grid.equipment) do
						spider_entity.grid.put{name=equipment.name, quality=equipment.quality, position=equipment.position}
					end
				end
				inv[index].clear()
				-- add un flying temp par default
				spider_entity.insert({name="temp-bot", count=1})
				-- Put the cargo pod content into the spider newly created
				for i=1,#inv do
					if inv[i].valid_for_read then
						local nbr=spider_entity.insert(inv[i])
						inv[i].count=inv[i].count-nbr
					end
				end
			end
		end
	end
end

local surface={}


surface.events={
	[defines.events.on_chunk_generated ]=on_chunk_generated,
	[defines.events.on_surface_created ]=on_surface_created,
	[defines.events.on_marked_for_deconstruction]=on_marked_for_deconstruction,

}

return surface

