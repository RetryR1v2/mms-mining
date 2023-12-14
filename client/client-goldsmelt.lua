local RSGCore = exports['rsg-core']:GetCoreObject()

---------------------------
-- target smelt menu + blip smeltlocations
---------------------------

for _, k in ipairs(Config.SmeltingLocations) do
    if Config.SmeltLocations == true then
        exports['rsg-target']:AddBoxZone("Smelter", k.coords, 1.45, 1.35, {
        name = "Smelter",
        heading = k.heading,
        debugPoly = false,
        minZ = k.minZ,
        maxZ = k.maxZ,
        }, {
            options = {
                {
                    type = "client",
                    event = "mms-mining:client:smeltmenu",
                    icon = "fas fa-fire",
                    label = Lang:t('menu.smelt'),
                },
            },
            distance = 2.5
        })
    end
    exports['rsg-target']:AddTargetModel('p_goldsmeltburner01x', {
    options = {
        {   icon = 'far fa-gear',
            label = Lang:t('menu.smelt_item'), -- use text '' = 'Title example'
            type = "client",
            event = 'mms-mining:client:smeltmenu',
        },},
    distance = 2.0,
    })

    if k.showblip == true then
        local SmeltingBlip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, k.coords)
        SetBlipSprite(SmeltingBlip, GetHashKey("blip_shop_shady_store"), 1)
        SetBlipScale(SmeltingBlip, 0.2)
        Citizen.InvokeNative(0x9CB1A1623062F402, SmeltingBlip, k.name)
    end
end

---------------------------
-- menu smeltmenu
---------------------------

local options = {}
local categoryMenus = {}

for _, v in ipairs(Config.SmeltOptions) do
    local smeltitemsMetadata = {}
    local setheader = RSGCore.Shared.Items[tostring(v.receive)].label
    local itemimg = "nui://"..Config.Img..RSGCore.Shared.Items[tostring(v.receive)].image

    for i, smeltitem in ipairs(v.smeltitems) do
        table.insert(smeltitemsMetadata, { label = RSGCore.Shared.Items[smeltitem.item].label, value = smeltitem.amount })
    end

    local option = {
        title = setheader,
        icon = itemimg,
        event = 'mms-mining:client:checksmeltitems',
        metadata = smeltitemsMetadata,
        args = {
            title = setheader,
            smeltitems = v.smeltitems,
            smelttime = v.smelttime,
            receive = v.receive,
            giveamount = v.giveamount,
        }
    }

    -- check if a menu already exists for this category
    if not categoryMenus[v.category] then
        categoryMenus[v.category] = {
            id = 'smelting_menu_' .. v.category,
            title = Lang:t('menu.smelt_menu') .. v.category,
            menu = 'smelting_main_menu',
            onBack = function() end,
            options = { option }
        }
    else
        table.insert(categoryMenus[v.category].options, option)
    end
end

-- log menu events by category
for category, menuData in pairs(categoryMenus) do
    RegisterNetEvent('mms-mining:client:' .. category)
    AddEventHandler('mms-mining:client:' .. category, function()
        lib.registerContext(menuData)
        lib.showContext(menuData.id)
    end)
end

-- main event to open main menu
RegisterNetEvent('mms-mining:client:smeltmenu')
AddEventHandler('mms-mining:client:smeltmenu', function()
    -- show main menu with categories
    local mainMenu = {
        id = 'smelting_main_menu',
        title = Lang:t('menu.smelt_menu'),
        options = {}
    }

    for category, menuData in pairs(categoryMenus) do
        table.insert(mainMenu.options, {
            title = category,
            description = 'Explora las recetas para ' .. category,
            icon = 'fa-solid fa-fire',
            event = 'mms-mining:client:' .. category,
            arrow = true
        })
    end

    lib.registerContext(mainMenu)
    lib.showContext(mainMenu.id)
end)

