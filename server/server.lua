local ESX = nil

ESX = Config.ESXTrigger()

while ESX == nil do
    Wait(100)
end

local scriptName = 'Novel_Kevlar_V2'
Citizen.CreateThread(function()
    local convarValue = GetConvar("Novel", "")
    if convarValue == '' then
        SetConvarServerInfo("Novel", scriptName)
    else
        if not string.find(convarValue, scriptName) then
            SetConvarServerInfo("Novel", convarValue .. ", " .. scriptName)
        end
    end
end)

AddEventHandler('onResourceStop', function()
    local convarValue = GetConvar("Novel", "")
    if string.find(convarValue, scriptName) then
        SetConvarServerInfo("Novel", scriptName:gsub(scriptName, ""):gsub(', ,', ''))
    end
    SaveAllPlayers()
end)

AddEventHandler('playerDropped', function (reason)
    local _source = source
    local identifier = GetPlayerLicense(_source, "license")
    SavePlayerKevlar(identifier, GetPedArmour(GetPlayerPed(_source)))
end)

RegisterServerEvent("Novel:Kevlar:SetPlayerKevlar")
AddEventHandler("Novel:Kevlar:SetPlayerKevlar", function (fake)
    local _source = source
    if fake ~= 0 then
        TriggerEvent(Config.Events["BanTrigger"], _source)
        print(string.format("^8 CHEATER FOUND!!! PLAYER %s TRIGGERD SetPlayerKevlar WITH VALUE identifier -> %s ^7", _source, GetPlayerLicense(_source, "license")))
        return
    end
    local amount = GetPlayerKevlar(_source)
    Debug(string.format("set ped armour -> PlayerId: %s Armour: %s", _source, amount))
    SetPedArmour(GetPlayerPed(_source), amount)
    if amount > 0 then
        TriggerClientEvent("Novel:Kevlar:SetClientKevlar",_source,  Config.Loader.AutoloadKevlarName) -- animation and skin trigger
    end
end)

for _, v in pairs(Config.Kevlar) do
    Debug("register usable item -> ".. tostring(_))
    local item = tostring(_)
    ESX.RegisterUsableItem(item, function(source)
       local xPlayer = ESX.GetPlayerFromId(source)
       if IsAllowedJob(item, xPlayer.job.name) == false then
            Config.Notify(source, Config.Translation["YouAreNotAllowed"])
            return
       end
       xPlayer.removeInventoryItem(item, 1) --remove item from player
       SetPedArmour(GetPlayerPed(source), v.Kevlar)
       TriggerClientEvent("Novel:Kevlar:SetClientKevlar",source, item) -- animation and skin trigger
       Config.Notify(source, Config.Translation["YouGotKevlar"]) --notification to client
    end)
end

if Config.Loader.AutoSave and Config.Loader.AutoSaveInterval > 0 then
    Citizen.CreateThread(function ()
        while true do 
            Citizen.Wait(Config.Loader.AutoSaveInterval)
            Debug("------ start kevlar autosave ------")
            SaveAllPlayers()
            Debug("------ autosave end ------")
        end 
    end)
end

RegisterServerEvent("Novel:Kevlar:UseKevlar")
AddEventHandler("Novel:Kevlar:UseKevlar", function ()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local kevlar = GetBestKevlar(xPlayer.getInventory())
    if kevlar == 0 then
        Config.Notify(_source, string.format(Config.Translation["NotEnoughItem"]))
        return
    end
    xPlayer.removeInventoryItem(kevlar.name, 1)
    Config.Notify(_source, string.format(Config.Translation["YouGotKevlar"]))
    SetPedArmour(GetPlayerPed(_source), kevlar.item.Kevlar)
    TriggerClientEvent("Novel:Kevlar:SetClientKevlar",_source, kevlar.name)
end)

RegisterCommand(Config.Commands["GiveKevlar"], function (source, args, raw)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if IsAllowed(xPlayer.getGroup()) == false then
        Config.Notify(source, Config.Translation["NoPermission"])
        return
    end
    if #args == 0 or #args < 2 or IsStringNullOrEmpty(args[1]) or IsStringNullOrEmpty(args[2]) then
        Config.Notify(source, Config.Translation["MissingArgsForCommand"])
        return
    end

    local playerId = tonumber(args[1])
    local armour = tonumber(args[2])

    if IsPlayerOnline(playerId) == false then
        Config.Notify(source, string.format(Config.Translation["PlayerIsOffline"], playerId))
        return
    end

    SetPlayerKevlar(playerId, armour)
    TriggerClientEvent("Novel:Kevlar:SetClientKevlar",playerId, Config.Loader.AutoloadKevlarName)
end)

RegisterCommand(Config.Commands["GiveKevlarRadius"], function (source, args, raw)
    local xPlayer = ESX.GetPlayerFromId(source)
    if IsAllowed(xPlayer.getGroup()) == false then
        Config.Notify(source, Config.Translation["NoPermission"])
        return
    end
    if #args == 0 or #args < 2 or IsStringNullOrEmpty(args[1]) or IsStringNullOrEmpty(args[2]) then
        Config.Notify(source, Config.Translation["MissingArgsForCommand"])
        return
    end

    local players = GetPlayers()
    local aCoords = GetEntityCoords(GetPlayerPed(source))
    local radius = tonumber(args[1])
    local armour = tonumber(args[2])
    for i = 1, #players, 1 do 
        local ped = GetPlayerPed(players[i])
        local pCoords = GetEntityCoords(ped)
        if #(aCoords - pCoords) < radius then
            SetPlayerKevlar(players[i], armour, true)
            if armour > 0 then
                TriggerClientEvent("Novel:Kevlar:SetClientKevlar", players[i], Config.Loader.AutoloadKevlarName)
            end
        end
    end
end)


