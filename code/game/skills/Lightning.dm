skill
	lightning
		chidori
			id = CHIDORI
			name = "Lightning: Chidori"
			icon_state = "chidori"
			default_chakra_cost = 400
			default_cooldown = 90
			default_seal_time = 5



			Use(mob/human/user)
				viewers(user) << output("[user]: Lightning: Chidori!", "combat_output")
				user.overlays+='icons/chidori.dmi'

				var/mob/human/etarget = user.MainTarget()
				user.stunned=100
				if(!etarget)
					user.stunned=0
					user.usemove=1
					sleep(10)
					if(!user.usemove)
						return
					var/ei=7
					while(!etarget && ei>0)
						for(var/mob/human/o in get_step(user,user.dir))
							if(!o.ko&&!o.protected)
								etarget=o
						ei--
						walk(user,user.dir)
						sleep(1)
						walk(user,0)

					if(etarget)
						var/result=Roll_Against(user.rfx+user.rfxbuff-user.rfxneg,etarget.rfx+etarget.rfxbuff-etarget.rfxneg,70)
						if(result>=5)
							user.combat("[user] Critically hit [etarget] with the Chidori")
							etarget.combat("[user] Critically hit [etarget] with the Chidori")
							etarget.Wound(rand(20,50),1,user)
							etarget.Dec_Stam(rand(1200,2000),1,user)

						if(result==4||result==3)
							user.combat("[user] Managed to partially hit [etarget] with the Chidori")
							etarget.combat("[user] Managed to partially hit [etarget] with the Chidori")
							etarget.Wound(rand(10,20),1,user)
							etarget.Dec_Stam(rand(300,500),1,user)

						if(result>=3)
							spawn()ChidoriFX(user)
							etarget.move_stun=50
							spawn()Blood2(etarget,user)
							spawn()etarget.Hostile(user)
							spawn()user.Taijutsu(etarget)
						if(result<3)
							user.combat("You Missed!!!")
							if(!user.icon_state)
								flick("hurt",user)
					user.overlays-='icons/chidori.dmi'
				else if(etarget)
					user.usemove=1
					spawn(20)
						user.overlays-='icons/chidori.dmi'
					sleep(20)
					etarget = user.MainTarget()
					var/inrange=(etarget in oview(user, 10))
					user.stunned=0

					if(etarget && user.usemove==1 && inrange)
						var/result=Roll_Against(user.rfx+user.rfxbuff-user.rfxneg,etarget.rfx+etarget.rfxbuff-etarget.rfxneg,70)
						if(result>=5)
							user.combat("[user] Critically hit [etarget] with the Chidori")
							etarget.combat("[user] Critically hit [etarget] with the Chidori")
							etarget.Wound(rand(5,20),1,user)

							etarget.Dec_Stam(rand(1500,2500),1,user)

						if(result==4||result==3)
							user.combat("[user] Managed to partially hit [etarget] with the Chidori")
							etarget.combat("[user] Managed to partially hit [etarget] with the Chidori")
							etarget.Wound(rand(2,5),1,user)
							etarget.Dec_Stam(rand(1200,2000),1,user)
						if(result<3)
							user.combat("[user] Partially Missed [etarget] with the Chidori,[etarget] is damaged by the electricity!")
							etarget.combat("[user] Partially Missed [etarget] with the Chidori,[etarget] is damaged by the electricity!")
							etarget.Dec_Stam(rand(750,1500),1,user)

						if(user.AppearMyDir(etarget))
							if(result>=3)
								spawn()ChidoriFX(user)
								etarget.move_stun=50
								spawn()Blood2(etarget,user)
								spawn()etarget.Hostile(user)
								spawn()user.Taijutsu(etarget)
							if(result<3)
								user.combat("You Missed!!!")
								if(!user.icon_state)
									flick("hurt",user)

