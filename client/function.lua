function Debug(msg)
    if Config.Debug == false then 
        return
    end
    print(msg)
end

function SetKevlarSkin(kevlar, job)
    local ped = PlayerPedId()
    Debug(string.format("set kevlar string -> kevlar: %s job: %s", kevlar, job))
    local kevlarSkin = Config.KevlarSkin[job] or Config.KevlarSkin[kevlar]
    local gender = GetPedGender(ped)
    if Config.KevlarSkin[kevlar] == nil or Config.Kevlar[kevlar].UseSkin == false then
        Debug(string.format("SetKevlarSkin could be set reason -> Config.KevlarSkin[%s]: %s or Config.KevlarSkin[%s].UseSkin: %s", kevlar, tostring(Config.KevlarSkin[kevlar]), kevlar, tostring(Config.Kevlar[kevlar].UseSkin)))
        return
    end
    TriggerEvent(Config.Events["getSkin"], function(skinData)
        if skinData ~= nil then
            Debug(string.format("set skin data -> bproof_1: %s bproof_2: %s", kevlarSkin[gender]["bproof_1"], kevlarSkin[gender]["bproof_2"]))
            if Config.useIlleniumAppearance then
                local uniform = {
                    bproof_1 = kevlarSkin[gender]["bproof_1"],
                    bproof_2 = kevlarSkin[gender]["bproof_2"]
                }
                TriggerEvent("skinchanger:loadClothes", skinData, uniform)
                return
            end
            skinData['bproof_1'] = kevlarSkin[gender]["bproof_1"]
            skinData['bproof_2'] = kevlarSkin[gender]["bproof_2"]
            TriggerEvent(Config.Events["loadSkin"], skinData)
        end
    end)

end


function GetPedGender(ped)
    if IsPedMale(ped) then
        return "male"
    end

    return "female"
end