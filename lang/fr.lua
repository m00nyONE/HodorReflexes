-- SPDX-FileCopyrightText: 2025 m00nyONE Melicious
-- SPDX-License-Identifier: Artistic-2.0

local strings = {

    ------------------------- CORE -------------------------
    -- VISIBILITY
    HR_VISIBILITY_SHOW_NEVER = "Jamais",
    HR_VISIBILITY_SHOW_ALWAYS = "Toujours",
    HR_VISIBILITY_SHOW_OUT_OF_COMBAT = "Hors combat",
    HR_VISIBILITY_SHOW_NON_BOSSFIGHTS = "Hors combat de Boss",
    HR_VISIBILITY_SHOW_IN_COMBAT = "Seulement en combat",
    -- HUD
    HR_CORE_HUD_COMMAND_LOCK_HELP = "Verrouiller l'interface (UI) de l'extension",
    HR_CORE_HUD_COMMAND_UNLOCK_HELP = "Déverrouiller l'interface (UI) de l'extension",
    HR_CORE_HUD_COMMAND_LOCK_ACTION = "Interface (UI) verrouillé",
    HR_CORE_HUD_COMMAND_UNLOCK_ACTION = "Interface (UI) déverrouillé",
    -- Group
    HR_CORE_GROUP_COMMAND_TEST_HELP = "Commencer/arrêter le test",
    HR_CORE_GROUP_COMMAND_TEST_ACTION_START = "Test commencé",
    HR_CORE_GROUP_COMMAND_TEST_ACTION_STOP = "Test arrêté",
    HR_CORE_GROUP_COMMAND_TEST_LEAVE_GROUP = "Vous devez quitter le groupe pour commencer le test",
    -- LibCheck
    HR_MISSING_LIBS_TITLE = "Obtenez l’expérience complète de HodorReflexes!",
    HR_MISSING_LIBS_TEXT = "|c00FF00Vous passez à côté de l’expérience complète de HodorReflexes!|r\n\nInstallez |cFFFF00LibCustomIcons|r et |cFFFF00LibCustomNames|r pour voir des icônes personnalisées, les pseudos et les styles personnalisés des autres utilisateurs de Hodor, y compris vos amis et les membres de votre guilde. Transformez le champ de bataille en quelque chose de personnel et plein de caractère!\n\nC’est entièrement facultatif et non requis pour le bon fonctionnement de HodorReflexes.",
    HR_MISSING_LIBS_TEXT_CONSOLE = "|c00FF00Vous passez à côté de l’expérience complète de HodorReflexes!|r\n\nInstallez |cFFFF00LibCustomNames|r pour voir les pseudos et les styles personnalisés des autres utilisateurs de Hodor, y compris vos amis et les membres de votre guilde. Transformez le champ de bataille en quelque chose de personnel et plein de caractère!\n\nC’est entièrement facultatif et non requis pour le bon fonctionnement de HodorReflexes.",
    HR_MISSING_LIBS_DONTSHOWAGAIN = "Ne plus afficher",
    -- Menu
    --HR_MENU_GENERAL = "General",
    --HR_MENU_MODULES = "Modules",
    --HR_MENU_EXTENSIONS = "Extensions",
    --HR_MENU_RESET_MESSAGE = "Reset complete! Some changes might require a /reloadui to take effect.",
    --HR_MENU_RELOAD = "Reload UI",
    --HR_MENU_RELOAD_TT = "Reloads the UI",
    --HR_MENU_RELOAD_HIGHLIGHT = "Settings highlighted in |cffff00yellow|r require a reload.",
    --HR_MENU_TESTMODE = "Toggle Test Mode",
    --HR_MENU_TESTMODE_TT = "Toggles the test mode for the addon. This does NOT work when you are in a group.",
    --HR_MENU_LOCKUI = "Lock UI",
    --HR_MENU_LOCKUI_TT = "Locks/Unlocks the addon UI.",
    --HR_MENU_ACCOUNTWIDE = "Account Wide Settings",
    --HR_MENU_ACCOUNTWIDE_TT = "If enabled, your settings will be saved account wide instead of per character.",
    --HR_MENU_ADVANCED_SETTINGS = "Advanced Settings",
    --HR_MENU_ADVANCED_SETTINGS_TT = "Allows you to customize more advanced settings.",
    --HR_MENU_HORIZONTAL_POSITION = "Horizontal Position",
    --HR_MENU_HORIZONTAL_POSITION_TT = "Adjust the horizontal position.",
    --HR_MENU_VERTICAL_POSITION = "Vertical Position",
    --HR_MENU_VERTICAL_POSITION_TT = "Adjust the vertical position.",
    --HR_MENU_SCALE = "Scale",
    --HR_MENU_SCALE_TT = "Set the scale.",
    --HR_MENU_DISABLE_IN_PVP = "Disable in PvP",
    --HR_MENU_DISABLE_IN_PVP_TT = "disable when in PvP.",
    --HR_MENU_VISIBILITY = "Visibility",
    --HR_MENU_VISIBILITY_TT = "Set when it should be visible.",
    --HR_MENU_LIST_WIDTH = "List Width",
    --HR_MENU_LIST_WIDTH_TT = "Set the width of the list.",
    -- general strings
    --HR_UNIT_SECONDS = "seconds",

    ------------------------- MODULES -------------------------
    -- DPS
    HR_MODULES_DPS_FRIENDLYNAME = "Dégâts",
    HR_MODULES_DPS_DESCRIPTION = "Vous permet de voir les statistiques des dégâts de votre groupe.",
    HR_MODULES_DPS_DAMAGE = "Dégâts",
    HR_MODULES_DPS_DAMAGE_TOTAL = "Dégâts totaux",
    HR_MODULES_DPS_DAMAGE_MISC = "Divers",
    HR_MODULES_DPS_DPS_BOSS = "DPS Boss",
    HR_MODULES_DPS_DPS_TOTAL = "DPS Total",
    --HR_MODULES_DPS_MENU_HEADER = "Damage List",
    --HR_MODULES_DPS_MENU_SHOW_SUMMARY = "Show Summary",
    --HR_MODULES_DPS_MENU_SHOW_SUMMARY_TT = "toggle the display of the summary row in the damage list.",
    --HR_MODULES_DPS_SUMMARY_GROUP_TOTAL = "Group Total: ",
    -- EXIT INSTANCE
    HR_MODULES_EXITINSTANCE_FRIENDLYNAME = "Quitter l'instance",
    HR_MODULES_EXITINSTANCE_DESCRIPTION = "Vous permet d’envoyer des demandes de sortie d’instance à votre groupe.",
    HR_MODULES_EXITINSTANCE_BINDING_SENDEJECT = "Expulser le groupe",
    HR_MODULES_EXITINSTANCE_BINDING_EXITINSTANCE = "Quitter l'instance immédiatemment",
    HR_MODULES_EXITINSTANCE_COMMAND_HELP = "Envoie une demande à votre groupe pour quitter l’instance actuelle.",
    HR_MODULES_EXITINSTANCE_NOT_LEADER = "Vous devez être le leader du groupe pour lancer une demande de sortie d’instance!",
    HR_MODULES_EXITINSTANCE_SENDEXITINSTANCE_DIALOG_TITLE = "Expulser le groupe",
    HR_MODULES_EXITINSTANCE_SENDEXITINSTANCE_DIALOG_TEXT = "Voulez-vous que tout le monde quitte l’instance (vous y compris)?",
    HR_MODULES_EXITINSTANCE_EXITINSTANCE_DIALOG_TITLE = "Quitter l'instance",
    HR_MODULES_EXITINSTANCE_EXITINSTANCE_DIALOG_TEXT = "Voulez-vous quitter l’instance immédiatement?",
    HR_MODULES_EXITINSTANCE_MENU_CONFIRM_EXIT = "Confirmez la sortie d'instance",
    HR_MODULES_EXITINSTANCE_MENU_CONFIRM_EXIT_TT = "Si cette option est activée, une confirmation vous sera demandée avant de quitter l’instance.",
    HR_MODULES_EXITINSTANCE_MENU_IGNORE_REQUESTS = "Ignorer les demandes de sortie d'instance",
    HR_MODULES_EXITINSTANCE_MENU_IGNORE_REQUESTS_TT = "Si cette option est activée, vous ignorerez toutes les demandes de sortie d’instance provenant de votre leader de groupe.",
    -- HIDEME
    --HR_MODULES_HIDEME_FRIENDLYNAME = "Hide Me",
    --HR_MODULES_HIDEME_DESCRIPTION = "Allows you to hide some of your stats from other group members lists.",
    --HR_MODULES_HIDEME_HIDEDAMAGE_LABEL = "Hide Damage",
    --HR_MODULES_HIDEME_HIDEDAMAGE_DESCRIPTION = "Hide your damage numbers from other group members dps list.",
    --HR_MODULES_HIDEME_HIDEHORN_LABEL = "Hide Horn",
    --HR_MODULES_HIDEME_HIDEHORN_DESCRIPTION = "Hide your horn from the lists.",
    --HR_MODULES_HIDEME_HIDECOLOS_LABEL = "Hide Colossus",
    --HR_MODULES_HIDEME_HIDECOLOS_DESCRIPTION = "Hide your colossus from the lists.",
    --HR_MODULES_HIDEME_HIDEATRO_LABEL = "Hide Atro",
    --HR_MODULES_HIDEME_HIDEATRO_DESCRIPTION = "Hide your atronach from the lists.",
    --HR_MODULES_HIDEME_HIDESAXHLEEL_LABEL = "Hide Saxhleel",
    --HR_MODULES_HIDEME_HIDESAXHLEEL_DESCRIPTION = "Hide your saxhleel from the lists.",
    --HR_MODULES_HIDEME_HIDEBARRIER_LABEL = "Hide Barrier",
    --HR_MODULES_HIDEME_HIDEBARRIER_DESCRIPTION = "Hide your barrier from the lists.",
    --HR_MODULES_HIDEME_MENU_HEADER = "Hide Me Options",
    -- PULL
    HR_MODULES_PULL_FRIENDLYNAME = "Compte à rebours avant de commencer le combat",
    HR_MODULES_PULL_DESCRIPTION = "Vous permet d’envoyer des comptes à rebours avant de commencer le combat à votre groupe.",
    HR_MODULES_PULL_BINDING_COUNTDOWN = "Compte à rebours avant de commencer le combat",
    HR_MODULES_PULL_COUNTDOWN_DURATION = "Durée du compte à rebours",
    HR_MODULES_PULL_COUNTDOWN_DURATION_TT = "Définissez la durée du compte à rebours avant de commencer le combat en secondes.",
    HR_MODULES_PULL_NOT_LEADER = "Vous devez être le leader du groupe pour lancer un compte à rebours!",
    HR_MODULES_PULL_COMMAND_HELP = "Démarre un compte à rebours avant de commencer le combat.",
    -- READYCHECK
    HR_MODULES_READYCHECK_FRIENDLYNAME = "Vérification de statut",
    HR_MODULES_READYCHECK_DESCRIPTION = "Améliore la vérification de statut en affichant qui a voté quoi.",
    HR_MODULES_READYCHECK_TITLE = "Vérification de statut",
    HR_MODULES_READYCHECK_READY = "Prêt",
    HR_MODULES_READYCHECK_NOT_READY = "Pas prêt",
    --HR_MODULES_READYCHECK_MENU_UI = "show ui",
    --HR_MODULES_READYCHECK_MENU_UI_TT = "Displays the readycheck window with the results.",
    HR_MODULES_READYCHECK_MENU_CHAT = "résultat dans le chat",
    HR_MODULES_READYCHECK_MENU_CHAT_TT = "Affiche les résultats de la vérification de statut dans le chat.",
    -- SKILL LINES
    HR_MODULES_SKILLLINES_FRIENDLYNAME = "Lignes de compétences",
    HR_MODULES_SKILLLINES_DESCRIPTION = "Vous permet de voir quelles lignes de compétences de sous-classe sont utilisées par les membres de votre groupe.",
    -- ULT
    HR_MODULES_ULT_FRIENDLYNAME = "Ultimes",
    HR_MODULES_ULT_DESCRIPTION = "Vous permet de voir les statistiques d’ultimes de votre groupe.",

    ------------------------- EXTENSIONS -------------------------
    -- ANIMATIONS
    --HR_EXTENSIONS_ANIMATIONS_FRIENDLYNAME = "Animations",
    --HR_EXTENSIONS_ANIMATIONS_DESCRIPTION = "Provides animated user icon support for lists via LibCustomIcons.",
    -- ICONS
    --HR_EXTENSIONS_ICONS_FRIENDLYNAME = "Icons",
    --HR_EXTENSIONS_ICONS_DESCRIPTION = "Extension to provide static user icons via LibCustomIcons.",
    -- NAMES
    --HR_EXTENSIONS_NAMES_FRIENDLYNAME = "Names",
    --HR_EXTENSIONS_NAMES_DESCRIPTION = "Extension to provide custom user names via LibCustomNames.",
    -- SEASONS
    --HR_EXTENSIONS_SEASONS_FRIENDLYNAME = "Seasons",
    --HR_EXTENSIONS_SEASONS_DESCRIPTION = "Seasonal events which change some behaviors of the addon on specific dates.",
    -- CONFIGURATOR
    --HR_EXTENSIONS_CONFIGURATOR_FRIENDLYNAME = "Configurator",
    --HR_EXTENSIONS_CONFIGURATOR_DESCRIPTION = "Allows you to request a custom name/icon yourself with an easy to use editor.",
    HR_MENU_ICONS_SECTION_CUSTOM = "Noms et icônes personnalisés",
    HR_MENU_ICONS_NOLIBSINSTALLED = "Pour profiter pleinement de HodorReflexes, veuillez vous assurer que les modules suivants sont installés :\n\n - |cFFFF00LibCustomIcons|r – Active les icônes personnalisées pour les joueurs.\n - |cFFFF00LibCustomNames|r – Affiche des noms personnalisés pour les amis, les membres de guilde et plus encore.\n\nCes modules améliorent l’expérience visuelle et permettent une plus grande personnalisation, mais ne sont pas nécessaires pour le fonctionnement de base. C’est à vous de choisir si vous souhaitez les installer ou non.",
    HR_MENU_ICONS_README_1 = "Avant de faire quoi que ce soit, veuillez lire ce guide attentivement ! Cela permettra de garantir que vous recevrez exactement ce à quoi vous vous attendez.\n",
    HR_MENU_ICONS_HEADER_ICONS = "Icônes et animations – Critères:",
    HR_MENU_ICONS_README_2 = "Veuillez respecter les limitations techniques suivantes pour vos fichiers:\n\n- Taille maximum: 32×32 pixels\n- Animations: maximum de 50 images\n- Formats de fichiers acceptés: .dds, .jpg, .png, .gif, .webp\n",
    HR_MENU_ICONS_HEADER_TIERS = "Niveaux de don:",
    HR_MENU_ICONS_README_3 = "Il existe trois niveaux de donation, chacun offrant des récompenses différentes:\n\n1. 5 millions de pièces d’or – nom personnalisé\n2. 7 millions de pièces d’or – nom personnalisé + icône statique\n3. 10 millions de pièces d’or – nom personnalisé + icône statique + icône animée\n\nVous pouvez sélectionner le niveau souhaité à l’aide du curseur ci-dessous. Il vous suffit de le déplacer sur la position 1 à 3, selon le niveau que vous voulez.\n",
    HR_MENU_ICONS_HEADER_CUSTOMIZE = "Personnalisez votre nom:",
    HR_MENU_ICONS_README_4 = "Utilisez le configurateur ci-dessous pour personnaliser votre nom.\n",
    HR_MENU_ICONS_HEADER_TICKET = "Créer un ticket sur Discord",
    HR_MENU_ICONS_README_5 = "1. Cliquez à l’intérieur de la zone de texte contenant le code LUA généré.\n2. Appuyez sur Ctrl + A pour tout sélectionner.\n3. Appuyez sur Ctrl + C pour copier le contenu.",
    HR_MENU_ICONS_README_6 = "\nEnsuite, ouvrez un ticket sur notre serveur Discord — choisissez le niveau que vous avez sélectionné — puis collez le code et l’icône dans le ticket.",
    HR_MENU_ICONS_HEADER_DONATION = "Envoi d’un don",
    HR_MENU_ICONS_README_7 = "Une fois que vous avez créé votre ticket sur Discord:\n\n1. Cliquez sur le bouton \"%s\".\n2. Entrez votre numéro de ticket dans le champ ticket-XXXXX.\n3. Envoyez les pièces d’or correspondant au niveau de don que vous avez sélectionné.",
    HR_MENU_ICONS_HEADER_INFO = "Informations:",
    HR_MENU_ICONS_INFO = "- Il s’agit d’un service basé sur les dons.\n- Vous n’achetez pas d'icônes et n’en acquérez aucuns droits dessus.\n- Il s’agit d’un don volontaire offrant des avantages cosmétiques dans le cadre des extensions utilisant LibCustomNames et LibCustomIcons.\n- Vous devez rester conforme aux conditions d’utilisation de ZoS - Les gros mots dans les noms ou les icônes inappropriées seront refusés!\n- Vous pouvez toujours envoyer des demandes de tirage (pull requests) sur GitHub avec votre icône et votre nom, sans aucun don requis, si vous savez coder.",
    HR_MENU_ICONS_CONFIGURATOR_DISCORD = "rejoindre Discord",
    HR_MENU_ICONS_CONFIGURATOR_DISCORD_TT = "Rejoignez le discord de HodorReflexes pour créer un ticket d’assistance.",
    HR_MENU_ICONS_README_DONATION_TIER = "Niveau de don: ",
    HR_MENU_ICONS_README_DONATION_TIER_TT = "En changeant le niveau de don, le code LUA dans le configurateur ci-dessous générera du code supplémentaire selon le niveau que vous choisissez.",
    HR_MENU_ICONS_CONFIGURATOR_LUA_TT = "Cliquez dans la zone de texte et appuyez sur Ctrl + A pour sélectionner tout le code, puis sur Ctrl + C pour copier le code dans votre presse-papiers.",
    HR_MENU_ICONS_CONFIGURATOR_DONATE_TT = "Ouvre la fenêtre de messagerie et y insère du texte.",
}

for id, val in pairs(strings) do
   ZO_CreateStringId(id, val)
   SafeAddVersion(id, 1)
end