/*		false_darkness
			id = LIGHTNING_FALSE_DARKNESS
			name = "Lightning Release: False Darkness"
			icon_state = "falsedarkness"
			default_chakra_cost = 350
			default_cooldown = 90
			var
				active_state = 0

			IsUsable(mob/user)
				. = ..()
				if(.)
					if(!user.MainTarget())
						Error(user, "No Target")
						return 0

			Use(mob/human/user)
				viewers(user) << output("[user]:<font color =aqua> Lightning Release: False Darkness!", "combat_output")
				user.icon_state="Seal"
				spawn(10)
					user.icon_state = ""
				user.stunned=3
				var/conmult = user.ControlDamageMultiplier()
				var/targets[] = user.NearestTargets(num=3)
				for(var/mob/human/player/target in targets)
					++active_state
					spawn()
						var/obj/trailmaker/o=new/obj/trailmaker/Falsedarkness(locate(user.x,user.y,user.z))
						var/mob/result = Trail_Homing_Projectile(user.x,user.y,user.z,user.dir,o,10,target,1,1,0,0,1,user)
						if(result)
							result.Dec_Stam(rand(200, (400+300*conmult)), 0, user)
							result.Wound(rand(1, 8), 0, user)
							result.icon_state="hurt"
							result.move_stun=20
							spawn(15) result.icon_state=""
							if(!result.ko && !result.protected)
								spawn()Blood2(result,user)
								o.icon_state="still"
								spawn()result.Hostile(user)
						--active_state
						if(active_state <= 0)
							user.stunned = 0
						del(o)
						for(var/turf/New_Turfs/Outside/Wire/w in oview(10))
							spawn()Electricity(w.x,w.y,w.z,50)
							spawn()AOExk(w.x,w.y,w.z,1,(rand(500,100)),50,user,0,1.5,1)
						for(var/turf/New_Turfs/Outside/Electricity/e in oview(10))
							spawn()Electricity(e.x,e.y,e.z,50)
							spawn()AOExk(e.x,e.y,e.z,1,(rand(500,100)),50,user,0,1.5,1)*/


		chidori_spear
			id = CHIDORI_SPEAR
			name = "Lightning: Chidori Spear"
			icon_state = "raton_sword_form_assasination_technique"
			default_chakra_cost = 350
			default_cooldown = 150
			face_nearest = 1



			Use(mob/human/user)
				viewers(user) << output("[user]: Lightning: Chidori Spear!", "combat_output")

				user.stunned=10

				user.overlays+='icons/ratonswordoverlay.dmi'
				sleep(5)

				var/obj/trailmaker/o=new/obj/trailmaker/Raton_Sword()
				var/mob/result=Trail_Straight_Projectile(user.x,user.y,user.z,user.dir,o,14,user)
				if(result)
					spawn(50)
						del(o)
					result.Wound(rand(10,20),1,user)
					result.Dec_Stam(rand(1500,4300),1,user)
					//result.Wound(rand(10,20),1,user)
					spawn()Blood2(result,user)
					spawn()result.Hostile(user)
					result.move_stun=50
					spawn(50)
						user.stunned=0
						user.overlays-='icons/ratonswordoverlay.dmi'
				else
					user.stunned=0
					user.overlays-='icons/ratonswordoverlay.dmi'




		chidori_current
			id = CHIDORI_CURRENT
			name = "Lightning: Chidori Current"
			icon_state = "chidori_nagashi"
			default_chakra_cost = 100
			default_cooldown = 20
			face_nearest = 1



			Use(mob/human/user)
				viewers(user) << output("[user]: Lightning: Chidori Current!", "combat_output")

				user.icon_state="Seal"
				user.stunned=5

				var/conmult = user.ControlDamageMultiplier()

				if(!user.waterlogged)
					spawn()
						spawn()Electricity(user.x+1,user.y,user.z,30)
						spawn()Electricity(user.x-1,user.y,user.z,30)
						spawn()Electricity(user.x,user.y+1,user.z,30)
						spawn()Electricity(user.x,user.y-1,user.z,30)
						spawn()Electricity(user.x+1,user.y+1,user.z,30)
						spawn()Electricity(user.x-1,user.y+1,user.z,30)
						spawn()Electricity(user.x+1,user.y-1,user.z,30)
						spawn()Electricity(user.x-1,user.y-1,user.z,30)
					spawn()AOExk(user.x,user.y,user.z,1,(500+150*conmult),30,user,0,1.5,1)
					Electricity(user.x,user.y,user.z,30)
				else
					for(var/turf/x in oview(2))
						spawn()Electricity(x.x,x.y,x.z,30)
					spawn()AOExk(user.x,user.y,user.z,2,(500+150*conmult),30,user,0,1.5,1)
					Electricity(user.x,user.y,user.z,30)

				user.stunned=0
				user.icon_state=""




		chidori_needles
			id = CHIDORI_NEEDLES
			name = "Lightning: Chidori Needles"
			icon_state = "chidorisenbon"
			default_chakra_cost = 200
			default_cooldown = 30
			face_nearest = 1



			Use(mob/human/user)
				viewers(user) << output("[user]: Lightning: Chidori Needles!", "combat_output")
				var/eicon='icons/chidorisenbon.dmi'
				var/estate=""

				if(!user.icon_state)
					user.icon_state="Throw1"
					user.overlays+='icons/raitonhand.dmi'
					spawn(20)
						user.icon_state=""
						user.overlays-='icons/raitonhand.dmi'
				var/mob/human/player/etarget = user.NearestTarget()
				if(etarget)
					user.dir = angle2dir_cardinal(get_real_angle(user, etarget))

				var/angle
				var/speed = 32
				var/spread = 9
				if(etarget) angle = get_real_angle(user, etarget)
				else angle = dir2angle(user.dir)

				var/damage = 100+50*user.ControlDamageMultiplier()

				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*2, distance=10, damage=damage, wounds=1, daze=25)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread, distance=10, damage=damage, wounds=1, daze=25)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle, distance=10, damage=damage, wounds=1, daze=25)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle-spread, distance=10, damage=damage, wounds=1, daze=25)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle-spread*2, distance=10, damage=damage, wounds=1, daze=25)
				//advancedprojectile_ramped(i,estate,mob/efrom,xvel,yvel,distance,damage,wnd,vel,pwn,daze,radius)//daze as percent/100

				/*if(user.dir==NORTH)
					spawn()advancedprojectile_ramped(eicon,estate,user,25,32,10,(400+200*conmult),1,85,0,15)
					spawn()advancedprojectile_ramped(eicon,estate,user,16,32,10,(400+200*conmult),1,90,0,15)
					spawn()advancedprojectile_ramped(eicon,estate,user,0,32,10,(400+200*conmult),1,100,1,15)
					spawn()advancedprojectile_ramped(eicon,estate,user,-16,32,10,(400+200*conmult),1,90,0,15)
					spawn()advancedprojectile_ramped(eicon,estate,user,-25,32,10,(400+200*conmult),1,85,0,15)
				if(user.dir==SOUTH)
					spawn()advancedprojectile_ramped(eicon,estate,user,25,-32,10,(400+200*conmult),1,85,0,15)
					spawn()advancedprojectile_ramped(eicon,estate,user,16,-32,10,(400+200*conmult),1,90,0,15)
					spawn()advancedprojectile_ramped(eicon,estate,user,0,-32,10,(400+200*conmult),1,100,1,15)
					spawn()advancedprojectile_ramped(eicon,estate,user,-16,-32,10,(400+200*conmult),1,90,0,15)
					spawn()advancedprojectile_ramped(eicon,estate,user,-25,-32,10,(400+200*conmult),1,85,0,15)
				if(user.dir==EAST)
					spawn()advancedprojectile_ramped(eicon,estate,user,32,25,10,(400+200*conmult),1,85,0,15)
					spawn()advancedprojectile_ramped(eicon,estate,user,32,16,10,(400+200*conmult),1,90,0,15)
					spawn()advancedprojectile_ramped(eicon,estate,user,32,0,10,(400+200*conmult),1,100,1,15)
					spawn()advancedprojectile_ramped(eicon,estate,user,32,-16,10,(400+200*conmult),1,90,0,15)
					spawn()advancedprojectile_ramped(eicon,estate,user,32,-25,10,(400+200*conmult),1,85,0,15)
				if(user.dir==WEST)
					spawn()advancedprojectile_ramped(eicon,estate,user,-32,25,10,(400+200*conmult),1,85,0,15)
					spawn()advancedprojectile_ramped(eicon,estate,user,-32,16,10,(400+200*conmult),1,90,0,15)
					spawn()advancedprojectile_ramped(eicon,estate,user,-32,0,10,(400+200*conmult),1,100,1,15)
					spawn()advancedprojectile_ramped(eicon,estate,user,-32,-16,10,(400+200*conmult),1,90,0,15)
					spawn()advancedprojectile_ramped(eicon,estate,user,-32,-25,10,(400+200*conmult),1,85,0,15)*/



	lightning_clone
		id = LIGHTNING_KAGE_BUNSHIN
		name = "Lightning Shadow Clone"
		icon_state = "lightning_bunshin"
		default_chakra_cost = 500
		default_cooldown = 30



		Use(mob/user)
			for(var/mob/human/player/npc/kage_bunshin/O in world)
				if(O.ownerkey==user.key)
					del(O)
			flick("Seal",user)

			viewers(user) << output("[user]: Shadow Clone!", "combat_output")
			var/mob/human/player/npc/kage_bunshin/X = new/mob/human/player/npc/kage_bunshin(locate(user.x,user.y,user.z))
			user.client.eye=X
			X.ownerkey=user.key
			user.controlmob=X
			spawn(2)
				X.icon=user.icon
				X.overlays=user.overlays
				X.underlays=user.underlays
				X.faction=user.faction
			//	X.lightning=1
				X.mouse_over_pointer=user.mouse_over_pointer
				X.con=user.con
				X.str=user.str
				X.rfx=user.rfx
				X.int=user.int

				X.name="[user.name]"
				spawn(1)X.CreateName(255, 255, 255)

			spawn() X.regeneration2()

			if(user) user.BunshinTrick(list(X))
