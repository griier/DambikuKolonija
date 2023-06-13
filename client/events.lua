RegisterNetEvent('pacificBankRobbery:client:randomKeyGen') --starts the random key generation
AddEventHandler('pacificBankRobbery:client:randomKeyGen', function(key) --adds the random key generation
    serverKeyGen = key --sets the server key generation to the key
end) --ends the random key generation

RegisterNetEvent('pacificBankRobbery:client:animator') --starts the animator
AddEventHandler('pacificBankRobbery:client:animator', function(type, dict, anim, speech) --adds the animator
    local ped = nil --sets the ped to nil
    if(type == "reception")then --if the type is reception
        ped = ReceptionPed --sets the ped to the reception ped
    end --ends the if statement

    if(ped ~= nil)then --if the ped is not nil
        if(DoesEntityExist(ped) and inPoly)then --if the entity exists and is in the poly
            ClearPedTasks(ped) --clears the ped tasks
            Citizen.Wait(300) --waits 300 seconds
            loadDict(dict) --loads the dict
            TaskPlayAnim(ped, dict, anim, 3.0, -1, -1, 50, 0, false, false, false) --plays the animation
            RemoveAnimDict(dict) --removes the animation dict

            if(speech)then --if speech is true
                Citizen.Wait(500) --waits 500 seconds
                PlayAmbientSpeech1(ped, "GUN_BEG", "SPEECH_PARAMS_FORCE_NORMAL_CLEAR") --plays the ambient speech
            end --ends the if statement

        end --ends the if statement
    end --ends the if statement
end) --ends the animator

RegisterNetEvent('pacificBankRobbery:client:PedsUpdate') --starts the ped update
AddEventHandler('pacificBankRobbery:client:PedsUpdate', function(mainReceptionEmployee, mainSecurityGuardWeapon, mainReceptionEmployeeState, mainSecurityGuard, mainSecurityGuardState, secondSecurityGuardWeapon, secondSecurityGuard, secondSecurityGuardState,  randomPeds) --adds the ped update
    Config.PacificBank.mainReceptionEmployee = mainReceptionEmployee --sets the main reception employee to the main reception employee
    Config.PacificBank.mainReceptionEmployeeState = mainReceptionEmployeeState --sets the main reception employee state to the main reception employee state
    Config.PacificBank.mainSecurityGuard = mainSecurityGuard --sets the main security guard to the main security guard
    Config.PacificBank.mainSecurityGuardWeapon = mainSecurityGuardWeapon --sets the main security guard weapon to the main security guard weapon
    Config.PacificBank.mainSecurityGuardState = mainSecurityGuardState --sets the main security guard state to the main security guard state
    
    Config.PacificBank.secondSecurityGuard = secondSecurityGuard --sets the second security guard to the second security guard
    Config.PacificBank.secondSecurityGuardWeapon = secondSecurityGuardWeapon
    Config.PacificBank.secondSecurityGuardState = secondSecurityGuardState --sets the second security guard state to the second security guard state

    for i = 1, #Config.PacificBank.randomPeds do --for loop for the random peds
        Config.PacificBank.randomPeds[i].ped = randomPeds[i].type --sets the random peds to the random peds
        Config.PacificBank.randomPeds[i].animation = randomPeds[i].animation --sets the random peds animation to the random peds animation
        Config.PacificBank.randomPeds[i].state = randomPeds[i].state  --sets the random peds state to the random peds state
    end

end)

RegisterNetEvent('pacificBankRobbery:client:robbed') --starts the robbed event
AddEventHandler('pacificBankRobbery:client:robbed', function(key) --adds the robbed event
    Config.PacificBank.robbed = key --sets the robbed to the key
end) --ends the robbed event