---------------------------
-- check player has the ingredients to cook item
---------------------------
RegisterNetEvent('mms-mining:client:checksmeltitems', function(data)
    local input = lib.inputDialog('Smelting Amount', {
        { 
            type = 'input',
            label = 'Amount',
            required = true,
            min = 1, max = 10
        },
    })

    if not input then return end

    local smeltamount = tonumber(input[1])
    if smeltamount then
        RSGCore.Functions.TriggerCallback('mms-mining:server:checkingsmeltitems', function(hasRequired)
            if (hasRequired) then
                if Config.Debug == true then
                    print("passed")
                end
                TriggerEvent('mms-mining:client:smeltitem', data.title, data.smeltitems, tonumber(data.smelttime * smeltamount), data.receive, data.giveamount,  smeltamount)
            else
                if Config.Debug == true then
                    print("failed")
                end
                return
            end
        end, data.smeltitems,  smeltamount)
    end
end)

-- do cooking
RegisterNetEvent('mms-mining:client:smeltitem', function(title, smeltitems, smelttime, receive, giveamount, smeltamount)
    local ped = PlayerPedId()
    local animDict = 'amb_work@prop_human_repair_wagon_wheel_on@front@male_a@idle_a'
    local animName = 'idle_a'

    RSGCore.Functions.RequestAnimDict(animDict)
    local success = lib.skillCheck({{areaSize = 50, speedMultiplier = 0.5}}, {'w', 'a', 's', 'd'})
    if success == true then
        -- Check if the animation dictionary was successfully loaded
        if HasAnimDictLoaded(animDict) then
            -- Play the animation
            TaskPlayAnim(ped, animDict, animName, 8.0, -8.0, -1, 1, 0, false, false, false)
            LocalPlayer.state:set("inv_busy", true, true)

            -- Use the Oxlib progress circle with a message
            if lib.progressCircle({
                duration = smelttime, -- Adjust the duration as needed
                position = 'bottom',
                useWhileDead = false,
                canCancel = Config.AllowSmeltCanceling, -- Change to true if you want to allow canceling
                anim = {
                    dict = animDict,
                    clip = 'empathise_headshake_f_001',
                    flag = 15,
                },
                disableControl = true, -- Disable player control during the animation
                label = Lang:t('primary.smelting_item') .. title, -- Your cooking message here
            }) then
                -- Cooking was successful
                TriggerServerEvent('mms-mining:server:finishsmelting', smeltitems, receive, giveamount, smeltamount)

                -- Stop the animation
                StopAnimTask(ped, animDict, animName, 1.0)
                LocalPlayer.state:set("inv_busy", false, true)
            else
                -- Handle cancelation or failure
                RSGCore.Functions.Notify(Lang:t('primary.cancelation_failure'), 'primary')

                -- Cancel the animation
                StopAnimTask(ped, animDict, animName, 1.0)
                LocalPlayer.state:set("inv_busy", false, true)
            end
        else
            -- Handle if the animation dictionary couldn't be loaded
            lib.notify({ title = 'Error', description = Lang:t('error.failed_animation'), type = 'error' })
        end
    else
        SetPedToRagdoll(PlayerPedId(), 1000, 1000, 0, 0, 0, 0)
        lib.notify({ title = 'Error!', description = Lang:t('error.try_again'), type = 'error' })
    end
end)

---------------------------
-- gold smelt prop
---------------------------

local goldsmelt = false

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

RegisterNetEvent('mms-mining:client:setupgoldsmelt')
AddEventHandler('mms-mining:client:setupgoldsmelt', function()
    if Config.UseGoldSmeltItem == true then
        local ped = PlayerPedId()
        local x, y, z

        CrouchAnim()
        Wait(6000)
        ClearPedTasks(ped)

        if goldsmelt then
            ClearPedTasks(ped)
            SetEntityAsMissionEntity(smelt)
            DeleteObject(smelt)
            lib.notify({ title = 'Info', description = Lang:t('success.item_picked_up'), type = 'inform' })
            goldsmelt = false
        else
            CrouchAnim()
            Wait(6000)
            ClearPedTasks(ped)

            x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.75, -1.55))
            local prop = CreateObject(GetHashKey('p_goldsmeltburner01x'), x, y, z, true, false, true)
            SetEntityHeading(prop, GetEntityHeading(PlayerPedId()))
            PlaceObjectOnGroundProperly(prop)
            smelt = prop

            lib.notify({ title = 'Info', description = Lang:t('success.item_set_up'), type = 'inform' })
            goldsmelt = true
        end
    else
        print('Config.UseGoldSmeltItem is set to false genius!') 
    end
end, false)
