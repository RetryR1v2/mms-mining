local VORPcore = exports.vorp_core:GetCore()
local BccUtils = exports['bcc-utils'].initiate()
local progressbar = exports.vorp_progressbar:initiate()

local MineBlips = {}

local Toolout = false
local ToolId = nil
local CurrentItem = nil
local CurrentItemMaxUses = nil
local LastMinedCoords = nil

-- Axe out

RegisterNetEvent('mms-mining:client:ToolOut')
AddEventHandler('mms-mining:client:ToolOut',function(ItemId,UsedItem,MaxUses)
    ToolId = ItemId
    CurrentItem = UsedItem
    CurrentItemMaxUses = MaxUses
    MyPed = PlayerPedId()
    if not Toolout then
        Wait(500)
        Tool = CreateObject(Config.ToolHash, GetOffsetFromEntityInWorldCoords(MyPed, 0.0, 0.0, 0.0), true, true, true)
        AttachEntityToEntity(Tool, MyPed, GetPedBoneIndex(MyPed, 7966), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 2, 1, 0, 0)
        Citizen.InvokeNative(0x923583741DC87BCE, MyPed, 'arthur_healthy')
        Citizen.InvokeNative(0x89F5E7ADECCCB49C, MyPed, "carry_pitchfork")
        Citizen.InvokeNative(0x2208438012482A1A, MyPed, true, true)
        ForceEntityAiAndAnimationUpdate(Tool, 1)
        Citizen.InvokeNative(0x3A50753042B6891B, MyPed, "PITCH_FORKS")
        LastMinedCoords = GetEntityCoords(PlayerPedId())
        Toolout = true
        TriggerEvent('mms-mining:client:CheckCanWork')
    elseif Toolout then
        Wait(500)
        DeleteObject(Tool)
        Citizen.InvokeNative(0x923583741DC87BCE, MyPed, 'arthur_healthy')
        Citizen.InvokeNative(0x2208438012482A1A, MyPed, false, false)
        Citizen.InvokeNative(0x58F7DB5BD8FA2288, PlayerPedId())
        ClearPedTasks(MyPed)
        Toolout = false
    end
end)

--- Get New ToolID

RegisterNetEvent('mms-mining:client:UpdateItemId')
AddEventHandler('mms-mining:client:UpdateItemId',function(NewToolId)
    ToolId = NewToolId
end)

-- RepairTool

RegisterNetEvent('mms-mining:client:RepairTool')
AddEventHandler('mms-mining:client:RepairTool',function()
    if Toolout then
        TriggerServerEvent('mms-mining:server:RepairTool',ToolId,CurrentItemMaxUses)
        Progressbar(Config.RepairTime * 1000 ,_U('RepairingTool'))
    else
        VORPcore.NotifyTip(_U('NoToolInHand'),5000)
    end
end)

-- Main Thred

