local test=require("script.test")

local function on_entity_build(e)
	local entity = e.entity or e.created_entity
	local constructeur = nil
	if e.player_index then
		constructeur = game.players[e.player_index]
	else
		constructeur = e.robot or e.platform
	end
	if not entity or not entity.valid then
		return
	end
	if not constructeur or not constructeur.valid then
		return
	end
	if (entity.name == "lihop-harvester") then
        entity.recipe_locked=true
	end
	---test.on_entity_build(e)
end

local function on_cargo_pod_finished_ascending(e)
	--game.print("maintenant")
	--e.cargo_pod.force_finish_ascending()
	--game.print(e.cargo_pod.get_inventory(defines.inventory.cargo_unit)) 
end

local entities={}

entities.events={
	[defines.events.on_built_entity]=on_entity_build,
	[defines.events.on_robot_built_entity]=on_entity_build,
	[defines.events.on_space_platform_built_entity]=on_entity_build,
	[defines.events.on_cargo_pod_finished_ascending]=on_cargo_pod_finished_ascending,

}

return entities