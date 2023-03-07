mainReceptionEmployee = nil
mainReceptionEmployeeState = nil

mainSecurityGuard = nil
mainSecurityGuardState = nil
mainSecurityGuardWeapon = nil

alarmState = nil

randomPeds = {
    [1] = {
        type = nil,
        animimation = nil,
        state = nil,
    },
    [2] = {
        type = nil,
        animimation = nil,
        state = nil,
    },
    [3] = {
        type = nil,
        animimation = nil,
        state = nil,
    },
    [4] = {
        type = nil,
        animimation = nil,
        state = nil,
    },
    [5] = {
        type = nil,
        animimation = nil,
        state = nil,
    },
}

doors = {
    [1] = {
        locked = nil,
        destroyed = nil,
    },
    [2] = {
        locked = nil,
        destroyed = nil,
    },
    [3] = {
        locked = nil,
        destroyed = nil,
    },
    [4] = {
        locked = nil,
        destroyed = nil,
    },
    [5] = {
        locked = nil,
        destroyed = nil,
    },
    [6] = {
        locked = nil,
        destroyed = nil,
    },
    [7] = {
        locked = nil,
        destroyed = nil,
    },
    [8] = {
        locked = nil,
        destroyed = nil,
    },
    [9] = {
        locked = nil,
        destroyed = nil,
    },
    [10] = {
        locked = nil,
        destroyed = nil,
    },
}

safes = {
    [1] = {
        opened = nil,
        busy = nil
    },
    [2] = {
        opened = nil,
        busy = nil
    }
}

lockers = {
    [1] = {
        opened = nil,
        busy = nil
    },
    [2] = {
        opened = nil,
        busy = nil
    },
    [3] = {
        opened = nil,
        busy = nil
    },
    [4] = {
        opened = nil,
        busy = nil
    },
    [5] = {
        opened = nil,
        busy = nil
    },
    [6] = {
        opened = nil,
        busy = nil
    },
    [7] = {
        opened = nil,
        busy = nil
    },
    [8] = {
        opened = nil,
        busy = nil
    },
    [9] = {
        opened = nil,
        busy = nil
    },
    [10] = {
        opened = nil,
        busy = nil
    }
}

cash = {
    [1] = {
        stolen = nil,
        busy = nil
    },
    [2] = {
        stolen = nil,
        busy = nil
    },
    [3] = {
        stolen = nil,
        busy = nil
    },
}

vault = {
    bombed = nil,
    hacked = nil,
}

robbed = nil

coreFinished = false

randomKeyGen = math.random(100000000,999999999)

Citizen.CreateThread(function()

            alarmState = false

            mainReceptionEmployee = math.random(1, #Config.Reception)
            mainReceptionEmployeeState = true
            
            mainSecurityGuard = math.random(1, #Config.SecurityPeds)
            mainSecurityGuardWeapon = Config.SecurityPeds[mainSecurityGuard].Weapons[math.random(1, #Config.SecurityPeds[mainSecurityGuard].Weapons)]
            mainSecurityGuardState = true

            secondSecurityGuard = math.random(1, #Config.SecurityPeds)
            secondSecurityGuardWeapon = Config.SecurityPeds[secondSecurityGuard].Weapons[math.random(1, #Config.SecurityPeds[secondSecurityGuard].Weapons)]
            secondSecurityGuardState = true

            for i = 1, #Config.PacificBank.randomPeds do

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
            policeCheck = CheckCops()

end)

Citizen.CreateThread(function()
    while true do

        while not coreFinished do
            Citizen.Wait(100)
        end

        policeCheck = CheckCops()
        TriggerClientEvent("pacificBankRobbery:client:policeCheck", -1, policeCheck)
        Citizen.Wait(30000)
    end

end)

function CheckCops() --Checks the current cops online.
    if(Config.UseCopJob)then
        local cops = 10 --Sets current cops to 0 to do the check.
            --add police check here!!!
        print("add police check here!!!")

        if(cops >= Config.PacificBank.copsNeeded)then --Checks if there are enough cops online.
            return true
        else
            return false
        end
    else
        return true --Returns true if you don't need a cop job. Feel free to do whatever the fuck you want here.
    end
end