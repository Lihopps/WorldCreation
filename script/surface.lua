local util=require("util.util")

local function on_surface_created(e)
	util.set_size(e)
end


local surface={}


surface.events={
	[defines.events.on_surface_created]=on_surface_created,

}

return surface

