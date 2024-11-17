isRadarOpen = false
isTabletOpen = false
selectedLanguage = "default"
isPolVeh = false
frontXMIT = true
rearXMIT = true
fwdMode = "same"
bwdMode = "same"
currentFrontVehicle = false
currentRearVehicle = false
lockedFrontVehicle = false
lockedRearVehicle = false
frontLockedSpeed = false
rearLockedSpeed = false
frontSpeedWarning = false
rearSpeedWarning = false
showFastActions = false
cursorEnabled = false
radarPower = true
boloPlates = {}
radarTime = 0
rearScannedVehicles = 0
frontScannedVehicles = 0



angles = { ["same"] = vector3(0.0, 50.0, 0.0), ["opp"] = vector3(-10.0, 50.0, 0.0) }

function round(num)
    return tonumber(string.format("%.0f", num))
end

function GetVehicleInDirectionSphere(entFrom, coordFrom, coordTo)
    local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10,
        entFrom, 0)
    local _, _, _, _, vehicle = GetShapeTestResult(rayHandle)
    return vehicle
end

function oppang(ang)
    return (ang + 180) % 360
end



function IsEntityInMyHeading(myAng, tarAng, range)
    local rangeStartFront = myAng - (range / 2)
    local rangeEndFront = myAng + (range / 2)

    local opp = oppang(myAng)

    local rangeStartBack = opp - (range / 2)
    local rangeEndBack = opp + (range / 2)

    if ((tarAng > rangeStartFront) and (tarAng < rangeEndFront)) then
        return true
    elseif ((tarAng > rangeStartBack) and (tarAng < rangeEndBack)) then
        return false
    else
        return nil
    end
end

function GetVehSpeed(veh)
    return GetEntitySpeed(veh) * 3.6
end


function AddKey(primaryLabel, secondaryLabel, title)
    nuiMessage("ADD_KEY", {
        primaryLabel = primaryLabel, 
        secondaryLabel = secondaryLabel, 
        title = title,
    })
end

function ClearKeys()
    nuiMessage("CLEAR_KEYS")
end


CreateThread(function()
    while true do
        if isRadarOpen and radarPower then
            radarTime = radarTime + 1
            UpdateRadarTime()
        end
        Wait(1000)
    end
end)

function UpdateRadarTime()
    nuiMessage("UPDATE_RADAR_TIME", radarTime)
end

RegisterNUICallback("closeTablet", function(data, cb)
    SetNuiFocus(false, false)
    cb("ok")
end)

CreateThread(function()
    while true do
        if isRadarOpen and isPolVeh then
            if IsControlPressed(0, Config.Radar.fastActionsKey.primary.key) and IsControlJustPressed(0, Config.Radar.fastActionsKey.secondary.key) then
                showFastActions = not showFastActions
                nuiMessage("TOGGLE_FAST_ACTIONS", showFastActions)
            end
            if IsControlPressed(0, Config.Radar.fastActionsKey.primary.key) and IsControlJustPressed(0, Config.Radar.fastActionsKey.cursorKey.key) then
                if showFastActions then
                    cursorEnabled = not cursorEnabled
                    SetNuiFocus(cursorEnabled, cursorEnabled)
                    SetNuiFocusKeepInput(cursorEnabled)           
                    DisableMouseControl()
                end
            end
            if cursorEnabled and isTabletOpen then
                cursorEnabled = false
                SetNuiFocusKeepInput(cursorEnabled)  
            end
        else
            if cursorEnabled then
                cursorEnabled = false
                SetNuiFocus(cursorEnabled, cursorEnabled)
                SetNuiFocusKeepInput(cursorEnabled)       
            end  
            Wait(2000)
        end
        Wait(0)
    end
end)

