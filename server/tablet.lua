local punishData = {}
RegisterServerEvent('codem-radar:savePunish', function(data)
    local src = source
    local officerName
    if Config.Framework ~= 'standalone' then
        officerName = GetName(src)
    else
        officerName = 'Unknown'
    end
    local date = os.date("%Y-%m-%d %H:%M")
    ExecuteSql(
        "INSERT INTO `codemradar` (`citizenname`,`officername`, `time`, `location`,`description`,`plate`,`image`) VALUES ('" ..
        data.playerName ..
        "','" ..
        officerName ..
        "', '" ..
        date ..
        "','" ..
        data.location ..
        "','" ..
        data.description ..
        "','" .. data.plate .. "','" .. data.imageURL .. "')")

    local newData = {
        citizenname = data.playerName,
        officername = officerName,
        time = date,
        location = data.location,
        description = data.description,
        plate = data.plate,
        image = data.imageURL
    }

    table.insert(punishData, newData)
    TriggerClientEvent('codem-radar:updateData', -1, newData)
end)


Citizen.CreateThread(function()
    Citizen.Wait(1000)
    local result = ExecuteSql("SELECT * FROM `codemradar`")

    for _, v in pairs(result) do
        table.insert(punishData, v)
    end
    TriggerClientEvent('codem-radar:allUpdate', -1, punishData)
end)

RegisterServerEvent('codem:radar:getProfile', function()
    local src = source
    if Config.Framework ~= 'standalone' then
        local data = {
            avatar = GetDiscordAvatar(src) or Config.DefaultImage,
            name = GetName(src),
        }
        TriggerClientEvent('codem:radar:sendProfile', src, data)
        TriggerClientEvent('codem-radar:getAllDataa', src, punishData)
    else

    end
end)


RegisterServerEvent('codem:radar:loadedFirstData', function()
    local src = source
    TriggerClientEvent('codem-radar:allUpdate', src, punishData)
end)
