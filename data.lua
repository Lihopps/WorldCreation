require("categories.group")
worldCreation_planet_graphics={}

---Add graphics set for planet type like
---@param name string : name of the planet type like (ex : vulcanus)
---@param icon string : path to the file
---@param starmap_icon string : path to the file
---@param starmap_icon_size number : size of the starmap_icon
function wc_add_graphics_asset(name,icon,starmap_icon,starmap_icon_size)
    
    if not worldCreation_planet_graphics[name] then
        worldCreation_planet_graphics[name]={}
    end
    table.insert(worldCreation_planet_graphics[name],{
        icon=icon,
        starmap_icon=starmap_icon or icon,
        starmap_icon_size=starmap_icon_size
    })
end


--add vulcanus like planet graphics
local base_planet = {}--"vulcanus","gleba","nauvis","fulgora","aquilo"}
for _,name in pairs(base_planet) do
    for i=0,1 do
        local base="__WorldCreation__/graphics/icons/corps/"..name.."/icon-"
        wc_add_graphics_asset("vulcanus",base..i..".png",base..i.."-starmap.png",512)
    end
end



