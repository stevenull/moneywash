local CurrentlyWashing = false
local InsideLaundry = false
local WashCooldown =  false

local function Cooldown()
	WashCooldown = true
	Wait(Config.Cooldown)
	WashCooldown = false
end

function WashMoney()
	if CurrentlyWashing then
		lib.notify({
			title = 'Currently Washing',
			description = 'You are already washing money!',
			type = 'error'
		})
	else

		if Config.UseTickets then
			local WashTicket = exports.ox_inventory:Search('count','moneywash_ticket')
			if WashTicket >= 1 then
				if not WashCooldown then
					SetEntityHeading(PlayerPedId(), 349.9048)
					lib.requestAnimDict('anim@gangops@facility@servers@bodysearch@', 10)
					TaskPlayAnim(PlayerPedId(), 'anim@gangops@facility@servers@bodysearch@', 'player_search', 8.0, -8.0, -1, 48, 0)
					local input = lib.inputDialog('Washing Amount', {'How much to wash?'})
		
					if not input then return end
					local WashAmount = tonumber(input[1])	
					TriggerServerEvent('stevo_moneywash:cleanmoney', WashAmount)
					Wait(500)
					ClearPedTasksImmediately(PlayerPedId())
				else
					lib.notify({
						title = 'Cooldown Active',
						description = 'The washing cooldown is active',
						type = 'error'
					})
				end
			else
				lib.notify({
					title = 'Access Denied',
					description = 'You need a wash ticket to use this machine!',
					type = 'error'
				})
			end
		else
			if not WashCooldown then
				SetEntityHeading(PlayerPedId(), 349.9048)
				lib.requestAnimDict('anim@gangops@facility@servers@bodysearch@', 10)
				TaskPlayAnim(PlayerPedId(), 'anim@gangops@facility@servers@bodysearch@', 'player_search', 8.0, -8.0, -1, 48, 0)
				local input = lib.inputDialog('Washing Amount', {'How much to wash?'})
	
				if not input then return end
				local WashAmount = tonumber(input[1])	
				TriggerServerEvent('stevo_moneywash:cleanmoney', WashAmount)
				Wait(500)
				ClearPedTasksImmediately(PlayerPedId())
			else
				lib.notify({
					title = 'Cooldown Active',
					description = 'The washing cooldown is active',
					type = 'error'
				})
			end
		end
	end
end

function ExitLaundry()
	if CurrentlyWashing then
		lib.notify({
			title = 'Currently Washing',
			description = 'You cannot exit the LaundryMat while washing!',
			type = 'error'
		})
	else
		InsideLaundry = false
		DoScreenFadeOut(100)
		Wait(500)
	    SetEntityCoords(PlayerPedId(), 1143.8951, -1000.2181, 45.3136)
		SetEntityHeading(PlayerPedId(), 275.8793)
		Wait(1000)
		DoScreenFadeIn(100)
	end
end

function EnterLaundry()
	if Config.UseEnterKeycard then
		local keycard = exports.ox_inventory:Search('count','moneywash_keycard')
		if keycard >= 1 then
			DoScreenFadeOut(100)
			Wait(1000)
			SetEntityCoords(PlayerPedId(), 1138.1279, -3199.1963, -39.6657)
			SetEntityHeading(PlayerPedId(), 6)
			Wait(1000)
			DoScreenFadeIn(100)
			InsideLaundry = true
		else
			lib.notify({
				title = 'Access Denied',
				description = 'You need a wash keycard to enter this LaundryMat!',
				type = 'error'
			})
		end
	else
		DoScreenFadeOut(100)
		Wait(1000)
		SetEntityCoords(PlayerPedId(), 1138.1279, -3199.1963, -39.6657)
		SetEntityHeading(PlayerPedId(), 6)
		Wait(1000)
		DoScreenFadeIn(100)
		InsideLaundry = true
	end
end

RegisterNetEvent('stevo_moneywash:washactions')
AddEventHandler('stevo_moneywash:washactions', function()
	CurrentlyWashing = true
	lib.notify({
		title = 'Started',
		description = 'You have started the washing process.',
		type = 'inform'
	})
	Wait(1000)
	if lib.progressBar({
		duration = Config.WashDuration,
		label = 'Washing Money',
		useWhileDead = false,
		canCancel = false,
	}) then lib.notify({title = 'Finished', description = 'You have finished washing your money!', type = 'inform'}) end
	CurrentlyWashing = false
    Cooldown()
end)

Citizen.CreateThread(function()
    exports.ox_target:addSphereZone({
		coords = vec3(1143.4563, -1000.2941, 45.3185),
		radius = 1,
		debug = drawZones,
		options = {
			{
				name = 'entry',
				icon = 'fa-solid fa-door-open',
				label = 'Enter LaundryMat',
				onSelect = function()
					EnterLaundry()
				end
			}
		}
	})
	exports.ox_target:addSphereZone({
		coords = vec3(1137.6561, -3199.2949, -40.2689),
		radius = 1,
		debug = drawZones,
		options = {
			{
				name = 'exit',
				icon = 'fa-solid fa-door-open',
				label = 'Exit LaundryMat',
				canInteract = function()
					return InsideLaundry
				end,
				onSelect = function()
					ExitLaundry()
				end
	
			}
		}
	})
	exports.ox_target:addSphereZone({
		coords = vec3(1122.4954, -3193.2864, -40.3926),
		radius = 1,
		debug = drawZones,
		options = {
			{
				name = 'wash',
				icon = 'fa-solid fa-money-bill',
				label = 'Wash Money',
				canInteract = function()
					return InsideLaundry
				end,
				onSelect = function()
					WashMoney()
				end
			}
		}
	})	
end)


	



