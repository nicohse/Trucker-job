ESX = exports["es_extended"]:getSharedObject()

local activeRentals = {}

ESX.RegisterServerCallback('truck_job:getRoutes', function(source, cb)
    MySQL.query('SELECT * FROM routes', {}, function(routes)
        if routes then
            print("Routen erfolgreich abgerufen: ", json.encode(routes))
            cb(routes)
        else
            print("Fehler: Keine Routen gefunden")
            cb({})
        end
    end)
end)

ESX.RegisterServerCallback('truck_job:rentTruck', function(source, cb, routeId)
    local xPlayer = ESX.GetPlayerFromId(source)
    local truckModel = 'pounder' -- truck modell
    
    if xPlayer.getMoney() >= 1000 then
        xPlayer.removeMoney(1000)
        TriggerClientEvent('truck_job:spawnTruck', source, truckModel, routeId)
        cb(true, truckModel)
    else
        cb(false)
        TriggerClientEvent('esx:showNotification', source, 'Nicht genug Geld für die Truck-Miete!')
    end
end)


RegisterServerEvent('truck_job:completeRoute')
AddEventHandler('truck_job:completeRoute', function(routeId)
    local xPlayer = ESX.GetPlayerFromId(source)
    local result = MySQL.query.await('SELECT reward FROM routes WHERE id = @id', {['@id'] = routeId})
    if result and result[1] then
        local reward = result[1].reward
        xPlayer.addMoney(reward)
    end
end)

RegisterServerEvent('truck_job:returnTruck')
AddEventHandler('truck_job:returnTruck', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    activeRentals[source] = nil
end)
