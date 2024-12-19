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


-- script.on_event({
-- 	defines.events.on_space_platform_changed_state,
	
-- }, function(e)
-- 	if e.platform.state==defines.space_platform_state.waiting_at_station then
-- 		if e.platform.space_location then
-- 			local space_l = e.platform.space_location
-- 			if string.find(space_l.name,"edge") then
-- 				rendering.draw_animation{
-- 					surface =e.platform.surface,
-- 					animation="test",
-- 					target=e.platform.hub,
-- 				}
-- 			end
-- 		end
-- 	end
-- end)