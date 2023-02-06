local CurrentlyWashing = false
local InsideLaundry = false
local WashCooldown =  false
local playerPed = PlayerPedId()


AddEventHandler('stevo_moneywash:washmoney', function()
	if CurrentlyWashing == true then
		lib.notify({
			title = 'Currently Washing',
			description = 'You are already washing money!',
			type = 'error'
		})
	else
		if WashCooldown == false then
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
	if CurrentlyWashing == true then
		lib.notify({
			title = 'Currently Washing',
			description = 'You cannot exit the LaundryMat while washing!',
			type = 'error'
		})
	else
		InsideLaundry = false
		DoScreenFadeOut(100)
		Wait(500)
	    SetEntityCoords(playerPed, 1143.8951, -1000.2181, 45.3136)
		SetEntityHeading(playerPed, 275.8793)
		Wait(1000)
		DoScreenFadeIn(100)
	end
end)

AddEventHandler('stevo_moneywash:enterlaundry', function()
    local keycard = exports.ox_inventory:Search('count','moneywash_keycard')
		if keycard >= 1 then
			InsideLaundry = true
			DoScreenFadeOut(100)
			Wait(1000)
			SetEntityCoords(playerPed, 1138.1649, -3199.1167, -39.6658)
			SetEntityHeading(playerPed, 357.9966)
			Wait(1000)
			DoScreenFadeIn(100)
		else
			lib.notify({
				title = 'Access Denied',
				description = 'You need a wash keycard to enter this LaundryMat!',
				type = 'error'
			})
		end
end)

RegisterNetEvent('stevo_moneywash:washactions')
AddEventHandler('stevo_moneywash:washactions', function()
	CurrentlyWashing = true
	lib.notify({
		title = 'Started',
		description = 'You have started the washing process.',
		type = 'inform'
	})
	Citizen.Wait(1000)
	if lib.progressBar({
		duration = Config.WashDuration,
		label = 'Washing Money',
		useWhileDead = false,
		canCancel = false,
	}) then lib.notify({title = 'Finished', description = 'You have finished washing your money!', type = 'inform'}) end
	CurrentlyWashing = false
    Cooldown()
end)

local function Cooldown()
	WashCooldown = true
	Wait(Config.Cooldown)
	WashCooldown = false
end




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
                return InsideLaundry
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
                return InsideLaundry
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