function DisableMouseControl()
    CreateThread(function()    
        while cursorEnabled do
            Wait(0)
            DisableControlAction(0, 1, true) -- disable mouse look
            DisableControlAction(0, 2, true) -- disable mouse look
            DisableControlAction(0, 3, true) -- disable mouse look
            DisableControlAction(0, 4, true) -- disable mouse look
            DisableControlAction(0, 5, true) -- disable mouse look
            DisableControlAction(0, 6, true) -- disable mouse look
            DisableControlAction(0, 199, true) -- map
            DisableControlAction(0, 200, true) -- map
            DisableControlAction(0, 75, true) -- F
            DisableControlAction(0, 200, true) -- ESC
            DisableControlAction(0, 202, true) -- BACKSPACE / ESC
            DisableControlAction(0, 177, true) -- BACKSPACE / ESC            
            HideHudComponentThisFrame(16)
        end
    end)
end





RegisterNUICallback("radarAction", function(data, cb)
    local type = data.type
    local payload = data.payload
    if type == 'setBWDMode' then
        bwdMode = payload
    end
    if type == 'setFWDMode' then
        fwdMode = payload
    end
    if type == 'setRearXMIT' then
        rearXMIT = not rearXMIT
    end
    if type == 'setFrontXMIT' then
        frontXMIT = not frontXMIT
    end
    if type == 'lockFrontVehicle' then
        if lockedFrontVehicle then
            lockedFrontVehicle = false
        else
            lockedFrontVehicle = currentFrontVehicle
        end
    end 

    if type == 'lockRearVehicle' then
        if lockedRearVehicle then
            lockedRearVehicle = false
        else
            lockedRearVehicle = currentRearVehicle
        end
    end
    if type == 'lockFrontSpeed' then

        if not frontLockedSpeed then
            if DoesEntityExist(currentFrontVehicle) then
                frontLockedSpeed = round(GetVehSpeed(currentFrontVehicle), 0)
            end
        else
            frontLockedSpeed = false
        end
    end
    if type == 'lockRearSpeed' then
        if not rearLockedSpeed then
            if DoesEntityExist(currentRearVehicle) then
                rearLockedSpeed = round(GetVehSpeed(currentRearVehicle), 0)
            end
        else
            rearLockedSpeed = false
        end
    end
    if type == 'increaseFrontWarningSpeed' then
        if not frontSpeedWarning then
            frontSpeedWarning = 5
        else
            frontSpeedWarning = frontSpeedWarning + 5
        end
        frontLockedSpeed = false
    end
    if type == 'decreaseFrontWarningSpeed' then
        if not frontSpeedWarning or frontSpeedWarning == 0 then
            frontSpeedWarning = false
        else
            frontSpeedWarning = frontSpeedWarning - 5
            if frontSpeedWarning == 0 then
                frontSpeedWarning = false
            end
        end
        frontLockedSpeed = false
    end

    if type == 'increaseRearWarningSpeed' then
        if not rearSpeedWarning then
            rearSpeedWarning = 5
        else
            rearSpeedWarning = rearSpeedWarning + 5
        end
        rearLockedSpeed = false
    end
    if type == 'decreaseRearWarningSpeed' then
        if not rearSpeedWarning or rearSpeedWarning == 0 then
            rearSpeedWarning = false
        else
            rearSpeedWarning = rearSpeedWarning - 5
            if rearSpeedWarning == 0 then
                rearSpeedWarning = false
            end
        end
        rearLockedSpeed = false
    end
    if type == 'setFrontWarningSpeed' then
        if not payload then
            frontSpeedWarning = false
        else
            if payload == 0 then
                frontSpeedWarning = false
            else
                frontSpeedWarning = tonumber(payload)
            end
        end
    end
    if type == 'setRearWarningSpeed' then
        if not payload then
            rearSpeedWarning = false
        else
            if payload == 0 then
                rearSpeedWarning = false
            else
                rearSpeedWarning = tonumber(payload)
            end
        end
    end
    if type == 'radarPower' then
        radarPower = not radarPower
    end
    ForceUpdateNui()
    
    cb("ok")
end)



function ForceUpdateNui()
    nuiMessage("FORCE_UPDATE", {
        fwdMode = fwdMode,
        bwdMode = bwdMode,
        frontSpeedWarning = frontSpeedWarning,
        rearSpeedWarning = rearSpeedWarning,
        frontLockedSpeed = frontLockedSpeed,
        rearLockedSpeed =  rearLockedSpeed,
        lockedFrontVehicle = lockedFrontVehicle,
        lockedRearVehicle  = lockedRearVehicle,
        radarPower = radarPower,
        frontXMIT = frontXMIT,
        rearXMIT = rearXMIT,
    })