RegisterNetEvent('pacificBankRobbery:client:stealableUpdate') -- starts the stealable update
AddEventHandler('pacificBankRobbery:client:stealableUpdate', function(safes, lockers, cash) --adds the stealable update
    for v=1, #Config.PacificBank.safes do --config for the safes
        Config.PacificBank.safes[v].opened = safes[v].opened --sets the safes to opened state
        Config.PacificBank.safes[v].busy = safes[v].busy --sets the safes to busy state
    end

    for v=1, #Config.PacificBank.lockers do
        Config.PacificBank.lockers[v].opened = lockers[v].opened 
        Config.PacificBank.lockers[v].busy = lockers[v].busy
    end

    for v=1, #Config.PacificBank.cash do --
        Config.PacificBank.cash[v].stolen = cash[v].stolen
        Config.PacificBank.cash[v].busy = cash[v].busy
    end
end)

RegisterNetEvent('pacificBankRobbery:client:locker_markers') --starts the locker markers
AddEventHandler('pacificBankRobbery:client:locker_markers', function() --adds the locker markers
    while inPoly do

        local inRange = false

        for i = 1, #Config.PacificBank.lockers do --for loop for the lockers
            if(#(globalPlayerCoords - Config.PacificBank.lockers[i].lockerCoords) <= 5.0)then --if the player is within 5 meters of the locker
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

RegisterNetEvent('pacificBankRobbery:client:busyState') --starts the busy state
AddEventHandler('pacificBankRobbery:client:busyState', function(type, id, state) --adds the busy state event handler
    if(type == "safe")then
        Config.PacificBank.safes[id].busy = state 
    elseif(type == "locker")then 
        Config.PacificBank.lockers[id].busy = state 
    elseif(type == "cash")then
        Config.PacificBank.cash[id].busy = state
    end
end)

RegisterNetEvent('pacificBankRobbery:client:stealableOpen') --starts the stealable open event
AddEventHandler('pacificBankRobbery:client:stealableOpen', function(type, id) --adds the stealable open event handler
    if(type == "safe")then  
        Config.PacificBank.safes[id].opened = true  
    elseif(type == "locker")then
        Config.PacificBank.lockers[id].opened = true
    elseif(type == "cash")then
        Config.PacificBank.cash[id].stolen = true
    end
end)

RegisterNetEvent('pacificBankRobbery:client:vault') --starts the vault event
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

RegisterNetEvent('pacificBankRobbery:client:pedHandler') --starts the ped handler
AddEventHandler('pacificBankRobbery:client:pedHandler', function() --adds the ped handler
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

RegisterNetEvent('pacificBankRobbery:client:randomPedAnim') --starts the random ped animation
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

RegisterNetEvent('pacificBankRobbery:client:pedDead') --starts the ped dead event
AddEventHandler('pacificBankRobbery:client:pedDead', function(type, number)

    if(type == "reception")then
        Config.PacificBank.mainReceptionEmployeeState = false
        if(DoesEntityExist(ReceptionPed))then
            SetEntityHealth(ReceptionPed, 0)
        end
    elseif(type == "guard")then
        Config.PacificBank.mainSecurityGuardState = false
        if(DoesEntityExist(SecurityPed))then
            SetEntityHealth(SecurityPed, 0)
        end
    elseif(type == "guard2")then
        Config.PacificBank.secondSecurityGuardState = false
        if(DoesEntityExist(SecondSecurityPed))then
            SetEntityHealth(SecondSecurityPed, 0)
        end
    elseif(type == "randomPeds")then
        Config.PacificBank.randomPeds[number].state = false
        if(DoesEntityExist(RandomPeds[number]))then
            SetEntityHealth(RandomPeds[number], 0)
        end
    end

end)

RegisterNetEvent('pacificBankRobbery:client:doorsUpdate') --starts the doors update event
AddEventHandler('pacificBankRobbery:client:doorsUpdate', function(doors, vault)
    for i = 1, #Config.PacificBank.doors do
        Config.PacificBank.doors[i].locked = doors[i].locked
        Config.PacificBank.doors[i].destroyed = doors[i].destroyed
    end

    Config.PacificBank.vaultDoor.bombed = vault.bombed
    Config.PacificBank.vaultDoor.hacked = vault.hacked
end)

RegisterNetEvent('pacificBankRobbery:client:toggleDoorLock') --starts the toggle door lock event
AddEventHandler('pacificBankRobbery:client:toggleDoorLock', function(id, state)
    Config.PacificBank.doors[id].locked = state
    local closestDoor = GetClosestObjectOfType(Config.PacificBank.doors[id].objCoords.x, Config.PacificBank.doors[id].objCoords.y, Config.PacificBank.doors[id].objCoords.z, 1.0, Config.PacificBank.doors[id].objName, false, false, false)
                    
                    if(Config.PacificBank.doors[id].destroyed)then
                        FreezeEntityPosition(closestDoor, false)
                    else
                        if(Config.PacificBank.doors[id].locked)then
                            FreezeEntityPosition(closestDoor, true)
                        else
                            FreezeEntityPosition(closestDoor, false)
                        end
                    end

end)

RegisterNetEvent('pacificBankRobbery:client:breakDoor') --starts the break door event
AddEventHandler('pacificBankRobbery:client:breakDoor', function(id, state)
    Config.PacificBank.doors[id].destroyed = state

    local closestDoor = GetClosestObjectOfType(Config.PacificBank.doors[id].objCoords.x, Config.PacificBank.doors[id].objCoords.y, Config.PacificBank.doors[id].objCoords.z, 1.0, Config.PacificBank.doors[id].objName, false, false, false)
                    
                    if(Config.PacificBank.doors[id].destroyed)then
                        FreezeEntityPosition(closestDoor, false)
                    else
                        if(Config.PacificBank.doors[id].locked)then
                            FreezeEntityPosition(closestDoor, true)
                        else
                            FreezeEntityPosition(closestDoor, false)
                        end
                    end

end)

RegisterNetEvent('pacificBankRobbery:client:damagedPeds') --starts the damaged peds event
AddEventHandler('pacificBankRobbery:client:damagedPeds', function()
    while inPoly and not Config.PacificBank.robbed do
        if(DoesEntityExist(ReceptionPed))then
            Citizen.Wait(100)

            for i=1, #RandomPeds do 
                if(GetEntityMaxHealth(RandomPeds[i]) > GetEntityHealth(RandomPeds[i]))then
                    damagedPed = true
                end
            end

            if(GetEntityMaxHealth(SecurityPed) > GetEntityHealth(SecurityPed) or GetEntityMaxHealth(SecondSecurityPed) > GetEntityHealth(SecondSecurityPed))then
                damagedPed = true
            end
        else
            Citizen.Wait(1000)
        end
    end
end)

RegisterNetEvent('pacificBankRobbery:client:thermiteEffect') --starts the thermite effect event
AddEventHandler('pacificBankRobbery:client:thermiteEffect', function(id)
    Citizen.CreateThread(function()
        if inPoly then

            RequestNamedPtfxAsset("scr_ornate_heist")
        
            while not HasNamedPtfxAssetLoaded("scr_ornate_heist") do
                Citizen.Wait(10)
            end
            
            SetPtfxAssetNextCall("scr_ornate_heist")

            local effect = StartParticleFxLoopedAtCoord("scr_heist_ornate_thermal_burn", Config.PacificBank.doors[id].thermitefx, 0.0, 0.0, 0.0, 1.0, false, false, false, false)

            Citizen.CreateThread(function()

                local animating = false
        
                while effect ~= nil do
                    Citizen.Wait(100)
                    if(#(globalPlayerCoords - Config.PacificBank.doors[id].thermitefx) < 2.5)then
                        if(not animating)then
                            animating = true

                            while #(globalPlayerCoords - Config.PacificBank.doors[id].thermitefx) < 2.5 do
                                Citizen.Wait(100)
                                if not IsEntityPlayingAnim(globalPlayerPed, "anim@heists@ornate_bank@thermal_charge", "cover_eyes_loop" , 3) then
                                    TaskPlayAnim(globalPlayerPedId, "anim@heists@ornate_bank@thermal_charge", "cover_eyes_intro", 8.0, 8.0, 1000, 36, 1, 0, 0, 0)
                                    TaskPlayAnim(globalPlayerPedId, "anim@heists@ornate_bank@thermal_charge", "cover_eyes_loop", 8.0, 8.0, 3000, 49, 1, 0, 0, 0)
                                end
                            end

                        end
                    else
                        if(animating)then
                            ClearPedTasks(globalPlayerPedId)
                            animating = false
                        end
                    end
                end
        
            end)

            Citizen.Wait(30000)

            AddExplosion(Config.PacificBank.doors[id].thermitefx.x, Config.PacificBank.doors[id].thermitefx.y, Config.PacificBank.doors[id].thermitefx.z, 1, scale, true, false, 0)

            StopParticleFxLooped(effect, 0)
            effect = nil
            
        end
    end)
end)

RegisterNetEvent('pacificBankRobbery:client:fightBack') --starts the fight back event
AddEventHandler('pacificBankRobbery:client:fightBack', function(targeter)

    target = GetPlayerPed(GetPlayerFromServerId(targeter))

    Citizen.CreateThread(function()
        if(DoesEntityExist(SecurityPed) and DoesEntityExist(target))then
            
            SetFacialIdleAnimOverride(SecurityPed, "mood_angry_1")
            PlayAmbientSpeech1(SecurityPed, "Chat_State", "Speech_Params_Force")

            ClearPedTasks(SecurityPed)
            Citizen.Wait(500)

            TaskCombatPed(SecurityPed, target, 0, 16)
            TaskShootAtEntity(SecurityPed, target, 120000, 1)
            

            while((not IsPedDeadOrDying(target) and not IsPedDeadOrDying(SecurityPed)) or (GetEntityHealth(target) > GetEntityMaxHealth(target) - 100))do
                Citizen.Wait(200)
            end

            ClearPedTasks(SecurityPed)
        end
    end)

    Citizen.CreateThread(function() 
        if(DoesEntityExist(SecondSecurityPed) and DoesEntityExist(target))then
            
            SetFacialIdleAnimOverride(SecondSecurityPed, "mood_angry_1")
            PlayAmbientSpeech1(SecondSecurityPed, "Chat_State", "Speech_Params_Force")

            ClearPedTasks(SecondSecurityPed)
            Citizen.Wait(500)

            TaskCombatPed(SecondSecurityPed, target, 0, 16)
            TaskShootAtEntity(SecondSecurityPed, target, 120000, 1)
            

            while(not IsPedDeadOrDying(target) and not IsPedDeadOrDying(SecondSecurityPed))do
                Citizen.Wait(200)
            end

            ClearPedTasks(SecondSecurityPed)
        end
    end)
end)

RegisterNetEvent('pacificBankRobbery:client:pedsRun') --starts the peds run event
AddEventHandler('pacificBankRobbery:client:pedsRun', function(pedRun)

    for i = 1, #Config.PacificBank.randomPeds do
        if(DoesEntityExist(RandomPeds[i]) and not IsPedDeadOrDying(RandomPeds[i]))then

            Citizen.CreateThread(function()
                
                Citizen.Wait(math.random(500,2000))
                ClearPedTasksImmediately(RandomPeds[i])
                if(pedRun[i] > 50)then
                    PlayPain(RandomPeds[i], 7, 0, 0)
                    SetFacialIdleAnimOverride(RandomPeds[i], "shocked_1")

                    TaskGoStraightToCoord(RandomPeds[i], 262.84, 213.09, 106.28, 15.0, -1, 0.0, 0.0)
                    
                    local place = vector3(262.84, 213.09, 106.28)

                    while (#(GetEntityCoords(RandomPeds[i]) - place) > 0.5) and not IsPedDeadOrDying(RandomPeds[i]) do
                        Citizen.Wait(300)
                    end

                    TaskGoStraightToCoord(RandomPeds[i], 257.97, 199.29, 104.98, 15.0, -1, 0.0, 0.0)
                    
                    local place = vector3(257.97, 199.29, 104.98)

                    while (#(GetEntityCoords(RandomPeds[i]) - place) > 0.5) and not IsPedDeadOrDying(RandomPeds[i]) do
                        Citizen.Wait(300)
                    end

                    TaskGoStraightToCoord(RandomPeds[i], 362.29 + math.random(-20, 20), 67.67 + math.random(-20, 20),97.90, 15.0, -1, 0.0, 0.0)
                    Citizen.Wait(15000)
                    DeletePed(RandomPeds[i])
                else
                    PlayPain(RandomPeds[i], 6, 0, 0)
                    SetFacialIdleAnimOverride(RandomPeds[i], "shocked_1")

                    TaskGoStraightToCoord(RandomPeds[i], 243.45, 214.99, 106.29, 15.0, -1, 0.0, 0.0)
                    
                    local place = vector3(243.45, 214.99, 106.29)

                    while (#(GetEntityCoords(RandomPeds[i]) - place) > 0.5) and not IsPedDeadOrDying(RandomPeds[i]) do
                        Citizen.Wait(300)
                    end

                    TaskGoStraightToCoord(RandomPeds[i], 241.91, 212.16, 106.29, 15.0, -1, 0.0, 0.0)
                    
                    local place = vector3(241.91, 212.16, 106.29)

                    while (#(GetEntityCoords(RandomPeds[i]) - place) > 0.5) and not IsPedDeadOrDying(RandomPeds[i]) do
                        Citizen.Wait(300)
                    end

                    TaskGoStraightToCoord(RandomPeds[i], 233.79, 216.11, 106.29, 15.0, -1, 0.0, 0.0)
                    
                    local place = vector3(233.79, 216.11, 106.29)

                    while (#(GetEntityCoords(RandomPeds[i]) - place) > 0.5) and not IsPedDeadOrDying(RandomPeds[i]) do
                        Citizen.Wait(300)
                    end

                    TaskGoStraightToCoord(RandomPeds[i], 86.41 + math.random(-20, 20), 162.61 + math.random(-20, 20), 104.65, 15.0, -1, 0.0, 0.0)
                    Citizen.Wait(15000)
                    DeletePed(RandomPeds[i])
                end
            end)
        end
    end
end)

RegisterNetEvent('pacificBankRobbery:client:robbedToggler') --starts the robbed toggler event
AddEventHandler('pacificBankRobbery:client:robbedToggler', function(robbed)
    Config.PacificBank.robbed = robbed
    Config.PacificBank.AlarmState = robbed
end)

RegisterNetEvent('pacificBankRobbery:client:AlarmState') --starts the alarm state event
AddEventHandler('pacificBankRobbery:client:AlarmState', function(state)
    Config.PacificBank.AlarmState = state

end)

RegisterNetEvent('pacificBankRobbery:client:policeCheck') --starts the police check event
AddEventHandler('pacificBankRobbery:client:policeCheck', function(state)
    policeCheck = state
end)

RegisterNetEvent('pacificBankRobbery:client:vaultOpener') --starts the vault opener event
AddEventHandler('pacificBankRobbery:client:vaultOpener', function(type)

    if(type == "bomb")then

        Config.PacificBank.vaultDoor.bombed = true

        Citizen.Wait(15000)
    
        if inPoly then
            shaker = 8.00
        else
            local distance = #(globalPlayerCoords - Config.PacificBank.vaultDoor.vaultCoords)
            
            if(distance < 100)then
                shaker = 6.00
            elseif(distance < 150)then
                shaker = 4.00
            elseif(distance < 200)then
                shaker = 3.00
            elseif(distance < 250)then
                shaker = 2.00
            elseif(distance < 300)then
                shaker = 1.00
            else
                shaker = 0.00
            end

        end

        AddExplosion(Config.PacificBank.vaultDoor.bombLocation.x, Config.PacificBank.vaultDoor.bombLocation.y, Config.PacificBank.vaultDoor.bombLocation.z, 6, 50.00, true, false, shaker)

        if(bomb ~= nil)then
            DeleteObject(bomb)
        end

        if inPoly then
            TriggerEvent("pacificBankRobbery:client:vault")
        end

    elseif(type == "hack")then

        Config.PacificBank.vaultDoor.hacked = true
        if inPoly then
            TriggerEvent("pacificBankRobbery:client:vault")
        end

    end
end)

RegisterNetEvent('pacificBankRobbery:client:cashModel') --starts the cash model event
AddEventHandler('pacificBankRobbery:client:cashModel', function(i)
    if inPoly then
        cash[i] = CreateModelSwap(Config.PacificBank.cash[i].cashCoords.x, Config.PacificBank.cash[i].cashCoords.y, Config.PacificBank.cash[i].cashCoords.z, 5, `hei_prop_hei_cash_trolly_01`, `prop_gold_trolly`, 1)
    end
end)

RegisterNetEvent('pacificBankRobbery:client:startRobbery') --starts the robbery event
AddEventHandler('pacificBankRobbery:client:startRobbery', function()
    
    if(not Config.PacificBank.robbed)then
                                        
        robbing = true

        TriggerServerEvent("pacificBankRobbery:server:robbedToggler")

        TriggerServerEvent("pacificBankRobbery:server:fightBack", GetPlayerServerId(globalPlayerId))

        TriggerServerEvent("pacificBankRobbery:server:pedsRun")

        ClearPedTasks(ReceptionPed)
        PlayPain(ReceptionPed, 7, 0, 0)
        SetFacialIdleAnimOverride(ReceptionPed, "shocked_1")

        TriggerServerEvent("pacificBankRobbery:server:animator", "reception", "missheist_agency2ahands_up", "handsup_anxious")

        while (not IsPedDeadOrDying(SecurityPed) and  not IsPedDeadOrDying(SecondSecurityPed)) do
            Citizen.Wait(500)
        end

        while (not IsPedDeadOrDying(ReceptionPed) and inPoly) do
            if(globalIsPlayerFreeAiming)then
                
                Citizen.Wait(3000)
                TriggerServerEvent("pacificBankRobbery:server:animator", "reception", "random@mugging3", "handsup_standing_base", true)
                
                Citizen.Wait(2000)
                
                while Config.PacificBank.doors[1].locked do
                    pedCoords = GetEntityCoords(ReceptionPed)

                    distance = #(globalPlayerCoords - pedCoords)    

                    if(distance < 8.0)then
                        DrawText3D(pedCoords.x, pedCoords.y, pedCoords.z, "What do you want?")

                        if IsControlJustPressed(1, Config.SendReceptionToUnlockButton) then
                            TriggerServerEvent("pacificBankRobbery:server:receptionUnlock")
                            return
                        end
                        
                        if(Config.UsingSurveillanceSystem and not camerasHacked)then
                            DrawText3D(pedCoords.x, pedCoords.y, pedCoords.z-0.10, "[E] Unlock the door")

                            if IsControlJustPressed(1, Config.DisableCamerasButton) then
                                local timer = 0

                                TriggerServerEvent("pacificBankRobbery:server:animator", "reception", "anim@heists@prison_heiststation@cop_reactions", "cop_b_idle")
                                while(timer <= 5000 and not IsPedDeadOrDying(ReceptionPed))do
                                    

                                    DrawText3D(pedCoords.x, pedCoords.y, pedCoords.z, "Okay, okay. Wait.")
                                    DrawText3D(pedCoords.x, pedCoords.y, pedCoords.z-0.10, "Disabling cameras - " .. round(timer / 50, 1) .. "%")
                                    timer = timer + randomFloat(4.5, 8.2)
                                    Citizen.Wait(5)
                                end

                                if timer >= 5000 then
                                    camerasHacked = true
                                    if(not (Config.Reception[Config.PacificBank.mainReceptionEmployee].disableCamerasFakeChance > math.random(1,100)))then
                                        if(not IsPedDeadOrDying(ReceptionPed))then
                                            for k, v in pairs(Config.PacificBank.camera) do
                                                TriggerServerEvent("cameraSystem:server:updateState", v, false) 
                                            end
                                        end
                                    end
                                    TriggerServerEvent("pacificBankRobbery:server:animator", "reception", "random@mugging3", "handsup_standing_base", true)
                                end

                            end

                        else
                            DrawText3D(pedCoords.x, pedCoords.y, pedCoords.z-0.10, "[E] Unlock the door")
                        end
                    else
                        Citizen.Wait(250)
                    end

                    Citizen.Wait(4)
                end
            end
            Citizen.Wait(100)
        end
    end

end)


RegisterNetEvent('pacificBankRobbery:client:receptionUnlock') --starts the reception unlock event
AddEventHandler('pacificBankRobbery:client:receptionUnlock', function() --adds reception unlock event handler
    if inPoly and DoesEntityExist(ReceptionPed) then --
        TaskGoStraightToCoord(ReceptionPed, 256.96, 224.44, 106.29, 1.0, -1, 0.0, 0.0)

        local place = vector3(256.96, 224.44, 106.29)

        while (#(GetEntityCoords(ReceptionPed) - place) > 0.5) and not IsPedDeadOrDying(ReceptionPed) do
            Citizen.Wait(300)
        end

        TaskGoStraightToCoord(ReceptionPed, 257.32, 220.79, 106.29, 1.0, -1, 0.0, 0.0)

        local place = vector3(257.32, 220.79, 106.29)

        while (#(GetEntityCoords(ReceptionPed) - place) > 0.5) and not IsPedDeadOrDying(ReceptionPed) do
            Citizen.Wait(300)
        end 

        SetEntityHeading(ReceptionPed, 170.11)

        TriggerServerEvent("pacificBankRobbery:server:animator", "reception", "anim@heists@keycard@", "exit")

        if(Config.PacificBank.doors[1].locked)then
            TriggerServerEvent("pacificBankRobbery:server:toggleDoorLock", 1, false)
        end
        
        Citizen.Wait(1000)

        TriggerServerEvent("pacificBankRobbery:server:animator", "reception", "random@mugging3", "handsup_standing_base")

        TaskGoStraightToCoord(ReceptionPed, 256.61, 215.62, 106.29, 1.0, -1, 0.0, 0.0)

        local place = vector3(256.61, 215.62, 106.29)

        while (#(GetEntityCoords(ReceptionPed) - place) > 0.5) and not IsPedDeadOrDying(ReceptionPed) do
            Citizen.Wait(500)
            TaskGoStraightToCoord(ReceptionPed, 256.61, 215.62, 106.29, 1.0, -1, 0.0, 0.0)
        end 

        ClearPedTasks(ReceptionPed)
        PlayPain(ReceptionPed, 7, 0, 0)
        SetFacialIdleAnimOverride(ReceptionPed, "shocked_1")

        TaskGoStraightToCoord(ReceptionPed, 262.84, 213.09, 106.28, 15.0, -1, 0.0, 0.0)
        
        local place = vector3(262.84, 213.09, 106.28)

        while (#(GetEntityCoords(ReceptionPed) - place) > 0.5) and not IsPedDeadOrDying(ReceptionPed) do
            Citizen.Wait(300)
        end

        TaskGoStraightToCoord(ReceptionPed, 257.97, 199.29, 104.98, 15.0, -1, 0.0, 0.0)
        
        local place = vector3(257.97, 199.29, 104.98)

        while (#(GetEntityCoords(ReceptionPed) - place) > 0.5) and not IsPedDeadOrDying(ReceptionPed) do
            Citizen.Wait(300)
        end
    end
end)

RegisterNetEvent('pacificBankRobbery:client:teleport') --starts the teleport event
AddEventHandler('pacificBankRobbery:client:teleport', function() --adds teleport event handler
    
    if(inPoly)then
        DoScreenFadeOut(1000)
        Citizen.Wait(1000)
        SetEntityCoords(globalPlayerPed, 228.48, 213.54, 105.52, false, false, false, false)
        Citizen.Wait(1000)
        DoScreenFadeIn(1000)
    end

    Config.PacificBank.mainReceptionEmployeeState = true
    Config.PacificBank.mainSecurityGuardState = true
    Config.PacificBank.secondSecurityGuardState = true

    Config.PacificBank.robbed = false

    for i = 1, #Config.PacificBank.randomPeds do
        Config.PacificBank.randomPeds[i].state = true
    end
    
end)

