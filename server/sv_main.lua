--  Luara ;#2547 | Yuval#6296 | https://discord.gg/3sqYyVjJ5J

QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

local users = {}
local players = {}
local callsignsData = {}

RegisterNetEvent('ys-activity:load')
AddEventHandler('ys-activity:load', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    users[src] = {id = src, grade = Player.PlayerData.job.grade.name, name = Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname}
end)

AddEventHandler('playerDropped', function()
    users[source] = nil
end)

RegisterNetEvent('ys-activity:getPlayers')
AddEventHandler('ys-activity:getPlayers', function()
    local src = source
    local data = {}
    local Player = QBCore.Functions.GetPlayer(src)
    users[src] = {grade = Player.PlayerData.job.grade.name, name = Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname}
    Wait(150)
    local cops = 0
    for k,v in pairs(users) do
        if Player.PlayerData.job.name == "police" then
            cops = cops + 1
        end
        table.insert(data, {name = v.name, grade = v.grade, count = cops, callsign = callsignsData[Player.PlayerData.citizenid] or "Unknown"})
    end

    TriggerClientEvent('ys-activity:open', src, data)
end)

RegisterServerEvent("ys-activity:setCallsign")
AddEventHandler("ys-activity:setCallsign", function(data)
    local Player = QBCore.Functions.GetPlayer(source)
    callsignsData[Player.PlayerData.citizenid] = data
    SaveResourceFile(GetCurrentResourceName(), "data.json", json.encode(callsignsData))
end)

CreateThread(function()
    Wait(50)
    local result = json.decode(LoadResourceFile(GetCurrentResourceName(), "data.json"))
    if result then
        callsignsData = result
    end
end)
