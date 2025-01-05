
data:extend({
    {
        type = "recipe",
        name = "lihop-titan-catalyseur",
        enabled = lihop_debug,
        category = "cryogenics",
        main_product="lihop-titan-catalyseur",
        subgroup = "fluid-recipes",
        order = "z",
        energy_required = 20,
        factoriopedia_alternative="lihop-titan-catalyseur",
        ingredients =
        {
            { type = "fluid", name = "fluoroketone-hot",         amount = 100 },
            { type = "fluid", name = "electrolyte",              amount = 50 },
            { type = "item", name = "lihop-chemical-catalyst-ioning-belt", amount = 2 },
        },
        results = {
            { type = "fluid", name = "lihop-titan-catalyseur", amount = 20 },
            { type = "fluid", name = "fluoroketone-cold", amount = 50 },
        }
    },
    {
        type = "fluid",
        name = "lihop-titan-catalyseur",
        icons = {
            {
                icon="__WorldCreation__/graphics/icons/lihop-titan-catalyseur.png",
                icon_size=64
            },
            {
                icon="__WorldCreation__/graphics/icons/lihop-titan-catalyseur-tint.png",
                icon_size=64
            }
        },
        
        subgroup = "fluid",
        order = "b[new-fluid]-e[aquilo]-a[ammoniacal-solution]",
        default_temperature = 0,
        max_temperature = 100,
        --hidden=true,
        heat_capacity = "1kJ",
        base_color = { 203/255, 0, 196/255 },
        flow_color = { 201/255, 99/255, 198/255},
        auto_barrel = true
    },

})
