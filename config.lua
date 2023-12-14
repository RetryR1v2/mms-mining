Config = {}

Config.Img = "rsg-inventory/html/images/"

---------------------------
-- goldpaning 
---------------------------

Config.itemGoldpan = "goldpan"
Config.itemRock = "rock"

-- set the amount of nuggets to give
Config.GoldChance = 60 -- (80 = 20% changce of not finding gold) / (70 = 30% changce of not finding gold).. and so on

-- set the amount of nuggets to give in hotspot
Config.HSSmallRewardAmount   = 1
Config.HSMediumRewardAmount  = 2
Config.HSHSLargeRewardAmount = 3
Config.HSGoldChance = 20 -- (70 = 30% changce of not finding gold

Config.HotspotZones = { 
    [1] = {
        zones = { 
            vector2(-2668.4643554688, -331.17501831055),
            vector2(-2676.6958007813, -345.48364257813),
            vector2(-2692.796875, -341.9401550293),
            vector2(-2691.8974609375, -334.74746704102)
        },
        minZ = 142.12985229492,
        maxZ = 143.64106750488
    },
    [2] = {
        zones = { 
            vector2(1542.0013427734, -7162.8862304688),
            vector2(1547.5384521484, -7171.96875),
            vector2(1556.6940917969, -7168.587890625),
            vector2(1550.9084472656, -7158.328125)
        },
        minZ = 62.612213134766,
        maxZ = 63.129043579102
    },
}

Config.WaterTypes = {
    [1] =  {["name"] = "San Luis River",      ["waterhash"] = -1504425495, ["watertype"] = "river"},
    [2] =  {["name"] = "Upper Montana River", ["waterhash"] = -1781130443, ["watertype"] = "river"},
    [3] =  {["name"] = "Owanjila",            ["waterhash"] = -1300497193, ["watertype"] = "river"},
    [4] =  {["name"] = "HawkEye Creek",       ["waterhash"] = -1276586360, ["watertype"] = "river"},
    [5] =  {["name"] = "Little Creek River",  ["waterhash"] = -1410384421, ["watertype"] = "river"},
    [6] =  {["name"] = "Dakota River",        ["waterhash"] = 370072007,   ["watertype"] = "river"},
    [7] =  {["name"] = "Beartooth Beck",      ["waterhash"] = 650214731,   ["watertype"] = "river"},
    [8] =  {["name"] = "Deadboot Creek",      ["waterhash"] = 1245451421,  ["watertype"] = "river"},
    [9] =  {["name"] = "Spider Gorge",        ["waterhash"] = -218679770,  ["watertype"] = "river"},
    [10] = {["name"] = "Roanoke Valley",      ["waterhash"] = -1229593481, ["watertype"] = "river"},
    [11] = {["name"] = "Lannahechee River",   ["waterhash"] = -2040708515, ["watertype"] = "river"},
    [12] = {["name"] = "Random1",             ["waterhash"] = 231313522,   ["watertype"] = "river"},
    [13] = {["name"] = "Random2",             ["waterhash"] = 2005774838,  ["watertype"] = "river"},
    [14] = {["name"] = "Random3",             ["waterhash"] = -1287619521, ["watertype"] = "river"},
    [15] = {["name"] = "Random4",             ["waterhash"] = -1308233316, ["watertype"] = "river"},
    [16] = {["name"] = "Random5",             ["waterhash"] = -196675805,  ["watertype"] = "river"},
    [17] = {["name"] = "Arroyo De La Vibora", ["waterhash"] = -49694339,   ["watertype"] = "river"},
}

Config.RewardPaning = {
    'coal',
    "rock",
    'wood',
    'stone',
}

---------------------------
-- smelt
---------------------------

Config.itemSmelt = "goldsmelt"
Config.UseGoldSmeltItem = true -- if false please remember to take out goldsmelt item if not using it and uncomment lines below in ```Config.SmeltOptions``` for gold smelt at founderies.
Config.AllowSmeltCanceling = true
Config.SmeltLocations = true -- can active 'true' / desactive 'false'

Config.SmeltingLocations = {
    { name = 'Smelter', coords = vector3(-370.5368, 795.87225, 115.66062), heading = 125.98059, minZ = 114.66062, maxZ = 117.66062, showblip = true },
    { name = 'Smelter', coords = vector3(-2396.335, -2376.617, 61.053844), heading = 355.44912, minZ = 59.29764,  maxZ = 63.29764,  showblip = true }, 
    { name = 'Smelter', coords = vector3(2516.4436, -1456.448, 46.146656), heading = 272.17373, minZ = 44.29764,  maxZ = 48.29764,  showblip = true },
    { name = 'Smelter', coords = vector3(-370.5368, 795.87225, 115.66062), heading = 125.98059, minZ = 114.66062, maxZ = 117.66062, showblip = true },
}

Config.SmeltOptions = {
    {
        category = "Ore",
        smelttime = 20000,
        smeltitems = {
            [1] = { item = "copper_ore", amount = 1 },
            [2] = { item = "coal", amount = 1 },
            [3] = { item = "wood", amount = 1 },
        },
        receive = "copper",
        giveamount = 1
    },
    {
        category = "Ore",
        smelttime = 20000,
        smeltitems = {
            [1] = { item = "aluminum_ore", amount = 1 },
            [2] = { item = "coal", amount = 2 },
            [3] = { item = "wood", amount = 1 },
        },
        receive = "aluminum",
        giveamount = 1
    },
    {
        category = "Ore",
        smelttime = 20000,
        smeltitems = {
            [1] = { item = "iron_ore", amount = 1 },
            [2] = { item = "coal", amount = 1 },
            [3] = { item = "water", amount = 1 },
        },
        receive = "iron",
        giveamount = 1
    },
    {
        category = "Ore",
        smelttime = 20000,
        smeltitems = {
            [1] = { item = "steel_ore", amount = 1 },
            [2] = { item = "coal", amount = 1 },
            [3] = { item = "wood", amount = 1 },
            [4] = { item = "water", amount = 2 },
        },
        receive = "steel",
        giveamount = 1
    }, 
     {
        category = "Ore",
        smelttime = 20000,
        smeltitems = {
            [1] = { item = "silver_ore", amount = 1 },
            [2] = { item = "rocksalt", amount = 1 },
            [3] = { item = "wood", amount = 1 },
        },
        receive = "silver",
        giveamount = 1
    },
    --[[
    {
        category = "Gold",
        smelttime = 20000,
        smeltitems = {
            [1] = { item = "largenugget", amount = 20 },
        },
        receive = "goldbar",
        giveamount = 1
    },
    {
        category = "Gold",
        smelttime = 20000,
        smeltitems = {
            [1] = { item = "mediumnugget", amount = 40 },
        },
        receive = "goldbar",
        giveamount = 1
    },
    {
        category = "Gold",
        smelttime = 20000,
        smeltitems = {
            [1] = { item = "smallnugget", amount = 80 },
        },
        receive = "goldbar",
        giveamount = 1
    },--]]
}

---------------------------
-- mining
---------------------------

-- settings
Config.KeyMining = 'J'
Config.itemMining = 'pickaxe'
Config.DoMiniGame = false
Config.SmallRewardAmount = 1
Config.MediumRewardAmount = 2
Config.MiningTime = 3000
Config.MarkerShowDistance = 10.0

-- set the item rewards
Config.RareAward = {
    'diamond', --- 3te stufe
    'ruby',      --- 3te stufe
    'emerald',    --- 3te stufe
    'goldore',    --- 3te stufe
    'silver_ore', --- 2te stufe
}

Config.UncommonAward = {
    'steel_ore',
    'rocksalt',  ---Check
    'copper_ore', --- 2te stufe
}

Config.Normal = {
    'rock',  ---Check
    'rocksalt',   ---Check
    'iron_ore',   --- 2te stufe
    'coal', --- 2te stufe
    'aluminum_ore',--- 2te stufe
}

-- mining locations

Config.MiningLocations = {
    {name = 'Mining', location = 'mining1',  coords = vector3(-1424.091, 1176.6002, 226.3431), showblip = true,  showmarker = true, target = false},
    {name = 'Mining', location = 'mining2',  coords = vector3(-1417.508, 1171.145, 226.57142), showblip = false, showmarker = true, target = false},
    {name = 'Mining', location = 'mining3',  coords = vector3(-1425.11, 1173.34, 226.22),      showblip = false, showmarker = true, target = false},
    {name = 'Mining', location = 'mining4',  coords = vector3(-1430.49, 1176.11, 226.33),      showblip = false, showmarker = true, target = false},
    {name = 'Mining', location = 'mining5',  coords = vector3(-1422.86, 1187.35, 225.47),      showblip = false, showmarker = true, target = false},
    {name = 'Mining', location = 'mining6',  coords = vector3(-1414.73, 1185.32, 225.48),      showblip = false, showmarker = true, target = false},
    {name = 'Mining', location = 'mining7',  coords = vector3(-1411.92, 1182.53, 225.55),      showblip = false, showmarker = true, target = false},
    {name = 'Mining', location = 'mining8',  coords = vector3(-1409.72, 1190.29, 225.46),      showblip = false, showmarker = true, target = false},
    {name = 'Mining', location = 'mining9',  coords = vector3(-1405.99, 1194.99, 225.37),      showblip = false, showmarker = true, target = false},
    {name = 'Mining', location = 'mining10', coords = vector3(-1415.83, 1197.11, 225.14),      showblip = false, showmarker = true, target = false},
    {name = 'Mining', location = 'mining11', coords = vector3(-1420.33, 1201.63, 225.36),      showblip = false, showmarker = true, target = false},
    {name = 'Mining', location = 'mining12', coords = vector3(-1429.2, 1202.06, 225.53),       showblip = false, showmarker = true, target = false},
    {name = 'Mining', location = 'mining13', coords = vector3(-1421.24, 1217.51, 222.45),      showblip = false, showmarker = true, target = false},
    {name = 'Mining', location = 'mining14', coords = vector3(-1412.51, 1212.7, 222.42),       showblip = false, showmarker = true, target = false},
    {name = 'Mining', location = 'mining15', coords = vector3(-1406.02, 1207.38, 222.87),      showblip = false, showmarker = true, target = false},
    {name = 'Mining', location = 'mining16', coords = vector3(-1415.12, 1201.39, 224.71),      showblip = false, showmarker = true, target = false},
    {name = 'Mining', location = 'mining17', coords = vector3(-1444.72, 1202.9, 226.33),       showblip = false, showmarker = true, target = false},
    {name = 'Mining', location = 'mining18', coords = vector3(-1446.54, 1195.84, 226.35),      showblip = false, showmarker = true, target = false},
    {name = 'Mining', location = 'mining19', coords = vector3(-1444.63, 1192.29, 226.44),      showblip = false, showmarker = true, target = false},
    {name = 'Mining', location = 'mining20', coords = vector3(-1400.83, 1175.13, 222.08),      showblip = false, showmarker = true, target = false},
    {name = 'Mining', location = 'mining21', coords = vector3(-1396.7, 1170.83, 222.19),       showblip = false, showmarker = true, target = false},
    {name = 'Mining', location = 'mining22', coords = vector3(-1393.61, 1171.83, 222.58),      showblip = false, showmarker = true, target = false},
    {name = 'Mining', location = 'mining23', coords = vector3(-1394.68, 1169.74, 222.38),      showblip = false, showmarker = true, target = false},
    {name = 'Mining', location = 'mining24', coords = vector3(-1387.02, 1182.16, 222.21),      showblip = false, showmarker = true, target = false},
    {name = 'Mining', location = 'mining25', coords = vector3(-1388.55, 1177.58, 221.88),      showblip = false, showmarker = true, target = false},
    {name = 'Mining', location = 'mining26', coords = vector3(-1392.99, 1186.0, 222.01),       showblip = false, showmarker = true, target = false},
    {name = 'Mining', location = 'mining27', coords = vector3(-1418.91, 1193.09, 225.37),      showblip = false, showmarker = true, target = false},
    {name = 'Mining', location = 'mining28', coords = vector3(-1393.31, 1185.81, 221.96),      showblip = false, showmarker = true, target = false},
    {name = 'Mining', location = 'mining29', coords = vector3(-223.31, 285.81, 221.96),      showblip = true, showmarker = true, target = false}, --- markus
}
