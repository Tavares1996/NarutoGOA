skill
	kaguya
		copyable = 0




		finger_bullets
			id = BONE_BULLETS
			name = "Piercing Finger Bullets"
			icon_state = "bonebullets"
			default_chakra_cost = 100
			default_cooldown = 20



			Use(mob/human/user)
				viewers(user) << output("[user]: Piercing Finger Bullets!", "combat_output")
				var/eicon='icons/bonebullets.dmi'
				var/estate=""

				if(!user.icon_state)
					user.icon_state="Throw2"
					spawn(20)
						user.icon_state=""

				var/angle
				var/speed = 32
				var/spread = 18
				if(user.MainTarget()) angle = get_real_angle(user, user.MainTarget())
				else angle = dir2angle(user.dir)

				var/damage = 200+75*user.ControlDamageMultiplier()

				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*2, distance=10, damage=damage, wounds=1)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread, distance=10, damage=damage, wounds=1)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle, distance=10, damage=damage, wounds=1)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle-spread, distance=10, damage=damage, wounds=1)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle-spread*2, distance=10, damage=damage, wounds=1)
				//advancedprojectile_ramped(i,estate,mob/efrom,xvel,yvel,distance,damage,wnd,vel,pwn,daze,radius)//daze as percent/100
				//spawn()advancedprojectile_ramped(eicon,estate,user,speed*cos(angle+spread*2),speed*sin(angle+spread*2),10,(500+200*conmult),1,100,0)
				//spawn()advancedprojectile_ramped(eicon,estate,user,speed*cos(angle+spread),speed*sin(angle+spread),10,(500+200*conmult),1,100,0)
				//spawn()advancedprojectile_ramped(eicon,estate,user,speed*cos(angle),speed*sin(angle),10,(500+200*conmult),1,100,1)
				//spawn()advancedprojectile_ramped(eicon,estate,user,speed*cos(angle-spread),speed*sin(angle-spread),10,(500+200*conmult),1,100,0)
				//spawn()advancedprojectile_ramped(eicon,estate,user,speed*cos(angle-spread*2),speed*sin(angle-spread*2),10,(500+200*conmult),1,100,0)




		bone_harden
			id = BONE_HARDEN
			name = "Bone Harden"
			icon_state = "bone_harden"
			default_chakra_cost = 20
			default_cooldown = 80



			IsUsable(mob/user)
				. = ..()
				if(.)
					if(user.ironskin)
						Error(user, "Cannot be used with Iron Skin active")
						return 0


			ChakraCost(mob/user)
				if(!user.boneharden)
					return ..(user)
				else
					return 0


			Cooldown(mob/user)
				if(!user.boneharden)
					return ..(user)
				else
					return 0


			Use(mob/user)
				if(!user.boneharden)
					user.combat("Your Bones Harden")
					user.boneharden=1
					ChangeIconState("bone_harden_cancel")
				else
					user.combat("You halt the chakra flow to your bones, they become soft again")
					user.boneharden=0
					ChangeIconState("bone_harden")




		camellia_dance
			id = BONE_SWORD
			name = "Camellia Dance"
			icon_state = "bone_sword"
			default_chakra_cost = 100
			default_cooldown = 200



			Use(mob/user)
				viewers(user) << output("[user]: Camellia Dance!", "combat_output")
				user.hasbonesword = 1
				user.boneuses=30
				var/o=new/obj/items/weapons/melee/sword/Bone_Sword(user)
				o:Use(user)




		young_bracken_dance
			id = SAWARIBI
			name = "Young Bracken Dance"
			icon_state = "sawarabi"
			base_charge = 150
			default_cooldown = 120
			default_seal_time = 30



			Use(mob/user)
				viewers(user) << output("[user]: Young Bracken Dance!", "combat_output")
				var/range=1 //200
				while(charge>base_charge && range<10)
					range+=1
					charge-=base_charge
				spawn()SpireCircle(user.x,user.y,user.z,range,user)




		larch_dance
			id = BONE_SPINES
			name = "Larch Dance"
			icon_state = "bone_spines"
			default_chakra_cost = 100
			default_cooldown = 35



			Use(mob/user)
				user.stunned+=2
				sleep(2)
				viewers(user) << output("[user]: Larch Dance!", "combat_output")
				var/obj/o=new(locate(user.x,user.y,user.z))
				o.icon='icons/Dance of the Larch.dmi'
				flick("flick",o)
				spawn()
					for(var/mob/human/M in oview(1,user))
						Blood2(M)
						M.Wound(rand(5,10),0,user)
						M.Dec_Stam(rand(100,500),0,user)
						spawn()M.Hostile(user)
						M.move_stun+=30
				sleep(4)
				del(o)
				user.overlays+='icons/Dance of the Larch.dmi'
				user.larch=1
				user.ironskin=1
				sleep(100)
				user.ironskin=0
				user.larch=0
				user.stunned+=2
				user.overlays-='icons/Dance of the Larch.dmi'
				var/obj/x=new(locate(user.x,user.y,user.z))
				x.icon='icons/Dance of the Larch.dmi'
				flick("unflick",x)
				sleep(4)
				del(x)

		dance_flower
			id = BONE_FLOWER
			name = "Dance Of the Clematis: Flower"
			icon_state = "flower"
			default_chakra_cost = 800
			default_cooldown = 100

			Use(mob/user)
				if(user.bonedrill)
					user << "You retract your bone drill."
					user.bonedrill = 0
					user.Load_Overlays()
					return
				viewers(user) << output("[user]: Dance Of the Clematis: Flower!", "combat_output")
				user.bonedrilluses = rand(4, 10)
				user.bonedrill=1
				user.combat("You have [user.bonedrilluses] uses")
				user.Load_Overlays()
				user<<"You have sculpted your arm into a massive drill! Press A to drill the guts out of anyone within punching range!"


		Clematis
			id = BONE_CLEMATIS
			name = "Dance Of the Clematis: Vine"
			icon_state = "clematis"
			default_chakra_cost = 300
			default_cooldown = 20

			Use(mob/human/user)
				user.stunned=5
				user.icon_state="Throw1"
				user.overlays+='clematis.dmi'
				spawn()
					while(user&&user.stunned>0)
						sleep(1)
					user.icon_state=""
					user.overlays-='clematis.dmi'
				var/obj/Clematis_Head/P
				var/dir = user.dir
				var/mob/human/player/etarget = user.MainTarget()
				if(etarget)
					dir = angle2dir_cardinal(get_real_angle(user, etarget))
					user.dir = dir
				P=new/obj/Clematis_Head
				switch(dir)
					if(NORTH)
						P.loc=locate(user.x,user.y+1,user.z)
					if(SOUTH)
						P.loc=locate(user.x,user.y-1,user.z)
					if(EAST)
						P.loc=locate(user.x+1,user.y,user.z)
					if(WEST)
						P.loc=locate(user.x-1,user.y,user.z)
					else
						return
				P.dir=dir
				P.icon='icons/clematis p.dmi'
				P.icon_state="Head"
				var/hit=0
				var/distance=10
				while(P && distance>0&&!hit)
					user.stunned=3
					for(var/mob/M in P.loc)
						if(!M.pressured && M!=user)
							M.pressured=1
							spawn(100)
								if(M&&M.pressured)
									M.pressured=0
							M.stunned+=5
							M.animate_movement=2
							hit=1
							M.Dec_Stam(500,0,user)
							M.overlays+='clematis h.dmi'
							spawn()
								while(M&&M.stunned>0)
									sleep(1)
								if(M)
									M.overlays-='clematis h.dmi'
									M.pressured=0
									M.animate_movement=1
								else
									return
							break
					if(!hit)
						step(P,P.dir)

						sleep(2)
						distance--
				user.stunned=0
				user.icon_state=""
				user.overlays-='clematis.dmi'
				P.Del()
