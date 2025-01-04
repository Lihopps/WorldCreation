local mgu={}


function mgu.get_elevation()
  local elevations={}
  for _,noise_ex in pairs(data.raw["noise-expression"]) do
    if noise_ex.intended_property == "elevation" then
      table.insert(elevations,noise_ex.name)
    end
  end
  return elevations
end

function mgu.delete_ennemies(mgs)
  mgs.territory_settings=nil
  mgs.enemy_base_radius = nil
  mgs.enemy_base_frequency = nil
  mgs.autoplace_controls["gleba_enemy_base"]=nil
  mgs.autoplace_controls["enemy-base"]=nil
  return mgs
end

return mgu