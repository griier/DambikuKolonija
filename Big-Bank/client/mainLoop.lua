ped = nil -- Sets ped to nil
local objects = {} -- Creates a new table called objects
robbing = false  -- Sets robbing to false
lockpicking = false -- Sets lockpicking to false
safeboxing = false -- Sets safeboxing to false
currentStore = 0 -- Sets currentStore to 0
copsCalled = false -- Sets copsCalled to false
serverKeyGen = 0 -- Sets serverKeyGen to 0
inPoly = false -- Sets inPoly to false
first = true -- Sets first to true
canRob = true -- Sets canRob to true
allowedToOpen = false -- Sets allowedToOpen to false
globalClosestDoor = nil -- Sets globalClosestDoor to nil
bomb = nil -- Sets bomb to nil
vault = nil -- Sets vault to nil
hacking = nil -- Sets hacking to nil
camerasHacked = false -- Sets camerasHacked to false
damagedPed = false -- Sets damagedPed to false
cash = {} -- Creates a new table called cash
local status = 0 -- Sets status to 0

ReceptionPed = nil -- Sets ReceptionPed to nil
SecurityPed = nil -- Sets SecurityPed to nil
SecondSecurityPed = nil -- Sets SecondSecurityPed to nil
RandomPeds = { --Creates peds table 
    [1] = nil,
    [2] = nil,
    [3] = nil,
    [4] = nil,
    [5] = nil,
}

--defines the zones
local Pacific = PolyZone:Create({ --Creates polyzone for Pacific Bank
    vector2(232.71, 211.31),
    vector2(229.84, 218.54),
    vector2(250.70, 274.82),
    vector2(298.05, 258.32),
    vector2(275.69, 196.06)
}, {
    name = "Pacific", --Name of the polyzone
    debugGrid = false, --Debug grid
    maxZ = 115.61, --Max Z
    gridDivisions = 45 --Grid divisions
})

RegisterNetEvent("pacificBankRobbery:client:changeStatus") --Registering event for changing status
AddEventHandler("pacificBankRobbery:client:changeStatus", function(newStatus) --Event for changing status
    status = newStatus
end)


--starts the robbery
Citizen.CreateThread(function() --Creates thread
    while Config.UseLasers do --While Config.UseLasers is true
        Citizen.Wait(1000) --Wait 1000ms
        if(inPoly)then --If inPoly is true
            if(Config.PacificBank.vaultDoor.bombed)then --If Config.PacificBank.vaultDoor.bombed is true
                if not lasersInitiated then --If lasersInitiated is false
                    lasersInitiated = true --Set lasersInitiated to true
                    lasersToggler(true) --Run lasersToggler function with true as argument
                end
                Citizen.Wait(2000) --Wait 2000ms
            else
                if lasersInitiated then --If lasersInitiated is true
                    lasersInitiated = false --Set lasersInitiated to false
                    lasersToggler(false) --Run lasersToggler function with false as argument
                end
            end
        else
            if lasersInitiated then --If lasersInitiated is true
                lasersInitiated = false --Set lasersInitiated to false
                lasersToggler(false) --Run lasersToggler function with false as argument
            end
            Citizen.Wait(2000)
        end
    end
end)

