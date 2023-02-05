local hasAlreadyEnteredMarker, lastZone
local currentAction, currentActionMsg, currentActionData = nil, nil, {}
local washing = false
local inwashroom = false
local cooldown =  false


AddEventHandler('stevo_moneywash:washmoney', function()
	if washing == true then
		lib.notify({
			title = 'Currently Washing',
			description = 'You are already washing money!',
			type = 'error'
		})
	else
		if cooldown == false then
		    local input = lib.inputDialog('Washing Amount', {'How much to wash?'})

			if not input then return end
			local WashAmount = tonumber(input[1])	
			TriggerServerEvent('stevo_moneywash:cleanmoney', WashAmount)
		else
			lib.notify({
				title = 'Cooldown Active',
				description = 'The washing cooldown is active',
				type = 'error'
			})
		end
	end
end)




AddEventHandler('stevo_moneywash:exitlaundry', function() 
	local playerPed = PlayerPedId()
	if washing == true then
		lib.notify({
			title = 'Currently Washing',
			description = 'You cannot exit the LaundryMat while washing!',
			type = 'error'
		})
	else
		inwashroom = false
	    SetEntityCoords(playerPed, 1144.8295, -1000.2859, 45.2904, 277.0518)
	    ExecuteCommand('e shrug')
	end
end)

AddEventHandler('stevo_moneywash:enterlaundry', function()
	ESX.TriggerServerCallback('checkforkeycard', function(item)
		if item == true then
			inwashroom = true
			local playerPed = PlayerPedId()
			SetEntityCoords(playerPed, 1138.1478, -3199.1692, -39.6657)
		else
			lib.notify({
				title = 'Access Denied',
				description = 'You need a wash keycard to enter this LaundryMat!',
				type = 'error'
			})
		end
	end)	
end)

RegisterNetEvent('stevo_moneywash:washactions')
AddEventHandler('stevo_moneywash:washactions', function()
	washing = true
	cooldown = true
	lib.notify({
		title = 'Started',
		description = 'You have started the washing process.',
		type = 'inform'
	})
	Citizen.Wait(1000)
	if lib.progressBar({
		duration = Config.washduration,
		label = 'Washing Money',
		useWhileDead = false,
		canCancel = false,
	}) then lib.notify({title = 'Finished', description = 'You have finished washing your money!', type = 'inform'}) end
	washing = false
	Wait(Config.cooldown)
	cooldown = false
end)

RegisterNetEvent('notenoughblack', function()
	lib.notify({
		title = 'Not Enough',
		description = 'You do not have enough black money.',
		type = 'error'
	})
end)



exports.ox_target:addSphereZone({
    coords = vec3(1122.3206, -3193.2749, -40.623),
    radius = 2,
    debug = drawZones,
    options = {
        {
            name = 'wash',
            event = 'stevo_moneywash:washmoney',
            icon = 'fa-solid fa-money-bill',
            label = 'Wash Money',
            canInteract = function()
                return inwashroom
            end
        }
    }
})


exports.ox_target:addSphereZone({
    coords = vec3(1138.1576, -3199.1143, -39.6656),
    radius = 2,
    debug = drawZones,
    options = {
        {
            name = 'exit',
            event = 'stevo_moneywash:exitlaundry',
            icon = 'fa-solid fa-door-open',
            label = 'Exit LaundryMat',
            canInteract = function()
                return inwashroom
            end
        }
    }
})

exports.ox_target:addSphereZone({
    coords = vec3(1143.4563, -1000.2941, 45.3185),
    radius = 1,
    debug = drawZones,
    options = {
        {
            name = 'entry',
            event = 'stevo_moneywash:enterlaundry',
            icon = 'fa-solid fa-door-open',
            label = 'Enter LaundryMat',
        }
    }
})