//new
		raikiri
			id = RAIKIRI
			name = "Lightning: Raikiri"
			icon_state = "Raikiri"
			default_chakra_cost = 600
			default_cooldown = 90
			default_seal_time = 5



			Use(mob/human/user)
				viewers(user) << output("[user]: Lightning: Raikiri!", "combat_output")
				user.overlays+='icons/raikiri.dmi'

				var/mob/human/etarget = user.MainTarget()
				user.stunned=100
				if(!etarget)
					user.stunned=0
					user.usemove=1
					sleep(10)
					if(!user.usemove)
						return
					var/ei=7
					while(!etarget && ei>0)
						for(var/mob/human/o in get_step(user,user.dir))
							if(!o.ko&&!o.protected)
								etarget=o
						ei--
						walk(user,user.dir)
						sleep(1)
						walk(user,0)

					if(etarget)
						var/result=Roll_Against(user.rfx+user.rfxbuff-user.rfxneg,etarget.rfx+etarget.rfxbuff-etarget.rfxneg,70)
						if(result>=5)
							user.combat("[user] Critically hit [etarget] with the Raikiri")
							etarget.combat("[user] Critically hit [etarget] with the Raikiri")
							etarget.Wound(rand(50,100),1,user)
							etarget.Dec_Stam(rand(3200,5000),1,user)

						if(result==4||result==3)
							user.combat("[user] Managed to partially hit [etarget] with the Raikiri")
							etarget.combat("[user] Managed to partially hit [etarget] with the Raikiri")
							etarget.Wound(rand(20,40),1,user)
							etarget.Dec_Stam(rand(300,500),1,user)

						if(result>=3)
							spawn()ChidoriFX(user)
							etarget.move_stun=50
							spawn()Blood2(etarget,user)
							spawn()etarget.Hostile(user)
							spawn()user.Taijutsu(etarget)
						if(result<3)
							user.combat("You Missed!!!")
							if(!user.icon_state)
								flick("hurt",user)
					user.overlays-='icons/raikiri.dmi'
				else if(etarget)
					user.usemove=1
					spawn(20)
						user.overlays-='icons/raikiri.dmi'
					sleep(20)
					etarget = user.MainTarget()
					var/inrange=(etarget in oview(user, 10))
					user.stunned=0

					if(etarget && user.usemove==1 && inrange)
						var/result=Roll_Against(user.rfx+user.rfxbuff-user.rfxneg,etarget.rfx+etarget.rfxbuff-etarget.rfxneg,70)
						if(result>=5)
							user.combat("[user] Critically hit [etarget] with the Raikiri")
							etarget.combat("[user] Critically hit [etarget] with the Raikiri")
							etarget.Wound(rand(20,45),1,user)

							etarget.Dec_Stam(rand(2500,4500),1,user)

						if(result==4||result==3)
							user.combat("[user] Managed to partially hit [etarget] with the Raikiri")
							etarget.combat("[user] Managed to partially hit [etarget] with the Raikiri")
							etarget.Wound(rand(10,15),1,user)
							etarget.Dec_Stam(rand(1200,2000),1,user)
						if(result<3)
							user.combat("[user] Partially Missed [etarget] with the Raikiri,[etarget] is damaged by the electricity!")
							etarget.combat("[user] Partially Missed [etarget] with the Raikiri,[etarget] is damaged by the electricity!")
							etarget.Dec_Stam(rand(1200,1800),1,user)

						if(user.AppearMyDir(etarget))
							if(result>=3)
								spawn()ChidoriFX(user)
								etarget.move_stun=50
								spawn()Blood2(etarget,user)
								spawn()etarget.Hostile(user)
								spawn()user.Taijutsu(etarget)
							if(result<3)
								user.combat("You Missed!!!")
								if(!user.icon_state)
									flick("hurt",user)

		four_pillar_bind
			id = FOUR_PILLAR_BIND
			name = "Lightning: Four Pillar Bind"
			//description = "Four giant rock pillars are summoned around the enemy, then shoot bolts of lightning, immobilising the target and doing minimal damage to them."
			icon_state = "pillar_binding"
			default_chakra_cost = 350
			default_cooldown = 110
			default_seal_time = 10

			IsUsable(mob/human/user)
				if(..())
					var/mob/human/etarget = user.MainTarget()
					if(!etarget)
						Error(user, "No Target")
						return 0
					else
						return 1

			Use(mob/human/user)
				viewers(user) << output("[user]: Lightning: Four Pillar Bind!", "combat_output")
				var/conmult = user.ControlDamageMultiplier()
				var/mob/human/etarget = user.MainTarget()
				user.icon_state = "HandSeals"
				user.Timed_Stun(10)
				spawn(10) if(user.icon_state == "HandSeals") user.icon_state = ""
				sleep(5)//delay user jutsu use by half a second after this jutsu
				if(etarget)
					var/turf/eloc = etarget.loc
					new/obj/four_pillar(locate(eloc.x-2,eloc.y-2,eloc.z),"Left")
					new/obj/four_pillar(locate(eloc.x+2,eloc.y-2,eloc.z),"Right")
					new/obj/four_pillar(locate(eloc.x-2,eloc.y+2,eloc.z),"Left")
					new/obj/four_pillar(locate(eloc.x+2,eloc.y+2,eloc.z),"Right")
					sleep(10)
					for(var/turf/x in oview(2,eloc))
						if(!(locate(/obj/four_pillar) in x))
							spawn() Electricity(x.x,x.y,x.z,40)
					spawn() AOEcc(eloc.x,eloc.y,eloc.z,2,(rand(600,800)+150*conmult),(40+20*conmult),40,user,0,1.5,0)
					Electricity(eloc.x,eloc.y,eloc.z,40)

		false_darkness
			id = FALSE_DARKNESS
			name = "False Darkness"
