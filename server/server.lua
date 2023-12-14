local RSGCore = exports['rsg-core']:GetCoreObject()

-----------------------------------------------------------------------
-- version checker
-----------------------------------------------------------------------
local function versionCheckPrint(_type, log)
    local color = _type == 'success' and '^2' or '^1'

    print(('^5['..GetCurrentResourceName()..']%s %s^7'):format(color, log))
end

local function CheckVersion()
    PerformHttpRequest('https://raw.githubusercontent.com/RetryR1v2/mms-mining/main/version.txt', function(err, text, headers)
        local currentVersion = GetResourceMetadata(GetCurrentResourceName(), 'version')

        if not text then 
            versionCheckPrint('error', 'Currently unable to run a version check.')
            return 
        end

        --versionCheckPrint('success', ('Current Version: %s'):format(currentVersion))
        --versionCheckPrint('success', ('Latest Version: %s'):format(text))
        
        if text == currentVersion then
            versionCheckPrint('success', 'You are running the latest version.')
        else
            versionCheckPrint('error', ('You are currently running an outdated version, please update to version %s'):format(text))
        end
    end)
end

-----------------------------------------------------------------------

---------------------------
-- use item
---------------------------
-- use goldsmelt
RSGCore.Functions.CreateUseableItem(Config.itemSmelt, function(source, item)
    local src = source
	TriggerClientEvent('mms-mining:client:setupgoldsmelt', src, item.name)
end)

-- use goldpan
RSGCore.Functions.CreateUseableItem(Config.itemGoldpan, function(source, item)
    local src = source
    TriggerClientEvent("mms-mining:client:StartGoldPan", src, item.name)
end)

-- use rock
RSGCore.Functions.CreateUseableItem(Config.itemRock, function(source, item)
    local src = source
    TriggerClientEvent('mms-mining:client:StartRockPan', src, item.name)
end) 

---------------------------
-- mining
---------------------------

RegisterServerEvent('mms-mining:server:givestone')
AddEventHandler('mms-mining:server:givestone', function()
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    local chance = math.random(1, 100)
    local rock = math.random(2, 4)
    local salt = math.random(2, 4)
    local playername = Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname
    local citizenid = Player.PlayerData.citizenid

    Player.Functions.AddItem(Config.itemRock, rock)
    TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items[Config.itemRock], "add")
    Player.Functions.AddItem('rocksalt', salt)
    TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items['rocksalt'], "add")
    
    if chance <= 50 then  --- kleiner als 50
        local randomitem = math.random(1,5)
        if randomitem == 1 then
            local amount = math.random(2, 3)
            Player.Functions.AddItem('iron_ore', amount)
            TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items['iron_ore'], "add")
        elseif randomitem == 2 then
            local amount = math.random(2, 3)
            Player.Functions.AddItem('coal', amount)
            TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items['coal'], "add")
        elseif randomitem == 3 then
            local amount = math.random(2, 3)
            Player.Functions.AddItem('aluminum_ore', amount)
            TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items['aluminum_ore'], "add")
        elseif randomitem == 4 then
            local amount = math.random(2, 3)
            Player.Functions.AddItem('copper_ore', amount)
            TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items['copper_ore'], "add")
        elseif randomitem == 5 then
            local amount = math.random(2, 3)
            Player.Functions.AddItem('steel_ore', amount)
            TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items['steel_ore'], "add")
        end
    elseif chance >= 90 then
        local randomrareitem = math.random(1,4)
        if randomrareitem == 1 then
            local amount = math.random(1, 2)
            Player.Functions.AddItem('diamond', amount)
            TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items['diamond'], "add")
        elseif randomrareitem == 2 then
            local amount = math.random(1, 2)
            Player.Functions.AddItem('ruby', amount)
            TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items['ruby'], "add")
        elseif randomrareitem == 3 then
            local amount = math.random(1, 2)
            Player.Functions.AddItem('emerald',  amount)
            TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items['emerald'], "add")
        elseif randomrareitem == 4 then
            local amount = math.random(1, 2)
            Player.Functions.AddItem('mediumnugget',  amount)
            TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items['mediumnugget'], "add")
        end
    end
end)

---------------------------
-- remove pickaxe if broken
---------------------------

