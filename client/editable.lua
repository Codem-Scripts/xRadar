RegisterNetEvent(Config.Radar.event)
AddEventHandler(Config.Radar.event, function()
    ToggleRadar()
end)


if Config.Radar.enableCommand then
    RegisterCommand(Config.Radar.command, function()
        ToggleRadar()
    end)
end

CreateThread(function()
    while true do
        if  IsControlPressed(0, Config.Radar.openKey.primary) and IsControlJustPressed(0, Config.Radar.openKey.secondary) then
            ToggleRadar()
        end
        Wait(0)
    end
end)


function ToggleRadar()
    if isPolVeh then
        isRadarOpen = not isRadarOpen
        nuiMessage("TOGGLE_RADAR", isRadarOpen)
        AddKeys()
        ForceUpdateNui()
        UpdateRadarTime()
        RadarLoop()
    end
end



function AddKeys()
    local locales = Locales.Default
    if selectedLanguage == 'en' then
        locales = Locales.English
    end
    if selectedLanguage == 'tr' then
        locales = Locales.Turkish
    end
    if selectedLanguage == 'de' then
        locales = Locales.Deutsch
    end
    if selectedLanguage == 'es' then
        locales = Locales.Spanisch
    end
    if selectedLanguage == 'pr' then
        locales = Locales.Portugiesisch 
    end
    if selectedLanguage == 'in' then
        locales = Locales.Hindi
    end

    ClearKeys()
    AddKey(Config.Radar.fastActionsKey.primary.label, Config.Radar.fastActionsKey.secondary.label, locales["FAST_ACCESS"])
    AddKey(Config.Radar.fastActionsKey.primary.label, Config.Radar.fastActionsKey.cursorKey.label, locales["OPEN_CURSOR"])
    AddKey(Config.Tablet.openKey.primary.label, Config.Tablet.openKey.secondary.label, locales["OPEN_TABLET"])
end

RegisterNUICallback("selectLanguage", function(data, cb)
    selectedLanguage = data.language
    AddKeys()
    nuiMessage("GET_LANGUAGE_VALUE", json.encode({
        DefaultLocales = Locales.Default,
        EnglishLocales = Locales.English,
        TurkishLocales = Locales.Turkish,
        DeutschLocales = Locales.Deutsch,
        EspanolLocales = Locales.Spanisch,
        PortugalLocales = Locales.Portugiesisch,
        HindiLocales = Locales.Hindi

    }))
end)


RegisterNUICallback("addBoloPlate", function(data, cb)
    if #data.plate > 0 then
        if  SearchBoloPlate(data.plate) then
            return
        end
        table.insert(boloPlates, data.plate)
    end
end)

RegisterNUICallback("clearBoloPlate", function(data, cb)
    for _,v in pairs(boloPlates) do
        if v == data.plate then
            table.remove(boloPlates, _)
        end
    end
end)

function SearchBoloPlate(plate)
    for _,v in pairs(boloPlates) do
        if v:lower() == plate:lower() then
            return true
        end
    end
    return false
end

RegisterNetEvent(Config.Tablet.event)
AddEventHandler(Config.Tablet.event, function()
    OpenTablet()
end)


if Config.Tablet.enableCommand then
    RegisterCommand(Config.Tablet.command, function()
        OpenTablet()
    end)
end

CreateThread(function()
    while true do
        if isRadarOpen then
            if IsControlPressed(0, Config.Tablet.openKey.primary.key) and IsControlJustPressed(0, Config.Tablet.openKey.secondary.key) then
                OpenTablet()
            end
        end
        Wait(0)
    end
end)

function OpenTablet()
    if isRadarOpen then
        TriggerServerEvent('codem:radar:getProfile')
        SetNuiFocus(true, true)
        nuiMessage("TOGGLE_TABLET", true)
        nuiMessage("GET_RADAR_DATA", punishData)
        nuiMessage("SET_REAR_SCANNED_VEHICLES", rearScannedVehicles)
        nuiMessage("SET_FRONT_SCANNED_VEHICLES", frontScannedVehicles)

        ForceUpdateNui()
      
    end
end

RegisterNUICallback("closeTablet", function(data, cb)
    SetNuiFocus(false, false)
    cb("ok")
end)