//			description = "Releases a piercing lightning attack that will home in on one to three enemies."
			icon_state = "false_darkness"
			default_chakra_cost = 300
			default_seal_time = 8
			default_cooldown = 90

			var
				active_needles = 0

			Use(mob/human/user)
				viewers(user) << output("[user]: Lightning: False Darkness!", "combat_output")
				user.icon_state="Seal"
				spawn(10)
					user.icon_state = ""
				user.Begin_Stun()
				var/conmult = user.ControlDamageMultiplier()
				var/targets[] = user.NearestTargets(num=3)
				if(targets.len)
					for(var/mob/human/player/target in targets)
						++active_needles
						spawn()
							var/obj/trailmaker/o=new/obj/trailmaker/False_Darkness(locate(user.x,user.y,user.z))
							var/mob/result = Trail_Homing_Projectile(user.x,user.y,user.z,user.dir,o,8,target,1,1,0,0,1,user)
							if(result)
								result = result.Replacement_Start(user)
								result.Dec_Stam(rand(800,1000)+rand(150,200)*conmult,rand(1,4)+rand(0,2)*conmult,user,"Lightning: False Darkness","Normal")
								if(!result.ko && !result.IsProtected())
									result.movepenalty+=50
									spawn()Blood2(result,user)
									o.icon_state="still"
									spawn()result.Hostile(user)
								spawn(5) if(result) result.Replacement_End()
							--active_needles
							if(active_needles <= 0)
								user.End_Stun()
							o.loc = null
				else
					++active_needles
					spawn()
						var/obj/trailmaker/o=new/obj/trailmaker/False_Darkness(locate(user.x,user.y,user.z))
						var/mob/result = Trail_Straight_Projectile(user.x, user.y, user.z, user.dir, o, 8, user)
						if(result)
							result = result.Replacement_Start(user)
							result.Dec_Stam(rand(800,1000)+rand(150,200)*conmult,rand(1,4)+rand(0,2)*conmult,user,"Lightning: False Darkness","Normal")
							if(!result.ko && !result.IsProtected())
								result.movepenalty+=50
								spawn()Blood2(result,user)
								o.icon_state="still"
								spawn()result.Hostile(user)
							spawn(5) if(result) result.Replacement_End()
						--active_needles
						if(active_needles <= 0)
							user.End_Stun()
						o.loc = null

