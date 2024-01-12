PlayerData = {}
PlayerPed = nil
local firstSpawn = false

Citizen.CreateThread(function()
    while ESX == nil do
        ESX = Config.ESXTrigger()
        Citizen.Wait(0)
    end
    if #PlayerData == 0 then
        PlayerData = ESX.GetPlayerData()
    end
end)

Citizen.CreateThread(function ()
    while true do 
        PlayerPed = PlayerPedId()
        Citizen.Wait(1000)
    end 
end)

RegisterNetEvent(Config.Events["playerLoaded"])
AddEventHandler(Config.Events["playerLoaded"], function(xPlayer)
    Debug("xplayer loaded")
    PlayerData = xPlayer   
    Citizen.Wait(5000)
    local amount = 0
    TriggerServerEvent("Novel:Kevlar:SetPlayerKevlar", amount)
end)

RegisterNetEvent(Config.Events["setJob"])
AddEventHandler(Config.Events["setJob"], function(job)
    PlayerData.job = job
end)

RegisterNetEvent("Novel:Kevlar:SetClientKevlar")
AddEventHandler("Novel:Kevlar:SetClientKevlar", function (kevlar)
    if  #PlayerData == 0 or PlayerData.job == nil then
        PlayerData = ESX.GetPlayerData()
    end
    Debug(string.format("SetClientKevlar -> Kevlar: %s Ped: %s",kevlar, PlayerPed))
    if kevlar == "default" then
        SetKevlarSkin(kevlar, PlayerData.job.name)
        return
    end

    Config.Kevlar[kevlar].Animation(PlayerPed)
    SetKevlarSkin(kevlar, PlayerData.job.name)
end)

RegisterCommand(Config.Commands["Kevlar"], function (source, args, raw)
    TriggerServerEvent("Novel:Kevlar:UseKevlar")
end)

if Config.KeyKevlar.UseKey then
    RegisterKeyMapping(Config.Commands["Kevlar"], Config.Translation["KeyInfo"], 'keyboard', Config.KeyKevlar.DefaultKey)
end

TriggerEvent('chat:addSuggestion', "/"..Config.Commands["GiveKevlar"], 'Gives a player armour', {
    { name="id", help="the player id" },
    { name="armour", help="the count of armour 0-100" }
})

TriggerEvent('chat:addSuggestion', "/"..Config.Commands["GiveKevlarRadius"], 'Gives all players in a radius armour', {
    { name="radius", help="the radius" },
    { name="armour", help="the count of armour 0-100" }
})

TriggerEvent('chat:addSuggestion', "/"..Config.Commands["Kevlar"], 'Use the Kevlar from inventory')

