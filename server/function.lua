function Debug(msg)
    if Config.Debug == false then 
        return
    end
    print(msg)
end

function SavePlayerKevlar(identifier, amount)
    if IsStringNullOrEmpty(identifier) then 
        Debug(string.format("player kevlar could be updated -> IsStringNullOrEmpty: true identifier: %s", tostring(identifier)))
        return
    end
    local changed = MySQL.Sync.execute("UPDATE `users` SET `kevlar` = @amount WHERE `identifier` = @identifier LIMIT 1",{
        	["@identifier"] = identifier,
            ["@amount"] = amount
    })

    if changed then
        Debug(string.format("player kevlar updated -> identifier: %s amount: %s", identifier, amount))
    else
        Debug(string.format("player kevlar could be updated -> identifier: %s amount: %s", identifier, amount))
    end
end



function SaveAllPlayers()
    local players = ESX.GetPlayers()
    for i = 1, #players, 1 do 
        if IsPlayerOnline(players[i]) then
            local ped = GetPlayerPed(players[i])
            if ped ~= 0 then
                local armour = GetPedArmour(ped)
                SavePlayerKevlar(GetPlayerLicense(players[i], "license"), armour)
            else
                Debug(string.format("player kevlar could be saved in the autosave interval because the ped are 0 -> PlayerId: %s", players[i]))
            end
        end
    end
end

function GetPlayerKevlar(playerId)
    local identifier = GetPlayerLicense(playerId, "license")
    local amount = MySQL.Sync.fetchAll("SELECT `kevlar` FROM `users` WHERE `identifier` = @identifier LIMIT 1",{
        ["@identifier"] = identifier
    })[1].kevlar
    Debug(string.format("get player kevlar -> identifier: %s kevlar: %s",identifier, amount))
    if amount == nil or amount == 0 then 
        return 0
    end

    return amount
end

function SetPlayerKevlar(playerId, armour, saveDB)
    SetPedArmour(GetPlayerPed(playerId), armour)
    if saveDB then
        SavePlayerKevlar(GetPlayerLicense(playerId, "license"), armour)
    end
end

function IsStringNullOrEmpty(s)
    return s == nil or s == ""
end


function GetPlayerLicense(playerId, type)
    local identifiers = GetPlayerIdentifiers(playerId)
    local licenseIdentifier = "no_found"

    for _, v in pairs(identifiers) do
        if string.find(v, type) then
            licenseIdentifier = v
            break
       end
    end

    return licenseIdentifier:gsub("license:", "")
end

function IsPlayerOnline(playerId)
    if playerId == nil then 
        Debug(string.format("IsPlayerOnline -> PlayerId: %s is Offline", tostring(playerId)))
        return false
    end 
    if tostring(GetPlayerName(playerId)) == "nil" then
        Debug(string.format("IsPlayerOnline -> PlayerId: %s is Offline", tostring(playerId)))
        return false        
    end
    Debug(string.format("IsPlayerOnline -> PlayerId: %s is Online", tostring(playerId)))
    return true
end

function IsAllowedJob(kevlar, job)
    if #Config.Kevlar[kevlar].AllowedJobs == 0 then
        return true
    end

    for i = 1, #Config.Kevlar[kevlar].AllowedJobs, 1 do 
        if Config.Kevlar[kevlar].AllowedJobs[i] == job then
            return true
        end
    end

    return false
end

function IsAllowed(group)
    for i = 1, #Config.Admins, 1 do
        if Config.Admins[i] == group then
            return true
        end
    end

    return false
end

function GetBestKevlar(inventory)
    local list = {}
    for i, v  in pairs(inventory) do
        if Config.Kevlar[v.name] ~= nil and v.count > 0 then
            Debug(string.format("kevlar found in inventory -> kevlar: %s index: %s", v.name, i))
            table.insert(list, {name = v.name, item = Config.Kevlar[v.name]})
        end
    end

    table.sort(list, function (a, b)
        return a.item.Kevlar > b.item.Kevlar
    end)
    if #list == 0 then
        Debug(string.format("GetBestKevlar return false -> list: %s", #list))
        return 0
    end
    Debug(string.format("GetBestKevlar return -> kevlar: %s", list[1].name))
    return list[1]
end


exports("GetPlayerKevlar", GetPlayerKevlar)

exports("SetPlayerKevlar", SetPlayerKevlar)
