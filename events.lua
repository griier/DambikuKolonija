RegisterNetEvent('pacificBankRobbery:client:randomKeyGen') --Used for serverside protection, so peeps can't trigger money events.
AddEventHandler('pacificBankRobbery:client:randomKeyGen', function(key)
    serverKeyGen = key
end)

RegisterNetEvent('pacificBankRobbery:client:animator')
AddEventHandler('pacificBankRobbery:client:animator', function(type, dict, anim, speech)
    local ped = nil
    if(type == "reception")then
        ped = ReceptionPed
    end

    if(ped ~= nil)then
        if(DoesEntityExist(ped) and inPoly)then
            ClearPedTasks(ped)
            Citizen.Wait(300)
            loadDict(dict)
            TaskPlayAnim(ped, dict, anim, 3.0, -1, -1, 50, 0, false, false, false)
            RemoveAnimDict(dict)

            if(speech)then
                Citizen.Wait(500)
                PlayAmbientSpeech1(ped, "GUN_BEG", "SPEECH_PARAMS_FORCE_NORMAL_CLEAR")
            end

        end
    end
end)

RegisterNetEvent('pacificBankRobbery:client:PedsUpdate') --Fethches back the main ped data.
AddEventHandler('pacificBankRobbery:client:PedsUpdate', function(mainReceptionEmployee, mainSecurityGuardWeapon, mainReceptionEmployeeState, mainSecurityGuard, mainSecurityGuardState, secondSecurityGuardWeapon, secondSecurityGuard, secondSecurityGuardState,  randomPeds)
    Config.PacificBank.mainReceptionEmployee = mainReceptionEmployee
    Config.PacificBank.mainReceptionEmployeeState = mainReceptionEmployeeState
    Config.PacificBank.mainSecurityGuard = mainSecurityGuard
    Config.PacificBank.mainSecurityGuardWeapon = mainSecurityGuardWeapon
    Config.PacificBank.mainSecurityGuardState = mainSecurityGuardState
    
    Config.PacificBank.secondSecurityGuard = secondSecurityGuard
    Config.PacificBank.secondSecurityGuardWeapon = secondSecurityGuardWeapon
    Config.PacificBank.secondSecurityGuardState = secondSecurityGuardState

    for i = 1, #Config.PacificBank.randomPeds do
        Config.PacificBank.randomPeds[i].ped = randomPeds[i].type 
        Config.PacificBank.randomPeds[i].animation = randomPeds[i].animation
        Config.PacificBank.randomPeds[i].state = randomPeds[i].state
    end

end)

RegisterNetEvent('pacificBankRobbery:client:robbed') --Fetches if the bank has already been robbed.
AddEventHandler('pacificBankRobbery:client:robbed', function(key)
    Config.PacificBank.robbed = key
end)

RegisterNetEvent('pacificBankRobbery:client:stealableUpdate') --Fetches if the bank has already been robbed.
AddEventHandler('pacificBankRobbery:client:stealableUpdate', function(safes, lockers, cash)
    for v=1, #Config.PacificBank.safes do
        Config.PacificBank.safes[v].opened = safes[v].opened
        Config.PacificBank.safes[v].busy = safes[v].busy
    end

    for v=1, #Config.PacificBank.lockers do
        Config.PacificBank.lockers[v].opened = lockers[v].opened
        Config.PacificBank.lockers[v].busy = lockers[v].busy
    end

    for v=1, #Config.PacificBank.cash do
        Config.PacificBank.cash[v].stolen = cash[v].stolen
        Config.PacificBank.cash[v].busy = cash[v].busy
    end
end)

