ESX = exports["es_extended"]:getSharedObject()

local currentRoute = nil
local rentalLocation = vector3(-115.7035, -2516.6558, 6.0957) -- koords vermietung
local returnLocation = vector3(-124.3886, -2537.9221, 6.0000) -- koords rückgabe
local hasTruck = false

local activeBlips = {} 
local rentalBlip = nil

function CreateBlipForCoord(coords, sprite, color, name, route)
    local blip = AddBlipForCoord(coords)
    SetBlipSprite(blip, sprite)
    SetBlipColour(blip, color)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(blip)

    if route then
        SetBlipRoute(blip, true)
    end

    table.insert(activeBlips, blip)
end

function RemoveAllWaypoints()
    for _, blip in ipairs(activeBlips) do
        if DoesBlipExist(blip) and blip ~= rentalBlip then
            RemoveBlip(blip)
        end
    end
    activeBlips = {} 
end

--vermietung
Citizen.CreateThread(function()
    rentalBlip = AddBlipForCoord(rentalLocation)
    SetBlipSprite(rentalBlip, 477)
    SetBlipDisplay(rentalBlip, 4)
    SetBlipScale(rentalBlip, 1.0)
    SetBlipColour(rentalBlip, 47)
    SetBlipAsShortRange(rentalBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Trucker Job")
    EndTextCommandSetBlipName(rentalBlip)

    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        -- rückgabe
        if hasTruck then
            DrawMarker(1, returnLocation.x, returnLocation.y, returnLocation.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 5.0, 5.0, 1.0, 255, 0, 0, 100, false, true, 2, false, false, false, false)

            local returnDistance = GetDistanceBetweenCoords(playerCoords, returnLocation, true)
            if returnDistance < 5.0 then
                ESX.ShowHelpNotification("Drücke ~INPUT_CONTEXT~ um den Truck zurückzugeben")

                if IsControlJustReleased(0, 38) then -- E taste
                    
                    local vehicle = GetVehiclePedIsIn(playerPed, false)
                    if vehicle then
                        DeleteVehicle(vehicle)
                    end
                    hasTruck = false
                    currentRoute = nil
                    RemoveAllWaypoints()
                    TriggerServerEvent('truck_job:returnTruck')
                    ESX.ShowNotification("Truck zurückgegeben")
                end
            end
        end

        -- marker und menü vermietung
        local rentalDistance = GetDistanceBetweenCoords(playerCoords, rentalLocation, true)
        if rentalDistance < 10.0 and not hasTruck then
            DrawMarker(22, rentalLocation.x, rentalLocation.y, rentalLocation.z + 1.0 - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.5, 255, 255, 0, 100, false, true, 2, false, false, false, false)

            if rentalDistance < 1.0 then
                ESX.ShowHelpNotification("Drücke ~INPUT_CONTEXT~ um einen Truck zu mieten")

                if IsControlJustReleased(0, 38) then -- E taste
                    ESX.TriggerServerCallback('truck_job:getRoutes', function(routes)
                        if routes then
                            local elements = {}
                            for _, route in ipairs(routes) do
                                local label = string.format("%s - $%d", route.name, route.reward)
                                table.insert(elements, {label = label, value = route.id})
                            end
                    
                            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'select_route', {
                                title    = 'Wähle eine Route',
                                align    = 'bottom-right', -- menü position
                                elements = elements
                            }, function(data, menu)
                                ESX.TriggerServerCallback('truck_job:rentTruck', function(success)
                                    if success then
                                        currentRoute = data.current.value
                                        hasTruck = true
                                    else
                                        ESX.ShowNotification("Fehler beim Mieten des Trucks")
                                    end
                                end, data.current.value)
                                menu.close()
                            end, function(data, menu)
                                menu.close()
                            end)
                        else
                            ESX.ShowNotification("Keine Routen verfügbar")
                        end
                    end)
                    
                end
            end
        end
    end
end)

-- spawntruck + waypoint
RegisterNetEvent('truck_job:spawnTruck')
AddEventHandler('truck_job:spawnTruck', function(truckModel, routeId)
    local playerPed = PlayerPedId()
    local spawnCoords = vector3(-105.2660, -2531.4810, 6.0000)
    local heading = 320.3202

    ESX.Game.SpawnVehicle(truckModel, spawnCoords, heading, function(vehicle)
        TaskWarpPedIntoVehicle(playerPed, vehicle, -1)

        -- gelber waypoint
        ESX.TriggerServerCallback('truck_job:getRoutes', function(routes)
            for _, route in ipairs(routes) do
                if route.id == routeId then
                    local routeCoords = vector3(route.x, route.y, route.z)

                    CreateBlipForCoord(routeCoords, 1, 5, "Zielort", true)

                    -- ziel
                    Citizen.CreateThread(function()
                        while currentRoute do
                            Citizen.Wait(500)
                            local playerCoords = GetEntityCoords(playerPed)
                            local distanceToTarget = GetDistanceBetweenCoords(playerCoords, routeCoords, true)

                            if distanceToTarget < 10.0 then
                                TriggerServerEvent('truck_job:completeRoute', routeId)
                                ESX.ShowNotification("Route abgeschlossen! Kehre zur Vermietstation zurück")
                                RemoveAllWaypoints()
                                currentRoute = nil
                                break
                            end
                        end
                    end)

                    break
                end
            end
        end)
    end)
end)