RegisterServerEvent('mms-mining:server:breakpickaxe')
AddEventHandler('mms-mining:server:breakpickaxe', function(item)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if item == Config.itemMining then
        Player.Functions.RemoveItem(Config.itemMining, 1)
        TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items[Config.itemMining], "remove")
        
        TriggerClientEvent('ox_lib:notify', src, {title = 'Spitzhacke', description =  'Deine Spitzhacke ist Kaputt gegangen!', type = 'info', duration = 5000 })
            
    else
        TriggerClientEvent('ox_lib:notify', src, {title = 'Error', description =  Lang:t('error.something_went_wrong'), type = 'error' })
            print('something went wrong with the script could be exploint!')
    end
end)


---------------------------
-- Smelting
---------------------------

-- check player has the smeltitems
RSGCore.Functions.CreateCallback('mms-mining:server:checkingsmeltitems', function(source, cb, smeltitems, smeltamount)
    local src = source
    local hasItems = false
    local icheck = 0
    local Player = RSGCore.Functions.GetPlayer(src)
    for k, v in pairs(smeltitems) do
        if Player.Functions.GetItemByName(v.item) and Player.Functions.GetItemByName(v.item).amount >= v.amount * smeltamount then
            icheck = icheck + 1
            if icheck == #smeltitems then
                cb(true)
            end
        else
            TriggerClientEvent('ox_lib:notify', src, {title = 'Error', description =  Lang:t('error.missing_items').. RSGCore.Shared.Items[tostring(v.item)].label, type = 'error' })
            cb(false)
            return
        end
    end
end)

-- finish smelting
RegisterServerEvent('mms-mining:server:finishsmelting')
AddEventHandler('mms-mining:server:finishsmelting', function(smeltitems, receive, giveamount, smeltamount)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    -- remove ingredients
    for k, v in pairs(smeltitems) do
        if Config.Debug == true then
            print(v.item)
            print(v.amount)
        end
        local requiredAmount = v.amount * smeltamount
        Player.Functions.RemoveItem(v.item, requiredAmount)    
        TriggerClientEvent('inventory:client:ItemBox', src, RSGCore.Shared.Items[v.item], "remove")
    end
    -- add cooked item
    Player.Functions.AddItem(receive, giveamount * smeltamount)
    TriggerClientEvent('inventory:client:ItemBox', src, RSGCore.Shared.Items[receive], "add")
    local labelReceive = RSGCore.Shared.Items[receive].label

    TriggerClientEvent('ox_lib:notify', src, {title = 'Success', description =  Lang:t('success.smelting_successful')..' '..smeltamount..' ' .. labelReceive, type = 'success' })

end)

---------------------------
-- paning washrocks
---------------------------

