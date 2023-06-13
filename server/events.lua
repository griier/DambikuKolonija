
RegisterServerEvent('pacificBankRobbery:server:randomKeyGen') -- Starts the randomkey generation
AddEventHandler('pacificBankRobbery:server:randomKeyGen', function(source) -- add randomkey generation event handler
    TriggerClientEvent('pacificBankRobbery:client:randomKeyGen', source, randomKeyGen) -- trigger the client event
end)

RegisterServerEvent('pacificBankRobbery:server:AlarmState') -- Starts the alarm state
AddEventHandler('pacificBankRobbery:server:AlarmState', function(source) --add alarm state event handler
    TriggerClientEvent('pacificBankRobbery:client:AlarmState', source, alarmState)
end)

RegisterServerEvent('pacificBankRobbery:server:policeCheck') -- Starts the police check
AddEventHandler('pacificBankRobbery:server:policeCheck', function(source) -- add police check event handler
    TriggerClientEvent('pacificBankRobbery:client:policeCheck', source, policeCheck)
end)

RegisterServerEvent('pacificBankRobbery:server:globalAlarmState') -- Starts the global alarm state
AddEventHandler('pacificBankRobbery:server:globalAlarmState', function(source) -- add global alarm state event handler
    alarmState = false
    TriggerClientEvent('pacificBankRobbery:client:AlarmState', -1, alarmState) 
end)

RegisterServerEvent('pacificBankRobbery:server:PedsUpdate') -- this is to make sure the peds are loaded before the event is triggered
AddEventHandler('pacificBankRobbery:server:PedsUpdate', function(source)
    while checker do 
        checker = false
        if(mainReceptionEmployee == nil)then 
            checker = true 
        end
        Citizen.Wait(100)
    end

    TriggerClientEvent('pacificBankRobbery:client:PedsUpdate', source, mainReceptionEmployee, mainSecurityGuardWeapon, mainReceptionEmployeeState, mainSecurityGuard, mainSecurityGuardState, secondSecurityGuardWeapon, secondSecurityGuard, secondSecurityGuardState,  randomPeds)
end) 

RegisterServerEvent('pacificBankRobbery:server:robbed') -- Starts the robbed event
AddEventHandler('pacificBankRobbery:server:robbed', function(source)
    TriggerClientEvent('pacificBankRobbery:client:robbedToggler', source, robbed)
end)

RegisterServerEvent('pacificBankRobbery:server:animator') -- Starts the animator event
AddEventHandler('pacificBankRobbery:server:animator', function(type, dict, anim, speech)
    TriggerClientEvent('pacificBankRobbery:client:animator', -1, type, dict, anim, speech)
end)

RegisterServerEvent('pacificBankRobbery:server:stealableUpdate') -- Starts the stealable update event
AddEventHandler('pacificBankRobbery:server:stealableUpdate', function(source)
    TriggerClientEvent('pacificBankRobbery:client:stealableUpdate', source, safes, lockers, cash)
end)

RegisterServerEvent('pacificBankRobbery:server:doorsUpdate') -- Starts the doors update event
AddEventHandler('pacificBankRobbery:server:doorsUpdate', function(source)
    TriggerClientEvent('pacificBankRobbery:client:doorsUpdate', source, doors, vault)
end)

RegisterServerEvent('pacificBankRobbery:server:receptionUnlock') -- Starts the reception unlock event
AddEventHandler('pacificBankRobbery:server:receptionUnlock', function(source)
    TriggerClientEvent('pacificBankRobbery:client:receptionUnlock', -1)
end)

RegisterServerEvent('pacificBankRobbery:server:vaultOpener') -- Starts the vault opener event
AddEventHandler('pacificBankRobbery:server:vaultOpener', function(type)
    if(type == "bomb")then -- if the type is bomb then set the vault to bombed and trigger the client event
        vault.bombed = true 
        TriggerClientEvent("pacificBankRobbery:client:vaultOpener", -1, type)
    elseif(type == "hack")then -- if the type is hack then set the vault to hacked and trigger the client event
        vault.hacked = true
        TriggerClientEvent("pacificBankRobbery:client:vaultOpener", -1, type)
    end
end)

