local handler = require("__core__.lualib.event_handler")

handler.add_libraries({
  	require("__flib__.gui"),
	require("script.main"),
	require("script.surface"),
	require("script.entity"),
	require("script.teleporter_gui"),
})