//Need to fix runtime errors with this jutsu, for some reason the compiler doesnt read the blank object acting as the center of the entire jutsu. I think i gotta make the object to read as a mob
/*		thunder_binding
			id = THUNDER_BINDING
			name = "Lightning Release: Thunder Binding"
			icon_state = "thunder_binding"
			default_chakra_cost = 400
			default_cooldown = 140
			default_seal_time = 10

			IsUsable(mob/user)
				.=..()
				if(.)
					if(!user.MainTarget())
						Error(user, "No Target")
						return 0

			Use(mob/human/user)
				var/mob/human/X = user.MainTarget()
				viewers(user) << output("[user]:<font color =aqua> Lightning Release: Thunder Binding!", "combat_output")

				user.icon_state="Seal"
				user.stunned=99

				var/conmult = user.ControlDamageMultiplier()

				if(X)
					var/obj/thunder_binding_animation/x = new/obj/thunder_binding_animation(locate(X.x+3,X.y+3,X.z))
					var/obj/thunder_binding_animation/z = new/obj/thunder_binding_animation(locate(X.x-3,X.y+3,X.z))
					var/obj/thunder_binding_animation/y = new/obj/thunder_binding_animation(locate(X.x-3,X.y-3,X.z))
					var/obj/thunder_binding_animation/u = new/obj/thunder_binding_animation(locate(X.x+3,X.y-3,X.z))
					sleep(5)
					var/obj/thunder_binding_right/A = new/obj/thunder_binding_right(locate(x.x,x.y,x.z))
					var/obj/thunder_binding_left/S = new/obj/thunder_binding_left(locate(z.x,z.y,z.z))
					var/obj/thunder_binding_left/D = new/obj/thunder_binding_left(locate(y.x,y.y,y.z))
					var/obj/thunder_binding_right/F = new/obj/thunder_binding_right(locate(u.x,u.y,u.z))
					var/obj/blank/H=new/obj/blank(locate(D.x+3,D.y+3,D.z))
					user.stunned=0
					user.icon_state=""
					del(x)
					del(z)
					del(y)
					del(u)

					spawn()

						//middle
						spawn()Electricity(H.x,H.y,H.z,30)
						//nagashi distance
						spawn()Electricity(H.x+1,H.y,H.z,30)
						spawn()Electricity(H.x-1,H.y,H.z,30)
						spawn()Electricity(H.x,H.y+1,H.z,30)
						spawn()Electricity(H.x,H.y-1,H.z,30)
						spawn()Electricity(H.x+1,H.y+1,H.z,30)
						spawn()Electricity(H.x-1,H.y+1,H.z,30)
						spawn()Electricity(H.x+1,H.y-1,H.z,30)
						spawn()Electricity(H.x-1,H.y-1,H.z,30)
						//outer distance
						spawn()Electricity(H.x+2,H.y,H.z,30)
						spawn()Electricity(H.x-2,H.y,H.z,30)
						spawn()Electricity(H.x+2,H.y+1,H.z,30)
						spawn()Electricity(H.x-2,H.y+1,H.z,30)
						spawn()Electricity(H.x+2,H.y-1,H.z,30)
						spawn()Electricity(H.x-2,H.y-1,H.z,30)
						spawn()Electricity(H.x,H.y+2,H.z,30)
						spawn()Electricity(H.x,H.y-2,H.z,30)
						spawn()Electricity(H.x+1,H.y+2,H.z,30)
						spawn()Electricity(H.x+1,H.y-2,H.z,30)
						spawn()Electricity(H.x-1,H.y+2,H.z,30)
						spawn()Electricity(H.x-1,H.y-2,H.z,30)
						spawn()Electricity(H.x+2,H.y+2,H.z,30)
						spawn()Electricity(H.x-2,H.y+2,H.z,30)
						spawn()Electricity(H.x+2,H.y-2,H.z,30)
						spawn()Electricity(H.x-2,H.y-2,H.z,30)

					spawn()AOExk(H.x,H.y,H.z,2,(500+350*conmult),30,user,0,1.5,1)
					Electricity(H.x,H.y,H.z,30)
					spawn(1)
						del(H)
						del(A)
						del(S)
						del(D)
						del(F)
					for(var/turf/New_Turfs/Outside/Wire/w in oview(7))
						spawn()Electricity(w.x,w.y,w.z,50)
						spawn()AOExk(w.x,w.y,w.z,1,(user.con+user.conbuff+conmult/2),50,user,0,1.5,1)
					for(var/turf/New_Turfs/Outside/Electricity/e in oview(10))
						spawn()Electricity(e.x,e.y,e.z,50)
						spawn()AOExk(e.x,e.y,e.z,1,(user.con+user.conbuff+conmult/2),50,user,0,1.5,1)
				else
					default_cooldown = 4
					user.combat("Failed due to no target, cooldown is 4")
					return*/