RegisterNetEvent('pacificBankRobbery:client:locker_markers')
AddEventHandler('pacificBankRobbery:client:locker_markers', function()
    while inPoly do

        local inRange = false

        for i = 1, #Config.PacificBank.lockers do
            if(#(globalPlayerCoords - Config.PacificBank.lockers[i].lockerCoords) <= 5.0)then
                inRange = true
                if not Config.PacificBank.lockers[i].busy and not Config.PacificBank.lockers[i].opened then
                    DrawMarker(2, Config.PacificBank.lockers[i].lockerCoords.x, Config.PacificBank.lockers[i].lockerCoords.y, Config.PacificBank.lockers[i].lockerCoords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                end
            end
        end

        if not inRange then
            Citizen.Wait(500)
        end

        Citizen.Wait(10)
    end
end)

RegisterNetEvent('pacificBankRobbery:client:busyState')
AddEventHandler('pacificBankRobbery:client:busyState', function(type, id, state)
    if(type == "safe")then
        Config.PacificBank.safes[id].busy = state
    elseif(type == "locker")then
        Config.PacificBank.lockers[id].busy = state
    elseif(type == "cash")then
        Config.PacificBank.cash[id].busy = state
    end
end)

RegisterNetEvent('pacificBankRobbery:client:stealableOpen')
AddEventHandler('pacificBankRobbery:client:stealableOpen', function(type, id)
    if(type == "safe")then
        Config.PacificBank.safes[id].opened = true
    elseif(type == "locker")then
        Config.PacificBank.lockers[id].opened = true
    elseif(type == "cash")then
        Config.PacificBank.cash[id].stolen = true
    end
end)

RegisterNetEvent('pacificBankRobbery:client:vault')
AddEventHandler('pacificBankRobbery:client:vault', function()
    vault = GetClosestObjectOfType(Config.PacificBank.vaultDoor.vaultCoords.x, Config.PacificBank.vaultDoor.vaultCoords.y, Config.PacificBank.vaultDoor.vaultCoords.z, 20.0, Config.PacificBank.vaultDoor.vaultObject, false, false, false)
    local vaultHeading = Config.PacificBank.vaultDoor.vaultHeading.closed

    if(vault ~= 0)then
        FreezeEntityPosition(vault, true)
        if(Config.PacificBank.vaultDoor.bombed or Config.PacificBank.vaultDoor.hacked)then
            if(Config.PacificBank.vaultDoor.bombed)then
                FreezeEntityPosition(vault, false)
                SetEntityCoords(vault, 0, 0, 0, false, false, false, false)
            elseif(Config.PacificBank.vaultDoor.hacked)then
                FreezeEntityPosition(vault, false)
                Citizen.CreateThread(function()
                    while vaultHeading > Config.PacificBank.vaultDoor.vaultHeading.open do
        
                        vaultHeading = vaultHeading - 0.05
                        SetEntityHeading(vault, vaultHeading - 1)
        
                        Citizen.Wait(10)
                    end
                end)
                
            end
        else
            SetEntityHeading(vault, Config.PacificBank.vaultDoor.vaultHeading.closed)
        end
    end
end)

RegisterNetEvent('pacificBankRobbery:client:pedHandler')
AddEventHandler('pacificBankRobbery:client:pedHandler', function()
        while true do
            Citizen.Wait(100)
                if(inPoly)then
                    if(not DoesEntityExist(SecondSecurityPed))then
                        if(not Config.PacificBank.robbed)then
                            ReceptionPed = _CreatePed(Config.Reception[Config.PacificBank.mainReceptionEmployee].model, Config.PacificBank.mainReceptionEmployeeCoords, Config.PacificBank.mainReceptionEmployeeHeading)
                            loadDict("anim@heists@prison_heiststation@cop_reactions")

                            TaskPlayAnim(ReceptionPed, "anim@heists@prison_heiststation@cop_reactions", "cop_b_idle", 3.0, -1, -1, 49, 0, false, false, false)
                            RemoveAnimDict("anim@heists@prison_heiststation@cop_reactions")
                        end

                        SecurityPed = _CreatePed(Config.SecurityPeds[Config.PacificBank.mainSecurityGuard].model, Config.PacificBank.mainSecurityGuardCoords, Config.PacificBank.mainSecurityGuardHeading)
                        SecondSecurityPed = _CreatePed(Config.SecurityPeds[Config.PacificBank.secondSecurityGuard].model, Config.PacificBank.secondSecurityGuardCoords, Config.PacificBank.secondSecurityGuardHeading)

                        GiveWeaponToPed(SecurityPed, Config.PacificBank.mainSecurityGuardWeapon, math.random(20, 100), true, false)
                        SetCurrentPedWeapon(SecurityPed, Config.PacificBank.mainSecurityGuardWeapon, true)
                        SetPedArmour(SecurityPed, 100)
                        SetEntityHealth(SecurityPed, 200)
                        SetPedSuffersCriticalHits(SecurityPed, false)

                        GiveWeaponToPed(SecondSecurityPed, Config.PacificBank.secondSecurityGuardWeapon, math.random(20, 100), true, false)
                        SetCurrentPedWeapon(SecondSecurityPed, Config.PacificBank.secondSecurityGuardWeapon, true)
                        SetPedArmour(SecondSecurityPed, 100)
                        SetEntityHealth(SecondSecurityPed, 200)
                        SetPedSuffersCriticalHits(SecondSecurityPed, false)

                        if(not Config.PacificBank.robbed)then
                            for i = 1, #Config.PacificBank.randomPeds do
                                RandomPeds[i] = _CreatePed(Config.RandomPeds[Config.PacificBank.randomPeds[i].ped].model, Config.PacificBank.randomPeds[i].coords, Config.PacificBank.randomPeds[i].heading)
                                TriggerEvent('pacificBankRobbery:client:randomPedAnim', i)
                            end
                        end
                        
                        if(not  Config.PacificBank.mainReceptionEmployeeState)then
                            SetEntityHealth(ReceptionPed, 0)
                        end

                        if(not  Config.PacificBank.mainSecurityGuardState)then
                            SetEntityHealth(SecurityPed, 0)
                        end

                        if(not  Config.PacificBank.secondSecurityGuardState)then
                            SetEntityHealth(SecondSecurityPed, 0)
                        end

                        for i = 1, #Config.PacificBank.randomPeds do
                            if(not  Config.PacificBank.randomPeds[i].state)then
                                SetEntityHealth(RandomPeds[i], 0)
                            end
                        end
                    end
                else
                    if(DoesEntityExist(SecondSecurityPed))then
                        DeletePed(ReceptionPed)
                        DeletePed(SecurityPed)
                        DeletePed(SecondSecurityPed)
                        for i = 1, #Config.PacificBank.randomPeds do
                            DeletePed(RandomPeds[i])
                        end

                    end
                    Citizen.Wait(500)
                end
        end
end)

RegisterNetEvent('pacificBankRobbery:client:randomPedAnim') --Plays the animations for the random peds.
AddEventHandler('pacificBankRobbery:client:randomPedAnim', function(pedNumber)
    Citizen.Wait(500)
    local animtype = Config.RandomAnimations[Config.PacificBank.randomPeds[pedNumber].animation].type
    local prop = nil
    local model = nil
    local dict = nil
    local anim = nil

    if(animtype == "phone")then

        model = -1038739674
        dict = "cellphone@"
        anim = "cellphone_text_in"
        loadDict(dict)
        TaskPlayAnim(RandomPeds[pedNumber], dict, anim, 3.0, -1, -1, 50, 0, false, false, false)

        modeler(model, pedNumber)

    elseif(animtype == "calling")then

        model = -1038739674
        dict = "cellphone@"
        anim = "cellphone_text_to_call"
        loadDict(dict)
        TaskPlayAnim(RandomPeds[pedNumber], dict, anim, 3.0, -1, -1, 50, 0, false, false, false)

        modeler(model, pedNumber)
    elseif(animtype == "crossarms-angry")then

        dict = "amb@world_human_hang_out_street@male_c@idle_a"
        anim = "idle_b"
        loadDict(dict)
        TaskPlayAnim(RandomPeds[pedNumber], dict, anim, 3.0, -1, -1, 49, 0, false, false, false)

    elseif(animtype == "crossarms")then

        dict = "random@street_race"
        anim = "_car_b_lookout"
        loadDict(dict)
        TaskPlayAnim(RandomPeds[pedNumber], dict, anim, 3.0, -1, -1, 49, 0, false, false, false)

    elseif(animtype == "facepalm")then

        dict = "anim@mp_player_intupperface_palm"
        anim = "idle_a"
        loadDict(dict)
        TaskPlayAnim(RandomPeds[pedNumber], dict, anim, 3.0, -1, -1, 49, 0, false, false, false)

    elseif(animtype == "fallasleep")then

        dict = "mp_sleep"
        anim = "sleep_loop"
        loadDict(dict)
        TaskPlayAnim(RandomPeds[pedNumber], dict, anim, 3.0, -1, -1, 49, 0, false, false, false)

    elseif(animtype == "guard")then

        TaskStartScenarioInPlace(RandomPeds[pedNumber], "WORLD_HUMAN_GUARD_STAND", 0, true)

    elseif(animtype == "idle")then

        dict = "anim@heists@heist_corona@team_idles@male_a"
        anim = "idle"
        loadDict(dict)
        TaskPlayAnim(RandomPeds[pedNumber], dict, anim, 3.0, -1, -1, 49, 0, false, false, false)

    elseif(animtype == "idle2")then

        dict = "anim@heists@heist_corona@team_idles@female_a"
        anim = "idle"
        loadDict(dict)
        TaskPlayAnim(RandomPeds[pedNumber], dict, anim, 3.0, -1, -1, 49, 0, false, false, false)

    elseif(animtype == "idle3")then
 
        dict = "anim@heists@humane_labs@finale@strip_club"
        anim = "ped_b_celebrate_loop"
        loadDict(dict)
        TaskPlayAnim(RandomPeds[pedNumber], dict, anim, 3.0, -1, -1, 49, 0, false, false, false)

    elseif(animtype == "inspect")then

        dict = "random@train_tracks"
        anim = "idle_e"
        loadDict(dict)
        TaskPlayAnim(RandomPeds[pedNumber], dict, anim, 3.0, -1, -1, 49, 0, false, false, false)

    elseif(animtype == "knucklecrunch")then

        dict = "anim@mp_player_intcelebrationfemale@knuckle_crunch"
        anim = "knuckle_crunch"
        loadDict(dict)
        TaskPlayAnim(RandomPeds[pedNumber], dict, anim, 3.0, -1, -1, 49, 0, false, false, false)

    elseif(animtype == "lookout")then

        TaskStartScenarioInPlace(RandomPeds[pedNumber], "CODE_HUMAN_CROSS_ROAD_WAIT", 0, true)

    end 

    if(dict ~= nil)then
        RemoveAnimDict(dict)
    end
        
end)