RegisterServerEvent('pacificBankRobbery:server:toggleDoorLock') -- Starts the toggle door lock event
AddEventHandler('pacificBankRobbery:server:toggleDoorLock', function(id, statino)

    if(statino ~= nil)then 
        doors[id].locked = statino
    else
        doors[id].locked = not doors[id].locked
    end

    TriggerClientEvent('pacificBankRobbery:client:toggleDoorLock', -1, id, doors[id].locked)
end)

RegisterServerEvent('pacificBankRobbery:server:breakDoor') -- Starts the break door event
AddEventHandler('pacificBankRobbery:server:breakDoor', function(id)
    doors[id].destroyed = true
    TriggerClientEvent('pacificBankRobbery:client:breakDoor', -1, id, doors[id].destroyed)
end)

RegisterServerEvent('pacificBankRobbery:server:thermiteEffect') -- Starts the thermite effect event
AddEventHandler('pacificBankRobbery:server:thermiteEffect', function(id)
    TriggerClientEvent('pacificBankRobbery:client:thermiteEffect', -1, id)
end)

RegisterServerEvent('pacificBankRobbery:server:busyState') -- Starts the busy state event
AddEventHandler('pacificBankRobbery:server:busyState', function(type, id, state)
    if(type == "safe")then
        safes[id].busy = state
        TriggerClientEvent("pacificBankRobbery:client:busyState", -1, type, id, state)
    elseif(type == "locker")then
        lockers[id].busy = state
        TriggerClientEvent("pacificBankRobbery:client:busyState", -1, type, id, state)
    elseif(type == "cash")then
        cash[id].busy = state
        TriggerClientEvent("pacificBankRobbery:client:busyState", -1, type, id, state)
    end
end)

RegisterServerEvent('pacificBankRobbery:server:stealableOpen') -- Starts the stealable open event
AddEventHandler('pacificBankRobbery:server:stealableOpen', function(source, type, id, password)
    if(password ~= nil)then
        if(password == randomKeyGen)then
            local randomAmount = nil

            if(type == "safe")then

                if(not safes[id].opened)then
                    safes[id].opened = true
                    randomAmount = math.random(Config.PacificBank.safes[id].safeMoney[1], Config.PacificBank.safes[id].safeMoney[2])
                    TriggerClientEvent("pacificBankRobbery:client:stealableOpen", -1, type, id)
                    print("Yes this is Server Event!")
                else
                    DropPlayer(source, 'Pacific: Abusing Safe')
                    randomAmount = 0  
                end

            elseif(type == "locker")then

                if(not lockers[id].opened)then
                    lockers[id].opened = true
                    randomAmount = math.random(Config.PacificBank.lockers[id].lockerMoney[1], Config.PacificBank.lockers[id].lockerMoney[2])
                    TriggerClientEvent("pacificBankRobbery:client:stealableOpen", -1, type, id)
                    print("Yes this is Server Event!")
                else
                    DropPlayer(source, 'Pacific: Abusing Lockers')
                    randomAmount = 0  
                end

            elseif(type == "cash")then

                if(not cash[id].stolen)then
                    cash[id].stolen = true
                    randomAmount = math.random(Config.PacificBank.cash[id].cashMoney[1], Config.PacificBank.cash[id].cashMoney[2])
                    TriggerClientEvent("pacificBankRobbery:client:stealableOpen", -1, type, id)
                    TriggerClientEvent("pacificBankRobbery:client:cashModel", -1, id)
                else
                    DropPlayer(source, 'Pacific: Abusing Cash')
                    randomAmount = 0  
                end

            end

                print(randomAmount)
                
        else
            DropPlayer(source, 'Cheating')  
        end
    else
        DropPlayer(source, 'Cheating')  
    end

end)

