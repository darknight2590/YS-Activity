-- Luara ;#2547 | Yuval#6296 | https://discord.gg/3sqYyVjJ5J

QBCore = nil
local PlayerData = {}
isLoggedIn = true

Citizen.CreateThread(function()
    while QBCore == nil do
        TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
        Citizen.Wait(500)
    end

    while QBCore.Functions.GetPlayerData().job == nil do
        Citizen.Wait(100)
    end

    Citizen.Wait(800)
    PlayerData = QBCore.Functions.GetPlayerData()
end)

RegisterNetEvent("QBCore:Client:OnPlayerLoaded")
AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
    isLoggedIn = true
    PlayerData = QBCore.Functions.GetPlayerData()
end)

RegisterNetEvent("QBCore:Client:OnPlayerUnload")
AddEventHandler("QBCore:Client:OnPlayerUnload", function()
    SendNUIMessage({type = 'forceclose'})
    SetNuiFocus(false, false)
    isLoggedIn = false
    PlayerData = {}
end)

RegisterNetEvent("QBCore:Client:OnJobUpdate")
AddEventHandler("QBCore:Client:OnJobUpdate", function(Job)
   PlayerData.job = Job
end)

local cops = 0
RegisterNetEvent('ys-activity:open')
AddEventHandler('ys-activity:open', function(users)
    SendNUIMessage({type = 'refresh', users = users})
    cops = users.count
end)

Citizen.CreateThread(function()
    Citizen.Wait(100)
    TriggerServerEvent('ys-activity:load')
end)

local running = false
RegisterCommand("mokdan", function()
    Wait(200)
    if running then
        running = false
        SendNUIMessage({type = 'mainclose'})
    else
        running = true
        TriggerServerEvent('ys-activity:getPlayers')
    end
end)

RegisterNUICallback("toggle", function(data)
    Wait(200)
    if not data.toggle then
        running = true
        TriggerServerEvent('ys-activity:getPlayers')
    else
        running = false
        SendNUIMessage({type = 'mainclose'})
    end
end)

Citizen.CreateThread(function()
    Wait(500)
    while true do
        if isLoggedIn then
            if running then
                TriggerServerEvent('ys-activity:getPlayers')
            else
                SendNUIMessage({type = 'mainclose'})
            end
        else
            Wait(2800)
        end
        Wait(4000)
    end
end)

RegisterCommand("settings", function()
    if isLoggedIn then
        SendNUIMessage({type = 'settings'})
        SetNuiFocus(true, true)
    end
end)

RegisterNUICallback("settingsclose", function()
    SetNuiFocus(false, false)
end)

RegisterNUICallback("callsign", function(data)
    TriggerServerEvent('ys-activity:setCallsign', data.callsign)
end)