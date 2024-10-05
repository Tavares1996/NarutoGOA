obj/items/equipable/faction_chuunin
	armor="armor"
	icon_state="HUD"
	acmod=10
	var/overlay_type
	proc/Use(var/mob/u)
		set hidden=1
		set category=null
		var/equ=src.equipped
		usr=u
		for(var/obj/items/O in usr.contents)
			if(O.armor=="armor")
				O.overlays=0
				O.equipped=0
				O.overlays+=O.macover
		if(equ)
			usr.EQUIP("armor",0)
		else
			src.equipped=1
			src.overlays+='icons/Equipped.dmi'
			usr.EQUIP("armor",src.overlay_type)

		usr.Load_Overlays()
	Click()
		Use(usr)

	Ourico_Ame
		code=10000
		overlay_type=/obj/faction_chuunin/Ourico_Ame
		icon='faction_icons/ourico-ame-chuunin.dmi'

	Mange_Sound
		code=10001
		overlay_type=/obj/faction_chuunin/Mange_Sound
		icon='faction_icons/mange-sound-chuunin.dmi'

	Suit_Akat
		code=10002
		overlay_type=/obj/faction_chuunin/Suit_Akat
		icon='faction_icons/akatsuki.dmi'
	Hat_Akat
		code=10003
		overlay_type=/obj/faction_chuunin/Hat_Akat
		icon='faction_icons/hat1.dmi'
	Rock_Vest
		code=10004
		overlay_type=/obj/faction_chuunin/Rock_Vest
		icon='faction_icons/rock-chuunin-vest.dmi'
	Mist_Medic_Vest
		code=10005
		overlay_type=/obj/faction_chuunin/Mist_Medic_Vest
		icon='faction_icons/Mist-Medical.dmi'
	Negro_Vest
		code=10006
		overlay_type=/obj/faction_chuunin/Negro_Vest
		icon='faction_icons/NegroIndustries.dmi'
	Blitzkrieg_Suit
		code=263
		overlay_type=/obj/faction_chuunin/Blitzkrieg_Suit
		icon='members/blitzkrieg_suit.dmi'

obj/faction_chuunin
	layer = FLOAT_LAYER-7
	Ourico_Ame
		icon = 'faction_icons/ourico-ame-chuunin.dmi'
	Mange_Sound
		icon = 'faction_icons/mange-sound-chuunin.dmi'
	Suit_Akat
		icon = 'faction_icons/akatsuki.dmi'
	Hat_Akat
		icon = 'faction_icons/hat1.dmi'
	Rock_Vest
		icon = 'faction_icons/rock-chuunin-vest.dmi'
	Mist_Medic_Vest
		icon='faction_icons/Mist-Medical.dmi'
	Negro_Vest
		icon='faction_icons/NegroIndustries.dmi'
	Blitzkrieg_Suit
		icon='members/blitzkrieg_suit.dmi'