RegisterServerEvent('pacificBankRobbery:server:robbedToggler') -- Starts the robbed toggler event
AddEventHandler('pacificBankRobbery:server:robbedToggler', function()

    robbed = true
    alarmState = true

    TriggerClientEvent('pacificBankRobbery:client:robbedToggler', -1, robbed)

    local second = 1000
    local minute = 60 * second
    local hour = 60 * minute
    local cooldown = Config.PacificBank.cooldown
    local wait = cooldown.hour * hour + cooldown.minute * minute + cooldown.second * second
    Citizen.CreateThread(function()
        Wait(wait)
        TriggerEvent("pacificBankRobbery:server:ResetBank")
    end)

end)

RegisterServerEvent('pacificBankRobbery:server:pedDead')
AddEventHandler('pacificBankRobbery:server:pedDead', function(type, number)
    local second = 1000
    local minute = 60 * second
    local hour = 60 * minute
    local cooldown = Config.PacificBank.cooldown
    local wait = cooldown.hour * hour + cooldown.minute * minute + cooldown.second * second

    if(type == "reception")then
        if(mainReceptionEmployeeState)then -- if the mainReceptionEmployeeState is true then set it to false and wait for the cooldown to end
            mainReceptionEmployeeState = false
            Citizen.CreateThread(function()
                Wait(wait)
                    mainReceptionEmployeeState = true
                    mainSecurityGuardState = true
                    secondSecurityGuardState = true
                    for i = 1, #Config.PacificBank.randomPeds do
                        randomPeds[i].state = true
                    end
                    TriggerClientEvent('pacificBankRobbery:client:reset', -1)
            end)
        end
    elseif(type == "guard")then -- if the mainSecurityGuardState is true then set it to false and wait for the cooldown to end
        if(mainSecurityGuardState)then
            mainSecurityGuardState = false
            Citizen.CreateThread(function()
                Wait(wait)
                    mainReceptionEmployeeState = true
                    mainSecurityGuardState = true
                    secondSecurityGuardState = true
                    for i = 1, #Config.PacificBank.randomPeds do
                        randomPeds[i].state = true
                    end
                    TriggerClientEvent('pacificBankRobbery:client:reset', -1)
            end)
        end
    elseif(type == "guard2")then -- if the secondSecurityGuardState is true then set it to false and wait for the cooldown to end
        if(secondSecurityGuardState)then
            secondSecurityGuardState = false
            Citizen.CreateThread(function()
                Wait(wait)
                    mainReceptionEmployeeState = true
                    mainSecurityGuardState = true
                    secondSecurityGuardState = true
                    for i = 1, #Config.PacificBank.randomPeds do
                        randomPeds[i].state = true
                    end
                    TriggerClientEvent('pacificBankRobbery:client:reset', -1)
            end)
        end
    elseif(type == "randomPeds")then -- if the randomPeds[number].state is true then set it to false and wait for the cooldown to end
        if(randomPeds[number].state)then
            randomPeds[number].state = false
            Citizen.CreateThread(function()
                Wait(wait)
                    mainReceptionEmployeeState = true
                    mainSecurityGuardState = true
                    secondSecurityGuardState = true
                    for i = 1, #Config.PacificBank.randomPeds do
                        randomPeds[i].state = true
                    end
                    TriggerClientEvent('pacificBankRobbery:client:reset', -1)
            end)
        end
    end

    TriggerClientEvent('pacificBankRobbery:client:pedDead', -1, type, number)
end)

RegisterServerEvent('pacificBankRobbery:server:fightBack') -- Starts the fight back event
AddEventHandler('pacificBankRobbery:server:fightBack', function(ped)
    TriggerClientEvent('pacificBankRobbery:client:fightBack', -1, ped)
end)

RegisterServerEvent('pacificBankRobbery:server:pedsRun') -- Starts the peds run event
AddEventHandler('pacificBankRobbery:server:pedsRun', function(ped)
    local pedRun = {}

    for i = 1, #Config.PacificBank.randomPeds do
        pedRun[i] = math.random(1,100)
    end

    TriggerClientEvent('pacificBankRobbery:client:pedsRun', -1, pedRun)
end)

