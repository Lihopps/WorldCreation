 data:extend {
    {
      type = "technology",
      name = "planet-discovery-lihop",
      icons = util.technology_icon_constant_planet("__space-age__/graphics/technology/vulcanus.png"),
      icon_size = 256,
      essential = true,
      effects = {},
      prerequisites = { "space-platform-thruster" },
      unit =
      {
        count = 1000,
        ingredients =
        {
          { "automation-science-pack", 1 },
          { "logistic-science-pack",   1 },
          { "chemical-science-pack",   1 },
          { "space-science-pack",      1 }
        },
        time = 60
      }
    },
    {
      type = "technology",
      name = "lihop-superbarrel",
      icons = util.technology_icon_constant_planet("__space-age__/graphics/technology/vulcanus.png"),
      icon_size = 256,
      essential = true,
      effects = {},
      prerequisites = { "space-platform-thruster" },
      unit =
      {
        count = 1000,
        ingredients =
        {
          { "automation-science-pack", 1 },
          { "logistic-science-pack",   1 },
          { "chemical-science-pack",   1 },
          { "space-science-pack",      1 }
        },
        time = 60
      }
    },
    {
      type = "technology",
      name = "lihop-test",
      icons = util.technology_icon_constant_planet("__space-age__/graphics/technology/vulcanus.png"),
      icon_size = 256,
      essential = true,
      effects = {
        
      },
      prerequisites = { "space-platform-thruster" },
      research_trigger={
          type="craft-item",
          count=100,
          item={name="lihop-titan-mesh-ioning-star"}
        }
    },
  }