Citizen.CreateThread(function ()
    local MiningPromptGroup = BccUtils.Prompts:SetupPromptGroup()
    local DoMining = MiningPromptGroup:RegisterPrompt(_U('Mining'), 0x760A9C6F, 1, 1, true, 'hold', {timedeventhash = 'MEDIUM_TIMED_EVENT'})

    -- Create MiningBlips
    for h,v in ipairs(Config.Mines) do
        if v.CreateBlip then
            local MinesBlips = BccUtils.Blips:SetBlip(v.MineName, v.BlipSprite, 0.3, v.MinePosition.x,v.MinePosition.y,v.MinePosition.z)
            MineBlips[#MineBlips + 1] = MinesBlips
        end
    end

while true do
    Citizen.Wait(1500)

    while Toolout do
        Citizen.Wait(3)
        for h,v in ipairs(Config.Mines) do
            local MyCoords = GetEntityCoords(PlayerPedId())
            local Distance = #(MyCoords - v.MinePosition)
            local DistanceLast = #(MyCoords - LastMinedCoords)
            if v.ForceMoveAfterMine then
                if Distance < v.MineRadius and DistanceLast >= v.ForceMoveDistance then
                    MiningPromptGroup:ShowGroup(v.MineName)
                        
                    if DoMining:HasCompleted() then
                        Wait(200)
                        local CurrentMine = Config.Mines[h]
                        LastMinedCoords = GetEntityCoords(PlayerPedId())
                        TriggerServerEvent('mms-mining:server:CheckForTool',ToolId,CurrentMine)
                    end
                end
            else
                if Distance < v.MineRadius then
                    MiningPromptGroup:ShowGroup(v.MineName)
                        
                    if DoMining:HasCompleted() then
                        Wait(200) -- DL
                        local CurrentMine = Config.Mines[h]
                        TriggerServerEvent('mms-mining:server:CheckForTool',ToolId,CurrentMine)
                    end
                end
            end
        end
    end
end
end)

-- Getting lumber

RegisterNetEvent('mms-mining:client:DoMining')
AddEventHandler('mms-mining:client:DoMining',function(ToolId,CurrentMine)
    Citizen.Wait(100)
    local MyPed = PlayerPedId()
    Anim(MyPed, 'amb_work@world_human_pickaxe_new@working@male_a@trans', 'pre_swing_trans_after_swing', -1, 0)
    Progressbar(Config.MineTime,_U('WorkingHere'))
    TriggerServerEvent('mms-mining:server:FinishMining',ToolId,CurrentItem,CurrentItemMaxUses,CurrentMine)
end)

-- Check Player Status
RegisterNetEvent('mms-mining:client:CheckCanWork')
AddEventHandler('mms-mining:client:CheckCanWork',function()
    while Toolout do
        Citizen.Wait(5000)
        if Toolout then
            CanDoWork = CanWork()
            if not CanDoWork then
                TriggerEvent('mms-mining:client:ToolOut')
            end
        end
    end
end)

function CanWork (MyPed)
    local MyPed = PlayerPedId()
    local Dead = IsPedDeadOrDying(MyPed)
    local OnHorse = IsPedOnMount(MyPed)
    local OnWagon = IsPedOnVehicle(MyPed)
    local InWater = IsPedSwimmingUnderWater(MyPed)
    if not Dead and not OnHorse and not OnWagon and not InWater then
        return true
    else
        return false
    end
end

----------------- Utilities -----------------

---- CleanUp on Resource Restart 

RegisterNetEvent('onResourceStop',function(resource)
    if resource == GetCurrentResourceName() then
    for _, blips in ipairs(MineBlips) do
        blips:Remove()
	end
end
end)

------ Progressbar

function Progressbar(Time,Text)
    progressbar.start(Text, Time, function ()
    end, 'linear')
    Wait(Time)
    ClearPedTasks(PlayerPedId())
end

------ Animation

function CrouchAnim()
    local dict = "script_rc@cldn@ig@rsc2_ig1_questionshopkeeper"
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end
    local MyPed = PlayerPedId()
    local coords = GetEntityCoords(MyPed)
    TaskPlayAnim(MyPed, dict, "inspectfloor_player", 0.5, 8.0, -1, 1, 0, false, false, false)
end

function Anim(actor, dict, body, duration, flags, introtiming, exittiming)
    Citizen.CreateThread(function()
        RequestAnimDict(dict)
        local dur = duration or -1
        local flag = flags or 1
        local intro = tonumber(introtiming) or 1.0
        local exit = tonumber(exittiming) or 1.0
        timeout = 5
        while (not HasAnimDictLoaded(dict) and timeout > 0) do
            timeout = timeout - 1
            if timeout == 0 then
                print("Animation Failed to Load")
            end
            Citizen.Wait(300)
        end
        TaskPlayAnim(actor, dict, body, intro, exit, dur, flag --[[1 for repeat--]], 1, false, false, false, 0, true)
    end)
end