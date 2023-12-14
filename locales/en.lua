local Translations = {
    error = {
        you_dont_have_pickaxe = "you don\'t have a pickaxe!",
        something_went_wrong = 'something went wrong!',
        no_stone = 'You have no more stone to wash!',
        destroyed_rock = 'You destroyed the rock. Luck ran out on this one! ',
        failed_animation = 'Failed to load animation dictionary.',
        try_again = 'Have you ever crafted before ?!',
        missing_items = 'You dont have the required items.',
        mounted = 'You are mounted.',
        already_goldpanning = 'You are already Gold Panning.',
        already_rockpanning = 'You are already Rock Panning.',
        failed_goldpanning = 'Have you never used a Goldpan?',
        failed_mining = 'Have you never used a pickaxe?',
        you_are_busy = 'You are already doing something!',
        no_gold_this_time = 'No Gold This Time.',
    },
    success = {
        your_pickaxe_broke = 'your pickaxe broke!',
        smelting_successful = 'Successfully extracted ',
        item_picked_up = 'Your item is picked up',
        item_set_up = 'Your gold smelt is deployed',
        mining_action = 'Mining...',
        jack_pot_fever = 'Bingo !! Got Some Goodies!',
        jack_pot_medium = 'Got Some Good Gold.',
        jack_pot_small = 'I guess this will do.',
        rock_destroyed_but_item = 'Found something of use!',
    },
    primary = {
        smelting_item = 'Smelting..',
        cancelation_failure = 'Smelting canceled or failed.',
        need_river = 'You need the river to pan.',
        rock_returned = 'There is more to this rock.',
    },
    menu = {
        start = 'Start ',
        smelt_menu = 'Smelting Menu - ',
        smelt_item = 'Smelt item',
        smelt = 'Smelt',
    },
    commands = {
        var = 'text goes here',
    },
    progressbar = {
        var = 'text goes here',
    },
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
