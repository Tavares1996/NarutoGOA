mob/var/warp_warn_time

turf/warp
	Entered(atom/movable/O)
		..()
		var/mob/human/player/M = O
		if(M.pk && /*(a && !a.pkzone) && */(M.isCombatFlag(20,"offense") || M.isCombatFlag(10,"defense")))
			if(M.warp_warn_time < world.time-20) M << "You may not retreat so soon!"
			M.warp_warn_time = world.time
			return 0

		if(O && istype(O,/mob/human/))
			O.Get_Global_Coords()
	EpicWarp
		layer = 100
		var
			RPdis=0
			WINDEX=0
			Wx
			Wy
			Wz
			needgenin=0
			needvillage=0
		New()
			..()
			var/match = 0
			for(var/turf/warp/EpicWarp/P in world)
				if(P.WINDEX==src.WINDEX && P!=src &&P.z!=src.z)
					Wx=P.x
					Wy=P.y
					Wz=P.z
					match = 1
					break
			if(!match)
				world.log << "EpicWarp failed: ([x], [y], [z]): No match for WINDEX=[WINDEX]"

		Enter(atom/movable/O)
			if(istype(O,/mob/human/player))
				var/mob/human/player/M = O
				if(!M.client)
					return 0
				return 1
			else
				return 0

		Entered(atom/movable/O)
			if(ismob(O))
				var/mob/M = O
				if(M.pk && /*(a && !a.pkzone) && */(M.isCombatFlag(20,"offense") || M.isCombatFlag(10,"defense")))
					if(M.warp_warn_time < world.time-20) M << "You may not retreat so soon!"
					M.warp_warn_time = world.time
					return 0
				if(M.client && Wx && Wy && Wz)
					if(istype(M,/mob/human/player) && !istype(M,/mob/human/player/npc))
						var/obj/mapinfo/old_map = locate("__mapinfo__[M.z]")
						var/obj/mapinfo/new_map = locate("__mapinfo__[Wz]")
						M.loc = locate(Wx, Wy, Wz)
						if(old_map) old_map.PlayerLeft(M)
						if(new_map) new_map.PlayerEntered(M)
						M.Get_Global_Coords()

	EpicWarpi
		layer = 100
		var
			WINDEX=0
			Wx
			Wy
			Wz
			needgenin=0
			needvillage=0
		New()
			..()
			var/match = 0
			for(var/turf/warp/EpicWarpi/P in world)
				if(P.WINDEX==src.WINDEX && P!=src)
					Wx=P.x
					Wy=P.y
					Wz=P.z
					match = 1
					break
			if(!match)
				world.log << "EpicWarpi failed: ([x], [y], [z]): No match for WINDEX=[WINDEX]"

		Enter(atom/movable/O)
			if(ismob(O))
				var/mob/M = O
				if(!M.client)
					return 0
				return 1
			else
				return 0

		Entered(atom/movable/O)
			if(ismob(O))
				var/mob/M = O
				if(M.pk && /*(a && !a.pkzone) && */(M.isCombatFlag(20,"offense") || M.isCombatFlag(10,"defense")))
					if(M.warp_warn_time < world.time-20) M << "You may not retreat so soon!"
					M.warp_warn_time = world.time
					return 0
				if(M.client && Wx && Wy && Wz)
					var/obj/mapinfo/old_map = locate("__mapinfo__[M.z]")
					var/obj/mapinfo/new_map = locate("__mapinfo__[Wz]")
					M.loc = locate(Wx, Wy, Wz)
					if(old_map) old_map.PlayerLeft(M)
					if(new_map) new_map.PlayerEntered(M)
					M.Get_Global_Coords()

obj
	Manaquin
		icon='icons/interrior_obj.dmi'
		icon_state="manaquin"
		var
			reff=0
		New()
			..()
			if(src.reff)
				src.overlays+=reff

