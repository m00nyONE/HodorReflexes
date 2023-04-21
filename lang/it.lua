-- Italian translation by @Dusty_82

local strings = {

	-------------------------
	-- MENUS
	-------------------------

	HR_MENU_GENERAL = "Generale",
	HR_MENU_GENERAL_ENABLED = "Abilita",
	HR_MENU_GENERAL_ENABLED_TT = "Abilita/Disabilita questo addon. Quando è disabilitato, l'addon non elaborerà e non mostrerà i ping nella mappa in arrivo dagli altri giocatori.",
	HR_MENU_GENERAL_UI_LOCKED = "Blocca UI",
	HR_MENU_GENERAL_UI_LOCKED_TT = "Sblocca l'UI per mostrare tutti i controlli abilitati. Se non sei raggruppato, allora puoi digitare\n |cFFFF00/hodor.share test|r nella chat per sbloccare i controlli con i dati di test.",
	HR_MENU_GENERAL_ACCOUNT_WIDE = "Impostazioni Intero Account",
	HR_MENU_GENERAL_ACCOUNT_WIDE_TT = "Passa dalle impostazioni globali dell'account a quelle del personaggio.",
	HR_MENU_GENERAL_DISABLE_PVP = "Disabilita in PvP",
	HR_MENU_GENERAL_DISABLE_PVP_TT = "Disabilita questo addon per le zone di PvP.",
	HR_MENU_GENERAL_EXIT_INSTANCE = "Conferma Uscita Istanza",
	HR_MENU_GENERAL_EXIT_INSTANCE_TT = "Mostra un dialogo di conferma prima di uscire dall'istanza corrente tramite una richiesta del capogruppo o con un tasto di scelta rapida.",

	HR_MENU_DAMAGE = "Danno",
	HR_MENU_DAMAGE_SHOW = "Mostra Danno:",
	HR_MENU_DAMAGE_SHOW_TT = "Mostra l'elenco con i danni del gruppo.",
	HR_MENU_DAMAGE_SHARE = "Condividi DPS:",
	HR_MENU_DAMAGE_SHARE_TT = "Invia i tuoi danni ai membri del gruppo.",

	HR_MENU_HORN = "Corno da Guerra",
	HR_MENU_HORN_SHOW = "Mostra i Corni di Guerra:",
	HR_MENU_HORN_SHOW_TT = "Mostra l'elenco con le abilità finali del gruppo.",
	HR_MENU_HORN_SHARE = "Condividi Mossa Finale:",
	HR_MENU_HORN_SELFISH = "Modalità Egoista:",
	HR_MENU_HORN_SELFISH_TT = "Quando è abilitato, vedrai la durata rimanente del corno solo se hai un buff attivo su di esso.",
	HR_MENU_HORN_ICON = "Mostra Icona:",
	HR_MENU_HORN_ICON_TT = "Mostra un'icona con un numero di persone nel raggio di 20 metri quando il tuo corno è pronto.\nL'icona diventa |c00FF00verde|r quando tutti i DD sono nel raggio del corno.\nL'icona verde diventa |cFFFF00gialla|r se qualcuno è più in alto di te nella lista dei corni. Annuncia il tuo corno!",
	HR_MENU_HORN_COUNTDOWN_TYPE = "Tipo di Contatore:",
	HR_MENU_HORN_COUNTDOWN_TYPE_TT = "- Nessuno: nessun conto alla rovescia.\n- Me: conto alla rovescia solo per il mio corno/forza maggiore.\n- Tutti: conto alla rovescia per ogni corno/forza maggiore (modalità raid lead).",
	HR_MENU_HORN_COUNTDOWN_TYPE_NONE = "Nessuno",
	HR_MENU_HORN_COUNTDOWN_TYPE_SELF = "Corno da Guerra (me)",
	HR_MENU_HORN_COUNTDOWN_TYPE_ALL = "Corno da Guerra (tutti)",
	HR_MENU_HORN_COUNTDOWN_TYPE_FORCE_SELF = "Foza Maggiore (me)",
	HR_MENU_HORN_COUNTDOWN_TYPE_FORCE_ALL = "Forza maggiore (tutti)",
	HR_MENU_HORN_COUNTDOWN_COLOR = "Colore Testo del Conto alla Rovescia",

	HR_MENU_COLOS = "Colosso",
	HR_MENU_COLOS_SHOW = "Mostra Colosso:",
	HR_MENU_COLOS_SHOW_TT = "Mostra l'elenco con le abilità finali del gruppo.",
	HR_MENU_COLOS_SHARE = "Condividi Mossa Finale:",
	HR_MENU_COLOS_SHARE_TT = "Invia la tua % abilità finale ai membri del gruppo (solo quando il Colosso è inserito).",
	HR_MENU_COLOS_PRIORITY = "Priorità:",
	HR_MENU_COLOS_PRIORITY_TT = "- Predefinito: abilità massima % è 200.\n- Ruolo Tank: invia il 201% se il tuo ruolo è tank e hai il colosso pronto.\n- Sempre: invia il 201% quando la tua abilità è pronta.\n- Mai: inviare il 99% o meno.\n|cFFFFFFNOTA: inviare il 99% o il 201% invece del 100% influenzerà anche la % del corno se si condividono entrambe le abilità finali.|r",
	HR_MENU_COLOS_PRIORITY_DEFAULT = "Predefinito",
	HR_MENU_COLOS_PRIORITY_TANK = "Ruolo Tank",
	HR_MENU_COLOS_PRIORITY_ALWAYS = "Sempre",
	HR_MENU_COLOS_PRIORITY_NEVER = "Mai",
	HR_MENU_COLOS_SUPPORT_RANGE = "Mostra solo Alleati Vicini:",
	HR_MENU_COLOS_SUPPORT_RANGE_TT = "I giocatori che sono troppo lontani da te saranno nascosti nella lista.",
	HR_MENU_COLOS_COUNTDOWN = "Mostra Contatore:",
	HR_MENU_COLOS_COUNTDOWN_TT = "Mostra una notifica con un conto alla rovescia per usare la tua abilità finale",
	HR_MENU_COLOS_COUNTDOWN_TEXT = "Testo Contatore:",
	HR_MENU_COLOS_COUNTDOWN_COLOR = "Colore Testo del Contatore:",

	HR_MENU_MISC = "Varie",
	HR_MENU_MISC_DESC = "Per mostrare/nascondere una lista di esempio di giocatori, digitare |c999999/hodor.share test|r nella chat.\nPuoi anche scegliere quali giocatori mostrare digitando i loro nomi:\n|c999999/hodor.share test @andy.s @Alcast|r",

	HR_MENU_ICONS = "Icone",
	HR_MENU_ICONS_README = "Leggimi (Clicca per aprire)",
	HR_MENU_ICONS_MY = "La mia icona",
	HR_MENU_ICONS_NAME_VAL = "Nome Personalizzato",
	HR_MENU_ICONS_NAME_VAL_TT = "Per impostazione predefinita l'addon mostra il nome del tuo account. Puoi impostare un nome personalizzato qui.",
	HR_MENU_ICONS_GRADIENT = "Gradiente",
	HR_MENU_ICONS_GRADIENT_TT = "Creare un gradiente basato sui colori qui sotto.",
	HR_MENU_ICONS_COLOR1 = "Colore Iniziale",
	HR_MENU_ICONS_COLOR2 = "Colore Finale",
	HR_MENU_ICONS_PREVIEW = "Anteprima",
	HR_MENU_ICONS_LUA = "Codice LUA:",
	HR_MENU_ICONS_LUA_TT = "Potrebbe essere necessario riavviare il gioco (non solo /reloadui) quando si modifica il percorso dell'icona. Invia questo codice all'autore dell'addon insieme al tuo file di icone.",
	HR_MENU_ICONS_VISIBILITY = "Visibilità",
	HR_MENU_ICONS_VISIBILITY_HORN = "Icone del Corno di Guerra",
	HR_MENU_ICONS_VISIBILITY_HORN_TT = "Mostra icone personalizzate per i giocatori nella lista dei corni.",
	HR_MENU_ICONS_VISIBILITY_DPS = "Icone Danno",
	HR_MENU_ICONS_VISIBILITY_DPS_TT = "Mostra icone personalizzate per i giocatori nella lista dei danni.",
	HR_MENU_ICONS_VISIBILITY_COLOS = "Icone Colosso",
	HR_MENU_ICONS_VISIBILITY_COLOS_TT = "Mostra icone personalizzate per i giocatori nella lista dei colossi.",
	HR_MENU_ICONS_VISIBILITY_COLORS = "Nomi Colorati",
	HR_MENU_ICONS_VISIBILITY_COLORS_TT = "Colori dei nomi di altri giocatori.",
	HR_MENU_ICONS_VISIBILITY_ANIM = "Icone Animate",
	HR_MENU_ICONS_VISIBILITY_ANIM_TT = "Riprodurre icone animate. Nota: disabilitare questa funzione non aumenterà i tuoi FPS.",

	HR_MENU_STYLE = "Stile",
	HR_MENU_STYLE_PINS = "Mostra i ping della Mappa",
	HR_MENU_STYLE_PINS_TT = "Mostra i ping dei giocatori sulla mappa del mondo e sulla bussola.",
	HR_MENU_STYLE_DPS = "Elenco Danni",
	HR_MENU_STYLE_DPS_FONT = "Carattere dei Numeri:",
	HR_MENU_STYLE_DPS_FONT_DEFAULT = "Predefinito",
	HR_MENU_STYLE_DPS_FONT_GAMEPAD = "Gamepad",
	HR_MENU_STYLE_DPS_BOSS_COLOR = "Colore Danno del Boss:",
	HR_MENU_STYLE_DPS_TOTAL_COLOR = "Colore Danno Totale:",
	HR_MENU_STYLE_DPS_HEADER_OPACITY = "Opacità Intestazione:",
	HR_MENU_STYLE_DPS_EVEN_OPACITY = "Opacità Righe Pari:",
	HR_MENU_STYLE_DPS_ODD_OPACITY = "Opacità Righe Dispari:",
	HR_MENU_STYLE_DPS_HIGHLIGHT = "Evidenzia Colore:",
	HR_MENU_STYLE_DPS_HIGHLIGHT_TT = "Evidenzia il tuo nome nella lista dei danni con il colore selezionato. Se non vuoi evidenziare il tuo nome, allora imposta Opacity a 0. Solo tu vedi il nome evidenziato.",

	HR_MENU_ANIMATIONS = "Messaggi Animati",
	HR_MENU_ANIMATIONS_TT = "Anima il conti alla rovescia dei colossi e dei corni per renderli più evidenti.",

	HR_MENU_VOTE = "Voto",
	HR_MENU_VOTE_DISABLED = "Questo modulo richiede che Hodor Reflexes sia abilitato!",
	HR_MENU_VOTE_DESC = "Questo modulo migliora il controllo predefinito che permette di vedere chi è pronto o meno se i membri del gruppo hanno Hodor Reflex abilitato.",
	HR_MENU_VOTE_ENABLED_TT = "Abilita/disabilita questo modulo. Quando è disabilitato, gli altri giocatori non saranno in grado di vedere i tuoi voti.",
	HR_MENU_VOTE_CHAT = "Messaggi in Chat",
	HR_MENU_VOTE_CHAT_TT = "Visualizza i risultati dei voti e alcune altre informazioni nella chat del gioco.",
	HR_MENU_VOTE_ACTIONS = "Azioni",
	HR_MENU_VOTE_ACTIONS_RC = "Controllo di Stato",
	HR_MENU_VOTE_ACTIONS_RC_TT = "Avvia Controllo di Stato.",
	HR_MENU_VOTE_ACTIONS_COUNTDOWN = "Contatore",
	HR_MENU_VOTE_ACTIONS_COUNTDOWN_TT = "Inizia un conto alla rovescia con la durata specificata sopra. Devi essere un capogruppo per farlo.",
	HR_MENU_VOTE_ACTIONS_COUNTDOWN_CONFIRM = "Devi essere un capogruppo per iniziare un conto alla rovescia!",
	HR_MENU_VOTE_ACTIONS_LEADER = "Cambia il Capogruppo",
	HR_MENU_VOTE_ACTIONS_LEADER_TT = "Richiede il 60% dei membri del gruppo per votare Sì.",
	HR_MENU_VOTE_ACTIONS_LEADER_CONFIRM = "Cambia il Capogruppo in",
	HR_MENU_VOTE_COUNTDOWN_DURATION = "Durata Contatore",


	HR_MENU_MISC_TOXIC = "Modalità Tossica",
	HR_MENU_MISC_TOXIC_TT = "Suggerimenti beffardi e altro.",

	-------------------------
	-- BINDINGS
	-------------------------

	HR_BINDING_HORN_SHARE = "Abilita/Disabilita Condividi Corni da Guerra",
	HR_BINDING_COLOS_SHARE = "Abilita/Disabilita Condividi Colosso",
	HR_BINDING_DPS_SHARE = "Abilita/Disabilita Condividi Danno",
	HR_BINDING_COUNTDOWN = "Contatore",
	HR_BINDING_EXIT_INSTANCE = "Esci dall'Istanza",
	HR_BINDING_SEND_EXIT_INSTANCE = "Espelli il Gruppo",

	-------------------------
	-- SHARE MODULE
	-------------------------

	HR_SEND_EXIT_INSTANCE = "Espelli il Gruppo",
	HR_SEND_EXIT_INSTANCE_CONFIRM = "Vuoi che tutti lascino l'istanza (compreso te stesso)?",

	HR_COLOS_COUNTDOWN_DEFAULT_TEXT = "FINALE",
	HR_MAJOR_FORCE = "Forza Maggiore",
	HR_HORN = "Corno da Guerra",
	HR_COLOS = "Colosso",

	-- Damage list title
	HR_DAMAGE = "Danno",
	HR_TOTAL_DAMAGE = "Danno Totale",
	HR_MISC_DAMAGE = "Varie",
	HR_BOSS_DPS = "DPS Boss",
	HR_TOTAL_DPS = "DPS Totale",

	HR_NOW = "NOW", -- HORN/COLOS: NOW!

	HR_TEST_STARTED = "Test Avviato.",
	HR_TEST_STOPPED = "Test Fermato.",
	HR_TEST_LEAVE_GROUP = "Devi lasciare il gruppo per fare il test.",

	-------------------------
	-- VOTE MODULE
	-------------------------

	HR_READY_CHECK = "Verifica Stato Giocatori",
	HR_READY_CHECK_READY = "Tutti sono pronti!",
	HR_COUNTDOWN = "Contatore",
	HR_COUNTDOWN_START = "Inizia tra",
	HR_READY_CHECK_INIT_CHAT = "Avviata Verifica Stato Giocatori",
	HR_COUNTDOWN_INIT_CHAT = "Iniziato il conto alla rovaescia",
	HR_VOTE_NOT_READY_CHAT = "non è pronto",
	HR_VOTE_LEADER_CHAT = "vuole cambiare il capogruppo",

	-------------------------
	-- MOCK
	-------------------------

	HR_MOCK1 = "Immaginate di morire con tutti questi addon abilitati.",
    HR_MOCK2 = "Prova ad equipaggiare Mighty Chudan, Plague Doctor e Beekeeper's Gear.",
    HR_MOCK3 = "Darai di nuovo la colpa ai server?",
	HR_MOCK4 = "Una brutta istanza, ovviamente.",
	HR_MOCK5 = "Forse tank o guaritore sarebbero ruoli migliori per te.",
	HR_MOCK6 = "Avete perso la notifica dell'addon?",
	HR_MOCK7 = "Tu sei l'anello più debole, addio.",
	HR_MOCK8 = "Forse dovresti considerare l'acquisto di un carretto per il trasporto.",
	HR_MOCK9 = "Dovresti considerare l'utilizzo della barriera.",
	HR_MOCK10 = "Abbiamo finito i suggerimenti per le vostre morti.",
	HR_MOCK11 = "Se vuoi fare qualcosa di utile, allora controlla il Negozio delle Corone.",
	HR_MOCK12 = "La performance del gioco è pessima, ma la tua è peggiore.",
	HR_MOCK13 = "You are doing good at being bad.",
	HR_MOCK14 = "Try installing more addons to carry you.",
	HR_MOCK15 = "Il tuo APM è troppo basso per questo combattimento.",
	HR_MOCK16 = "Non preoccuparti, alla fine aggiungeranno gli obiettivi di questa Trial al Negozio delle Corone.",
	HR_MOCK17 = "La follia è fare la stessa cosa più e più volte e aspettarsi risultati diversi.",
	HR_MOCK18 = "Nei contenuti PvE si suppone che tu uccida i mob prima che loro uccidano te.",
	HR_MOCK19 = "Hai mai pensato di cambiare il tuo nome in Kenny?",
	HR_MOCK20 = "Ho combattuto granchi più temibili di te.",
	HR_MOCK_AA1 = "Sei morto in su un contenuto di 6 anni fa.",
	HR_MOCK_EU1 = "Perché giocate sul server UE?",
	HR_MOCK_NORMAL1 = "Questa non è nemmeno la modalità veterano...",
	HR_MOCK_VET1 = "Considera di cambiare la difficoltà della trial in Normale.",

	-------------------------
	-- Exit Instance
	-------------------------

	HR_EXIT_INSTANCE = "Lascia l'istanza",
	HR_EXIT_INSTANCE_CONFIRM = "Vuoi lasciare l'istanza corrente?",
	
	-------------------------
	-- Updated window
	-------------------------

	HR_UPDATED_TEXT = "Hodor Reflexes è stato aggiornato con successo, o forse no? Sfortunatamente, quando si aggiorna tramite Minion, c'è una moderata possibilità che alcuni file spariscano. Di solito sono solo icone, di solito... Quindi ecco un piccolo test di cinque immagini da diverse cartelle di addon. Se non le vedi tutte, allora dovresti chiudere il gioco e reinstallare l'addon. Altrimenti, ignorate questo messaggio, non apparirà più.",
	HR_UPDATED_DISMISS = "Vedo cinque icone!",

}

for id, val in pairs(strings) do
   ZO_CreateStringId(id, val)
   SafeAddVersion(id, 1)
end