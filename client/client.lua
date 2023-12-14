local RSGCore = exports['rsg-core']:GetCoreObject()
local miningstarted = false
local mining
local mineAnimation = 'amb_work@world_human_pickaxe@wall@male_d@base'
local anim = 'base'
local inRange = false

local LoadAnimDict = function(dict)
    local isLoaded = HasAnimDictLoaded(dict)

    while not isLoaded do
        RequestAnimDict(dict)
        Wait(0)
        isLoaded = not isLoaded
    end
end

---------------------------
-- start mining
---------------------------

Citizen.CreateThread(function()
    for _, v in pairs(Config.MiningLocations) do
        if v.target == true then
            exports['rsg-target']:AddCircleZone(v.location, v.coords, 2, {
                name = v.location,
                debugPoly = false,
            }, {
                options = {
                    {
                        type = "client",
                        action = function()
                            TriggerEvent('mms-mining:client:StartMining')
                        end,
                        icon = "fas fa-comments-dollar",
                        label = Lang:t('menu.start') .. v.name,
                    },
                },
                distance = 3,
            })
        elseif v.target == false then
            exports['rsg-core']:createPrompt(v.location, v.coords, RSGCore.Shared.Keybinds[Config.KeyMining], Lang:t('menu.start') .. v.name, {
                type = 'client',
                event = 'mms-mining:client:StartMining'
            })
        end
        if v.showblip == true then
            local MiningBlip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, v.coords)
            SetBlipSprite(MiningBlip, 1220803671)
            SetBlipScale(MiningBlip, 0.8)
            Citizen.InvokeNative(0x9CB1A1623062F402, MiningBlip, v.name)
        end
    end
end)

CreateThread(function()
    while true do
        Wait(0)
        for _,v in pairs(Config.MiningLocations) do
            if not v.showmarker then goto continue end
            local player = PlayerPedId()
            local pos = GetEntityCoords(player)
            local dist = #(pos - v.coords)
            inRange = false
            if dist < Config.MarkerShowDistance then
                inRange = true
                Citizen.InvokeNative(0x2A32FAA57B937173, 0x07DCE236, v.coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 215, 0, 155, false, false, false, 1, false, false, false)
            end
            ::continue::
        end
    end
end)

local miningstarted = false

RegisterNetEvent('mms-mining:client:StartMining')
AddEventHandler('mms-mining:client:StartMining', function()
    local player = PlayerPedId()
    local hasItem = RSGCore.Functions.HasItem(Config.itemMining, 1)
    local chance = math.random(1, 100)
    
    if Config.DoMiniGame == true then
        local success = lib.skillCheck({{areaSize = 50, speedMultiplier = 0.5}}, {'w', 'a', 's', 'd'})
        if not success then
            SetPedToRagdoll(player, 1000, 1000, 0, 0, 0, 0)
            lib.notify({ title = 'Error', description = Lang:t('error.failed_mining'), type = 'error' })
            return
        end
    end
    
    if miningstarted then
        lib.notify({ title = 'Error', description = Lang:t('error.you_are_busy'), type = 'error' })
        return
    end

    if not hasItem then
        lib.notify({ title = 'Error', description = Lang:t('error.you_dont_have_pickaxe'), type = 'error' })
        return
    end


    local coords = GetEntityCoords(player)
    local boneIndex = GetEntityBoneIndexByName(player, "SKEL_R_Finger00")
    local pickaxe = CreateObject(GetHashKey("p_pickaxe01x"), coords, true, true, true)
    miningstarted = true

    SetCurrentPedWeapon(player, "WEAPON_UNARMED", true)
    FreezeEntityPosition(player, true)
    ClearPedTasksImmediately(player)
    AttachEntityToEntity(pickaxe, player, boneIndex, -0.35, -0.21, -0.39, -8.0, 47.0, 11.0, true, false, true, false, 0, true)

    TriggerEvent('mms-mining:client:MineAnimation')

    RSGCore.Functions.Progressbar("mining", Lang:t('success.mining_action'), Config.MiningTime, false, true,
    {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function()
        ClearPedTasksImmediately(player)
        FreezeEntityPosition(player, false)

        TriggerServerEvent('mms-mining:server:givestone')
        SetEntityAsNoLongerNeeded(pickaxe)
        DeleteEntity(pickaxe)

        local numberGenerator = math.random(1, 100)
        if numberGenerator == 1 then
        local item = Config.itemMining
        TriggerServerEvent('mms-mining:server:breakpickaxe' , item)
        return
        end

        miningstarted = false
    end)
end)

AddEventHandler('mms-mining:client:MineAnimation', function()
    local player = PlayerPedId()
    LoadAnimDict(mineAnimation)
    while not HasAnimDictLoaded(mineAnimation) do
        Wait(100)
    end
    TaskPlayAnim(player, mineAnimation, anim, 3.0, 3.0, -1, 1, 0, false, false, false)
end)