obj
	Clematis_Head
		Move()
			var/old_loc = loc
			. = ..()
			if(. || !loc)
				spawn()new/obj/Clematis_Trail(src,old_loc,src.dir)
	Clematis_Trail
		icon='clematis p.dmi'
		density=0
		New(obj/owner,location,dirx)
			..()
			src.loc=location
			src.dir=dirx
			while(owner)
				sleep(1)
			del src



bone_field
	parent_type = /obj
	icon = 'sawa_part2.dmi'
	layer = MOB_LAYER+1
	density = 1

	New(loc)
		..(loc)
		overlays += image(icon = 'sawa_part1.dmi',pixel_x = -32)
		overlays += image(icon = 'sawa_part3.dmi',pixel_x = 32)
		overlays += image(icon = 'sawa_part4.dmi',pixel_x = -32,pixel_y = 32)
		overlays += image(icon = 'sawa_part5.dmi',pixel_y = 32)
		overlays += image(icon = 'sawa_part6.dmi',pixel_x = 32,pixel_y = 32)
	Click()
		Travel(usr)
	Bumped(atom/movable/o)
		Travel(o)
	proc
		Travel(mob/user)
			if(user == owner)
				density = 0
				user.Move(loc,user.dir)
				density = 1


atom
	movable
		Bump(atom/o)
			o.Bumped(src)
	proc
		Bumped(atom/movable/o)