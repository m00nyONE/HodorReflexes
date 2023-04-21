-- Spanish translation by @MuscleGeek502, corrected by Inval1d (@loneloba)

local strings = {

	-------------------------
	-- MENUS
	-------------------------

	HR_MENU_GENERAL = "General",
	HR_MENU_GENERAL_ENABLED = "Activar",
	HR_MENU_GENERAL_ENABLED_TT = "Activa o desactiva este addon. Cuando está desactivado, el addon no procesará ninguna información de otros jugadores.",
	HR_MENU_GENERAL_UI_LOCKED = "Bloquear interfaz",
	HR_MENU_GENERAL_UI_LOCKED_TT = "Desactivar esta opción te permitirá mover los elementos de la interfaz del addon.",
	HR_MENU_GENERAL_ACCOUNT_WIDE = "Aplicar configuración globalmente",
	HR_MENU_GENERAL_ACCOUNT_WIDE_TT = "Desactivar esta opción te permite configurar este addon en cada personaje por separado.",
	HR_MENU_GENERAL_DISABLE_PVP = "Desactivar en PvP",
	HR_MENU_GENERAL_DISABLE_PVP_TT = "Desactiva el addon en zonas de PvP.",
	HR_MENU_GENERAL_EXIT_INSTANCE = "Confirmar al abandonar instancia",
	HR_MENU_GENERAL_EXIT_INSTANCE_TT = "Muestra un diálogo de confirmación antes de abandonar una instancia por petición de un líder del grupo o por una tecla de atajo.",

	HR_MENU_DAMAGE = "Daño",
	HR_MENU_DAMAGE_SHOW = "Mostrar daño:",
	HR_MENU_DAMAGE_SHOW_TT = "Muestra una lista del daño realizado por cada miembro de tu grupo.",
	HR_MENU_DAMAGE_SHARE = "Compartir mi daño:",
	HR_MENU_DAMAGE_SHARE_TT = "Muestra tu daño realizado a los otros miembros de tu grupo.",

	HR_MENU_HORN = "Cuerno de guerra",
	HR_MENU_HORN_SHOW = "Mostrar estados de Cuerno de guerra:",
	HR_MENU_HORN_SHOW_TT = "Muestra una lista de cada miembro de tu grupo que tenga equipada la habilidad máxima (Ultimate) Cuerno de guerra en una barra de habilidades.",
	HR_MENU_HORN_SHARE = "Compartir mi estado:",
	HR_MENU_HORN_SHARE_TT = "Muestra el porcentaje de tu habilidad máxima a los miembros de tu grupo. Al usar las opciones del conjunto Saxheeel con el conjunto equipado, no necesitarás equiparte Cuerno de guerra. El addon compartirá tu coste de máxima más alto o simplemente 250 puntos de máxima.",
	HR_MENU_HORN_SHARE_NONE = "Desactivado",
	HR_MENU_HORN_SHARE_HORN = "Cuerno de guerra",
	HR_MENU_HORN_SHARE_SAXHLEEL1 = "Cuerno o Saxhleel (coste más alto)",
	HR_MENU_HORN_SHARE_SAXHLEEL250 = "Cuerno o Saxhleel (250 puntos)",
	HR_MENU_HORN_SELFISH = "Modo egoísta:",
	HR_MENU_HORN_SELFISH_TT = "Al activarse, verás una cuenta regresiva del tiempo que queda de la habilidad máxima (Ultimate) Cuerno de guerra, pero sólo si tienes un efecto positivo activo otorgado por la habilidad.",
	HR_MENU_HORN_ICON = "Mostrar icono:",
	HR_MENU_HORN_ICON_TT = "Cuando tu Cuerno de guerra esté listo, mostrará un icono con el número de personas que estén en un rango de 20 metros.\nEl icono será |c00FF00verde|r cuando todos los DPS de tu grupo estén dentro del rango.\nEl icono verde será |cFFFF00amarillo|r si alguien de tu grupo esta primero que tú en la lista de Cuernos de guerra. ¡Siempre anuncia tu Cuerno de guerra!",
	HR_MENU_HORN_COUNTDOWN_TYPE = "Tipo de cuenta regresiva:",
	HR_MENU_HORN_COUNTDOWN_TYPE_TT = "- Ninguno: sin cuenta regresiva.\n- Propio: cuenta regresiva solo de mi Cuerno de guerra/Fuerza mayor(Efect. positivo +15% de daño critico).\n- Todos: cuenta regresiva de todos los Cuernos de guerra/Fuerza mayor(Efect. positivo +15% de daño critico) (Recomendable sólo para quien lidera el grupo).",
	HR_MENU_HORN_COUNTDOWN_TYPE_NONE = "Ninguno",
	HR_MENU_HORN_COUNTDOWN_TYPE_SELF = "Cuerno de guerra (Propio)",
	HR_MENU_HORN_COUNTDOWN_TYPE_ALL = "Cuerno de guerra (Todos)",
	HR_MENU_HORN_COUNTDOWN_TYPE_FORCE_SELF = "Fuerza mayor (Propio)",
	HR_MENU_HORN_COUNTDOWN_TYPE_FORCE_ALL = "Fuerza mayor (Todos)",
	HR_MENU_HORN_COUNTDOWN_COLOR = "Color de la cuenta regresiva:",

	HR_MENU_COLOS = "Coloso",
	HR_MENU_COLOS_SHOW = "Mostrar estados de Coloso:",
	HR_MENU_COLOS_SHOW_TT = "Muestra una lista de cada miembro de tu grupo que tenga equipada la habilidad máxima (Ultimate) Coloso en una barra de habilidades.",
	HR_MENU_COLOS_SHARE = "Compartir mi estado:",
	HR_MENU_COLOS_SHARE_TT = "Muestra el porcentaje de tu habilidad máxima Coloso a los miembros de tu grupo (Sólo si está presente en tu barra de habilidades).",
	HR_MENU_COLOS_PRIORITY = "Prioridad:",
	HR_MENU_COLOS_PRIORITY_TT = "- Normal: el valor máximo es 200%.\n- Rol de tanque: envía al 201% si tu rol es Tanque y tu habilidad Coloso está lista.\n- Siempre: envía al 201% cuando tu habilidad Coloso esté lista.\n- Nunca: envía al 99% o menos.\n|cFFFFFFNOTA: enviar al 99% o 201% en lugar del 100% también afectará al porcentaje de tu Cuerno de guerra si esta activado la opción de compartir en ambas habilidades máximas.|r",
	HR_MENU_COLOS_PRIORITY_DEFAULT = "Normal",
	HR_MENU_COLOS_PRIORITY_TANK = "Rol de tanque",
	HR_MENU_COLOS_PRIORITY_ALWAYS = "Siempre",
	HR_MENU_COLOS_PRIORITY_NEVER = "Nunca",
	HR_MENU_COLOS_SUPPORT_RANGE = "Sólo mostrar aliados cercanos:",
	HR_MENU_COLOS_SUPPORT_RANGE_TT = "Los miembros del grupo que estén muy lejos no se mostraran en la lista.",
	HR_MENU_COLOS_COUNTDOWN = "Mostrar cuenta regresiva:",
	HR_MENU_COLOS_COUNTDOWN_TT = "Muestra una notificación con una cuenta regresiva para que uses tu habilidad máxima (Ultimate).",
	HR_MENU_COLOS_COUNTDOWN_TEXT = "Texto para la cuenta regresiva:",
	HR_MENU_COLOS_COUNTDOWN_COLOR = "Color de texto de la cuenta regresiva:",

	HR_MENU_MISC = "OTROS",
	HR_MENU_MISC_DESC = "Para MOSTRAR/OCULTAR un ejemplo de todas las opciones activadas de este addon, escribe |c999999/hodor.share test|r en el chat del juego.\nTambién puedes elegir qué jugadores mostrar escribiendo sus nombres:\n|c999999/hodor.share test @andy.s @Alcast|r",

	HR_MENU_ICONS = "Iconos",
	HR_MENU_ICONS_README = "Importante (Clic para abrir)",
	HR_MENU_ICONS_MY = "Mi icono",
	HR_MENU_ICONS_NAME_VAL = "Nombre personalizado",
	HR_MENU_ICONS_NAME_VAL_TT = "Por defecto, se mostrará el nombre de tu cuenta. Puedes establecer un nombre personalizado esta opción.",
	HR_MENU_ICONS_GRADIENT = "Gradiente",
	HR_MENU_ICONS_GRADIENT_TT = "Crea una gradiente tomando como base los colores asignados.",
	HR_MENU_ICONS_COLOR1 = "Color inicial",
	HR_MENU_ICONS_COLOR2 = "Color final",
	HR_MENU_ICONS_PREVIEW = "Previsualizar",
	HR_MENU_ICONS_LUA = "Código LUA:",
	HR_MENU_ICONS_LUA_TT = "Quizá tengas que reiniciar el juego (no recargar la interfaz) cuando modifiques la ruta del icono. Envía este código al autor del addon junto al archivo del icono.",
	HR_MENU_ICONS_VISIBILITY = "Visibilidad",
	HR_MENU_ICONS_VISIBILITY_HORN = "Iconos en marco de Cuerno de guerra",
	HR_MENU_ICONS_VISIBILITY_HORN_TT = "Muestra iconos personalizados de los jugadores en la lista de esta habilidad.",
	HR_MENU_ICONS_VISIBILITY_DPS = "Iconos en marco de daño",
	HR_MENU_ICONS_VISIBILITY_DPS_TT = "Muestra iconos personalizados de los jugadores en la lista de daño.",
	HR_MENU_ICONS_VISIBILITY_COLOS = "Iconos en marco de Coloso",
	HR_MENU_ICONS_VISIBILITY_COLOS_TT = "Muestra iconos personalizados de jugadores en la lista de las habilidades máximas (Ultimates).",
	HR_MENU_ICONS_VISIBILITY_COLORS = "Nombres coloridos",
	HR_MENU_ICONS_VISIBILITY_COLORS_TT = "Muestra los colores de los nombres personalizados de los jugadores.",
	HR_MENU_ICONS_VISIBILITY_ANIM = "Iconos animados",
	HR_MENU_ICONS_VISIBILITY_ANIM_TT = "Reproduce iconos animados. Nota: activar o desactivar esta opción no afecta los FPS.",

	HR_MENU_ICONS_README1 = "Usa los siguientes ajustes para personalizar tu nombre e icono en el addon. Esto es sólo una vista previa, por lo que nadie verá los cambios hasta que envíes el LUA generado al autor del addon.",
	HR_MENU_ICONS_README2 = "El juego sólo soporta imágenes con el formato de archivos de DirectDraw Surface y las dimensiones requeridas son de 32x32 px. Puedes ignorar esta parte si parece complicada, y solo enviar el archivo original junto al código LUA.",
	HR_MENU_ICONS_README3 = "Haz clic en \"%s\" en la parte superior de este menú para instrucciones más detalladas sobre cómo contactar al autor y obtener un icono personal. Por favor, utiliza el correo del juego sólo para donaciones en oro. ¡No recibirás respuesta por aquí!",

	HR_MENU_STYLE = "Estilo",
	HR_MENU_STYLE_PINS = "Mostrar iconos del mapa",
	HR_MENU_STYLE_PINS_TT = "Muestra los iconos de los jugadores en el mapa y brújula.", 
	HR_MENU_STYLE_DPS = "Lista de daño",
	HR_MENU_STYLE_DPS_FONT = "Fuente de los números:",								  									 
	HR_MENU_STYLE_DPS_FONT_DEFAULT = "Por defecto",
	HR_MENU_STYLE_DPS_FONT_GAMEPAD = "Mando",
	HR_MENU_STYLE_DPS_BOSS_COLOR = "Color de daño al jefe:",
	HR_MENU_STYLE_DPS_TOTAL_COLOR = "Color de daño total:",
	HR_MENU_STYLE_DPS_HEADER_OPACITY = "Opacidad del recuadro:",
	HR_MENU_STYLE_DPS_EVEN_OPACITY = "Opacidad de las filas pares:",
	HR_MENU_STYLE_DPS_ODD_OPACITY = "Opacidad de las filas impares:",
	HR_MENU_STYLE_DPS_HIGHLIGHT = "Color de resaltado:",
	HR_MENU_STYLE_DPS_HIGHLIGHT_TT = "Resalta el color de tu nombre en la lista de daño con el color deseado. Si no quieres que se resalte, coloca su opacidad a 0. (Solo tú puedes ver el nombre resaltado).",
	HR_MENU_STYLE_HORN_COLOR = "Color de duración de Cuerno de guerra",
	HR_MENU_STYLE_FORCE_COLOR = "Color de duración de Fuerza mayor",
	HR_MENU_STYLE_COLOS_COLOR = "Color de duración de Coloso",
	HR_MENU_STYLE_TIMER_OPACITY = "Opacidad de temporizador agotado",
	HR_MENU_STYLE_TIMER_OPACITY_TT = "Opacidad del texto e icono del temporizador cuando este llega a cero (0.0).",
	HR_MENU_STYLE_TIMER_BLINK = "Temporizador parpadeante",
	HR_MENU_STYLE_TIMER_BLINK_TT = "Los temporizadores parpadearán al llegar a los 0 segundos, y luego se opacarán.",

	HR_MENU_ANIMATIONS = "Alertas animadas",
	HR_MENU_ANIMATIONS_TT = "Anima las cuentas regresivas de Coloso y Cuerno para hacerlas más vistosas.",

	HR_MENU_VOTE = "Votaciones",
	HR_MENU_VOTE_DISABLED = "¡Este módulo necesita tener Hodor Reflexes activado!",
	HR_MENU_VOTE_DESC = "Este módulo mejora el sistema de comprobación de estado (ready check) y permite ver quien está listo o no si los miembros de tu grupo tienen instalado y activado Hodor Reflexes.",
	HR_MENU_VOTE_ENABLED_TT = "Activa o desactiva este módulo. Cuando está desactivado, los otros jugadores no podrán ver tus votos.",
	HR_MENU_VOTE_CHAT = "Mensaje en el chat",
	HR_MENU_VOTE_CHAT_TT = "Muestra la información de los resultados de las votaciones en el chat del juego.",
	HR_MENU_VOTE_ACTIONS = "Acciones",
	HR_MENU_VOTE_ACTIONS_RC = "Comprobación de estado",
	HR_MENU_VOTE_ACTIONS_RC_TT = "Iniciar comprobación de estado.",
	HR_MENU_VOTE_ACTIONS_COUNTDOWN = "Cuenta regresiva",
	HR_MENU_VOTE_ACTIONS_COUNTDOWN_TT = "Muestra una cuenta regresiva de 5 segundos cuando todos estén listos.\nDebes ser el líder del grupo para poder realizar esta acción.",
	HR_MENU_VOTE_ACTIONS_COUNTDOWN_CONFIRM = "¡Tienes que ser el líder del grupo para poder realizar esta acción!",
	HR_MENU_VOTE_ACTIONS_LEADER = "Cambiar líder del grupo",
	HR_MENU_VOTE_ACTIONS_LEADER_TT = "Requiere el 60% de votos a favor de los miembros de tu grupo.",
	HR_MENU_VOTE_ACTIONS_LEADER_CONFIRM = "Cambiar líder del grupo a",
	HR_MENU_VOTE_COUNTDOWN_DURATION = "Duración",														


	HR_MENU_MISC_TOXIC = "Modo tóxico",
	HR_MENU_MISC_TOXIC_TT = "Pistas burlescas y tal.",
	
	-------------------------
	-- BINDINGS
	-------------------------

	HR_BINDING_HORN_SHARE = "Alternar compartir Cuerno de guerra",
	HR_BINDING_COLOS_SHARE = "Alternar compartir Coloso ",
	HR_BINDING_DPS_SHARE = "Alternar compartir daño",
	HR_BINDING_COUNTDOWN = "Cuenta regresiva",
	HR_BINDING_EXIT_INSTANCE = "Abandonar instancia inmediatamente",
	HR_BINDING_SEND_EXIT_INSTANCE = "Expulsar grupo",

	-------------------------
	-- SHARE MODULE
	-------------------------
	
	HR_SEND_EXIT_INSTANCE = "Expulsar grupo",
	HR_SEND_EXIT_INSTANCE_CONFIRM = "¿Quieres que todos los miembros del grupo (incluyéndote) abandonen la instancia?",

	HR_COLOS_COUNTDOWN_DEFAULT_TEXT = "ULTI",
	HR_MAJOR_FORCE = "Fuerza mayor",
	HR_HORN = "Cuerno",
	HR_COLOS = "Coloso",

	-- Damage list title
	HR_DAMAGE = "Daño",
	HR_TOTAL_DAMAGE = "Daño total",
	HR_MISC_DAMAGE = "Total",
	HR_BOSS_DPS = "Daño al jefe",
	HR_TOTAL_DPS = "Daño total",

	HR_NOW = "AHORA", -- CUERNO/COLOSO: ¡AHORA!

	HR_TEST_STARTED = "Prueba iniciada.",
	HR_TEST_STOPPED = "Prueba detenida.",
	HR_TEST_LEAVE_GROUP = "Debes salir del grupo para realizar una prueba.",

	-------------------------
	-- VOTE MODULE
	-------------------------

	HR_READY_CHECK = "Comprobación de estado",
	HR_READY_CHECK_READY = "¡Todos están listos!",
	HR_COUNTDOWN = "Cuenta atrás",
	HR_COUNTDOWN_START = "Empieza en",
	HR_READY_CHECK_INIT_CHAT = "inicio una comprobación de estado.",
	HR_COUNTDOWN_INIT_CHAT = "inició una cuenta regresiva.",
	HR_VOTE_NOT_READY_CHAT = "no está listo.",
	HR_VOTE_LEADER_CHAT = "quiere cambiar al líder del grupo.",
	
	-------------------------
	-- MOCK
	-------------------------

	HR_MOCK1 = "¿Cómo se siente morir con tantos addons puestos?.",
    HR_MOCK2 = "Intenta equiparte Chudan, Doctor de la plaga y Apicultor.",
    HR_MOCK3 = "¿Vas a culpar al servidor otra vez?",
	HR_MOCK4 = "Instancia bugeada, claro.",
	HR_MOCK5 = "Quizá mejor te haces tank o healer.",
	HR_MOCK6 = "¿No viste la notificación del addon?",
	HR_MOCK7 = "Poco hacías de todas formas.",
	HR_MOCK8 = "Quizá debas pagar un grupo para que te carrée.",
	HR_MOCK9 = "¿Y si te equipas Barrera?",
	HR_MOCK10 = "Se nos acabaron los consejos.",
	HR_MOCK11 = "Si quieres sentirte útil, mejor revisa la Tienda de Coronas.",
	HR_MOCK12 = "El rendimiento del juego es malo, pero el tuyo es peor.",
	HR_MOCK13 = "Se te da bien jugar mal.",
	HR_MOCK14 = "Ponte más addons a ver si te ayudan.",
	HR_MOCK15 = "Tu APM es demasiado bajo para esta pelea.",
	HR_MOCK16 = "No te preocupes, pronto añadiremos los logros de esta trial en la Tienda de Coronas.",
	HR_MOCK17 = "La locura es hacer lo mismo una y otra vez esperando obtener resultados diferentes.",
	HR_MOCK18 = "¿Ves esa barra roja en la cabeza de los enemigos? Hay que vaciarla antes de que vacíen la tuya.",
	HR_MOCK19 = "¿Has considerado cambiar tu nombre a Kenny?",
	HR_MOCK20 = "Mejor pásate al Roblox.",
	HR_MOCK_AA1 = "Imagina morir en contenido del juego base.",
	HR_MOCK_EU1 = "¿Por qué juegas en EU?",
	HR_MOCK_NORMAL1 = "Ni siquiera está en veterano...",
	HR_MOCK_VET1 = "Para la próxima considera hacerla en normal.",	
	-------------------------
	-- Exit Instance
	-------------------------	
	
	HR_EXIT_INSTANCE = "Abandonar instancia",
	HR_EXIT_INSTANCE_CONFIRM = "¿Quieres salir de la instancia actual?",
	
	-------------------------
	-- Updated window
	-------------------------

	HR_UPDATED_TEXT = "Hodor Reflexes se ha actualizado exitosamente, ¿o quizá no? Lamentablemente al actualizar con Minion, existe la moderada posibilidad de que algunos archivos desaparezcan. Por lo general son sólo iconos... O al menos casi siempre. Aquí te dejamos una pequeña prueba con cinco imágenes de distintas carpetas del addon. Si no ves las cinco imágenes, entonces deberías cerrar el juego y reinstalar el addon. De lo contrario, ignora este mensaje. No volverá a aparecer.",
	HR_UPDATED_DISMISS = "¡Veo cinco iconos!",
	
	HR_MISSING_ICON = "No se pudo cargar tu icono de Hodor Reflexes. Reinstala el addon o descárgalo manualmente desde esoui.com y reinicia el juego.",

}

for id, val in pairs(strings) do
	SafeAddString(_G[id], val, 1)
end
