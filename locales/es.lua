local Translations = {
    error = {
        you_dont_have_pickaxe = "¡No tienes un pico!",
        something_went_wrong = '¡algo salió mal!',
        no_stone = 'No tienes mas piedra para lavar!',
        destroyed_rock = 'Destruistes la piedra, Ya no hay mas suerte con esta! ',
        failed_animation = 'Fallo el dictado de la animacion.',
        try_again = 'As crafteado antes ?!',
        missing_items = 'No tienes los articulos requeridos.',
        mounted = 'Estas a Caballo.',
        already_goldpanning = 'Ya estas bandejeando.',
        already_rockpanning = 'Ya estas bandejeando.',
        failed_goldpanning = 'As bandejeado antes ?',
        failed_mining = 'As usado un pico antes ?',
        you_are_busy = 'Ya estas ocupado!',
        no_gold_this_time = 'Esta vez no hay suerte.',
    },
    success = {
        your_pickaxe_broke = '¡Se rompió el pico!',
        smelting_successful = 'Extgraistes con exito ',
        item_picked_up = 'Recojistes tu articulo.',
        item_set_up = 'Su horneador esta Ajustado.',
        mining_action = 'Minando...',
        jack_pot_fever = 'Bingo !! La suerte esta conmigo!',
        jack_pot_medium = 'No es Mucho Pero es mejor que nada.',
        jack_pot_small = 'Algo es Algo.',
        rock_destroyed_but_item = 'Algo de algun uso!',
    },
    primary = {
        smelting_item = 'Horneando..', -- Please translate
        cancelation_failure = 'Horneo Cancelado o Fallado.',
        need_river = 'Nesecitas el Rio para bandejear.',
        rock_returned = 'Trataremos de nuevo.',
    },
    menu = {
        start = 'Iniciar ',
        smelt_menu = 'Menu De Horneo - ',
        smelt_item = 'Hornear Articulo',
        smelt = 'Hornear',
    },
    commands = {
        var = 'text goes here',
    },
    progressbar = {
        var = 'text goes here',
    },
}

if GetConvar('rsg_locale', 'en') == 'es' then
    Lang = Locale:new({
      phrases = Translations,
      warnOnMissing = true,
      fallbackLang = Lang,
  })
end
