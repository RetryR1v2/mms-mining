local RSGCore = exports['rsg-core']:GetCoreObject()
---------------------------
-- goldpaning + rockpaning
---------------------------

local panning = false
local canPan = false
-------------------
local Zones = {}
local hotspot = false
-------------------
-- create hotspot zones
CreateThread(function() 
    for k=1, #Config.HotspotZones do
        Zones[k] = PolyZone:Create(Config.HotspotZones[k].zones, {
            minZ = Config.HotspotZones[k].minz,
            maxZ = Config.HotspotZones[k].maxz,
            debugPoly = false,
        })
        Zones[k]:onPlayerInOut(function(isPointInside)
            if isPointInside then
                hotspot = true
            else
                hotspot = false
            end
        end)
    end
end)

-- ensure prop is loaded
local function LoadModel(model)
    local modelHash = GetHashKey(model)
    RequestModel(modelHash)
    local attempts = 0
    while not HasModelLoaded(modelHash) and attempts < 100 do
        Wait(10)
        attempts = attempts + 1
    end
    return IsModelValid(modelHash)
end

local function CrouchAnim()
    local dict = "script_rc@cldn@ig@rsc2_ig1_questionshopkeeper"
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    TaskPlayAnim(ped, dict, "inspectfloor_player", 0.5, 8.0, -1, 1, 0, false, false, false)
end

local function AttachPan()
    if not DoesEntityExist(prop_goldpan) then
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local modelHash = GetHashKey("P_CS_MININGPAN01X")
    LoadModel(modelHash)
    prop_goldpan = CreateObject(modelHash, coords.x+0.30, coords.y+0.10,coords.z, true, false, false)
    SetEntityVisible(prop_goldpan, true)
    SetEntityAlpha(prop_goldpan, 255, false)
    Citizen.InvokeNative(0x283978A15512B2FE, prop_goldpan, true)
    local boneIndex = GetEntityBoneIndexByName(ped, "SKEL_R_HAND")
    AttachEntityToEntity(prop_goldpan, PlayerPedId(), boneIndex, 0.2, 0.0, -0.20, -100.0, -50.0, 0.0, false, false, false, true, 2, true)
    SetModelAsNoLongerNeeded(modelHash)
    end
end

local function GoldShake()
    local dict = "script_re@gold_panner@gold_success"
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end
    TaskPlayAnim(PlayerPedId(), dict, "SEARCH02", 1.0, 8.0, -1, 1, 0, false, false, false)
end

-- delete goldpan prop
local function DeletePan(entity)
    DeleteObject(entity)
    DeleteEntity(entity)
    Wait(100)      
    ClearPedTasks(PlayerPedId())
end

-- Wash Rock
RegisterNetEvent('mms-mining:client:StartRockPan')
AddEventHandler('mms-mining:client:StartRockPan', function()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local water = Citizen.InvokeNative(0x5BA7A68A346A5A91, coords.x, coords.y, coords.z)
    local mounted = IsPedOnMount(ped)
    local hasItem = RSGCore.Functions.HasItem(Config.itemRock)
    local hasItem2 = RSGCore.Functions.HasItem(Config.itemGoldpan)

    if not hasItem or not hasItem2 then
        lib.notify({ title = 'Error', description = Lang:t('error.missing_items'), type = 'error' })
        return
    end

    if mounted then
        lib.notify({ title = 'Error', description = Lang:t('error.mounted'), type = 'error' })
        return
    end

    if panning then
        lib.notify({ title = 'Error', description = Lang:t('error.already_rockpanning'), type = 'error' })
        return
    end

    local canPan = false
    for k, v in pairs(Config.WaterTypes) do
        if water == Config.WaterTypes[k]["waterhash"] then
            canPan = true
            break
        end
    end

    if not canPan then
        lib.notify({ title = 'Info', description = Lang:t('primary.need_river'), type = 'primary' })
        return
    end

    panning = true
    AttachPan()
    CrouchAnim()
    LocalPlayer.state:set("inv_busy", true, true)
    Wait(6000)
    ClearPedTasks(ped)
    GoldShake()
    local randomwait = math.random(12000, 28000)
    Wait(randomwait)
    DeletePan(prop_goldpan)

    TriggerServerEvent('mms-mining:server:washrocks')

    panning = false
    canPan = false
    LocalPlayer.state:set("inv_busy", false, true)
end)

RegisterNetEvent('mms-mining:client:StartGoldPan')
AddEventHandler('mms-mining:client:StartGoldPan', function()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local water = Citizen.InvokeNative(0x5BA7A68A346A5A91, coords.x, coords.y, coords.z)
    local mounted = IsPedOnMount(ped)
    local hasItem = RSGCore.Functions.HasItem(Config.itemGoldpan)
    local success = lib.skillCheck({{areaSize = 50, speedMultiplier = 0.5}}, {'w', 'a', 's', 'd'})

    if not hasItem then
        lib.notify({ title = 'Error', description = Lang:t('error.missing_items'), type = 'error' })
        return
    end

    if mounted then
        lib.notify({ title = 'Error', description = Lang:t('error.mounted'), type = 'error' })
        return
    end

    if panning then
        lib.notify({ title = 'Error', description = Lang:t('error.already_goldpanning'), type = 'error' })
        return
    end

    local canPan = false
    for k, v in pairs(Config.WaterTypes) do
        if water == Config.WaterTypes[k]["waterhash"] then
            canPan = true
            break
        end
    end

    if not canPan then
        lib.notify({ title = 'Info', description = Lang:t('primary.need_river'), type = 'inform' })
        return
    end

    if not success then
        SetPedToRagdoll(PlayerPedId(), 1000, 1000, 0, 0, 0, 0)
        lib.notify({ title = 'Error', description = Lang:t('error.failed_goldpanning'), type = 'error' })
        return
    end

    panning = true
    AttachPan()
    CrouchAnim()
    LocalPlayer.state:set("inv_busy", true, true)
    Wait(6000)
    ClearPedTasks(ped)
    GoldShake()
    local randomwait = math.random(12000, 28000)
    Wait(randomwait)
    DeletePan(prop_goldpan)

    if hotspot then
        TriggerServerEvent('mms-mining:server:hotspotrewardgoldpaning')
    else
        TriggerServerEvent('mms-mining:server:rewardgoldpaning')
    end

    panning = false
    canPan = false
    LocalPlayer.state:set("inv_busy", false, true)
end)
