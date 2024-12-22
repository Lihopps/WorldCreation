local handler = require("__core__.lualib.event_handler")

handler.add_libraries({
	require("script.main"),
	require("script.surface"),
	require("script.plateform"),
	require("script.entity"),
	
	--require("script.test"),
})