/*		kirin
			id = KIRIN
			name = "Lightning Release: Kirin"
			icon_state = "kirin"
			default_chakra_cost = 2500
			default_cooldown = 550
			default_seal_time = 15

			Use(mob/human/user)
				user.stunned=2
				viewers(user) << output("[user]:<font color =aqua>Lightning Release: Kirin!", "combat_output")
				spawn()
					var/mob/human/player/etarget = user.NearestTarget()
					if(etarget==null)
						usr<<"Need a target to Kirin!"
						return
					else
						var/ex=etarget.x
						var/ey=etarget.y
						var/ez=etarget.z
						var/mob/x=new/mob(locate(ex,ey,ez))
						var/obj/K = new/obj/Kirin(locate(ex,ey+3,ez))
						sleep(3.5)
						step_towards(K,x)
						sleep(3.5)
						step_towards(K,x)
						sleep(3.5)
						step_towards(K,x)
						user.curchakra=50
						user.Dec_Stam(rand(1000,2000),0,user)
						etarget.Dec_Stam(rand(4000,6000),user)
						for(var/turf/t in oview(x,7))
							spawn()Electricity(t.x,t.y,t.z,200)
						spawn()AOExk(x.x,x.y,x.z,6,user.con*2.5+user.conbuff+user.rfx*2+user.rfxbuff,200,user,0,1.5,1)
						Electricity(x.x,x.y,x.z,200)
						spawn(80)
							del(x)
							del(K)
						var/conmult = user.ControlDamageMultiplier()
						for(var/turf/New_Turfs/Outside/Wire/w in oview(7))
							spawn()Electricity(w.x,w.y,w.z,50)
							spawn()AOExk(w.x,w.y,w.z,1,(user.con+user.conbuff+conmult/2),50,user,0,1.5,1)
						for(var/turf/New_Turfs/Outside/Electricity/e in oview(10))
							spawn()Electricity(e.x,e.y,e.z,50)
							spawn()AOExk(e.x,e.y,e.z,1,(user.con+user.conbuff+conmult/2),50,user,0,1.5,1)

obj/Kirin
	icon='Kirin(smaller).dmi'
	density=0
	New()
		src.overlays+=image('icons/Kirin(smaller).dmi',icon_state = "1",pixel_x=-32,pixel_y=0)
		src.overlays+=image('icons/Kirin(smaller).dmi',icon_state = "2",pixel_x=0,pixel_y=0)
		src.overlays+=image('icons/Kirin(smaller).dmi',icon_state = "3",pixel_x=32,pixel_y=0)
		src.overlays+=image('icons/Kirin(smaller).dmi',icon_state = "4",pixel_x=-32,pixel_y=32)
		src.overlays+=image('icons/Kirin(smaller).dmi',icon_state = "5",pixel_x=0,pixel_y=32)
		src.overlays+=image('icons/Kirin(smaller).dmi',icon_state = "6",pixel_x=32,pixel_y=32)
		src.overlays+=image('icons/Kirin(smaller).dmi',icon_state = "7",pixel_x=-32,pixel_y=64)
		src.overlays+=image('icons/Kirin(smaller).dmi',icon_state = "8",pixel_x=0,pixel_y=64)
		src.overlays+=image('icons/Kirin(smaller).dmi',icon_state = "6",pixel_x=32,pixel_y=64)
		..()*/

