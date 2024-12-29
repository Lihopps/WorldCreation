local bot = table.deepcopy(data.raw["construction-robot"]["construction-robot"])
bot.minable = { mining_time = 0.1, result = "temp-bot" }
bot.speed_multiplier_when_out_of_energy = 0
bot.min_to_charge = 0
bot.max_to_charge = 0
bot.speed = 0.03
bot.max_energy = "1MJ"
bot.energy_per_move = "10kJ"
bot.name = "temp-bot"
bot.destroy_action={
      {
        type = "direct",
        action_delivery =
        {
          type = "instant",
          target_effects =
          {
            {
              type = "create-explosion",
              entity_name = "construction-robot-explosion",
            }
          }
        }
      }
    }


local bot_item = table.deepcopy(data.raw["item"]["construction-robot"])
bot_item.name = "temp-bot"
bot_item.place_result = "temp-bot"
bot_item.hidden=true
bot_item.hidden_in_factoriopedia=true



data:extend({ bot, bot_item})
