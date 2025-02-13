local registeredNetworkIds = {}
local hashModel = `prop_tyre_spike_01`

local function debugPrint(text)
    if Config.Debug then
        print("^1[DEBUG] ^7" .. text)
    end
end

local function addSpikes(networkId)
    if type(networkId) ~= "number" or networkId == nil then return end

    local entity = NetworkGetEntityFromNetworkId(networkId)
    if not DoesEntityExist(entity) then return end

    local entityModel = GetEntityModel(entity)
    if entityModel ~= hashModel then 
        if Config.Debug then
            debugPrint("^1Spike not added: ^7Network ID " .. networkId .. ", Entity ID " .. entity .. " is not a spike.")
        end
        return
    end    

    if not registeredNetworkIds[networkId] then
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