obj
	lightning_one
		icon='icons/binding.dmi'
		layer=MOB_LAYER+1
		New()
			..()
			flick("anime 0,0",src)
	lightning_two
		icon='icons/binding.dmi'
		layer=MOB_LAYER+1
		pixel_y=32
		New()
			..()
			flick("anime 0,1",src)
	lightning_three
		icon='icons/binding.dmi'
		layer=MOB_LAYER+1
		pixel_y=64
		New()
			..()
			flick("anime 0,2",src)
obj
	lightning_four
		icon='icons/binding.dmi'
		layer=MOB_LAYER+1
		density=1
		icon_state="left 0,0"
	lightning_five
		icon='icons/binding.dmi'
		layer=MOB_LAYER+1
		pixel_y=32
		icon_state="left 0,1"
	lightning_six
		icon='icons/binding.dmi'
		layer=MOB_LAYER+1
		pixel_y=64
		icon_state="left 0,2"
obj
	lightning_seven
		icon='icons/binding.dmi'
		layer=MOB_LAYER+1
		density=1
		icon_state="right 0,0"
	lightning_eight
		icon='icons/binding.dmi'
		layer=MOB_LAYER+1
		pixel_y=32
		icon_state="right 0,1"
	lightning_nine
		icon='icons/binding.dmi'
		layer=MOB_LAYER+1
		pixel_y=64
		icon_state="right 0,2"

