
Citizen.CreateThread(function() -- Starts new thread
    while true do -- While loop
        Citizen.Wait(60000) -- Wait 60 seconds
        collectgarbage("collect") -- Collect garbage 
    end 
end)

Citizen.CreateThread(function() -- Starts new thread

    globalPlayerPedId = PlayerPedId() -- Sets globalPlayerPedId to the current player's ped id
    globalPlayerPed = GetPlayerPed(-1) -- Sets globalPlayerPed to the current player's ped
    globalPlayerId = PlayerId() -- Sets globalPlayerId to the current player's id

    while true do -- While loop
        if(inPoly)then -- If inPoly is true
            globalPlayerPedId = PlayerPedId() -- Sets globalPlayerPedId to the current player's ped id
            globalPlayerId = PlayerId() -- Sets globalPlayerId to the current player's id
            Citizen.Wait(3000) -- Wait 3 seconds
        else
            globalPlayerPed = GetPlayerPed(-1) -- Sets globalPlayerPed to the current player's ped
            Citizen.Wait(100) -- Wait 1 second
        end
    end
end)
Citizen.CreateThread(function() -- Starts new thread

    globalIsPedArmed = IsPedArmed(globalPlayerPedId, 7) -- Sets globalIsPedArmed to the current player's ped armed status
    globalIsPedMeleeArmed = IsPedArmed(globalPlayerPedId, 1) -- Sets globalIsPedMeleeArmed to the current player's ped melee armed status
    globalIsPlayerFreeAiming = IsPlayerFreeAiming(globalPlayerId) -- Sets globalIsPlayerFreeAiming to the current player's free aiming status
    globalPlayerCoords = GetEntityCoords(globalPlayerPed) -- Sets globalPlayerCoords to the current player's ped coords

    while true do -- While loop
        if(inPoly)then -- If inPoly is true
            globalIsPedArmed = IsPedArmed(globalPlayerPedId, 7) -- Sets globalIsPedArmed to the current player's ped armed status
            globalIsPedMeleeArmed = IsPedArmed(globalPlayerPedId, 1) -- Sets globalIsPedMeleeArmed to the current player's ped melee armed status
            globalIsPlayerFreeAiming = IsPlayerFreeAiming(globalPlayerId) -- Sets globalIsPlayerFreeAiming to the current player's free aiming status
            globalPlayerCoords = GetEntityCoords(globalPlayerPed) -- Sets globalPlayerCoords to the current player's ped coords
            globalIsPedShooting = IsPedShooting(globalPlayerPed) -- Sets globalIsPedShooting to the current player's ped shooting status
        else
            globalPlayerCoords = GetEntityCoords(globalPlayerPed) -- Sets globalPlayerCoords to the current player's ped coords
        end
        Citizen.Wait(100) -- Wait 1 second
    end

end)


--1. The code begins by creating a new thread using the Citizen.CreateThread function.
--2. The first thread contains a while loop that runs indefinitely (while true do).
--3. Inside the loop, it waits for 60 seconds using Citizen.Wait(60000).
--4. After waiting, it calls collectgarbage("collect") to collect garbage and free up memory.
--5. The second thread is created with Citizen.CreateThread.
--6. It initializes some global variables related to the player's ped (character model) and ID.
--7. Similar to the first thread, this second thread contains a while loop.
--8. If the variable inPoly is true, it updates the global variables related to the player's ped and ID and then waits for 3 seconds.
--9. If inPoly is false, it updates only the global variable globalPlayerPed and waits for 1 second.
--10. The third thread is created with Citizen.CreateThread.
--11. It initializes global variables related to the player's ped armed status, melee armed status, free aiming status, and coordinates.
--12. Like the previous threads, this thread also has a while loop.
--13. If inPoly is true, it updates all the relevant global variables and also checks if the player's ped is shooting.
--14. If inPoly is false, it updates only the globalPlayerCoords variable.
--15. Finally, there's a Citizen.Wait(100) statement that pauses the execution of the thread for 1 second before the loop restarts.