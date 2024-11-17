Config = {}
Config.Framework = 'qb'  -- esx, oldesx, qb ,oldqb , standalone
Config.Mysql = "oxmysql" -- mysql-async, ghmattimysql, oxmysql
Config.DefaultImage = 'https://cdn.discordapp.com/attachments/983471660684423240/1142493143128870922/banshee.jpg'


Config.Radar = {
    enableCommand = true,
    command = "radar",
    event = "xRadar:ToggleRadar",
    openKey = {
        primary = 36,
        secondary = 184,         
    },
    fastActionsKey = {
        primary = {
            key = 36, -- CTRL
            label = "CTRL"
        }, 
        secondary = {
            key = 311, -- K
            label = "K"
        }, 
        cursorKey = {
            key = 182, -- L
            label = "L",
        }, 
    }
}

Config.Tablet = {
    enableCommand = true,
    command = "radartablet",
    event = "xRadar:OpenTablet",
    openKey = {
        primary = {
            key = 36, -- CTRL
            label = "CTRL"
        } , 
        secondary = {
            key = 26, -- C
            label = "C" 
        }, 
    },

}

function GetName(source)
    if Config.Framework == "oldesx" or Config.Framework == "esx" then
        local xPlayer = frameworkObject.GetPlayerFromId(tonumber(source))
        if xPlayer then
            return xPlayer.getName()
        else
            return "0"
        end
    elseif Config.Framework == 'qb' or Config.Framework == 'oldqb' then
        local Player = frameworkObject.Functions.GetPlayer(tonumber(source))
        if Player then
            return Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname
        else
            return "0"
        end
    end
end
