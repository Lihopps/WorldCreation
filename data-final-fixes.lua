--create space-connection icon
for name, prototype in pairs(data.raw["space-connection"]) do
  local from = data.raw["space-location"][prototype.from] or data.raw["planet"][prototype.from]
  local to = data.raw["space-location"][prototype.to] or data.raw["planet"][prototype.to]
  if (not prototype.icon) and (not prototype.icons) and from and (from.icon or from.icons[1].icon) and to and (to.icon or to.icons[1].icon) then
    local from_size = from.icon_size or 64
    local from_tint = from.tint or { r = 1, g = 1, b = 1, a = 1 }
    if from.icons then
      from_size = from.icons[1].icon_size or 64
      from_tint = from.icons[1].tint
    end

    local to_size = to.icon_size or 64
    local to_tint = to.tint or { r = 1, g = 1, b = 1, a = 1 }
    if to.icons then
      to_size = to.icons[1].icon_size or 64
      to_tint = to.icons[1].tint
    end
    prototype.icons =
    {
      { icon = "__space-age__/graphics/icons/planet-route.png" },
      { icon = from.icon or from.icons[1].icon,                tint = from_tint, icon_size = from_size, scale = 0.333 * (64 / (from_size)), shift = { -6, -6 } },
      { icon = to.icon or to.icons[1].icon,                    tint = to_tint,   icon_size = to_size,   scale = 0.333 * (64 / (to_size)),   shift = { 6, 6 } }
    }
  end
end

-- add harvesting light and heavy recipe
--worldCreation_gazeous_field={light={},heavy={}}
for type, fluids in pairs(worldCreation_gazeous_field) do
  for _, fluid in pairs(fluids) do
    local temp=data.raw["fluid"][fluid].max_temperature or data.raw["fluid"][fluid].default_temperature
    data:extend({
      {
        type = "recipe",
        name = "lihop-harvesting-".. fluid,
        enabled = true,
        surface_conditions = { { property = "gravity", min = 0, max = 0 } },
        category = "lihop-harvesting-" .. type,
        energy_required = 2,
        ingredients = {},
        results = { { type = "fluid", name = fluid, amount = 100,temperature=temp } }
      },
    })
  end
end
data:extend({
  {
    type = "recipe",
    name = "lihop-harvesting-fusion-plasma",
    enabled = true,
    surface_conditions = { { property = "gravity", min = 0, max = 0 } },
    category = "lihop-harvesting-heavy",
    energy_required = 2,
    ingredients = {},
    results = { { type = "fluid", name = "fusion-plasma", amount = 100,temperature=data.raw["fluid"]["fusion-plasma"].max_temperature } }
  },
})
-- make super barrel for gazeous fluid