turf
	Inside2
		icon='icons/interrior_obj.dmi'
		density=1
		sidetable
			icon_state="sidetable"
		phone
			icon_state="phone"
		books_bottom
			icon_state="books-bottom"
		books_top
			icon_state="books-top"
		painting
			icon_state="painting"
		painting2
			icon_state="painting2"
		counter
			icon_state="counter"
		oven
			icon_state="oven"
		fridge_bottom
			icon_state="fridge-bottom"
		fridge_top
			icon_state="fridge-top"
		couch_bottom
			icon_state="couch-bottom"
		couch_top
			icon_state="couch-top"
		chair_north
			icon_state="chair-north"
			density=0
		chair_east
			icon_state="chair-east"
			density=0
		chair_west
			icon_state="chair-west"
			density=0
		chair_south
			icon_state="chair-south"
			density=0
		scroll_bottom
			icon_state="scroll-bottom"
		scroll_top
			icon_state="scroll-top"
		desk
			icon_state="desk"
		desk_stuff
			icon_state="desk-stuff"
		stuff
			icon_state="stuff"
		tv1
			icon_state="tv1"
		tv2
			icon_state="tv2"
		tv3
			icon_state="tv3"
		tv4
			icon_state="tv4"
		tv_side1
			icon_state="tv-side1"
		tv_side2
			icon_state="tv-side2"
		tv_side3
			icon_state="tv-side3"
		tv_side4
			icon_state="tv-side4"

	Inside
		walls
			density=1
			icon='icons/indoor.dmi'
			sidelwall
				icon_state="sidelwall"
				layer=MOB_LAYER+3
			siderwall
				icon_state="siderwall"
				layer=MOB_LAYER+3
			sideltop
				icon_state="sideltop"
				layer=MOB_LAYER+3
			sidertop
				icon_state="sidertop"
				layer=MOB_LAYER+3
			sideu
				icon_state="sideu"
				layer=MOB_LAYER+3
			sided
				icon_state="sided"
				layer=MOB_LAYER+3
			sider
				icon_state="sider"
				layer=MOB_LAYER+3
			sidel
				icon_state="sidel"
				layer=MOB_LAYER+3
			corner1
				icon_state="corner1"
				layer=MOB_LAYER+3
			corner2
				icon_state="corner2"
				layer=MOB_LAYER+3
			corner3
				icon_state="corner3"
				layer=MOB_LAYER+3
			corner4
				icon_state="corner4"
				layer=MOB_LAYER+3
		icon='icons/house_stuff2.dmi'
		Cab1
			density=1
			icon_state="cab1"
		Cab2
			density=0
			icon_state="cab2"
		Mirror1
			density=1
			icon_state="mirror1"
		Mirror2
			density=0
			icon_state="mirror2"
		End1
			density=1
			icon_state="end1"
		End2
			density=0
			icon_state="end2"
		Window//INSIDE ONLY!
			density=1
			icon_state="window"
		Table
			density=1
			Table1
				icon_state="table1"
			Table2
				icon_state="table2"
			Table3
				icon_state="table3"
			Table4
				icon_state="table4"
			Table5
				icon_state="table5"
			Table6
				icon_state="table6"
			Table7
				icon_state="table7"
				density=0
			Table8
				icon_state="table8"
				density=0
			Table9
				icon_state="table9"
				density=0
		Floor1
			density=0
			icon='icons/house_stuff.dmi'
			icon_state="floor1"
		Floor2
			icon='icons/house_stuff.dmi'
			density=0
			icon_state="floor2"
		Floor3
			density=0
			icon='icons/house_stuff.dmi'
			icon_state="floor3"
		Floor4
			icon='icons/house_stuff.dmi'
			density=0
			icon_state="floor4"
		Floor5
			icon='icons/house_stuff.dmi'
			density=0
			icon_state="floor5"
		Floor6
			icon='icons/house_stuff.dmi'
			density=0
			icon_state="floor6"
		Wall1
			density=1
			P1
				icon_state="1wall1"
			P2
				icon_state="1wall2"
			P3
				icon_state="1wall3"
			P4
				icon_state="1wall4"
			P5
				icon_state="1wall5"
			P6
				icon_state="1wall6"
			P7
				icon_state="1wall7"
			P8
				icon_state="1wall8"
			P9
				icon_state="1wall9"
			P10
				icon_state="1wall10"
			P11
				icon_state="1wall11"
			P12
				icon_state="1wall12"
		WallWhite
			icon='icons/wallwhite.dmi'
			density=1
			B
				icon_state="b"
			T
				icon_state="t"
			BL
				icon_state="bl"
			BR
				icon_state="br"
			TL
				icon_state="tl"
			TR
				icon_state="tr"
		WallBlue
			icon='icons/wallblue.dmi'
			density=1
			B
				icon_state="b"
			T
				icon_state="t"
			BL
				icon_state="bl"
			BR
				icon_state="br"
			TL
				icon_state="tl"
			TR
				icon_state="tr"
		WallGreen
			icon='icons/wallgreen.dmi'
			density=1
			B
				icon_state="b"
			T
				icon_state="t"
			BL
				icon_state="bl"
			BR
				icon_state="br"
			TL
				icon_state="tl"
			TR
				icon_state="tr"
		WallOrange
			icon='icons/wallorange.dmi'
			density=1
			B
				icon_state="b"
			T
				icon_state="t"
			BL
				icon_state="bl"
			BR
				icon_state="br"
			TL
				icon_state="tl"
			TR
				icon_state="tr"
		WallPink
			icon='icons/wallpink.dmi'
			density=1
			B
				icon_state="b"
			T
				icon_state="t"
			BL
				icon_state="bl"
			BR
				icon_state="br"
			TL
				icon_state="tl"
			TR
				icon_state="tr"
		Banner1_1
			density=1
			icon_state="banner1-1"
		Banner1_2
			density=1
			icon_state="banner1-2"
		Banner2_1
			density=1
			icon_state="banner2-1"
		Banner2_2
			density=1
			icon_state="banner2-2"
		Stair1
			density=0
			icon_state="stair1"
		Stair2
			density=0
			icon_state="stair2"