RegisterNetEvent('pacificBankRobbery:server:ResetBank') -- Starts the reset bank event
AddEventHandler('pacificBankRobbery:server:ResetBank', function()
    
    TriggerClientEvent("pacificBankRobbery:client:teleport", -1)
    Citizen.Wait(1000)
    alarmState = false

    mainReceptionEmployee = math.random(1, #Config.Reception)
    mainReceptionEmployeeState = true
    
    mainSecurityGuard = math.random(1, #Config.SecurityPeds)
    mainSecurityGuardWeapon = Config.SecurityPeds[mainSecurityGuard].Weapons[math.random(1, #Config.SecurityPeds[mainSecurityGuard].Weapons)]
    mainSecurityGuardState = true

    secondSecurityGuard = math.random(1, #Config.SecurityPeds)
    secondSecurityGuardWeapon = Config.SecurityPeds[secondSecurityGuard].Weapons[math.random(1, #Config.SecurityPeds[secondSecurityGuard].Weapons)]
    secondSecurityGuardState = true

    for i = 1, #Config.PacificBank.randomPeds do -- this is to make sure the random peds are loaded before the event is triggered

        local notfinished = true

        while notfinished do
        
            local number =  math.random(1, #Config.RandomPeds)

            if(not Config.RandomPeds[number].isUsed)then
                randomPeds[i].type = number
                Config.RandomPeds[number].isUsed = true
                notfinished = false
            else
                notfinished = true
            end
            Citizen.Wait(0)
        end

        notfinished = true

        while notfinished do
        
            local number =  math.random(1, #Config.RandomAnimations)

            if(not Config.RandomAnimations[number].isUsed)then
                randomPeds[i].animation = number
                Config.RandomAnimations[number].isUsed = true
                notfinished = false
            else
                notfinished = true
            end
            Citizen.Wait(0)
        end

        randomPeds[i].state = true
    end

    for i = 1, #Config.PacificBank.doors do
        doors[i].locked = true
        doors[i].destroyed = false
    end
    

    for v=1, #Config.PacificBank.safes do
        safes[v].opened = false
        safes[v].busy = false
    end

    for v=1, #Config.PacificBank.lockers do
        lockers[v].opened = false
        lockers[v].busy = false
    end

    for v=1, #Config.PacificBank.cash do
        cash[v].stolen = false
        cash[v].busy = false
    end

    vault.bombed = false
    vault.hacked = false

    robbed = false
    alarmState = false

    Citizen.Wait(1500)

    TriggerClientEvent('pacificBankRobbery:client:PedsUpdate', -1, mainReceptionEmployee, mainSecurityGuardWeapon, mainReceptionEmployeeState, mainSecurityGuard, mainSecurityGuardState, secondSecurityGuardWeapon, secondSecurityGuard, secondSecurityGuardState,  randomPeds)

    TriggerClientEvent('pacificBankRobbery:client:stealableUpdate', -1, safes, lockers, cash)

    TriggerClientEvent('pacificBankRobbery:client:doorsUpdate', -1, doors, vault)

    TriggerClientEvent('pacificBankRobbery:client:AlarmState', -1, alarmState)

    TriggerClientEvent('pacificBankRobbery:client:robbedToggler', -1, robbed)

end)

RegisterNetEvent('pacificBankRobbery:server:removeItem') -- Starts the remove item event
AddEventHandler('pacificBankRobbery:server:removeItem', function(type, source, password)
    if(password ~= nil)then
        if(password == randomKeyGen)then

            local item = nil

            if(type == "melt")then
                item = "thermite"
            elseif(type == "bomb")then
                item = "c4"
            elseif(type == "hack")then
                item = "electronickit"
            end

            if(item ~= nil)then
                print(GetPlayerName(source) .. 'Pacific Bank Robbery - Used ' .. item .. "need to remove item from inventory")
            else
                print(GetPlayerName(source) .. 'Pacific Bank Robbery - Cheating')
            end
        else
            print(GetPlayerName(source) .. 'Pacific Bank Robbery - Cheating')
        end
    else
        print(GetPlayerName(source) .. 'Pacific Bank Robbery - Cheating') 
    end
end)