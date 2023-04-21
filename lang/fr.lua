-- French translation by @Castel2511
-- Updated translation by @XXXspartiateXXX (2022/05)

local strings = {

	-------------------------
	-- MENUS
	-------------------------

	HR_MENU_GENERAL = "Général",
	HR_MENU_GENERAL_ENABLED = "Activer",
	HR_MENU_GENERAL_ENABLED_TT = "Active/Désactive cet addon. Lorsque cette option est désactivée, l'addon cessera de fonctionner et empêchera les pings de carte des autres joueurs.",
	HR_MENU_GENERAL_UI_LOCKED = "Interface Utilisateur verrouillée",
	HR_MENU_GENERAL_UI_LOCKED_TT = "Déverrouiller l'interface de l'utilisateur pour afficher tous les contrôles activés. Si vous n'êtes pas groupé, vous pouvez taper\n |cFFFF00/hodor.share test|r dans le Tchat pour remplir les contrôles avec des données de test.",
	HR_MENU_GENERAL_ACCOUNT_WIDE = "Paramètres communs au compte",
	HR_MENU_GENERAL_ACCOUNT_WIDE_TT = "Bascule entre les paramètres du compte et les paramètres du personnage.",
	HR_MENU_GENERAL_DISABLE_PVP = "Désactiver en PvP",
	HR_MENU_GENERAL_DISABLE_PVP_TT = "Désactive l'addon dans les zones PvP",
	HR_MENU_GENERAL_EXIT_INSTANCE = "Confirmer la sortie de l'instance",
	HR_MENU_GENERAL_EXIT_INSTANCE_TT = "Affiche la boîte de dialogue de confirmation avant de quitter l'instance actuelle par une demande du chef du groupe ou avec un raccourci clavier.",

	HR_MENU_DAMAGE = "Dégâts",
	HR_MENU_DAMAGE_SHOW = "Afficher les dégâts:",
	HR_MENU_DAMAGE_SHOW_TT = "Affiche la liste des dégâts du groupe.",
	HR_MENU_DAMAGE_SHOW_NEVER = "Jamais",
	HR_MENU_DAMAGE_SHOW_ALWAYS = "Toujours",
	HR_MENU_DAMAGE_SHOW_OUT = "Hors combat",
	HR_MENU_DAMAGE_SHOW_NONBOSS = "Combat sans boss",
	HR_MENU_DAMAGE_SHARE = "Partager le DPS:",
	HR_MENU_DAMAGE_SHARE_TT = "Envoye vos dégâts aux membres du groupe.",

	HR_MENU_HORN = "Cor de Guerre",
	HR_MENU_HORN_SHOW = "Afficher les Cors de Guerre:",
	HR_MENU_HORN_SHOW_TT = "Affiche la liste des Ultimes du groupe.",
	HR_MENU_HORN_SHARE = "Partager votre Ultime:",
	HR_MENU_HORN_SHARE_TT = "Envoye les % de votre Ultime aux membres du groupe. Lorsque vous utilisez les options Saxhleel avec l'ensemble Champion Saxhleel équipé, vous n'avez pas besoin d'un Cor de Guerre. L'addon partagera soit votre coût Ultime le plus élevé, soit seulement 250 points Ultimes.",
	HR_MENU_HORN_SHARE_NONE = "Désactivé",
	HR_MENU_HORN_SHARE_HORN = "Cor de Guerre",
	HR_MENU_HORN_SHARE_SAXHLEEL1 = "Cor ou Saxhleel (coût le plus élevé)",
	HR_MENU_HORN_SHARE_SAXHLEEL250 = "Cor ou Saxhleel (250 points)",
	HR_MENU_HORN_SELFISH = "Mode personnel:",
	HR_MENU_HORN_SELFISH_TT = "Lorsque cette option est activée, vous ne verrez la durée restante du Cor que si vous avez bénéficié de son effet.",
	HR_MENU_HORN_ICON = "Afficher l'icône:",
	HR_MENU_HORN_ICON_TT = "Affiche une icône avec le nombre de joueurs dans les 20 mètres de portée quand le Cor est disponible.\nL'icône devient |c00FF00verte|r lorsque tous les DD sont à portée.\nL'icône verte devient |cFFFF00jaune|r si un joueur est plus haut dans la liste des Cors. Annoncez votre Cor !",
	HR_MENU_HORN_COUNTDOWN_TYPE = "Type de Compte à rebours:",
	HR_MENU_HORN_COUNTDOWN_TYPE_TT = "- Aucun: pas de Compte à rebours.\n- Personnel: Compte à rebours uniquement pour mon Cor/Force Majeure.\n- Tous: Compte à rebours pour tous les Cors/Forces Majeures (Mode chef du raid).",
	HR_MENU_HORN_COUNTDOWN_TYPE_NONE = "Aucun",
	HR_MENU_HORN_COUNTDOWN_TYPE_SELF = "Cor de Guerre (personnel)",
	HR_MENU_HORN_COUNTDOWN_TYPE_ALL = "Cor de Guerre (tous)",
	HR_MENU_HORN_COUNTDOWN_TYPE_FORCE_SELF = "Force Majeure (personnel)",
	HR_MENU_HORN_COUNTDOWN_TYPE_FORCE_ALL = "Force Majeure (tous)",
	HR_MENU_HORN_COUNTDOWN_COLOR = "Couleur du texte:",

	HR_MENU_COLOS = "Colosse",
	HR_MENU_COLOS_SHOW = "Afficher les Colosses:",
	HR_MENU_COLOS_SHOW_TT = "Affiche la liste des Ultimes du groupe.",
	HR_MENU_COLOS_SHARE = "Partager votre Ultime:",
	HR_MENU_COLOS_SHARE_TT = "Envoye les % de votre Ultime aux membres du groupe (uniquement avec Colosse).",
	HR_MENU_COLOS_PRIORITY = "Priorité:",
	HR_MENU_COLOS_PRIORITY_TT = "- Par défaut: l'Ultime est calculé en % (200 max).\n- Rôle Tank: affiche 201% si votre rôle est tank et que votre Ultime est prêt.\n- Toujours: affiche 201% quand votre Ultime est prêt.\n- Jamais: affiche 99% ou moins.\n|cFFFFFFNOTE: affiche 99% ou 201% au lieu de 100% et affecte également votre % de Cor si vous le partagez également.|r",
	HR_MENU_COLOS_PRIORITY_DEFAULT = "Par défaut",
	HR_MENU_COLOS_PRIORITY_TANK = "Rôle Tank",
	HR_MENU_COLOS_PRIORITY_ALWAYS = "Toujours",
	HR_MENU_COLOS_PRIORITY_NEVER = "Jamais",
	HR_MENU_COLOS_SUPPORT_RANGE = "Alliés proches:",
	HR_MENU_COLOS_SUPPORT_RANGE_TT = "Les joueurs trop éloignés ne seront pas dans la liste.",
	HR_MENU_COLOS_COUNTDOWN = "Afficher le Compte à rebours:",
	HR_MENU_COLOS_COUNTDOWN_TT = "Affiche une notification avec un décompte pour lancer votre Ultime.",
	HR_MENU_COLOS_COUNTDOWN_TEXT = "Texte du Compte à rebours:",
	HR_MENU_COLOS_COUNTDOWN_COLOR = "Couleur du texte:",

	HR_MENU_MISC = "Divers",
	HR_MENU_MISC_DESC = "Pour afficher/masquer un exemple de liste de joueurs taper |c999999/hodor.share test|r dans le Tchat.\nVous pouvez choisir quel pseudo afficher en tapant leur pseudo:\n|c999999/hodor.share test @andy.s @Alcast @Castel2511|r",

	HR_MENU_ICONS = "Icônes",
	HR_MENU_ICONS_README = "Lisez-moi (Cliquez pour ouvrir)",
	HR_MENU_ICONS_MY = "Mon icône",
	HR_MENU_ICONS_NAME_VAL = "Nom personnalisé",
	HR_MENU_ICONS_NAME_VAL_TT = "Par défaut, l'addon indique votre nom de compte. Vous pouvez le modifier ici.",
	HR_MENU_ICONS_GRADIENT = "Dégradé",
	HR_MENU_ICONS_GRADIENT_TT = "Crée un dégradé basé sur les couleurs ci-dessous.",
	HR_MENU_ICONS_COLOR1 = "Couleur de départ",
	HR_MENU_ICONS_COLOR2 = "Couleur de fin",
	HR_MENU_ICONS_PREVIEW = "Prévisualisation",
	HR_MENU_ICONS_LUA = "LUA code:",
	HR_MENU_ICONS_LUA_TT = "Vous devrez peut-être redémarrer le jeu (pas seulement /reloadui) lorsque vous modifiez le chemin de l'icône. Envoyez ce code à l'auteur de l'addon avec votre fichier d'icône.",
	HR_MENU_ICONS_VISIBILITY = "Visibilité",
	HR_MENU_ICONS_VISIBILITY_HORN = "Icônes du Cor de Guerre",
	HR_MENU_ICONS_VISIBILITY_HORN_TT = "Affiche les icônes personnalisées dans la liste des Cors.",
	HR_MENU_ICONS_VISIBILITY_DPS = "Icônes des Dégats",
	HR_MENU_ICONS_VISIBILITY_DPS_TT = "Affiche les icônes personnalisées dans la liste des dégâts.",
	HR_MENU_ICONS_VISIBILITY_COLOS = "Icônes du Colosse",
	HR_MENU_ICONS_VISIBILITY_COLOS_TT = "Affiche les icônes personnalisées dans la liste des Colosses.",
	HR_MENU_ICONS_VISIBILITY_COLORS = "Noms colorés",
	HR_MENU_ICONS_VISIBILITY_COLORS_TT = "Noms colorés des autres joueurs.",
	HR_MENU_ICONS_VISIBILITY_ANIM = "Icônes animées",
	HR_MENU_ICONS_VISIBILITY_ANIM_TT = "Affiche les icônes animées. Note: désactiver cette fonction n'augmentera pas vos FPS.",

    HR_MENU_ICONS_README1 = "Utiliser les paramètres ci-dessous pour personnaliser votre nom et votre icône dans l'addon. Ce n'est qu'un aperçu, ce qui signifie que personne ne verra vos modifications tant que vous n'aurez pas envoyé le code LUA généré à l'auteur de l'addon.",
	HR_MENU_ICONS_README2 = "Le jeu ne prend en charge que le format de fichier DirectDraw Surface pour les images, et les dimensions requises par l'addon sont de 32x32 px. Vous pouvez ignorer cette partie si cela semble compliqué et envoyer simplement le fichier original avec votre code LUA.",
	HR_MENU_ICONS_README3 = "Cliquez sur \"%s\" en haut de ce menu pour obtenir des instructions plus détaillées sur la manière de contacter l'auteur et d'obtenir une icône personnelle. S'il vous plaît, utilisez uniquement les e-mails en jeu pour les dons d'or. Vous n'aurez pas de réponses là-bas!",

	HR_MENU_STYLE = "Style",
	HR_MENU_STYLE_PINS = "Afficher les pings de carte",
	HR_MENU_STYLE_PINS_TT = "Affiche les pings des joueurs sur la carte du monde et le compas.",
	HR_MENU_STYLE_DPS = "Liste du DPS",
	HR_MENU_STYLE_DPS_FONT = "Police des nombres:",
	HR_MENU_STYLE_DPS_FONT_DEFAULT = "Par défaut",
	HR_MENU_STYLE_DPS_FONT_GAMEPAD = "Manette",
	HR_MENU_STYLE_DPS_BOSS_COLOR = "Couleur des dégâts sur le Boss:",
	HR_MENU_STYLE_DPS_TOTAL_COLOR = "Couleur des dégâts totaux:",
	HR_MENU_STYLE_DPS_HEADER_OPACITY = "Opacité de l'en-tête:",
	HR_MENU_STYLE_DPS_EVEN_OPACITY = "Opacité des lignes paires:",
	HR_MENU_STYLE_DPS_ODD_OPACITY = "Opacité des lignes impaires:",
	HR_MENU_STYLE_DPS_HIGHLIGHT = "Couleur surlignée:",
	HR_MENU_STYLE_DPS_HIGHLIGHT_TT = "Surligne votre pseudo dans la liste par la couleur sélectionnée. Si vous ne souhaitez pas surligner votre pseudo, réduisez l'opacité à 0. Vous êtes le seul joueur à voir le surlignage.",
	HR_MENU_STYLE_HORN_COLOR = "Couleur de la durée du Cor de Guerre",
	HR_MENU_STYLE_FORCE_COLOR = "Couleur de la durée de Force Majeure",
	HR_MENU_STYLE_COLOS_COLOR = "Couleur de la durée du Colosse",
	HR_MENU_STYLE_TIMER_OPACITY = "Opacité à expiration du temps",
	HR_MENU_STYLE_TIMER_OPACITY_TT = "Opacité du texte et des icônes lorsqu'une minuterie atteint zéro (0,0).",
	HR_MENU_STYLE_TIMER_BLINK = "Minuteries clignotantes",
	HR_MENU_STYLE_TIMER_BLINK_TT = "Les minuteurs clignotent d'abord lorsqu'ils atteignent 0 seconde, puis l'opacité est appliquée.",

    HR_MENU_ANIMATIONS = "Messages animés",
	HR_MENU_ANIMATIONS_TT = "Anime les Comptes à rebours des Colosses et des Cornes pour les rendre plus visibles.",

	HR_MENU_VOTE = "Vote",
	HR_MENU_VOTE_DISABLED = "Cette fonction requiert que Hodor Reflexes soit actif !",
	HR_MENU_VOTE_DESC = "Cette fonction améliore la vérification du jeu et permet de voir qui est prêt ou non si les membres du groupe ont Hodor Reflexes actif.",
	HR_MENU_VOTE_ENABLED_TT = "Active/Désactive cette fonction. Lorsque cette option est désactivée, les autres joueurs ne verront pas votre vote.",
	HR_MENU_VOTE_CHAT = "Messages dans le Tchat",
	HR_MENU_VOTE_CHAT_TT = "Affiche le résultat du vote dans le Tchat ainsi que quelques autres informations.",
	HR_MENU_VOTE_ACTIONS = "Actions",
	HR_MENU_VOTE_ACTIONS_RC = "Appel de préparation",
	HR_MENU_VOTE_ACTIONS_RC_TT = "Lance un appel pour vérifier si tous les joueurs sont prêts.",
	HR_MENU_VOTE_ACTIONS_COUNTDOWN = "Compte à rebours",
	HR_MENU_VOTE_ACTIONS_COUNTDOWN_TT = "Déclenche un compte à rebours de 5 secondes quand tout le groupe est prêt.\nIl faut être le chef du groupe pour le lancer.",
	HR_MENU_VOTE_ACTIONS_COUNTDOWN_CONFIRM = "Vous devez être le Chef du groupe pour lancer un compte à rebours!",
	HR_MENU_VOTE_ACTIONS_LEADER = "Remplacer le Chef du groupe par",
	HR_MENU_VOTE_ACTIONS_LEADER_TT = "Requiert 60% de Oui des membres du groupe.",
	HR_MENU_VOTE_ACTIONS_LEADER_CONFIRM = "Devient le Chef du groupe",
	HR_MENU_VOTE_COUNTDOWN_DURATION = "Durée du Compte à rebours",


    HR_MENU_MISC_TOXIC = "Mode toxique",
	HR_MENU_MISC_TOXIC_TT = "Des allusions moqueuses et tout ça.",

	-------------------------
	-- RACCOURCIS
	-------------------------

	HR_BINDING_HORN_SHARE = "Active/Désactive le partage de Cor",
	HR_BINDING_COLOS_SHARE = "Active/Désactive le partage de Colosse",
	HR_BINDING_DPS_SHARE = "Active/Désactive le partage des dégâts",
	HR_BINDING_COUNTDOWN = "Compte à rebours",
	HR_BINDING_EXIT_INSTANCE = "Quitter l'instance immédiatement",
	HR_BINDING_SEND_EXIT_INSTANCE = "Expulsion du groupe",

	-------------------------
	-- FONCTION DE PARTAGE
	-------------------------

    HR_SEND_EXIT_INSTANCE = "Expulsion du groupe",
	HR_SEND_EXIT_INSTANCE_CONFIRM = "Voulez-vous que tout le monde quitte l'instance (y compris vous-même) ?",

	HR_COLOS_COUNTDOWN_DEFAULT_TEXT = "ULT",
	HR_MAJOR_FORCE = "Force Maj.",
	HR_HORN = "Cor",
	HR_COLOS = "Colosse",

	-- Titre de la liste des dégâts
	HR_DAMAGE = "Dégâts",
	HR_TOTAL_DAMAGE = "Dégâts Totaux",
	HR_MISC_DAMAGE = "Divers",
	HR_BOSS_DPS = "DPS sur le Boss",
	HR_TOTAL_DPS = "DPS Total",

	HR_NOW = "MAINTENANT", -- HORN/COLOS: MAINTENANT!

	HR_TEST_STARTED = "Test lancé.",
	HR_TEST_STOPPED = "Test arrêté.",
	HR_TEST_LEAVE_GROUP = "Vous devez quittez le groupe pour tester.",

	-------------------------
	-- FONCTION DE VOTE
	-------------------------

	HR_READY_CHECK = "Appel de préparation",
	HR_READY_CHECK_READY = "Tout le monde est prêt !",
	HR_COUNTDOWN = "Compte à rebours",
	HR_COUNTDOWN_START = "Départ dans",
	HR_READY_CHECK_INIT_CHAT = "a lancé un Appel de préparation",
	HR_COUNTDOWN_INIT_CHAT = "a lancé un compte à rebours",
	HR_VOTE_NOT_READY_CHAT = "n'est pas prêt",
	HR_VOTE_LEADER_CHAT = "veut changer le Chef du groupe",

	-------------------------
	-- MOCK
	-------------------------

    HR_MOCK1 = "Imagine mourir avec tous ces addons activés.",
    HR_MOCK2 = "Essaye d'équiper le Gros Chudan, le Médecin de la Peste, et l'Harnachement de l'Apiculteur.",
    HR_MOCK3 = "Vas-tu encore accuser le serveur ?",
    HR_MOCK4 = "Mauvaise instance, évidemment !",
    HR_MOCK5 = "Tu devrais plutôt essayer de tank ou heal.",
    HR_MOCK6 = "As-tu manqué la notification de l'addon ?",
    HR_MOCK7 = "Vous êtes le maillon faible. Au revoir.",
    HR_MOCK8 = "Tu devrais peux-être envisager le fait d'acheter un carry plutôt.",
    HR_MOCK9 = "Tu devrais peux-être envisager le fait d'utiliser une rotation de barrières.",
    HR_MOCK10 = "Nous n'avons plus d'indices pour vous éviter de mourir.",
    HR_MOCK11 = "Si tu veux faire quelque chose d'utile, regarde la boutique à couronnes.",
    HR_MOCK12 = "Les performances du jeu sont mauvaises, mais les tiennes sont pires.",
    HR_MOCK13 = "Tu es bon a être mauvais.",
    HR_MOCK14 = "Essaye d'installer plus d'addons pour te carry.",
    HR_MOCK15 = "Tes APM sont trop basses pour ce combat.",
    HR_MOCK16 = "Ne t'inquète pas, nous ajouterons peux-être les succés de ce raid dans la boutique à couronnes.",
    HR_MOCK17 = "La folie c'est de faire toujours la même chose et de s'attendre à un résultat différent.",
	HR_MOCK18 = "Tes APM sont trop basses pour ce combat.",
	HR_MOCK19 = "Imagine mourir avec tous ces addons activés.",
	HR_MOCK20 = "Vous êtes le maillon faible. Au revoir.",
    HR_MOCK_AA1 = "Imagine mourir dans du contenu vieux de six ans.",
    HR_MOCK_EU1 = "Pourquoi joues-tu sur le serveur EU ?",
    HR_MOCK_NORMAL1 = "Ce n'est même pas le mode vétéran...",
    HR_MOCK_VET1 = "Envisage le fait de passer en difficulté normal.",

    -------------------------
	-- QUITTER L'INSTANCE
	-------------------------

	HR_EXIT_INSTANCE = "Quitter l'instance",
	HR_EXIT_INSTANCE_CONFIRM = "Voulez-vous quitter l'instance actuelle ?",
	
	-------------------------
	-- MISE À JOUR
	-------------------------

	HR_UPDATED_TEXT = "Hodor Reflexes a été mis à jour avec succès, ou peut-être pas ? Malheureusement, lors de la mise à jour via Minion, il y a une chance modérée que certains fichiers disparaissent. Habituellement, ce ne sont que des icônes, généralement... Voici donc un petit test de cinq images provenant de différents dossiers d'extensions. Si vous ne les voyez pas tous, vous devez fermer le jeu et réinstaller l'addon. Sinon, ignorez simplement ce message, il n'apparaîtra plus.",
	HR_UPDATED_DISMISS = "Je vois cinq icônes !",

	HR_MISSING_ICON = "Impossible de charger votre icône Hodor Reflexes. Réinstallez l'addon ou téléchargez-le manuellement depuis esoui.com et redémarrez le jeu.",

}

for id, val in pairs(strings) do
	SafeAddString(_G[id], val, 1)
end