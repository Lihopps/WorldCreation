

local function make_ionise_item(item_name,ioning_type)
    --ioning
    local item=data.raw["item"][item_name]
    if not item then return end
    local item_ioning=table.deepcopy(item)
    item_ioning.name=item_ioning.name.."-ioning-"..ioning_type
    item_ioning.icon=nil
    item_ioning.icons={
        {
            icon=item.icon,
            icon_size=item.icon_size
        },
        {
            icon="__WorldCreation__/graphics/icons/"..item.name.."-ioning.png",
            icon_size=item.icon_size
        }
    }
    item_ioning.spoil_ticks= 1 * hour
    item_ioning.spoil_result=item.name
    item_ioning.send_to_orbit_mode="not-sendable"
    item_ioning.rocket_launch_products= nil
   


    data:extend({item_ioning})
end


data:extend({
    {
        type = "item",
        name = "lihop-dyson-scaffold-result",
        icon = "__WorldCreation__/graphics/icons/lihop-dyson-scaffold-result.png",
        icon_size = 64,
        subgroup = "extraction-machine",
        order = "a[items]-c[infinity-miner]",
        stack_size = 10,
        weight = 100*kg,
        spoil_ticks= 60 * second
    },
    {
        type = "recipe",
        name = "lihop-dyson-scaffold",
        enabled = lihop_debug,
        category = "electromagnetics",
        main_product="lihop-dyson-scaffold",
        energy_required = 10,
        ingredients =
        {
            { type = "item", name = "quantum-processor",      amount = 3 },
            { type = "item", name = "carbon-fiber",           amount = 5 },
            { type = "item", name = "space-platform-foundation", amount = 10 },
            { type = "item", name = "lihop-titan-mesh-ioning-star",           amount = 2 },
            { type = "item", name = "lihop-electronic-circuit",           amount = 10 },
        },
        results = { 
            { type = "item", name = "lihop-dyson-scaffold", amount = 1 },
            { type = "item", name = "scrap", amount = 10 }
        },
        send_to_orbit_mode="automated",
        rocket_launch_products= {{ type = "item", name = "lihop-dyson-scaffold-result",      amount = 1 }},
    },
    {
        type = "item",
        name = "lihop-dyson-scaffold",
        icon = "__WorldCreation__/graphics/icons/lihop-dyson-scaffold.png",
        icon_size = 64,
        subgroup = "extraction-machine",
        order = "a[items]-c[infinity-miner]",
        stack_size = 10,
        weight = 100*kg
    },
    {
        type = "recipe",
        name = "lihop-titan-mesh",
        enabled = lihop_debug,
        category="metallurgy",
        energy_required = 3,
        ingredients =
        {
            { type = "item", name = "low-density-structure",      amount = 10},
            { type = "item", name = "processing-unit",           amount = 2 },
            { type = "item", name = "lihop-titan-rod",           amount = 10 },
            { type = "fluid", name = "lihop-titan-catalyseur",           amount = 10 },
            

        },
        results = { { type = "item", name = "lihop-titan-mesh", amount = 2 } }
    },
    {
        type = "item",
        name = "lihop-titan-mesh",
        icon = "__WorldCreation__/graphics/icons/lihop-titan-mesh.png",
        icon_size = 64,
        subgroup = "extraction-machine",
        order = "a[items]-c[infinity-miner]",
        stack_size = 50,
        weight = 10*kg,
        send_to_orbit_mode="automated",
        rocket_launch_products= {{ type = "item", name = "lihop-titan-mesh-ioning-star",      amount = 1 }},
    },
     {
        type = "recipe",
        name = "lihop-titan-rod",
        enabled = lihop_debug,
        category="electromagnetics",
        main_product="lihop-titan-rod",
        energy_required = 10,
        ingredients =
        {
            { type = "item", name = "tungsten-plate",           amount = 3 },
            { type = "fluid", name = "sulfuric-acid",           amount = 10 },
            { type = "item", name = "lihop-titan-plate",           amount = 5 },
        },
        results = { 
            { type = "item", name = "lihop-titan-rod", amount = 1 },
            { type = "item", name = "scrap", amount = 10 }
        }
    },
    {
        type = "item",
        name = "lihop-titan-rod",
        icon = "__WorldCreation__/graphics/icons/lihop-titan-rod.png",
        icon_size = 64,
        subgroup = "extraction-machine",
        order = "a[items]-c[infinity-miner]",
        stack_size = 100,
        weight = 10*kg
    },
    {
        type = "recipe",
        name = "lihop-titan-plate",
        main_product="lihop-titan-plate",
        enabled = lihop_debug,
        category = "metallurgy",
        energy_required = 2,
        ingredients =
        {
            { type = "fluid", name ="lithium-brine",           amount = 20 },
            { type = "item", name = "lihop-titan-ore-ioning-belt",           amount = 5 },
        },
        results = { 
            { type = "item", name = "lihop-titan-plate", amount = 1,extra_count_fraction=0.1 },
            { type = "item", name = "lihop-titan-ore", amount = 1,probability=0.85 },
        }
    },
    {
        type = "item",
        name = "lihop-titan-plate",
        icon = "__WorldCreation__/graphics/icons/lihop-titan-plate.png",
        icon_size = 64,
        subgroup = "extraction-machine",
        order = "a[items]-c[infinity-miner]",
        stack_size = 100,
        weight = 5*kg
    },
    {
        type = "item",
        name = "lihop-titan-ore",
        icon = "__WorldCreation__/graphics/icons/lihop-titan-ore.png",
        pictures =
        {
            {size = 64, filename = "__WorldCreation__/graphics/icons/lihop-titan-ore.png", scale = 0.5, mipmap_count = 4},
            {size = 64, filename = "__WorldCreation__/graphics/icons/lihop-titan-ore-1.png", scale = 0.5, mipmap_count = 4},
            {size = 64, filename = "__WorldCreation__/graphics/icons/lihop-titan-ore-2.png", scale = 0.5, mipmap_count = 4},
            },
        icon_size = 64,
        subgroup = "extraction-machine",
        order = "a[items]-c[infinity-miner]",
        stack_size = 100,
        weight = 1*kg,
        send_to_orbit_mode="automated",
        rocket_launch_products= {{ type = "item", name = "lihop-titan-ore-ioning-belt",      amount = 1 }},
    },
    {
        type = "recipe",
        name = "lihop-chemical-catalyst",
        enabled = lihop_debug,
        category = "organic",
        energy_required = 2,
        ingredients =
        {
            { type = "item", name ="sulfur",           amount = 10 },
            { type = "item", name = "lithium",           amount = 5 },
        },

        results = { 
            { type = "item", name = "lihop-chemical-catalyst", amount = 3 },
        }
    },
    {
        type = "item",
        name = "lihop-chemical-catalyst",
        icon = "__WorldCreation__/graphics/icons/lihop-chemical-catalyst.png",
        icon_size = 64,
        subgroup = "extraction-machine",
        order = "a[items]-c[infinity-miner]",
        stack_size = 100,
        weight = 5*kg,
        send_to_orbit_mode="automated",
        rocket_launch_products= {{ type = "item", name = "lihop-chemical-catalyst-ioning-belt",      amount = 1 }},
    },
    -------------------------------------------------------------------------------------------------------------
    ------------------------------ Rocket part ------------------------------------------------------------------
    -------------------------------------------------------------------------------------------------------------
    {
        type = "recipe",
        name = "lihop-rocket",
        enabled = lihop_debug,
        energy_required = 50*4,
        icon = "__WorldCreation__/graphics/icons/rocket.png",
        ingredients =
        {
            {type = "item", name = "processing-unit", amount = 25},
            {type = "item", name = "low-density-structure", amount = 25},
            {type = "item", name = "rocket-fuel", amount = 25}
        },

        results = { 
            { type = "item", name = "lihop-rocket", amount = 1 },
        },
    },
    {
        type = "item",
        name = "lihop-rocket",
        icon = "__WorldCreation__/graphics/icons/rocket.png",
        icon_size = 64,
        subgroup = "extraction-machine",
        order = "a[items]-c[infinity-miner]",
        stack_size = 1,
        weight = 10000*kg,
        
    },
    {
        type = "recipe",
        name = "lihop-rocket-to-part",
        enabled = lihop_debug,
        hidden=true,
        hidden_in_factoriopedia=true,
        category = "rocket-building",
        energy_required = 10,
        ingredients =
        {
            {type = "item", name = "lihop-rocket", amount =1},
           
        },

        results = { 
            { type = "item", name = "rocket-part", amount = 50 },
        }
    },
-------------------------------------------------------------------------------------------------------------
------------------------------ satellite ------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
    {
    type = "item",
    name = "lihop-satellite",
    icon = "__base__/graphics/icons/satellite.png",
    subgroup = "space-related",
    order = "d[rocket-parts]-e[satellite]",
    stack_size = 1,
    weight = 1 * tons,
    send_to_orbit_mode = "automated",
    rocket_launch_products= {{ type = "item", name = "lihop-electronic-circuit",      amount = 100 }},
  },
  {
        type = "recipe",
        name = "lihop-satellite",
        enabled = lihop_debug,
        --hidden=true,
        --hidden_in_factoriopedia=true,
        energy_required = 10,
        ingredients =
        {
            {type = "item", name = "processing-unit", amount =10},
           
        },
        results = { 
            { type = "item", name = "lihop-satellite", amount = 50 },
        },
        
    },
     {
        type = "item",
        name = "lihop-electronic-circuit",
        icon = "__WorldCreation__/graphics/icons/electronic-circuit.png",
        icon_size = 64,
        subgroup = "extraction-machine",
        order = "a[items]-c[infinity-miner]",
        stack_size = 100,
        weight = 0.2*kg
    },
    {
    type = "item",
    name = "lihop-satellite-dummy",
    icon = "__base__/graphics/icons/satellite.png",
    subgroup = "space-related",
    order = "d[rocket-parts]-e[satellite]",
    hidden=true,
    hidden_in_factoriopedia=true,
    stack_size = 1,
    weight = 1 * tons,
  },

})


local ion ={["lihop-titan-mesh"]="star",["lihop-titan-ore"]="belt",["lihop-chemical-catalyst"]="belt"}
for name,ioning_type in pairs(ion) do
    make_ionise_item(name,ioning_type)
end