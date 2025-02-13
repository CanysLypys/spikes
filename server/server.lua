local registeredNetworkIds = {}

local function debugPrint(text)
    if Config.Debug then
        print("^1[DEBUG] ^7" .. text)
    end
end

local function addSpikes(networkId)
    if type(networkId) ~= "number" or networkId == nil then return end

    if not registeredNetworkIds[networkId] then
        local entity = NetworkGetEntityFromNetworkId(networkId)
        registeredNetworkIds[networkId] = entity
        debugPrint("^2Spike added: ^7Network ID " .. networkId .. ", Entity ID " .. entity)

        SetTimeout(Config.SpikeDeletionInterval, function()
            TriggerEvent("nc_spikes:deleteSpikes", networkId)
        end)
    end
end

RegisterNetEvent("nc_spikes:deleteSpikes", function(networkId)
    if type(networkId) ~= "number" or networkId == nil then return end

    if registeredNetworkIds[networkId] then
        local entity = NetworkGetEntityFromNetworkId(networkId)
        if DoesEntityExist(entity) then
            DeleteEntity(entity)
        end
        registeredNetworkIds[networkId] = nil
        debugPrint("^1Spike deleted: ^7Network ID " .. networkId)
    end
end)

RegisterNetEvent("nc_spikes:storeSpikes", function(netIdSpikes_1, netIdSpikes_2, netIdSpikes_3)
    addSpikes(netIdSpikes_1)
    addSpikes(netIdSpikes_2)
    addSpikes(netIdSpikes_3)
end)