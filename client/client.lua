local spikes = {}
local hashModel = `prop_tyre_spike_01`
local deployedVehicleNetId = nil

local function debugPrint(text)
    if Config.Debug then
        print("^1[DEBUG] ^7" .. text)
    end
end

local function createSpike(vehicle, offset, delay, index)
    SetTimeout(delay, function()
        local spike = CreateObject(hashModel, GetOffsetFromEntityInWorldCoords(vehicle, 0, -1.2 + offset, -0.4), true, true, false)
        SetEntityNoCollisionEntity(spike, vehicle, true)
        PlaySoundFromEntity(-1, "CAR_THEFT_MOVIE_LOT_DROP_SPIKES", vehicle, 0, false, 0)
        PlaceObjectOnGroundProperly(spike)
        SetEntityCollision(spike, true, true)
        spikes[index] = spike
    end)
end

local function storeSpikes()
    SetTimeout(400, function()
        local netIds = {}
        for i = 1, 3 do
            netIds[i] = NetworkGetNetworkIdFromEntity(spikes[i])
        end
        TriggerServerEvent("spikes:storeSpikes", netIds[1], netIds[2], netIds[3])
    end)
end

RegisterCommand("+dropspikes", function(source, args, rawCommand)
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)

    if vehicle == 0 or not DoesEntityExist(vehicle) then
        debugPrint("No vehicle found or vehicle does not exist.")
        return
    end

    if GetPedInVehicleSeat(vehicle, -1) ~= playerPed then
        debugPrint("You must be the driver to drop spikes.")
        return
    end

    local plate = GetVehicleNumberPlateText(vehicle)
    local model = GetEntityModel(vehicle)

    local isPlateAllowed = not Config.AllowOnlyPlates or Config.AllowedPlates[plate]
    local isModelAllowed = not Config.AllowOnlyModels or Config.AllowedModelHashes[model]

    if not isPlateAllowed and not isModelAllowed then
        debugPrint("Vehicle not allowed: Plate - " .. plate .. ", Model - " .. model)
        return
    end

    RequestAmbientAudioBank("CAR_THEFT_MOVIE_LOT", false, -1)

    deployedVehicleNetId = NetworkGetNetworkIdFromEntity(vehicle)

    createSpike(vehicle, 0, 100, 1)
    createSpike(vehicle, 0.5, 200, 2)
    createSpike(vehicle, 1.0, 300, 3)

    storeSpikes()
end)

RegisterKeyMapping("+dropspikes", "Drop Vehicle Spikes", "keyboard", "G")


-- Waiting for new Polyzone Natives... FiveM please commit men

CreateThread(function()
    while true do
        local waitTime = 250
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local vehicle = GetVehiclePedIsIn(playerPed, false)

        if vehicle ~= 0 and DoesEntityExist(vehicle) then
            local plate = GetVehicleNumberPlateText(vehicle)
            local object = GetClosestObjectOfType(playerCoords, 3.0, hashModel, false, false, false)

            if DoesEntityExist(object) then
                waitTime = 0
                local vehicleNetId = NetworkGetNetworkIdFromEntity(vehicle)
                if vehicleNetId ~= deployedVehicleNetId then
                    for i = 0, 7 do
                        if not IsVehicleTyreBurst(vehicle, i, true) then
                            SetVehicleTyreBurst(vehicle, i, true, 1000)
                        end
                    end
                    Wait(500)
                end
            end
        end

        Wait(waitTime)
    end
end)
