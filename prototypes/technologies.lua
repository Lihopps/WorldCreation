 data:extend {
    {
      type = "technology",
      name = "lihop-dyson-sphere-realisation",
      icons = util.technology_icon_constant_planet("__space-age__/graphics/technology/vulcanus.png"),
      icon_size = 256,
      essential = true,
      effects = {
        {
          type="nothing",
          effect_description="le titre",
          icon = "__base__/graphics/entity/accumulator/accumulator.png"
        }
      },
      prerequisites = { "lihop-dyson-scaffold" },
      research_trigger={
          type="craft-item",
          count=100,
          item={name="lihop-dyson-scaffold-result"}
        }
    },
--------------------------------------------------------------------------------------------------------------------
--------------------------------------------  Progress tree --------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------
  {
      type = "technology",
      name = "lihop-rocket-silo",
      icons = util.technology_icon_constant_planet("__space-age__/graphics/technology/vulcanus.png"),
      icon_size = 256,
      essential = true,
      effects = {
        {
        type = "unlock-recipe",
        recipe = "wc-rocket-silo"
        },
        {
        type = "unlock-recipe",
        recipe = "lihop-rocket"
        },
         {
        type = "unlock-recipe",
        recipe = "wc-cargo-landing-pad"
        },
        {
        type = "unlock-recipe",
        recipe = "lihop-satellite"
        },
      },
      prerequisites = { "space-science-pack" },
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
      name = "lihop-titan-ore",
      icons = util.technology_icon_constant_planet("__space-age__/graphics/technology/vulcanus.png"),
      icon_size = 256,
      essential = true,
      effects = {
         {
        type = "unlock-recipe",
        recipe = "lihop-chemical-catalyst"
        },
        {
        type = "unlock-recipe",
        recipe = "lihop-titan-catalyseur"
        },
        {
        type = "unlock-recipe",
        recipe = "lihop-titan-plate"
        },
      },
      prerequisites = { "lihop-rocket-silo" },
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
      name = "lihop-harvester-l",
      icons = util.technology_icon_constant_planet("__space-age__/graphics/technology/vulcanus.png"),
      icon_size = 256,
      essential = true,
      effects = {
        {
        type = "unlock-recipe",
        recipe = "lihop-harvester"
        },
      },
      prerequisites = { "lihop-titan-ore" },
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
      prerequisites = { "lihop-harvester-l" },
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
      name = "lihop-titan-util",
      icons = util.technology_icon_constant_planet("__space-age__/graphics/technology/vulcanus.png"),
      icon_size = 256,
      essential = true,
      effects = {
        {
        type = "unlock-recipe",
        recipe = "lihop-titan-rod"
        },
        {
        type = "unlock-recipe",
        recipe = "lihop-titan-mesh"
        },
      },
      prerequisites = { "lihop-rocket-silo","lihop-titan-ore" },
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
      name = "lihop-titan-pipe",
      icons = util.technology_icon_constant_planet("__space-age__/graphics/technology/vulcanus.png"),
      icon_size = 256,
      essential = true,
      effects = {
        {
        type = "unlock-recipe",
        recipe = "plasma_silo"
        },
        {
        type = "unlock-recipe",
        recipe = "plasma_pipe"
        },
        {
        type = "unlock-recipe",
        recipe = "plasma_pipe-to-ground"
        },
      },
      prerequisites = { "lihop-rocket-silo","lihop-titan-ore" },
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
      name = "lihop-harvester-h",
      icons = util.technology_icon_constant_planet("__space-age__/graphics/technology/vulcanus.png"),
      icon_size = 256,
      essential = true,
      effects = {
        {
        type = "unlock-recipe",
        recipe = "lihop-harvesting-fusion-plasma"
        },
        {
        type = "unlock-recipe",
        recipe = "lihop-plasma-thruster"
        },

      },
      prerequisites = { "lihop-harvester-l","lihop-titan-pipe" },
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
      name = "lihop-dyson-scaffold",
      icons = util.technology_icon_constant_planet("__space-age__/graphics/technology/vulcanus.png"),
      icon_size = 256,
      essential = true,
      effects = {
        {
        type = "unlock-recipe",
        recipe = "lihop-dyson-scaffold"
        },
      },
      prerequisites = { "lihop-titan-util" },
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
  }