Citizen.CreateThread(function() --starts thread that checks if player is in polyzone
    Citizen.Wait(2000)

    while true do --While true
        local plyPed = PlayerPedId() --Sets plyPed to PlayerPedId()
        local coord = GetPedBoneCoords(plyPed, HeadBone) --Sets coord to GetPedBoneCoords(plyPed, HeadBone)
        inPoly = Pacific:isPointInside(coord) --Sets inPoly to Pacific:isPointInside(coord)
        if inPoly and not insidePacific then --If inPoly is true and insidePacific is false
            insidePacific = true --Set insidePacific to true

            TriggerEvent("pacificBankRobbery:client:locker_markers") --Trigger event pacificBankRobbery:client:locker_markers
            TriggerEvent("pacificBankRobbery:client:vault") --Trigger event pacificBankRobbery:client:vault

            if first then --If first is true
                first = false --Set first to false
                TriggerEvent("pacificBankRobbery:client:pedHandler") --Trigger event pacificBankRobbery:client:pedHandler
                CreateSafe() --Run CreateSafe function
                CreateCash() --Run CreateCash function

                if(Config.UseLasers)then --If Config.UseLasers is true
                    initialiseLasers() --Run initialiseLasers function
                end
            end

            for i = 1, #Config.PacificBank.doors do --For i = 1, #Config.PacificBank.doors
                local closestDoor = GetClosestObjectOfType(Config.PacificBank.doors[i].objCoords.x, Config.PacificBank.doors[i].objCoords.y, Config.PacificBank.doors[i].objCoords.z, 1.0, Config.PacificBank.doors[i].objName, false, false, false) --Sets closestDoor to GetClosestObjectOfType(Config.PacificBank.doors[i].objCoords.x, Config.PacificBank.doors[i].objCoords.y, Config.PacificBank.doors[i].objCoords.z, 1.0, Config.PacificBank.doors[i].objName, false, false, false)

                if(Config.PacificBank.doors[i].destroyed)then --If Config.PacificBank.doors[i].destroyed is true
                    FreezeEntityPosition(closestDoor, false) --Freeze closestDoor position
                else --If Config.PacificBank.doors[i].destroyed is false
                    if(Config.PacificBank.doors[i].locked)then --If Config.PacificBank.doors[i].locked is true
                        FreezeEntityPosition(closestDoor, true) --Freeze closestDoor position
                    else --If Config.PacificBank.doors[i].locked is false
                        FreezeEntityPosition(closestDoor, false) --Freeze closestDoor position
                    end
                end
            end

            TriggerEvent("pacificBankRobbery:client:damagedPeds") --Trigger event pacificBankRobbery:client:damagedPeds

            if(Config.UseCopJob)then --If Config.UseCopJob is true
                print("Using cop job") --Prints "Using cop job"
                print(status) --Prints status
                if status == 1 then --If status is 1
                    print("Allowed") --Prints "Allowed"
                    allowedToOpen = false --Set allowedToOpen to false
                    allowedToOpen = true --Set allowedToOpen to true
                end


            end

            Citizen.CreateThread(function() --Creates thread that checks if player is in polyzone

                while inPoly do --While inPoly is true

                    local inRange = false --Sets inRange to false

                    if(not inRange)then --If inRange is false
                        if((#(globalPlayerCoords - Config.PacificBank.vaultDoor.vaultCoords) < 1.5) and not (Config.PacificBank.vaultDoor.hacked or Config.PacificBank.vaultDoor.bombed))then --If #(globalPlayerCoords - Config.PacificBank.vaultDoor.vaultCoords) is less than 1.5 and Config.PacificBank.vaultDoor.hacked or Config.PacificBank.vaultDoor.bombed is false

                            inRange = true --Set inRange to true

                            DrawText3D(Config.PacificBank.vaultDoor.bombLocation.x, Config.PacificBank.vaultDoor.bombLocation.y, Config.PacificBank.vaultDoor.bombLocation.z, "[E] Plant Bomb") --DrawText3D(Config.PacificBank.vaultDoor.bombLocation.x, Config.PacificBank.vaultDoor.bombLocation.y, Config.PacificBank.vaultDoor.bombLocation.z, "[E] Plant Bomb")

                            if IsControlJustPressed(1, Config.PlantBombButton) then --If IsControlJustPressed(1, Config.PlantBombButton) is true

                                Citizen.Wait(math.random(1,100)) --Wait math.random(1,100)ms

                                plantBomb() --Run plantBomb function

                            end

                        end
                    end

                    if(not inRange)then
                        if((#(globalPlayerCoords - Config.PacificBank.vaultDoor.hackCoords) < 1.5) and not (Config.PacificBank.vaultDoor.hacked or Config.PacificBank.vaultDoor.bombed))then --If #(globalPlayerCoords - Config.PacificBank.vaultDoor.hackCoords) is less than 1.5 and Config.PacificBank.vaultDoor.hacked or Config.PacificBank.vaultDoor.bombed is false

                            inRange = true

                            DrawText3D(Config.PacificBank.vaultDoor.hackCoords.x, Config.PacificBank.vaultDoor.hackCoords.y, Config.PacificBank.vaultDoor.hackCoords.z, "[E] Hack Panel") --DrawText3D(Config.PacificBank.vaultDoor.hackCoords.x, Config.PacificBank.vaultDoor.hackCoords.y, Config.PacificBank.vaultDoor.hackCoords.z, "[E] Hack Panel")

                            if IsControlJustPressed(1, Config.HackPanelButton) then 

                                Citizen.Wait(math.random(1,100))

                                hackPanel()

                            end

                        end
                    end

                    if(not inRange)then --If inRange is false

                        if(Config.UseCopJob)then --If Config.UseCopJob is true
                            if(#(globalPlayerCoords - Config.PacificBank.ResetBank) < 1.5 and Config.PacificBank.robbed)then --If #(globalPlayerCoords - Config.PacificBank.ResetBank) is less than 1.5 and Config.PacificBank.robbed is true

                                inRange = true --Set inRange to true

                                DrawText3D(Config.PacificBank.ResetBank.x, Config.PacificBank.ResetBank.y, Config.PacificBank.ResetBank.z, "[E] Reset Bank") --DrawText3D(Config.PacificBank.ResetBank.x, Config.PacificBank.ResetBank.y, Config.PacificBank.ResetBank.z, "[E] Reset Bank")

                                if IsControlJustPressed(1, Config.ResetButton) then --If IsControlJustPressed(1, Config.ResetButton) is true
                                    Citizen.Wait(math.random(1,1000)) --Wait math.random(1,1000)ms

                                    dict = "anim@mp_radio@garage@high" --Sets dict to "anim@mp_radio@garage@high"
                                    loadDict(dict) --Run loadDict function

                                    while(not HasAnimDictLoaded(dict) and globalPlayerPed == nil)do --While not HasAnimDictLoaded(dict) and globalPlayerPed is nil
                                        Citizen.Wait(100) --Wait 100ms
                                    end --End while loop

                                    TaskPlayAnim(globalPlayerPed, dict, "button_press", 3.0, -1, -1, 49, 0, false, false, false) --TaskPlayAnim(globalPlayerPed, dict, "button_press", 3.0, -1, -1, 49, 0, false, false, false)
                                    Citizen.Wait(850) --Wait 850ms
                                    ClearPedTasks(globalPlayerPed) --ClearPedTasks(globalPlayerPed)

                                    TriggerServerEvent("pacificBankRobbery:server:ResetBank") --Starts the padlock minigame.
                                end

                            end
                        end
                    end

                    if(not inRange)then
                        for i = 1, #Config.PacificBank.safes do --For i = 1, #Config.PacificBank.safes do
                            if(#(globalPlayerCoords - Config.PacificBank.safes[i].safeCoords) < 1.5)then --If #(globalPlayerCoords - Config.PacificBank.safes[i].safeCoords) is less than 1.5

                                inRange = true
                            --SEIFA KODS
                                if(policeCheck)then
                                    if(not safeboxing)then

                                        if(not Config.PacificBank.safes[i].opened and not Config.PacificBank.safes[i].busy)then --If Config.PacificBank.safes[i].opened and Config.PacificBank.safes[i].busy is false
                                            DrawText3D(Config.PacificBank.safes[i].safeCoords.x, Config.PacificBank.safes[i].safeCoords.y, Config.PacificBank.safes[i].safeCoords.z, "[E] Crack the safe") --DrawText3D(Config.PacificBank.safes[i].safeCoords.x, Config.PacificBank.safes[i].safeCoords.y, Config.PacificBank.safes[i].safeCoords.z, "[E] Crack the safe")

                                            if IsControlJustPressed(1, Config.CrackSafeButton) then --If IsControlJustPressed(1, Config.CrackSafeButton) is true
                                                Citizen.Wait(math.random(1,1000)) --Wait math.random(1,1000)ms
                                                Citizen.Wait(math.random(1,200)) --Wait math.random(1,200)ms
                                                if(not Config.PacificBank.safes[i].busy)then --If Config.PacificBank.safes[i].busy is false
                                                    safeboxing = true --Set safeboxing to true
                                                    TriggerServerEvent("pacificBankRobbery:server:busyState", "safe", i, true) --TriggerServerEvent("pacificBankRobbery:server:busyState", "safe", i, true)
                                                    TriggerEvent("pacific_safecracking:loop", i) --TriggerEvent("pacific_safecracking:loop", i)
                                                end
                                            end
                                        else
                                            DrawText3D(Config.PacificBank.safes[i].safeCoords.x, Config.PacificBank.safes[i].safeCoords.y, Config.PacificBank.safes[i].safeCoords.z, "Shit, the safebox has already been robbed")-- Prints about the safe box
                                        end
                                    end
                                else
                                    DrawText3D(Config.PacificBank.safes[i].safeCoords.x, Config.PacificBank.safes[i].safeCoords.y, Config.PacificBank.safes[i].safeCoords.z, 'Not enough cops in the city') --
                                end
                            end
                        end
                    end

                    if(not inRange)then
                        for i = 1, #Config.PacificBank.lockers do
                            if(#(globalPlayerCoords - Config.PacificBank.lockers[i].lockerCoords) < 0.5)then

                                inRange = true

                                local lockering = false

                                if(policeCheck)then
                                    if(not lockering)then
                                        if(not Config.PacificBank.lockers[i].opened and not Config.PacificBank.lockers[i].busy)then
                                            DrawText3D(Config.PacificBank.lockers[i].lockerCoords.x, Config.PacificBank.lockers[i].lockerCoords.y, Config.PacificBank.lockers[i].lockerCoords.z, "[E] Weld Locker") --

                                            if IsControlJustPressed(1, Config.BreakLockerButton) then --
                                                Citizen.Wait(math.random(1,1000))
                                                Citizen.Wait(math.random(1,200))
                                                if(not Config.PacificBank.lockers[i].busy)then
                                                    safeboxing = true
                                                    TriggerServerEvent("pacificBankRobbery:server:busyState", "locker", i, true)
                                                    breakLocker(i)
                                                end
                                            end
                                        else
                                            DrawText3D(Config.PacificBank.lockers[i].lockerCoords.x, Config.PacificBank.lockers[i].lockerCoords.y, Config.PacificBank.lockers[i].lockerCoords.z, "Shit, the locker has already been opened") --
                                        end
                                    end
                                else
                                    DrawText3D(Config.PacificBank.lockers[i].lockerCoords.x, Config.PacificBank.lockers[i].lockerCoords.y, Config.PacificBank.lockers[i].lockerCoords.z, Languages[Config.Language]['no_cops']) --
                                end
                            end
                        end
                    end
                --NAUDAS PAŅEMŠANA
                    if(not inRange)then
                        for i = 1, #Config.PacificBank.cash do
                            if(((#(globalPlayerCoords.xy - Config.PacificBank.cash[i].cashCoords.xy) < 0.70) and (globalPlayerCoords.z - Config.PacificBank.cash[i].cashCoords.z) < 2.00) and (not Config.PacificBank.cash[i].stolen))then
                                inRange = true

                                DrawText3D(Config.PacificBank.cash[i].cashCoords.x, Config.PacificBank.cash[i].cashCoords.y, Config.PacificBank.cash[i].cashCoords.z, "[E] Steal Cash") --

                                if IsControlJustPressed(1, Config.StealCashButton) then --
                                    stealCash(i)
                                end

                            end
                        end
                    end

                    if not inRange then
                        Citizen.Wait(500)
                    end

                    Citizen.Wait(4)
                end
            end)
        elseif not inPoly and insidePacific then
            insidePacific = false
            lasersToggler(false)
        end
        Citizen.Wait(500)
    end
end)

Citizen.CreateThread(function()

    while(globalPlayerId == nil)do
        Wait(100)
    end

    while(Config.PacificBank.robbed == nil)do --gets the info from the server

        TriggerServerEvent("pacificBankRobbery:server:randomKeyGen", GetPlayerServerId(globalPlayerId))

        TriggerServerEvent("pacificBankRobbery:server:PedsUpdate", GetPlayerServerId(globalPlayerId))

        TriggerServerEvent("pacificBankRobbery:server:stealableUpdate", GetPlayerServerId(globalPlayerId))

        TriggerServerEvent("pacificBankRobbery:server:doorsUpdate", GetPlayerServerId(globalPlayerId))

        TriggerServerEvent("pacificBankRobbery:server:AlarmState", GetPlayerServerId(globalPlayerId))

        TriggerServerEvent("pacificBankRobbery:server:robbed", GetPlayerServerId(globalPlayerId))

        TriggerServerEvent("pacificBankRobbery:server:policeCheck", GetPlayerServerId(globalPlayerId))

        Citizen.Wait(1000)
    end

    Citizen.CreateThread(function() --checks if the bank is robbed
        while true do
            Wait(3000)
            local callCops = false

            if(DoesEntityExist(ReceptionPed))then
                if(Config.PacificBank.mainReceptionEmployeeState)then
                    Wait(500)
                    if (IsPedDeadOrDying(ReceptionPed) and DoesEntityExist(ReceptionPed)) then
                        Wait(500)
                        if (IsPedDeadOrDying(ReceptionPed) and DoesEntityExist(ReceptionPed)) then
                            local deathSource, wep = NetworkGetEntityKillerOfPlayer(ReceptionPed)

                            if deathSource == -1 or deathSource == playerPed then
                                killer = PlayerId()
                            end

                            if deathSource == -1 or deathSource == globalPlayerPedId then
                                TriggerServerEvent('pacificBankRobbery:server:pedDead', "reception")
                                callCops = true
                            end
                        end
                    end
                end
            end

            if(DoesEntityExist(SecurityPed))then
                Wait(500)
                if(Config.PacificBank.mainSecurityGuardState)then
                    Wait(500)
                    if (IsPedDeadOrDying(SecurityPed) and DoesEntityExist(SecurityPed)) then
                        Wait(500)
                        if (IsPedDeadOrDying(SecurityPed) and DoesEntityExist(SecurityPed)) then
                            local deathSource, wep = NetworkGetEntityKillerOfPlayer(SecurityPed)

                            if deathSource == -1 or deathSource == playerPed then
                                killer = PlayerId()
                            end

                            if deathSource == -1 or deathSource == globalPlayerPedId then
                                TriggerServerEvent('pacificBankRobbery:server:pedDead', "guard")
                                callCops = true
                            end
                        end
                    end
                end
            end

            if(DoesEntityExist(SecondSecurityPed))then
                Wait(500)
                if(Config.PacificBank.secondSecurityGuardState)then
                    Wait(500)
                    if (IsPedDeadOrDying(SecondSecurityPed) and DoesEntityExist(SecondSecurityPed)) then
                        Wait(500)
                        if (IsPedDeadOrDying(SecondSecurityPed) and DoesEntityExist(SecondSecurityPed)) then
                            local deathSource, wep = NetworkGetEntityKillerOfPlayer(SecondSecurityPed)

                            if deathSource == -1 or deathSource == playerPed then
                                killer = PlayerId()
                            end

                            if deathSource == -1 or deathSource == globalPlayerPedId then
                                TriggerServerEvent('pacificBankRobbery:server:pedDead', "guard2")
                                callCops = true
                            end
                        end
                    end
                end
            end

            for i = 1, #Config.PacificBank.randomPeds do
                if(DoesEntityExist(RandomPeds[i]))then
                    if(Config.PacificBank.randomPeds[i].state)then
                        Wait(500)
                        if (IsPedDeadOrDying(RandomPeds[i]) and DoesEntityExist(RandomPeds[i])) then
                            Wait(500)
                            if (IsPedDeadOrDying(RandomPeds[i]) and DoesEntityExist(RandomPeds[i])) then
                                local deathSource, wep = NetworkGetEntityKillerOfPlayer(RandomPeds[i])

                                if deathSource == -1 or deathSource == playerPed then
                                    killer = PlayerId()
                                end

                                if deathSource == -1 or deathSource == globalPlayerPedId then
                                    TriggerServerEvent('pacificBankRobbery:server:pedDead', "randomPeds", i)
                                    callCops = true
                                end
                            end
                        end
                    end
                end
            end
        end
    end)

    Citizen.CreateThread(function() --creates a thread for the alarm
        while true do
            if(inPoly)then
                for i = 1, #Config.PacificBank.doors do
                    if(#(globalPlayerCoords - Config.PacificBank.doors[i].objCoords) <= 1.0)then
                        globalClosestDoor = i

                        local closestDoor = GetClosestObjectOfType(Config.PacificBank.doors[i].objCoords.x, Config.PacificBank.doors[i].objCoords.y, Config.PacificBank.doors[i].objCoords.z, 1.0, Config.PacificBank.doors[i].objName, false, false, false)

                        if(Config.PacificBank.doors[i].destroyed)then
                            FreezeEntityPosition(closestDoor, false)
                        else
                            if(Config.PacificBank.doors[i].locked)then
                                FreezeEntityPosition(closestDoor, true)
                            else
                                FreezeEntityPosition(closestDoor, false)
                            end
                        end

                        if(not Config.PacificBank.doors[i].destroyed)then
                            while(#(globalPlayerCoords - Config.PacificBank.doors[i].objCoords) <= 1.0 and not Config.PacificBank.doors[i].destroyed)do
                                if(allowedToOpen)then

                                    if(Config.PacificBank.doors[i].locked)then
                                        DrawText3D(Config.PacificBank.doors[i].objCoords.x, Config.PacificBank.doors[i].objCoords.y, Config.PacificBank.doors[i].objCoords.z, '[E] Locked')
                                    else
                                        DrawText3D(Config.PacificBank.doors[i].objCoords.x, Config.PacificBank.doors[i].objCoords.y, Config.PacificBank.doors[i].objCoords.z, '[E] Unlocked')
                                    end

                                    if IsControlJustPressed(1, Config.DoorButton) then --
                                        Citizen.Wait(math.random(1,100))
                                        TaskPlayAnim(globalPlayerPed, "anim@heists@keycard@", "exit", 3.0, -1, -1, 50, 0, false, false, false)
                                        TriggerServerEvent("pacificBankRobbery:server:toggleDoorLock", i)
                                        Citizen.Wait(1000)
                                        ClearPedTasks(globalPlayerPed)
                                    else
                                        FreezeEntityPosition(closestDoor, Config.PacificBank.doors[i]["locked"])
                                    end

                                else
                                    if(Config.PacificBank.doors[i].locked)then -- if the door is locked then it will display locked
                                        if(policeCheck)then
                                            if(Config.PacificBank.doors[i].type == "lockpick")then
                                                DrawText3D(Config.PacificBank.doors[i].objCoords.x, Config.PacificBank.doors[i].objCoords.y, Config.PacificBank.doors[i].objCoords.z, '[E] Lockpick Door')

                                                if IsControlJustPressed(1, Config.DoorButton) then --

                                                    if not robbing and not Config.PacificBank.robbed then
                                                        TriggerEvent("pacificBankRobbery:client:startRobbery")
                                                    end

                                                    Citizen.Wait(math.random(1,100))
                                                    LockpickAnim()
                                                    exports['ps-ui']:Circle(function(success)

                                                        if success then
                                                            print("Open door with id: " .. i .. " with lockpick. Nice Job")
                                                            TriggerServerEvent("pacificBankRobbery:server:breakDoor", i)
                                                        else
                                                            print("dummy u didnt do it")
                                                        end
                                                    end, math.random(4, 10), math.random(5, 20)) -- NumberOfCircles, MS


                                                end

                                            elseif(Config.PacificBank.doors[i].type == "thermite")then --if they use thermite then it will allow them to melt the door

                                                DrawText3D(Config.PacificBank.doors[i].objCoords.x, Config.PacificBank.doors[i].objCoords.y, Config.PacificBank.doors[i].objCoords.z, '[E] Melt Door')

                                                if IsControlJustPressed(1, Config.DoorButton) then --
                                                    Citizen.Wait(math.random(1,100))

                                                    if not robbing and not Config.PacificBank.robbed then
                                                        TriggerEvent("pacificBankRobbery:client:startRobbery")
                                                    end
                                                    exports['ps-ui']:Thermite(function(success)
                                                        if success then
                                                            meltDoor(i)
                                                            print("OI U UNLCOKED THE LUCKY DOOR NUMBER: " .. i)
                                                        else
                                                            print("YAY U DID IT , UR GREATER THAN NO ONE XD")
                                                        end
                                                    end, 20, 15, 3) -- Time, Gridsize (5, 6, 7, 8, 9, 10), IncorrectBlocks


                                                end
                                            end
                                        else
                                            DrawText3D(Config.PacificBank.doors[i].objCoords.x, Config.PacificBank.doors[i].objCoords.y, Config.PacificBank.doors[i].objCoords.z, Languages[Config.Language]['no_cops'])
                                        end
                                    else
                                        DrawText3D(Config.PacificBank.doors[i].objCoords.x, Config.PacificBank.doors[i].objCoords.y, Config.PacificBank.doors[i].objCoords.z, "Unlocked")
                                    end
                                end

                                Citizen.Wait(5)
                            end
                        else
                            FreezeEntityPosition(closestDoor, false)
                        end
                    else
                        Citizen.Wait(100)
                    end
                end
                Citizen.Wait(5)
            else
                Citizen.Wait(500)
            end
        end
    end)

    while true do
        Wait(5)
        local me = globalPlayerPedId
        if inPoly then
            if(not Config.PacificBank.robbed)then

                if globalIsPedArmed or damagedPed  then --

                    if globalIsPlayerFreeAiming or globalIsPedShooting == 1 or damagedPed then

                        if(DoesEntityExist(ReceptionPed))then

                            distance = #(globalPlayerCoords - Config.PacificBank.mainReceptionEmployeeCoords)

                            if(distance <= 25)then

                                if (HasEntityClearLosToEntityInFront(me, ReceptionPed, 19) or HasEntityClearLosToEntityInFront(me, SecurityPed, 19) or HasEntityClearLosToEntityInFront(me, SecondSecurityPed, 19)) and not IsPedDeadOrDying(ReceptionPed) then

                                    if(policeCheck)then

                                        if not robbing then
                                            TriggerEvent("pacificBankRobbery:client:startRobbery")
                                        end

                                    else
                                        DrawText3D(Config.PacificBank.mainReceptionEmployeeCoords.x, Config.PacificBank.mainReceptionEmployeeCoords.y, Config.PacificBank.mainReceptionEmployeeCoords.z, Languages[Config.Language]['no_cops'])
                                    end

                                else
                                    Citizen.Wait(100)
                                end
                            else
                                Citizen.Wait(100)
                            end
                        else
                            Citizen.Wait(100)
                        end
                    else
                        Citizen.Wait(100)
                    end
                else
                    Citizen.Wait(500)
                end
            else
                Citizen.Wait(1000)
            end
        else
            Citizen.Wait(1000)
        end
    end
end)

--Citizen.CreateThread(function() --blip
    --if(Config.UseBlips)then

       -- PacificBlip = AddBlipForCoord(Config.PacificBank.blip)

       --SetBlipSprite(PacificBlip, 278)
      --SetBlipScale(PacificBlip, 1.2)
        --SetBlipColour(PacificBlip, 43)

       -- SetBlipDisplay(PacificBlip, 4)
       -- SetBlipAsShortRange(PacificBlip, true)


      --  BeginTextCommandSetBlipName("STRING")
       -- AddTextComponentSubstringPlayerName("Central Pacific Bank")
       -- EndTextCommandSetBlipName(PacificBlip)
   -- end
--end)


local set = false
RegisterCommand("statusc", function()
    print("Status: ")
    if set == true then
        set = false
        TriggerEvent("pacificBankRobbery:client:changeStatus", 0)
        print("Status: Not Allowed")
    else
        set = true
        TriggerEvent("pacificBankRobbery:client:changeStatus", 1)
        print("Status: Allowed")
    end
end)

--1. first it defines the zones
--2. checks if it hasnt been robbed
--3. then it checks if the player is in the zone
--4. then it checks if the player is in the zone and if they are armed
--5. then checks if after robbery everything is done
--6. then ir resets the robbery