end



function RadarLoop()
    CreateThread(function()
        while isRadarOpen do
            if radarPower then
                local Player = PlayerPedId()
                local vehicle = GetVehiclePedIsIn(Player)
                checkRadarLocation()
                if DoesEntityExist(vehicle) and GetPedInVehicleSeat(vehicle, -1) == Player then
                    local vehicleSpeed = GetVehSpeed(vehicle)
                    local vehiclePos = GetEntityCoords(vehicle, true)
                    local h = round(GetEntityHeading(vehicle), 0)
                    if frontXMIT then
                        local forwardPosition = GetOffsetFromEntityInWorldCoords(vehicle, angles[fwdMode])
                        local fwdPos = { x = forwardPosition.x, y = forwardPosition.y, z = forwardPosition.z }
                        local _, fwdZ = GetGroundZFor_3dCoord(fwdPos.x, fwdPos.y, fwdPos.z + 500.0)
                        if fwdPos.z < fwdZ and not (fwdZ > vehiclePos.z + 1.0) then
                            fwdPos.z = fwdZ + 0.5
                        end
                        local fwdVeh = GetVehicleInDirectionSphere(vehicle, vehiclePos, fwdPos)
                        if not lockedFrontVehicle and not DoesEntityExist(lockedFrontVehicle) then
                            if DoesEntityExist(fwdVeh) and IsEntityAVehicle(fwdVeh) then
                                local fwdVehSpeed = round(GetVehSpeed(fwdVeh), 0)
                                local fwdVehHeading = GetEntityHeading(fwdVeh)
                                local plate = GetVehicleNumberPlateText(fwdVeh)
                                if currentFrontVehicle ~= fwdVeh then
                                    frontScannedVehicles = frontScannedVehicles + 1
                                end
                                currentFrontVehicle = fwdVeh
                                local speed = frontLockedSpeed or fwdVehSpeed
                                nuiMessage("SET_FRONT_RADAR_PLATE", plate)
                                nuiMessage("SET_FRONT_RADAR_SPEED", speed)
                                nuiMessage("SET_FRONT_SCANNED_VEHICLES", frontScannedVehicles)
                                if frontSpeedWarning and speed > frontSpeedWarning then
                                    PlaySoundFrontend( -1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
                                end
                                if SearchBoloPlate(plate) then
                                    nuiMessage("PLAY_SOUND", "pd-warn")
                                end
                            end
                        else
                            if IsEntityAVehicle(lockedFrontVehicle) then
                                local fwdVehSpeed = round(GetVehSpeed(lockedFrontVehicle), 0)
                                local fwdVehHeading = GetEntityHeading(lockedFrontVehicle)
                                local plate = GetVehicleNumberPlateText(lockedFrontVehicle)
    
                                currentFrontVehicle = lockedFrontVehicle
                                local speed = frontLockedSpeed or fwdVehSpeed
                                nuiMessage("SET_FRONT_RADAR_PLATE", plate)
                                nuiMessage("SET_FRONT_RADAR_SPEED", speed)
                                if frontSpeedWarning and speed > frontSpeedWarning then
                                    PlaySoundFrontend( -1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
                                end
    
    
                                if SearchBoloPlate(plate) then
                                    nuiMessage("PLAY_SOUND", "pd-warn")
                                end
                            end
                        end
                    end
                    if rearXMIT then
                        local backwardPosition = GetOffsetFromEntityInWorldCoords(vehicle, angles[bwdMode].x,
                            -angles[bwdMode].y, angles[bwdMode].z)
                        local bwdPos = { x = backwardPosition.x, y = backwardPosition.y, z = backwardPosition.z }
                        local _, bwdZ = GetGroundZFor_3dCoord(bwdPos.x, bwdPos.y, bwdPos.z + 500.0)
                        if bwdPos.z < bwdZ and not (bwdZ > vehiclePos.z + 1.0) then
                            bwdPos.z = bwdZ + 0.5
                        end
                        local bwdVeh = GetVehicleInDirectionSphere(vehicle, vehiclePos, bwdPos)
                        if not lockedRearVehicle and not DoesEntityExist(lockedRearVehicle) then
                            if DoesEntityExist(bwdVeh) and IsEntityAVehicle(bwdVeh) then
                                local bwdVehSpeed = round(GetVehSpeed(bwdVeh), 0)
                                local bwdVehHeading = GetEntityHeading(bwdVeh)
                                local plate = GetVehicleNumberPlateText(bwdVeh)
                                if currentRearVehicle ~= bwdVeh then
                                    rearScannedVehicles = rearScannedVehicles + 1
                                end
                                currentRearVehicle = bwdVeh
                                local speed = rearLockedSpeed or bwdVehSpeed
                                nuiMessage("SET_REAR_RADAR_PLATE", plate)
                                nuiMessage("SET_REAR_RADAR_SPEED", speed)
                                nuiMessage("SET_REAR_SCANNED_VEHICLES", rearScannedVehicles)
    
                                if rearSpeedWarning and speed > rearSpeedWarning then
                                    PlaySoundFrontend( -1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
                                end
                                if SearchBoloPlate(plate) then
                                    nuiMessage("PLAY_SOUND", "pd-warn")
                                end
                            end
                        else
                            if IsEntityAVehicle(lockedRearVehicle) then
                                local bwdVehSpeed = round(GetVehSpeed(lockedRearVehicle), 0)
                                local bwdVehHeading = GetEntityHeading(lockedRearVehicle)
                                local plate = GetVehicleNumberPlateText(lockedRearVehicle)
                                currentRearVehicle = lockedRearVehicle
                                nuiMessage("SET_REAR_RADAR_PLATE", plate)
                                local speed = rearLockedSpeed or bwdVehSpeed
    
                                nuiMessage("SET_REAR_RADAR_SPEED", speed)
                                if rearSpeedWarning and speed > rearSpeedWarning then
                                    PlaySoundFrontend( -1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
                                end
                                if SearchBoloPlate(plate) then
                                    nuiMessage("PLAY_SOUND", "pd-warn")
                                end
                            end
                        end
                    end
                    nuiMessage("SET_PATROL_SPEED", vehicleSpeed)
                end
            end
            Wait(200)
        end
    end)
end

directions = {
    N = 360,
    0,
    NE = 315,
    E = 270,
    SE = 225,
    S = 180,
    SW = 135,
    W = 90,
    NW = 45
 
}
checkRadarLocation = function()
    Citizen.CreateThread(function()
        local playerPed = PlayerPedId()
        local position = GetEntityCoords(playerPed)
        local var1, var2 = GetStreetNameAtCoord(position.x, position.y, position.z, Citizen.ResultAsInteger(),
            Citizen.ResultAsInteger())
        local zone = GetNameOfZone(position.x, position.y, position.z);
        local zoneLabel = GetLabelText(zone);
        hash1 = GetStreetNameFromHashKey(var1);
        hash2 = GetStreetNameFromHashKey(var2);
        local street2;
        street2 = zoneLabel;
        local heading = GetEntityHeading(playerPed);

        for k, v in pairs(directions) do
            if (math.abs(heading - v) < 22.5) then
                heading = k;

                if (heading == 1) then
                    heading = 'N';
                    break;
                end

                break;
            end
        end

        nuiMessage("SET_LOCATION", {
            street = hash1,
            heading = heading,
        })
    end)
end


CreateThread(function()
    while true do
        local Player = PlayerPedId()
        local veh = GetVehiclePedIsIn(Player)
        local class = GetVehicleClass(veh)
        isPolVeh = class == 18 and true or false
        if not isPolVeh and isRadarOpen then
            isRadarOpen = false
            nuiMessage("TOGGLE_RADAR", isRadarOpen)
        end
        Wait(2000)
    end
end)

function nuiMessage(action, payload)
    SendNUIMessage({
        action = action,
        payload = payload
    })
end




