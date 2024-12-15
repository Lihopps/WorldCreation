local test =require("script.test")

script.on_event({
	defines.events.on_built_entity,
	
}, function(e)
	local entity = e.entity or e.created_entity
	local constructeur = nil
	if e.player_index then
		constructeur = game.players[e.player_index]
	else
		constructeur = e.robot
	end
	if not entity or not entity.valid then
		return
	end
	if not constructeur or not constructeur.valid then
		return
	end
	local entity_name = entity.name
     game.print("couco")
	if entity_name == "transport-belt" then
       
		test.test()
	end
end)