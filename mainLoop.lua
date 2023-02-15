ped = nil
local objects = {}
robbing = false
lockpicking = false
safeboxing = false
currentStore = 0
copsCalled = false
serverKeyGen = 0
inPoly = false
first = true
canRob = true
allowedToOpen = false
globalClosestDoor = nil
bomb = nil
vault = nil
hacking = nil
camerasHacked = false
damagedPed = false
cash = {}
local status = 0

ReceptionPed = nil
SecurityPed = nil
SecondSecurityPed = nil
RandomPeds = {
    [1] = nil,
    [2] = nil,
    [3] = nil,
    [4] = nil,
    [5] = nil,
}


local Pacific = PolyZone:Create({
    vector2(232.71, 211.31),
    vector2(229.84, 218.54),
    vector2(250.70, 274.82),
    vector2(298.05, 258.32),
    vector2(275.69, 196.06)
}, {
    name = "Pacific",
    debugGrid = false,
    maxZ = 115.61,
    gridDivisions = 45
})

RegisterNetEvent("pacificBankRobbery:client:changeStatus")
AddEventHandler("pacificBankRobbery:client:changeStatus", function(newStatus)
    status = newStatus
end)



Citizen.CreateThread(function()
    while Config.UseLasers do
        Citizen.Wait(1000)
        if(inPoly)then
            if(Config.PacificBank.vaultDoor.bombed)then
                if not lasersInitiated then
                    lasersInitiated = true
                    lasersToggler(true)
                end
                Citizen.Wait(2000)
            else
                if lasersInitiated then
                    lasersInitiated = false
                    lasersToggler(false)
                end
            end
        else
            if lasersInitiated then
                lasersInitiated = false
                lasersToggler(false)
            end
            Citizen.Wait(2000)
        end
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(2000)

    while true do
        local plyPed = PlayerPedId()
        local coord = GetPedBoneCoords(plyPed, HeadBone)
        inPoly = Pacific:isPointInside(coord)
        if inPoly and not insidePacific then
            insidePacific = true

            TriggerEvent("pacificBankRobbery:client:locker_markers")
            TriggerEvent("pacificBankRobbery:client:vault")

            if first then
                first = false
                TriggerEvent("pacificBankRobbery:client:pedHandler")
                CreateSafe()
                CreateCash()

                if(Config.UseLasers)then
                    initialiseLasers()
                end
            end

            for i = 1, #Config.PacificBank.doors do
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
            end

            TriggerEvent("pacificBankRobbery:client:damagedPeds")

            if(Config.UseCopJob)then
                print("Using cop job")
                print(status)
                if status == 1 then
                    print("Allowed")
                    allowedToOpen = false
                    allowedToOpen = true
                end


            end

            Citizen.CreateThread(function()

                while inPoly do

                    local inRange = false

                    if(not inRange)then
                        if((#(globalPlayerCoords - Config.PacificBank.vaultDoor.vaultCoords) < 1.5) and not (Config.PacificBank.vaultDoor.hacked or Config.PacificBank.vaultDoor.bombed))then

                            inRange = true

                            DrawText3D(Config.PacificBank.vaultDoor.bombLocation.x, Config.PacificBank.vaultDoor.bombLocation.y, Config.PacificBank.vaultDoor.bombLocation.z, "[E] Plant Bomb") --Uzzīmē 3d tekstu lai var redzēt kur ir jāliek bumba

                            if IsControlJustPressed(1, Config.PlantBombButton) then --Ja poga ir uzspiesta, tad izmanto kodu apakšā

                                Citizen.Wait(math.random(1,100))

                                plantBomb()

                            end

                        end
                    end

                    if(not inRange)then
                        if((#(globalPlayerCoords - Config.PacificBank.vaultDoor.hackCoords) < 1.5) and not (Config.PacificBank.vaultDoor.hacked or Config.PacificBank.vaultDoor.bombed))then

                            inRange = true

                            DrawText3D(Config.PacificBank.vaultDoor.hackCoords.x, Config.PacificBank.vaultDoor.hackCoords.y, Config.PacificBank.vaultDoor.hackCoords.z, "[E] Hack Panel") --Uzzīmē 3d tekstu lai var redzēt kur ir jāhako

                            if IsControlJustPressed(1, Config.HackPanelButton) then --Ja poga ir uzspiesta, tad izmanto kodu apakšā

                                Citizen.Wait(math.random(1,100))

                                hackPanel()

                            end

                        end
                    end

                    if(not inRange)then

                        if(Config.UseCopJob)then
                            if(#(globalPlayerCoords - Config.PacificBank.ResetBank) < 1.5 and Config.PacificBank.robbed)then

                                inRange = true

                                DrawText3D(Config.PacificBank.ResetBank.x, Config.PacificBank.ResetBank.y, Config.PacificBank.ResetBank.z, "[E] Reset Bank") --Uzzīmē 3d tekstu lai var redzēt, kur var resetot pasu banku

                                if IsControlJustPressed(1, Config.ResetButton) then --Ja poga ir uzspiesta, tad izmanto kodu apakšā
                                    Citizen.Wait(math.random(1,1000))

                                    dict = "anim@mp_radio@garage@high"
                                    loadDict(dict)

                                    while(not HasAnimDictLoaded(dict) and globalPlayerPed == nil)do
                                        Citizen.Wait(100)
                                    end

                                    TaskPlayAnim(globalPlayerPed, dict, "button_press", 3.0, -1, -1, 49, 0, false, false, false)
                                    Citizen.Wait(850)
                                    ClearPedTasks(globalPlayerPed)

                                    TriggerServerEvent("pacificBankRobbery:server:ResetBank") --Starts the padlock minigame.
                                end

                            end
                        end
                    end

                    if(not inRange)then
                        for i = 1, #Config.PacificBank.safes do
                            if(#(globalPlayerCoords - Config.PacificBank.safes[i].safeCoords) < 1.5)then

                                inRange = true

                                if(policeCheck)then
                                    if(not safeboxing)then

                                        if(not Config.PacificBank.safes[i].opened and not Config.PacificBank.safes[i].busy)then
                                            DrawText3D(Config.PacificBank.safes[i].safeCoords.x, Config.PacificBank.safes[i].safeCoords.y, Config.PacificBank.safes[i].safeCoords.z, "[E] Crack the safe") --Uzzīmē 3d tekstu lai var redzēt kur var uzlauzt seifu

                                            if IsControlJustPressed(1, Config.CrackSafeButton) then --Ja poga ir uzspiesta, tad izmanto kodu apakšā
                                                Citizen.Wait(math.random(1,1000))
                                                Citizen.Wait(math.random(1,200))
                                                if(not Config.PacificBank.safes[i].busy)then
                                                    safeboxing = true
                                                    TriggerServerEvent("pacificBankRobbery:server:busyState", "safe", i, true)
                                                    TriggerEvent("pacific_safecracking:loop", i) -- Sāk seifa uzlaušanas minigame
                                                end
                                            end
                                        else
                                            DrawText3D(Config.PacificBank.safes[i].safeCoords.x, Config.PacificBank.safes[i].safeCoords.y, Config.PacificBank.safes[i].safeCoords.z, "Shit, the safebox has already been robbed") --Uzzīmē 3d tekstu lai pateiktu ka jau ir aplaupits seifs
                                        end
                                    end
                                else
                                    DrawText3D(Config.PacificBank.safes[i].safeCoords.x, Config.PacificBank.safes[i].safeCoords.y, Config.PacificBank.safes[i].safeCoords.z, 'Not enough cops in the city') --Uzzīme 3d tekstu lai pateiktu, ka vajag vairāk spelētāju policistu, lai varētu apzagt seifu
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
                                            DrawText3D(Config.PacificBank.lockers[i].lockerCoords.x, Config.PacificBank.lockers[i].lockerCoords.y, Config.PacificBank.lockers[i].lockerCoords.z, "[E] Weld Locker") --Uzzīmē 3d tekstu, lai varētu redzēt kur var uzlauzt skapīšus

                                            if IsControlJustPressed(1, Config.BreakLockerButton) then --Ja poga ir uzspiesta, tad izmanto kodu apakšā
                                                Citizen.Wait(math.random(1,1000))
                                                Citizen.Wait(math.random(1,200))
                                                if(not Config.PacificBank.lockers[i].busy)then
                                                    safeboxing = true
                                                    TriggerServerEvent("pacificBankRobbery:server:busyState", "locker", i, true)
                                                    breakLocker(i)
                                                end
                                            end
                                        else
                                            DrawText3D(Config.PacificBank.lockers[i].lockerCoords.x, Config.PacificBank.lockers[i].lockerCoords.y, Config.PacificBank.lockers[i].lockerCoords.z, "Shit, the locker has already been opened") --Uzzīmē 3d tekstu ja skapīts jau ir atlauzts vaļā
                                        end
                                    end
                                else
                                    DrawText3D(Config.PacificBank.lockers[i].lockerCoords.x, Config.PacificBank.lockers[i].lockerCoords.y, Config.PacificBank.lockers[i].lockerCoords.z, Languages[Config.Language]['no_cops']) --The draw 3d text for the safe.
                                end
                            end
                        end
                    end

                    if(not inRange)then
                        for i = 1, #Config.PacificBank.cash do
                            if(((#(globalPlayerCoords.xy - Config.PacificBank.cash[i].cashCoords.xy) < 0.70) and (globalPlayerCoords.z - Config.PacificBank.cash[i].cashCoords.z) < 2.00) and (not Config.PacificBank.cash[i].stolen))then
                                inRange = true

                                DrawText3D(Config.PacificBank.cash[i].cashCoords.x, Config.PacificBank.cash[i].cashCoords.y, Config.PacificBank.cash[i].cashCoords.z, "[E] Steal Cash") --Uzzīmē 3d tekstu, lai var redzēt kur var nozagt naudu

                                if IsControlJustPressed(1, Config.StealCashButton) then --Ja poga ir uzspiesta, tad izmanto kodu apakšā
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

    while(Config.PacificBank.robbed == nil)do --Pārliecināt ka mēs dabonam visus datus no servera

        TriggerServerEvent("pacificBankRobbery:server:randomKeyGen", GetPlayerServerId(globalPlayerId))

        TriggerServerEvent("pacificBankRobbery:server:PedsUpdate", GetPlayerServerId(globalPlayerId))

        TriggerServerEvent("pacificBankRobbery:server:stealableUpdate", GetPlayerServerId(globalPlayerId))

        TriggerServerEvent("pacificBankRobbery:server:doorsUpdate", GetPlayerServerId(globalPlayerId))

        TriggerServerEvent("pacificBankRobbery:server:AlarmState", GetPlayerServerId(globalPlayerId))

        TriggerServerEvent("pacificBankRobbery:server:robbed", GetPlayerServerId(globalPlayerId))

        TriggerServerEvent("pacificBankRobbery:server:policeCheck", GetPlayerServerId(globalPlayerId))

        Citizen.Wait(1000)
    end

    Citizen.CreateThread(function() --Pārbauda vai PEDs ir miris vai dzīvs.
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

    Citizen.CreateThread(function() -- Uzzīmē 3d tekstu, par to vai durvis ir Locked vai unlocked
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

                                    if IsControlJustPressed(1, Config.DoorButton) then --ja poga ir uzpiesta tad izmanto kodu apakšā
                                        Citizen.Wait(math.random(1,100))
                                        TaskPlayAnim(globalPlayerPed, "anim@heists@keycard@", "exit", 3.0, -1, -1, 50, 0, false, false, false)
                                        TriggerServerEvent("pacificBankRobbery:server:toggleDoorLock", i)
                                        Citizen.Wait(1000)
                                        ClearPedTasks(globalPlayerPed)
                                    else
                                        FreezeEntityPosition(closestDoor, Config.PacificBank.doors[i]["locked"])
                                    end

                                else
                                    if(Config.PacificBank.doors[i].locked)then
                                        if(policeCheck)then
                                            if(Config.PacificBank.doors[i].type == "lockpick")then
                                                DrawText3D(Config.PacificBank.doors[i].objCoords.x, Config.PacificBank.doors[i].objCoords.y, Config.PacificBank.doors[i].objCoords.z, '[E] Lockpick Door')

                                                if IsControlJustPressed(1, Config.DoorButton) then --ja poga ir uzpiesta tad izmanto kodu apakšā

                                                    if not robbing and not Config.PacificBank.robbed then
                                                        TriggerEvent("pacificBankRobbery:client:startRobbery")
                                                    end

                                                    Citizen.Wait(math.random(1,100))
                                                    LockpickAnim()
                                                    exports['ps-ui']:Circle(function(success)

                                                        if success then
                                                            print("Open door with id: " .. i .. " with lockpick. Nice Job You Dickhead")
                                                            TriggerServerEvent("pacificBankRobbery:server:breakDoor", i)
                                                        else
                                                            print("You are dumb fuckhead")
                                                        end
                                                    end, math.random(4, 10), math.random(5, 20)) -- NumberOfCircles, MS


                                                end

                                            elseif(Config.PacificBank.doors[i].type == "thermite")then

                                                DrawText3D(Config.PacificBank.doors[i].objCoords.x, Config.PacificBank.doors[i].objCoords.y, Config.PacificBank.doors[i].objCoords.z, '[E] Melt Door')

                                                if IsControlJustPressed(1, Config.DoorButton) then --ja poga ir uzpiesta tad izmanto kodu apakšā
                                                    Citizen.Wait(math.random(1,100))

                                                    if not robbing and not Config.PacificBank.robbed then
                                                        TriggerEvent("pacificBankRobbery:client:startRobbery")
                                                    end
                                                    exports['ps-ui']:Thermite(function(success)
                                                        if success then
                                                            meltDoor(i)
                                                            print("Fuck yeah dickhead you passed the door with id: " .. i)
                                                        else
                                                            print("Bor go fuck your self you fuckhead!")
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

                if globalIsPedArmed or damagedPed  then --Pārbauda vai PED ir armed. Pārbaude ir darīta no garbagecollector.lua priekš optimizācijas.

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

Citizen.CreateThread(function() --blip
    if(Config.UseBlips)then

        PacificBlip = AddBlipForCoord(Config.PacificBank.blip)

        SetBlipSprite(PacificBlip, 278)
        SetBlipScale(PacificBlip, 1.2)
        SetBlipColour(PacificBlip, 43)

        SetBlipDisplay(PacificBlip, 4)
        SetBlipAsShortRange(PacificBlip, true)


        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName("Central Pacific Bank")
        EndTextCommandSetBlipName(PacificBlip)
    end
end)


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
