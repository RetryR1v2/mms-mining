local Translations = {
error = {
    you_dont_have_pickaxe = "você não possui uma picareta!",
    something_went_wrong = 'algo deu errado!',
    no_stone = 'You have no more stone to wash!',   -- Please translate
    destroyed_rock = 'You destroyed the rock. Luck ran out on this one! ',   -- Please translate
    failed_animation = 'Failed to load animation dictionary.',  -- Please translate
    try_again = 'Have you ever crafted before ?!',  -- Please translate
    missing_items = 'You dont have the required items.',  -- Please translate
    mounted = 'You are mounted.',  -- Please translate
    already_goldpanning = 'You are already Gold Panning.',  -- Please translate
    already_rockpanning = 'You are already Rock Panning.',  -- Please translate
    failed_goldpanning = 'Have you never used a Goldpan?',  -- Please translate
    failed_mining = 'Have you never used a pickaxe?',  -- Please translate
    you_are_busy = 'You are already doing something!',  -- Please translate
    no_gold_this_time = 'No Gold This Time.',  -- Please translate


},
success = {
    your_pickaxe_broke = 'sua picareta quebrou!',
    smelting_successful = 'Successfully extracted ',  -- Please translate
    item_picked_up = 'Your item is picked up',  -- Please translate
    item_set_up = 'Your gold smelt is deployed',  -- Please translate
    mining_action = 'Mining...',  -- Please translate
    jack_pot_fever = 'Bingo !! Got Some Goodies!',  -- Please translate
    jack_pot_medium = 'Got Some Good Gold.',  -- Please translate
    jack_pot_small = 'I guess this will do.',  -- Please translate
    rock_destroyed_but_item = 'Found something of use!',  -- Please translate
},
primary = {
    smelting_item = 'Smelting..', -- Please translate
    cancelation_failure = 'Smelting canceled or failed.',  -- Please translate
    need_river = 'You need the river to goldpan.',  -- Please translate
    rock_returned = 'There is more to this rock.',  -- Please translate
},
menu = {
    start = 'Iniciar ',  -- Please translate
    smelt_menu = 'Smelting Menu - ',  -- Please translate
    smelt_item = 'Smelt item',  -- Please translate
    smelt = 'Smelt',  -- Please translate
},
commands = {
    var = 'o texto vai aqui',
},
progressbar = {
    var = 'o texto vai aqui',
},
}

if GetConvar('rsg_locale', 'en') == 'pt-br' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