obj/blank2
	icon='blank.dmi'


obj/blank
	var
		list/area=new
	New()
		spawn()..()
		spawn()
			area+=new/obj/blank2(locate(src.x,src.y,src.z))
	Del()
		for(var/obj/x in src.area)
			del(x)
		..()

obj/thunder_binding_animation
	var
		list/thunder=new
	New()
		spawn()..()
		spawn()
			thunder+=new/obj/lightning_one(locate(src.x,src.y,src.z))
			thunder+=new/obj/lightning_two(locate(src.x,src.y,src.z))
			thunder+=new/obj/lightning_three(locate(src.x,src.y,src.z))
	Del()
		for(var/obj/x in src.thunder)
			del(x)
		..()
obj/thunder_binding_left
	var
		list/thunder=new
	New()
		spawn()..()
		spawn()
			thunder+=new/obj/lightning_four(locate(src.x,src.y,src.z))
			thunder+=new/obj/lightning_five(locate(src.x,src.y,src.z))
			thunder+=new/obj/lightning_six(locate(src.x,src.y,src.z))
	Del()
		for(var/obj/x in src.thunder)
			del(x)
		..()
obj/thunder_binding_right
	var
		list/thunder=new
	New()
		spawn()..()
		spawn()
			thunder+=new/obj/lightning_seven(locate(src.x,src.y,src.z))
			thunder+=new/obj/lightning_eight(locate(src.x,src.y,src.z))
			thunder+=new/obj/lightning_nine(locate(src.x,src.y,src.z))
	Del()
		for(var/obj/x in src.thunder)
			del(x)
		..()

proc/AOEcc(xx, xy, xz, radius, stamdamage, stamdamage2, duration, mob/human/attacker, wo, stun, knock)
	var/obj/M = new /obj(locate(xx, xy, xz))
	var/i = duration
	var/list/gotcha[] = list()
	while(i > 0)
		i -= 10
		for(var/mob/human/O in oview(radius, M))
			spawn() if(O && O != attacker && !O.IsProtected())
				O = O.Replacement_Start(attacker)
				if(!gotcha.Find(O.realname))
					O.Dec_Stam(stamdamage, rand(0, wo), attacker, "AOEcc", "Normal")
					gotcha.Add(O.realname)
				else
					O.Dec_Stam(stamdamage2, rand(0, wo), attacker, "AOEcc", "Normal")
				O.Hostile(attacker)
				if(!O.ko && O.icon_state != "hurt") O.icon_state = "hurt"
				O.Timed_Stun(11)
				O.movepenalty+=stun*10
				spawn(5) if(O) O.Replacement_End()
		sleep(10)
	for(var/mob/human/O in oview(radius, M))
		spawn() if(O  && O != attacker && knock)
			var/ns = 0
			var/ew = 0
			if(O.x > xx)
				ew = 1
			if(O.x < xx)
				ew = 2
			if(O.y < xy)
				ns = 2
			if(O.y > xy)
				ns = 1
			O = O.Replacement_Start(attacker)
			if(ns == 1 && ew == 0)
				O.Knockback(knock+1, NORTH)
			if(ns == 2 && ew == 0)
				O.Knockback(knock+1, SOUTH)
			if(ns == 1 && ew == 1)
				O.Knockback(knock+1, NORTHEAST)
			if(ns == 1 && ew == 2)
				O.Knockback(knock+1, NORTHWEST)
			if(ns == 2 && ew == 1)
				O.Knockback(knock+1, SOUTHEAST)
			if(ns == 2 && ew == 2)
				O.Knockback(knock+1, SOUTHWEST)
			if(ns == 0 && ew == 1)
				O.Knockback(knock+1, EAST)
			if(ns == 0 && ew == 2)
				O.Knockback(knock+1, WEST)
			if(!gotcha.Find(O.realname))
				O.Dec_Stam(stamdamage, rand(0, wo), attacker, "AOEcc", "Normal")
			else
				O.Dec_Stam(stamdamage2, rand(0, wo), attacker, "AOEcc", "Normal")
			O.Hostile(attacker)
			O.Timed_Stun(4)
			O.movepenalty+=stun*10
			spawn(5) if(O) O.Replacement_End()
		spawn(5) if(!O.ko && O.icon_state == "hurt") O.icon_state = ""
	M.loc = null

obj/four_pillar
	icon = 'icons/four_pillar_binding.dmi'
	density = 1
	layer = MOB_LAYER
	New(location,way)
		..()
		icon_state = way
		flick("[way]_Rise",src)
		spawn(60) loc = null