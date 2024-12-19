local asteroid={}
local shading_data =
    {
      normal_strength = 1.2,
      light_width = 0,
      brightness = 0.9,
      specular_strength = 2,
      specular_power = 2,
      specular_purity = 0,
      sss_contrast = 1,
      sss_amount = 0,
      lights = {
        { color = {0.96,1,0.99}, direction = {0.7,0.6,-1} },
        { color = {0.57,0.33,0.23}, direction = {-0.72,-0.46,1} },
        { color = {0.1,0.1,0.1}, direction = {-0.4,-0.25,-0.5} },
      },
      ambient_light = {0.01, 0.01, 0.01},
    }

local function asteroid_graphics_set(rotation_speed, shading_data, variations)
  local result = table.deepcopy(shading_data)
  result.rotation_speed = rotation_speed
  result.variations = variations
  return result
end



function asteroid.spawn_smoke()
    return {
        type="entity",
        asteroid ="test-smoke",
        probability=1,
        speed=0.5
    }
end



return asteroid