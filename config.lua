Config = {}

Config.defaultlang = "de_lang"
Config.LatestVORPInvetory = true -- Make you to Check your Version if you Are Up to Date Else set it to false
Config.Debug = false

-- Webhook Settings

Config.WebHook = false

Config.WHTitle = 'Mining:'
Config.WHLink = ''  -- Discord WH link Here
Config.WHColor = 16711680 -- red
Config.WHName = 'Mining:' -- name
Config.WHLogo = '' -- must be 30x30px
Config.WHFooterLogo = '' -- must be 30x30px
Config.WHAvatar = '' -- must be 30x30px

-- Script Settings

Config.ResetMiningTimer = 1 -- Time in minute to Reset Lumber

Config.MiningItem = 'pickaxe' -- Make sure its not used in Another Script in case it get Buggy then 
Config.MiningItem2 = 'stonepickaxe' -- Make sure its not used in Another Script in case it get Buggy then
Config.ItemUsage = 1 -- Usage Per Swing
Config.ItemMaxUses = 250 -- Max Durability
Config.ItemMaxUses2 = 250 -- Max Durability
Config.MineTime = 3500  -- Time in MS 5000 = 5 Sec
Config.ToolHash = 'p_pickaxe01x' -- Pickaxe Model

-- Repair Sytem 

Config.RepairItem = 'rock' -- Item To Repair the Tool
Config.RepairItemUsage = 1 -- 1 Item Needed to Repair
Config.RepairAmount = 150 -- How Much Durability Should be added.
Config.RepairTime = 5 -- Time in Sec
Config.CanMoreThenMaxUses = true

Config.Mines = {
    {
        MineName = 'Annesburg Mine',
        MinePosition = vector3(2751.11, 1322.59, 69.05),
        CreateBlip = true,
        BlipSprite = 'blip_ambient_hitching_post',
        MineRadius = 50,
        ForceMoveAfterMine = true, -- if true you need to move before can mine Again.
        ForceMoveDistance = 3, -- Move 3 Meters to Mine Again.
        AlwaysItem = { AlwaysGetItem = true, AlwaysItemName = 'rock', AlwaysItemLabel = 'Stein', AlwaysItemAmount = 4 },
        LuckyItem = true,
        LuckyItemsTable = { -- As Higher the Chance as Lower you get the item Chance 1 is 100%  
            { Item = 'coal', Label = 'Kohle', Amount = 4, Chance = 12 }, -- Its Between 1 and 20 5% Steps If you set it 20 its really Rare Chance to Get the item
            { Item = 'salt', Label = 'Salz', Amount = 4, Chance = 6 },
            { Item = 'rock', Label = 'Stein', Amount = 4, Chance = 17 },
        },
        JobMultiplier = true,
        JobBonus = {
            { Job = 'farmer', Multiplier = 2.0 },  -- 1 = 100% if you got on 0.5 then it makes less Reward for this Job so you can give more or Lower in case of job
            { Job = 'hunter', Multiplier = 1.5 },
            { Job = 'schmied1', Multiplier = 1.4 },
        },
    },
}

