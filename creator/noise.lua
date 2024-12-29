data:extend({
    {
        name = "planet_size",
        type = "noise-expression",
        expression = "-1"
    },
    {
    type = "noise-expression",
    name = "planet_limit",
    -- bases_per_km2 = 10 + 3 * enemy_base_intensity
    --expression = "x",
    expression = "limitation(x,y,map_width)",
    local_functions =
    {
      limitation =
      {
        parameters = {"pos_x", "pos_y","size"},
        expression = "if(sqrt(pos_x*pos_x+pos_y*pos_y) >= size, 1000, -1000)"
      }
    }
  },


})