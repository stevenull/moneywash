local ox_inventory = exports.ox_inventory

RegisterServerEvent('stevo_moneywash:cleanmoney')
AddEventHandler('stevo_moneywash:cleanmoney', function(Amount)
local Player = source
local WashTax = Amount * Config.TaxRate
local WashTotal = Amount - WashTax
local black_money = exports.ox_inventory:Search(Player, 'count','black_money')
local moneywash_ticket =  exports.ox_inventory:Search(Player, 'count','moneywash_ticket')
    if black_money >= Amount then
        if Config.UseTickets then
            if moneywash_ticket >= 1 then
                exports.ox_inventory:RemoveItem(Player, 'black_money', Amount)
                exports.ox_inventory:RemoveItem(Player, 'moneywash_ticket', 1)
                TriggerClientEvent('stevo_moneywash:washactions', Player)
                Citizen.Wait(Config.WashDuration)
                exports.ox_inventory:AddItem(Player, 'money', WashTotal)
            else
                TriggerClientEvent('ox_lib:notify', Player, {title = 'No Wash Ticket', description = 'You do not have a wash ticket.', type = 'error'})
            end
        else
            exports.ox_inventory:RemoveItem(Player, 'black_money', Amount)
            exports.ox_inventory:RemoveItem(Player, 'moneywash_ticket', 1)
            TriggerClientEvent('stevo_moneywash:washactions', Player)
            Citizen.Wait(Config.WashDuration)
            exports.ox_inventory:AddItem(Player, 'money', WashTotal)
        end
    else
      TriggerClientEvent('ox_lib:notify', Player, {title = 'Not enough', description = 'You do not have enough black money.', type = 'error'})
    end
end)