Config = {}

Config.useIlleniumAppearance = GetResourceState("illenium-appearance") ~= 'missing' 

Config.ESXTrigger = function()
    local ESX = nil
    
    ESX = exports["es_extended"]:getSharedObject()
    --TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    return ESX
end

Config.Debug = true
Config.UseMultiChar = false

Config.Loader = {
    SaveKevlar = true,
    AutoSave = true,
    AutoSaveInterval = 60000 * 1,
    AutoloadKevlarName = "kevlar"
}


Config.Events = {
    ["playerLoaded"] = "esx:playerLoaded",
    ["setJob"] = "esx:setJob",
    ["getSkin"] = "skinchanger:getSkin",
    ["loadSkin"] = "skinchanger:loadSkin",
    ["BanTrigger"] = "" --IMPORTAN, read the docs
}

Config.KeyKevlar = {
    UseKey = true,
    DefaultKey = "PLUS"
}

Config.Admins = {
    "superadmin"
}

Config.Commands = {
    ["GiveKevlar"] = "give_kevlar",
    ["GiveKevlarRadius"] = "give_kevlar_radius",
    ["Kevlar"] = "kevlar"
}

Config.Translation = {
    ["YouGotKevlar"] = "You have put on a Kevlar vest",
    ["YouAreNotAllowed"] = "You don't have the right job to be allowed to use this vest",
    ["NoPermission"] = "You dont have permission to execute this command!",
    ["MissingArgsForCommand"] = "Arguments are required to execute the command",
    ["PlayerIsOffline"] = "The Player %s is offline!",
    ["NotEnoughItem"] = "You have no kevlar in your inventory",
    ["KeyInfo"] = "With the button you can use your Kevlar items from your inventory"
}

Config.Kevlar = {
    ["kevlar_s"] = {
        UseSkin = true,
        Kevlar = 50,
        AllowedJobs = {
        },
        Animation = function(ped)
            ESX.Streaming.RequestAnimDict("oddjobs@basejump@ig_15", function()
                TaskPlayAnim(ped, "oddjobs@basejump@ig_15", "puton_parachute", 8.0, -8.0, -1, 0, 0.0, false, false, false)
            end)
        end
    },
    ["kevlar_m"] = {
        UseSkin = true,
        Kevlar = 75,
        AllowedJobs = {
        },
        Animation = function(ped)
            ESX.Streaming.RequestAnimDict("oddjobs@basejump@ig_15", function()
                TaskPlayAnim(ped, "oddjobs@basejump@ig_15", "puton_parachute", 8.0, -8.0, -1, 0, 0.0, false, false, false)
            end)
        end
    },
    ["kevlar"] = {
        UseSkin = true,
        Kevlar = 100,
        AllowedJobs = {
        },
        Animation = function(ped)
            ESX.Streaming.RequestAnimDict("oddjobs@basejump@ig_15", function()
                TaskPlayAnim(ped, "oddjobs@basejump@ig_15", "puton_parachute", 8.0, -8.0, -1, 0, 0.0, false, false, false)
            end)
        end
    },
    ["kevlar_police"] = {
        UseSkin = true,
        Kevlar = 100,
        AllowedJobs = {
            "police"
        },
        Animation = function(ped)
            ESX.Streaming.RequestAnimDict("oddjobs@basejump@ig_15", function()
                TaskPlayAnim(ped, "oddjobs@basejump@ig_15", "puton_parachute", 8.0, -8.0, -1, 0, 0.0, false, false, false)
            end)
        end
    } 
}

Config.KevlarSkin = {
    ["kevlar"] = {
        male = {
            ["bproof_1"] = 10,
            ["bproof_2"] = 1,
        },
        female = {
            ["bproof_1"] = 10,
            ["bproof_2"] = 1,
        }
    },
    ["kevlar_m"] = {
        male = {
            ["bproof_1"] = 10,
            ["bproof_2"] = 2,
        },
        female = {
            ["bproof_1"] = 10,
            ["bproof_2"] = 1,
        }
    },
    ["kevlar_s"] = {
        male = {
            ["bproof_1"] = 10,
            ["bproof_2"] = 3,
        },
        female = {
            ["bproof_1"] = 10,
            ["bproof_2"] = 1,
        }
    },
    ["kevlar_police"] = {
        male = {
            ["bproof_1"] = 10,
            ["bproof_2"] = 3,
        },
        female = {
            ["bproof_1"] = 10,
            ["bproof_2"] = 1,
        }
    },
    ["police"] = {
        male = {
            ["bproof_1"] = 10,
            ["bproof_2"] = 1,
        },
        female = {
            ["bproof_1"] = 10,
            ["bproof_2"] = 1,
        }
    }
}



Config.Notify = function(source, message)
    if source ~= nil then
		TriggerClientEvent('notifications', source, "#66ff00", "INFORMATION", message)
	else
		TriggerEvent('notifications', "#66ff00", "INFORMATION", message)
	end

end