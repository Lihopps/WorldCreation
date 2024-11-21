data:extend(
  {
    {
      type = "int-setting",
      name = "lihop-infinity-oreamount",
      setting_type = "startup",
      default_value = 10,
      maximum_value = 1000,
      minimum_value = 1,
    },
    {
      type = "int-setting",
      name = "lihop-infinity-fluidamount",
      setting_type = "startup",
      default_value = 200,
      maximum_value = 10000,
      minimum_value = 1,
    },
    {
      type = "bool-setting",
      name = "lihop-infinity-force-tel",
      setting_type = "startup",
      default_value = false
    }
  })

-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------- Settings si le présence de certain mod -------------------------------------
-------------------------------------------------------------------------------------------------------------------------

if mods["Krastorio2"] then
  data:extend(
    {
      {
        type = "bool-setting",
        name = "lihop-infinity-Krastorioquarry",
        setting_type = "startup",
        default_value = false
      }
    })
end