RegisterServerEvent('mms-mining:server:washrocks')
AddEventHandler('mms-mining:server:washrocks', function()
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    local chance = math.random(1, 100)
    local checkItem = Player.Functions.GetItemByName(Config.itemRock)
    local item = Config.RareAward[math.random(1, #Config.RareAward)]
    local item2 = Config.UncommonAward[math.random(1, #Config.UncommonAward)]
    local item3 = Config.Normal[math.random(1, #Config.Normal)]

    if chance <= 5 then
        
        if checkItem.amount > 3 and chance <= 13 then
            local ore = math.random(1, 3)
            local remaining = 0
            Player.Functions.RemoveItem(Config.itemRock, 3)
            TriggerClientEvent('inventory:client:ItemBox', src, RSGCore.Shared.Items[Config.itemRock], "remove")
            Player.Functions.AddItem(item, ore)
            TriggerClientEvent('inventory:client:ItemBox', src, RSGCore.Shared.Items[item], "add")

            if ore <= 2 then
                remaining = 3 - ore
                Player.Functions.AddItem(Config.itemRock, remaining)
                TriggerClientEvent('inventory:client:ItemBox', src, RSGCore.Shared.Items[Config.itemRock], "add")
            else end

        elseif checkItem.amount <= 2 then

            Player.Functions.RemoveItem(Config.itemRock, 1)
            TriggerClientEvent('inventory:client:ItemBox', src, RSGCore.Shared.Items[Config.itemRock], "remove")
            Player.Functions.AddItem(item, 1)
            TriggerClientEvent('inventory:client:ItemBox', src, RSGCore.Shared.Items[item], "add")

        end

        TriggerClientEvent('ox_lib:notify', src, {title = 'Success', description =  Lang:t('success.rock_destroyed_but_item'), type = 'success' })

    elseif chance > 15 and chance <= 45 then

        if checkItem.amount >= 3 then
            local ore = math.random(1, 3)
            local remaining = 0
            Player.Functions.RemoveItem(Config.itemRock, 3)
            TriggerClientEvent('inventory:client:ItemBox', src, RSGCore.Shared.Items[Config.itemRock], "remove")
            Player.Functions.AddItem(item2, ore)
            TriggerClientEvent('inventory:client:ItemBox', src, RSGCore.Shared.Items[item2], "add")

            TriggerClientEvent('ox_lib:notify', src, {title = 'Success', description =  Lang:t('success.rock_destroyed_but_item'), type = 'success' })

            if ore <= 2 then
                remaining = 3 - ore
                Player.Functions.AddItem(Config.itemRock, remaining)
                TriggerClientEvent('inventory:client:ItemBox', src, RSGCore.Shared.Items[Config.itemRock], "add")
                TriggerClientEvent('ox_lib:notify', src, {title = 'Info', description =  Lang:t('primary.rock_returned'), type = 'inform' })
            else end

        elseif checkItem.amount <= 2 then
            Player.Functions.RemoveItem(Config.itemRock, 1)
            TriggerClientEvent('inventory:client:ItemBox', src, RSGCore.Shared.Items[Config.itemRock], "remove")
            Player.Functions.AddItem(item2, 1)
            TriggerClientEvent('inventory:client:ItemBox', src, RSGCore.Shared.Items[item2], "add")
        end

        TriggerClientEvent('ox_lib:notify', src, {title = 'Success', description =  Lang:t('success.rock_destroyed_but_item'), type = 'success' })

    elseif chance > 47 and chance <= 68 then

        if checkItem.amount >= 3 then
            local ore = math.random(1, 3)
            local remaining = 0
            Player.Functions.RemoveItem(Config.itemRock, 3)
            TriggerClientEvent('inventory:client:ItemBox', src, RSGCore.Shared.Items[Config.itemRock], "remove")
            Player.Functions.AddItem(item3, ore)
            TriggerClientEvent('inventory:client:ItemBox', src, RSGCore.Shared.Items[item3], "add")

            if ore <= 2 then
                remaining = 3 - ore
                Player.Functions.AddItem(Config.itemRock, remaining)
                TriggerClientEvent('inventory:client:ItemBox', src, RSGCore.Shared.Items[Config.itemRock], "add")

            else end

        elseif checkItem.amount <= 2 then
            Player.Functions.RemoveItem(Config.itemRock, 1)
            TriggerClientEvent('inventory:client:ItemBox', src, RSGCore.Shared.Items[Config.itemRock], "remove")
            Player.Functions.AddItem(item3, 1)
            TriggerClientEvent('inventory:client:ItemBox', src, RSGCore.Shared.Items[item3], "add")
        end

        TriggerClientEvent('ox_lib:notify', src, {title = 'Success', description =  Lang:t('success.rock_destroyed_but_item'), type = 'success' })

    elseif chance > 50 then

        if checkItem.amount >= 3 then
            local ore = math.random(1, 3)
            local remaining = 0
            Player.Functions.RemoveItem(Config.itemRock, 3)
            TriggerClientEvent('inventory:client:ItemBox', src, RSGCore.Shared.Items[Config.itemRock], "remove")

            if ore <= 2 then
                remaining = 3 - ore
                Player.Functions.AddItem(Config.itemRock, remaining)
                TriggerClientEvent('inventory:client:ItemBox', src, RSGCore.Shared.Items[Config.itemRock], "add")
            else end

        elseif checkItem.amount <= 2 then
            Player.Functions.RemoveItem(Config.itemRock, 1)
            TriggerClientEvent('inventory:client:ItemBox', src, RSGCore.Shared.Items[Config.itemRock], "remove")
        end

        TriggerClientEvent('ox_lib:notify', src, {title = 'Error', description =  Lang:t('error.destroyed_rock'), type = 'error' })

    end
end)

---------------------------
-- goldpaning
---------------------------

-- give reward
RegisterServerEvent('mms-mining:server:rewardgoldpaning')
AddEventHandler('mms-mining:server:rewardgoldpaning', function()
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    local foundgold = math.random(1,100)
    local firstname = Player.PlayerData.charinfo.firstname
    local lastname = Player.PlayerData.charinfo.lastname

    if foundgold < Config.GoldChance then
        local chance = math.random(1,100)
        if chance <= 50 then
            local item1 = Config.RewardPaning[math.random(1, #Config.RewardPaning)]
            -- add items
            Player.Functions.AddItem(item1, Config.SmallRewardAmount)
            TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items[item1], "add")

            TriggerClientEvent('ox_lib:notify', src, {title = 'Error', description =  Lang:t('error.no_gold_this_time'), type = 'inform' })

            -- webhook
            TriggerEvent('rsg-log:server:CreateLog', 'goldpanning', 'Gold Found 🌟', 'yellow', firstname..' '..lastname..' found a gold nugget!')

        elseif chance >= 50 and chance <= 100 then -- medium reward
            local item1 = Config.RewardPaning[math.random(1, #Config.RewardPaning)]
            local item2 = Config.RewardPaning[math.random(1, #Config.RewardPaning)]
            -- add items
            Player.Functions.AddItem(item1, Config.MediumRewardAmount)
            TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items[item1], "add")
            Player.Functions.AddItem(item2, Config.MediumRewardAmount)
            TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items[item2], "add")

            TriggerClientEvent('ox_lib:notify', src, {title = 'Success', description = Lang:t('success.jack_pot_small'), type = 'success' })

            -- webhook
            TriggerEvent('rsg-log:server:CreateLog', 'goldpanning', 'Gold Fever 🌟', 'yellow', firstname..' '..lastname..' found two gold nuggets!')
        end
    else

        TriggerClientEvent('ox_lib:notify', src, {title = 'Eroor', description = Lang:t('error.no_gold_this_time'), type = 'error' })

    end
end)

-- give hotspot reward
RegisterServerEvent('mms-mining:server:hotspotrewardgoldpaning')
AddEventHandler('mms-mining:server:hotspotrewardgoldpaning', function()
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    local foundgold = math.random(1,100)
    local firstname = Player.PlayerData.charinfo.firstname
    local lastname = Player.PlayerData.charinfo.lastname

        if foundgold < Config.HSGoldChance then
            local chance = math.random(1,100)
            if chance <= 50 then
                local item1 = Config.RewardPaning[math.random(1, #Config.RewardPaning)]
                -- add items
                Player.Functions.AddItem(item1, Config.HSSmallRewardAmount)
                TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items[item1], "add")

                TriggerClientEvent('ox_lib:notify', src, {title = 'Error', description =  Lang:t('error.no_gold_this_time'), type = 'error' })

                -- webhook
                TriggerEvent('rsg-log:server:CreateLog', 'goldpanning', 'Mega Gold Found 🌟', 'yellow', firstname..' '..lastname..' found a gold nugget!')
            end
            if chance >= 50 and chance <= 80 then -- medium reward
                local item1 = Config.RewardPaning[math.random(1, #Config.RewardPaning)]
                local item2 = Config.RewardPaning[math.random(1, #Config.RewardPaning)]
                -- add items
                Player.Functions.AddItem(item1, Config.HSMediumRewardAmount)
                TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items[item1], "add")
                Player.Functions.AddItem(item2, Config.HSMediumRewardAmount)
                TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items[item2], "add")

                TriggerClientEvent('ox_lib:notify', src, {title = 'Success', description = Lang:t('success.jack_pot_medium'), type = 'success' })

                -- webhook
                TriggerEvent('rsg-log:server:CreateLog', 'goldpanning', 'Mega Gold Fever 🌟', 'yellow', firstname..' '..lastname..' found two gold nuggets!')
            end
            if chance > 80 then -- large reward
                local item1 = Config.RewardPaning[math.random(1, #Config.RewardPaning)]
                local item2 = Config.RewardPaning[math.random(1, #Config.RewardPaning)]
                local item3 = Config.RewardPaning[math.random(1, #Config.RewardPaning)]

                -- add items
                Player.Functions.AddItem(item1, Config.HSLargeRewardAmount)
                TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items[item1], "add")
                Player.Functions.AddItem(item2, Config.HSLargeRewardAmount)
                TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items[item2], "add")
                Player.Functions.AddItem(item3, Config.HSLargeRewardAmount)
                TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items[item3], "add")

                TriggerClientEvent('ox_lib:notify', src, {title = 'Success', description = Lang:t('success.jack_pot_fever'), type = 'success' })

                -- webhook
                TriggerEvent('rsg-log:server:CreateLog', 'goldpanning', 'Mega Jackpot Gold Find 🌟', 'yellow', firstname..' '..lastname..' found three gold nuggets!')
            end
        else
            TriggerClientEvent('ox_lib:notify', src, {title = 'Error', description = Lang:t('error.no_gold_this_time'), type = 'error' })
    end
end)

--------------------------------------------------------------------------------------------------
-- start version check
--------------------------------------------------------------------------------------------------
CheckVersion()
