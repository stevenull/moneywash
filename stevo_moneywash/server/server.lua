local ox_inventory = exports.ox_inventory

RegisterServerEvent('stevo_moneywash:cleanmoney')
AddEventHandler('stevo_moneywash:cleanmoney',function(amount)
  local xPlayer = ESX.GetPlayerFromId(source)
  local tax = amount * 0.10
  local final = amount - tax
  local item = xPlayer.getInventoryItem('black_money').count
  local item2 = xPlayer.getInventoryItem('moneywash_ticket').count
  if item >= amount then
    if item2 >= 1 then
        xPlayer.removeInventoryItem('black_money', amount)
        xPlayer.removeInventoryItem('moneywash_ticket', 1)
        xPlayer.triggerEvent('stevo_moneywash:washactions')
        Citizen.Wait(Config.washduration)
        xPlayer.addInventoryItem('money', final)
    else
      TriggerClientEvent('ox_lib:notify', source, {title = 'No Wash Ticket', description = 'You do not have a wash ticket.', type = 'error'})
    end
  else
    TriggerClientEvent('ox_lib:notify', source, {title = 'Not enough', description = 'You do not have enough black money.', type = 'error'})
  end
end)



QBCore.Functions.CreateCallback('checkforkeycard', function(source, cb)
  local items = ox_inventory:Search(source, 'count', {'meth', 'moneywash_keycard'})
  if items and items.moneywash_keycard >= 1 then
      item = true
      cb(item)
  else
      item = false
      cb(item)
  end
end)







