punishData = {}
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if NetworkIsSessionStarted() then
            TriggerServerEvent('codem:radar:loadedFirstData')
            return
        end
    end
end)



RegisterNUICallback('addPunishment', function(data)
    local playerPed = PlayerPedId()
    local position = GetEntityCoords(playerPed)
    local var1, var2 = GetStreetNameAtCoord(position.x, position.y, position.z, Citizen.ResultAsInteger(),
        Citizen.ResultAsInteger())
    local zone = GetNameOfZone(position.x, position.y, position.z);
    hash1 = GetStreetNameFromHashKey(var1);
    data.location = hash1 or 'Unknown'
    if not data.imageURL then
        data.imageURL = Config.DefaultImage
    end
    TriggerServerEvent('codem-radar:savePunish', data)
end)






RegisterNetEvent('codem:radar:sendProfile', function(data)
    nuiMessage("GET_PROFILE", data)
end)


RegisterNetEvent('codem-radar:updateData', function(data)
    table.insert(punishData, data)
    nuiMessage("GET_RADAR_DATA", punishData)
end)


RegisterNetEvent('codem-radar:allUpdate', function(data)
    punishData = data
end)

