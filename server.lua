print("Ice car, Kuzkay YASUO_QB")
local QBCore = exports['qb-core']:GetCoreObject()	
local CopsConnected       	   = 0
local RequiredCopsMorf         = 1    --Limit on the number of online police


function CountCops()
	local xPlayers = QBCore.Functions.GetPlayers()
	CopsConnected = 0
	for i=1, #xPlayers, 1 do
		local xPlayer = QBCore.Functions.GetPlayer(xPlayers[i])
		if xPlayer.PlayerData.job.name == 'police' then
			CopsConnected = CopsConnected + 1
		end
	end

	SetTimeout(120 * 1000, CountCops)
end

CountCops()



RegisterServerEvent('esx_methcar:start')
AddEventHandler('esx_methcar:start', function()
	local _source = source
	local xPlayer = QBCore.Functions.GetPlayer(_source)
	
	if CopsConnected < RequiredCopsMorf then
		TriggerClientEvent('pkl:showCountryWelcome', _source, 'Limit on the number of online police')
		return
	end

	if xPlayer.Functions.GetItemByName('acetone').count >= 5 and xPlayer.Functions.GetItemByName('lithium').count >= 2 and xPlayer.Functions.GetItemByName('methlab').count >= 1 then
		if xPlayer.Functions.GetItemByName('meth').count >= 200 then
				TriggerClientEvent('esx_methcar:notify', _source, "~r~~h~Limit on the number of online police")
		else
			TriggerClientEvent('esx_methcar:startprod', _source)
			xPlayer.Functions.RemoveItem('acetone', 5)
			TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items["acetone"], "remove")
			xPlayer.Functions.RemoveItem('lithium', 2)
			TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items["lithium"], "remove")
		end

		
		
	else
		TriggerClientEvent('esx_methcar:notify', _source, "~r~~h~Limit on the number of online police")

	end
	
end)
RegisterServerEvent('esx_methcar:stopf')
AddEventHandler('esx_methcar:stopf', function(id)
local _source = source
	local xPlayers = QBCore.Functions.GetPlayers()
	local xPlayer = QBCore.Functions.GetPlayer(_source)
	for i=1, #xPlayers, 1 do
		TriggerClientEvent('esx_methcar:stopfreeze', xPlayers[i], id)
	end
	
end)
RegisterServerEvent('esx_methcar:make')
AddEventHandler('esx_methcar:make', function(posx,posy,posz)
	local _source = source
	local xPlayer = QBCore.Functions.GetPlayer(_source)
	
	if xPlayer.Functions.GetItemByName('methlab').count >= 1 then
	
		local xPlayers = QBCore.Functions.GetPlayers()
		for i=1, #xPlayers, 1 do
			TriggerClientEvent('esx_methcar:smoke',xPlayers[i],posx,posy,posz, 'a') 
		end
		
	else
		TriggerClientEvent('esx_methcar:stop', _source)
	end
	
end)
RegisterServerEvent('esx_methcar:finish')
AddEventHandler('esx_methcar:finish', function(qualtiy)
	local _source = source
	local xPlayer = QBCore.Functions.GetPlayer(_source)
	print(qualtiy)
	local rnd = math.random(-5, 5)
	TriggerEvent('KLevels:addXP', _source, 20)
	xPlayer.Functions.AddItem('meth', math.floor(qualtiy / 2) + rnd)
	TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['meth'], "add")
	
end)

RegisterServerEvent('esx_methcar:blow')
AddEventHandler('esx_methcar:blow', function(posx, posy, posz)
	local _source = source
	local xPlayers = QBCore.Functions.GetPlayers()
	local xPlayer = QBCore.Functions.GetPlayer(_source)
	for i=1, #xPlayers, 1 do
		TriggerClientEvent('esx_methcar:blowup', xPlayers[i],posx, posy, posz)
	end
	xPlayer.Functions.RemoveItem('methlab', 1)
	TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items["methlab"], "remove")
end)

