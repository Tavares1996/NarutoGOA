mob/var/mist_active=0
var/mist = 0
mob/var
	jutsunumber = 0
skill
	water
		giant_vortex
			id = SUITON_VORTEX
			name = "Water: Giant Vortex"
			icon_state = "giant_vortex"
			default_chakra_cost = 200
			default_cooldown = 60
			default_seal_time = 15



			Use(mob/human/user)
				viewers(user) << output("[user]: Water: Giant Vortex!", "combat_output")

				var/conmult = user.ControlDamageMultiplier()

				user.stunned=1.5
				spawn()wet_proj(user.x,user.y,user.z,'icons/watervortex.dmi',"",user,9,(225*conmult+700),2)
				if(user.dir==NORTH||user.dir==SOUTH)
					spawn()wet_proj(user.x+1,user.y,user.z,'icons/watervortex.dmi',"",user,9,(225*conmult+700),0)
					spawn()wet_proj(user.x-1,user.y,user.z,'icons/watervortex.dmi',"",user,9,(225*conmult+700),0)
				if(user.dir==EAST||user.dir==WEST)
					spawn()wet_proj(user.x,user.y-1,user.z,'icons/watervortex.dmi',"",user,9,(225*conmult+700),0)
					spawn()wet_proj(user.x,user.y+1,user.z,'icons/watervortex.dmi',"",user,9,(225*conmult+700),0)




		bursting_water_shockwave
			id = SUTION_SHOCKWAVE
			name = "Water: Bursting Water Shockwave"
			icon_state = "exploading_water_shockwave"
			default_chakra_cost = 500
			default_cooldown = 120
			default_seal_time = 30



			Use(mob/human/user)
				viewers(user) << output("[user]: Water: Bursting Water Shockwave!", "combat_output")

				var/conmult = user.ControlDamageMultiplier()

				user.stunned=3
				spawn()wet_proj(user.x,user.y,user.z,'icons/watershockwave.dmi',"",user,14,(1000+500*conmult),6)
				if(user.dir==NORTH||user.dir==SOUTH)
					spawn()wet_proj(user.x+1,user.y,user.z,'icons/watershockwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x-1,user.y,user.z,'icons/watershockwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x+2,user.y,user.z,'icons/watershockwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x-2,user.y,user.z,'icons/watershockwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x+3,user.y,user.z,'icons/watershockwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x-3,user.y,user.z,'icons/watershockwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x+4,user.y,user.z,'icons/watershockwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x-4,user.y,user.z,'icons/watershockwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x+5,user.y,user.z,'icons/watershockwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x-5,user.y,user.z,'icons/watershockwave.dmi',"",user,14,(1000+500*conmult),0)
				if(user.dir==EAST||user.dir==WEST)
					spawn()wet_proj(user.x,user.y+1,user.z,'icons/watershockwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x,user.y-1,user.z,'icons/watershockwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x,user.y+2,user.z,'icons/watershockwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x,user.y-2,user.z,'icons/watershockwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x,user.y+3,user.z,'icons/watershockwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x,user.y-3,user.z,'icons/watershockwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x,user.y+4,user.z,'icons/watershockwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x,user.y-4,user.z,'icons/watershockwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x,user.y+5,user.z,'icons/watershockwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x,user.y-5,user.z,'icons/watershockwave.dmi',"",user,14,(1000+500*conmult),0)




		water_dragon
			id = SUITON_DRAGON
			name = "Water: Water Dragon Projectile"
			icon_state = "water_dragon_blast"
			default_chakra_cost = 100
			default_cooldown = 90
			default_seal_time = 30



			IsUsable(mob/user)
				. = ..()
				if(.)
					if(!Iswater(user.x,user.y,user.z))
						Error(user, "You must be standing on water to use this technique.")
						return 0


			Use(mob/human/user)
				viewers(user) << output("[user]: Water: Water Dragon Projectile!", "combat_output")

				user.stunned=10
				var/conmult = user.ControlDamageMultiplier()
				var/mob/human/player/etarget = user.MainTarget()

				if(etarget)
					var/obj/trailmaker/o=new/obj/trailmaker/Water_Dragon()
					var/mob/result=Trail_Homing_Projectile(user.x,user.y,user.z,user.dir,o,20,etarget)
					if(result)
						result.Knockback(2,o.dir)
						spawn(1)
							del(o)
						result.Dec_Stam((2000 + 1750*conmult),0,user)
						spawn()result.Hostile(user)
				else
					var/obj/trailmaker/o=new/obj/trailmaker/Water_Dragon()
					var/mob/result=Trail_Straight_Projectile(user.x,user.y,user.z,user.dir,o,8)
					if(result)
						result.Knockback(2,o.dir)
						spawn(1)
							del(o)
						result.Dec_Stam((2000 + 1750*conmult),0,user)
						spawn()result.Hostile(user)
				user.stunned=0




		collision_destruction
			id = SUITON_COLLISION_DESTRUCTION
			name = "Water: Collision Destruction"
			icon_state = "watercollision"
			default_chakra_cost = 450
			default_cooldown = 70
			default_seal_time = 15



			IsUsable(mob/user)
				. = ..()
				if(.)
					if(!user.MainTarget())
						Error(user, "No Target")
						return 0
					if(!user.NearWater(4))
						Error(user, "Must be near water")
						return 0


			Use(mob/human/user)
				user.stunned=5
				viewers(user) << output("[user]: Water: Collision Destruction!", "combat_output")

				var/conmult = user.ControlDamageMultiplier()
				var/mob/human/player/etarget = user.MainTarget()
				if(etarget)
					user.icon_state="Seal"
					etarget.overlays+='icons/watersurround.dmi'
					spawn(5)etarget.overlays-='icons/watersurround.dmi'
					var/turf/L=etarget.loc
					sleep(5)
					var/hit=0
					if(L && L==etarget.loc)
						hit=1
						etarget.stunned=7
						user.stunned=1

					var/obj/O =new(locate(L.x,L.y,L.z))
					O.layer=MOB_LAYER+3
					O.overlays+=image('icons/watercollisiondestruction.dmi',icon_state="0,1",pixel_x=-16,pixel_y=16)
					O.overlays+=image('icons/watercollisiondestruction.dmi',icon_state="1,1",pixel_x=16,pixel_y=16)
					O.overlays+=image('icons/watercollisiondestruction.dmi',icon_state="0,0",pixel_x=-16,pixel_y=-16)
					O.overlays+=image('icons/watercollisiondestruction.dmi',icon_state="1,0",pixel_x=16,pixel_y=-16)
					var/found=0

					for(var/obj/Water/X in oview(4,user))
						found++
						break
					if(found>10)found=10
					if(hit && etarget)
						etarget.Dec_Stam((1400 + 400*conmult + found*50),0,user)
						spawn()etarget.Hostile(user)
					sleep(50)
					if(etarget)etarget.stunned=0
					user.stunned=0

					if(O)del(O)
					user.icon_state=""


/*		water_prison
			id = SUITON_PRISON
			name = "Water Release: Water Prison"
			icon_state = "water_prison"
			default_chakra_cost = 250
			default_cooldown = 90
			default_seal_time = 20

			IsUsable(mob/user)
				. = ..()
				if(.)
					if(!Iswater(user.x,user.y,user.z)&&!user.tobirama)
						Error(user, "You must be standing on water to use this technique.")
						return 0
					var/mob/human/target = user.NearestTarget()
					if(. && target)
						var/distance = get_dist(user, target)
						if(distance > 5)
							Error(user, "Target too far ([distance]/5 tiles)")
							return 0

			Use(mob/human/user)
				var/mob/human/player/etarget = user.MainTarget()
				viewers(user) << output("[user]:<font color=#5CB3FF> Water Release: Water Prison!", "combat_output")
				var/prison=0
				if(!etarget)
					user.combat("I'm sorry but there was no target for you to use water prison on.Due to this your cooldown is 45 seconds")
					default_cooldown=45
					return
				else
					user.stunned=30
					etarget.stunned=30
					user.AppearBehind(etarget)
					user.icon_state="Throw1"
					var/obj/x=new/obj/water_prison(etarget.loc)
					sleep(4)
					var/conmult = user.ControlDamageMultiplier()
					var/obj/gh=new/obj/water_prison_full(etarget.loc)
					del(x)
					user.dir=etarget.loc
					prison=pick(5,9)
					spawn()
						while(prison>0)
							if(etarget)
								etarget.curchakra-=rand(50,200)
								etarget.Dec_Stam(rand(10, 40)*conmult,0,user)
							user.curchakra-=50
							sleep(10)
							prison--
							if(prison<=0&&user)
								user.icon_state=""
								user.stunned=0
								del(gh)
								etarget.stunned=0
						if(!etarget&&user&&etarget)
							user.icon_state=""
							user.stunned=0
							del(gh)
							etarget.stunned=0*/

/*		water_shark
			id = SUITON_SHARK
			name = "Water Release: Shark Bullet Technique"
			icon_state = "water_shark"
			default_chakra_cost = 100
			default_cooldown = 40

			IsUsable(mob/user)
				. = ..()
				if(.)
					if(!user.NearWater(8)&&!user.tobirama&&!user.jutsunumber>0)
						Error(user, "Must be near water")
						return 0
					if(!user.MainTarget())
						Error(user, "No Target")
						return 0

			Use(mob/human/user)
			//	if(user.fusion)
			//		user.jutsunumber--
				//	user.combat("You are able to use water jutsu without water [user.jutsunumber] more times")
				viewers(user) << output("[user]:<font color=#5CB3FF> Water Release: Shark Bullet Technique!", "combat_output")
				var/conmult = user.ControlDamageMultiplier()
				var/mob/human/player/etarget = user.MainTarget()
				var/R=pick(100,500)
				if(etarget)
					var/obj/trailmaker/o=new/obj/water_shark()
					var/mob/result=Trail_Homing_Projectile(user.x,user.y,user.z,user.dir,o,20,etarget)
					if(result)
						spawn(1)
							del(o)
						result.Dec_Stam((R*conmult),0,user)
						result.Wound(rand(0, 2), 0, user)
						spawn()result.Hostile(user)

		water_release_water_clone
			id = SUITON_CLONE
			name = "Water Release: Water Clone"
			icon_state = "water_clone"
			default_chakra_cost = 200
			default_cooldown = 45
			default_seal_time = 12

			IsUsable(mob/user)
				. = ..()
				if(.)
					if(!user.NearWater(6)&&!user.tobirama&&!user.jutsunumber>0)
						Error(user, "Must be near water")
						return 0

			Use(mob/user)
				//if(user.fusion)
				//	user.jutsunumber--
				//	user.combat("You are able to use water jutsu without water [user.jutsunumber] more times")
				viewers(user) << output("[user]: Water Release: Water Clone!", "combat_output")
				var/mob/human/player/npc/kage_bunshin/O = new/mob/human/player/npc/kage_bunshin(locate(user.x,user.y-1,user.z))
				spawn(2)
					O.icon='icons/base_m_water.dmi'
					O.faction=user.faction
					O.mouse_over_pointer=user.mouse_over_pointer
					O.chakra = user.chakra
					O.curchakra = user.chakra
					O.temp = 1200
					O.str += user.str
					O.rfx += user.rfx
					O.int += user.int
					O.con += user.con
					O.overlays+=user.overlays
					O.name="[user.name] Water Clone"
					spawn(1)O.CreateName(255, 255, 255)
					spawn()O.AIinitialize()
					O.owner=user
					O.killable=1
					user.pet+=O
					for(var/skill/X in user.skills)
						O.AddSkill(X.id)
					spawn(150)
						if(locate(O) in world)
							del(O)

		gunshot
			id = SUITON_GUNSHOT
			name = "Water Release: Gunshot"
			icon_state = "water_bullet"
			default_chakra_cost = 200
			default_cooldown = 15

			Use(mob/human/user)
				viewers(user) << output("[user]:<font color=#5CB3FF> Water Release: Gunshot!", "combat_output")
				var/conmult = user.ControlDamageMultiplier()
				user.icon_state="Seal"
				var/obj/trailmaker/o=new/obj/water_bullet()
				var/mob/result=Trail_Straight_Projectile(user.x,user.y,user.z,user.dir,o,10,user)
				user.icon_state=""
				if(result)
					spawn(1)
						del(o)
					result.Dec_Stam(rand(160,240)*conmult,1,user)
					result.Knockback(1,o.dir)
					spawn()result.Hostile(user)

		water_shark_gun_technique
			id = SUITON_SHARK_GUN
			name = "Water Release: Water Shark Gun Technique"
			icon_state = "water_shark_gun"
			default_chakra_cost = 1000
			default_cooldown = 180
			default_seal_time = 15

			IsUsable(mob/user)
				.=..()
				if(.)
					if(!user.MainTarget())
						Error(user, "No Target")
						return 0

			Use(mob/human/user)
				var/conmult = user.ControlDamageMultiplier()
				var/mob/human/player/etarget = user.MainTarget()
				if(etarget)
					if(!Iswater(etarget.x,etarget.y,etarget.z)&&!user.tobirama&&!user.jutsunumber>0)
						viewers(user) << output("Your target must be standing on water to use this technique", "combat_output")
						var/value=0
						value=default_cooldown
						value=120
						return value
					else
					//	if(user.fusion)
						//	user.jutsunumber--
						//	user.combat("You are able to use water jutsu without water [user.jutsunumber] more times")
						viewers(user) << output("[user]:<font color=#5CB3FF> Water Release: Water Shark Gun Technique!", "combat_output")
						if(!etarget.protected&&!etarget.ko)
							user.icon_state="Seal"
							user.stunned=99
							etarget.stunned=99
							var/obj/X=new/obj/water_shark(locate(etarget.x+3,etarget.y,etarget.z),user)
							spawn(1)Poof(X.x,X.y,X.z)
							spawn(3)Homing_Projectile_Shark(user,X,8,etarget,1)
							sleep(8)
							etarget.Dec_Stam(1500+rand(100,400)*conmult)
							del(X)
							Blood2(etarget)
							etarget.Wound(rand(0,5),1,user)
							var/obj/Z=new/obj/water_shark(locate(etarget.x-3,etarget.y,etarget.z),user)
							spawn(1)Poof(Z.x,Z.y,Z.z)
							spawn(3)Homing_Projectile_Shark(user,Z,8,etarget,1)
							sleep(8)
							etarget.Dec_Stam(1500+rand(100,400)*conmult)
							del(Z)
							Blood2(etarget)
							etarget.Wound(rand(0,5),1,user)
							var/obj/Y=new/obj/water_shark(locate(etarget.x,etarget.y-3,etarget.z),user)
							spawn(1)Poof(Y.x,Y.y,Y.z)
							spawn(3)Homing_Projectile_Shark(user,Y,8,etarget,1)
							sleep(8)
							etarget.Dec_Stam(1500+rand(100,400)*conmult)
							del(Y)
							Blood2(etarget)
							etarget.Wound(rand(0,5),1,user)
							var/obj/Q=new/obj/water_shark(locate(etarget.x,etarget.y+3,etarget.z),user)
							spawn(1)Poof(Q.x,Q.y,Q.z)
							spawn(3)Homing_Projectile_Shark(user,Q,8,etarget,1)
							sleep(8)
							etarget.Dec_Stam(1500+rand(100,400)*conmult)
							del(Q)
							Blood2(etarget)
							etarget.Wound(rand(0,5),1,user)
							user.icon_state=""
							user.stunned=0
							etarget.stunned=0
							spawn()etarget.Hostile(user)*/

		hidden_mist
			id = SUITON_HIDDEN_MIST
			name = "Water: Hidden Mist"
	//		description = "Create a dense mist which causes your enemies to have difficulty tracking you. This costs 200 less chakra if the user is near water."
			icon_state = "hidden_mist"
			default_chakra_cost = 650
			default_cooldown = 180
			default_seal_time = 15

			ChakraCost(mob/user)
				var/cost = default_chakra_cost
				if(user.NearWater(4))
					cost -= 200
				if(user.skillspassive[5])
					return round(cost * (1 - user.skillspassive[5] * 0.04))
				else
					return cost




			Use(mob/human/user)
				viewers(user) << output("[user]: Water: Hidden Mist! (not the final icon)", "combat_output")
				user.icon_state="Seal"
				user.Timed_Stun(20)
				spawn(20)
					user.icon_state=""
					user.HideInMist()

				var/size = 4
				if(user.con < 100) size = 3
				else if(user.con < 140) size = 4
				else if(user.con < 180) size = 5
				else if(user.con < 220) size = 6
				else if(user.con < 260) size = 7
				else if(user.con < 300) size = 8
				else if(user.con < 340) size = 9
				else if(user.con < 380) size = 10
				else if(user.con < 420) size = 11
				else if(user.con < 460) size = 12
				else if(user.con < 500) size = 13
				else if(user.con < 540) size = 14
				else if(user.con < 580) size = 15
				else if(user.con >= 620) size = 16
				MistSpread(user, user.loc, size=size, delay=3)



/*	water_prison
		id = SUITON_WATER_PRISON
		name = "Water Prison"
		description = "Traps your enemy in a prison of water so dense it has been compaired to steel."
		icon_state = "water_prison"
		default_chakra_cost = 100
		default_cooldown = 150
		default_seal_time = 10

		IsUsable(mob/user)
			. = ..()
			if(.)
				if(!Iswater(user.loc))
					Error(user, "You must be standing on water to use this technique.")
					return 0
				if(user.keys["shift"]) //x modifies this jutsu to have it target yourself, so having no target is OK
					modified = 1
					return 1
				var/mob/human/etarget = user.MainTarget()
				var/distance = get_dist(user, etarget)
				if(etarget && !etarget.ko && distance > 1)
					Error(user, "Target too far ([distance]/1 tiles)")
					return 0
				if(!etarget || (etarget && etarget.ko))
					for(var/mob/human/eX in get_step(user,user.dir))
						if(!eX.ko && !eX.IsProtected())
							return 1 //target found
					Error(user, "No Valid Target")
					return 0

		Use(mob/human/player/user)
			viewers(user) << output("[user]: Water: Water Prison! (icon not complete)", "combat_output")
			if(modified)
				modified = 0
				var/obj/wp = new/obj
				wp.icon = 'icons/water_prison.dmi'
				wp.icon_state = "captured"
				flick("capturing",wp)
				wp.pixel_x -= 32
				wp.pixel_y -= 32
				wp.layer = MOB_LAYER
				wp.loc = user.loc
				user.icon_state = "Seal"
				user.Protect(50)
				user.Timed_Stun(50)
				sleep(50)
				user.icon_state = ""
				wp.loc = null
				return

			user.Timed_Stun(20)
			user.icon_state="Throw1"
			var/mob/human/gotcha
			var/turf/getloc

			var/mob/human/etarget = user.MainTarget()
			if(etarget && !etarget.ko && !(get_dist(user, etarget) > 1))
				user.FaceTowards(etarget)
			else
				for(var/mob/human/eX in get_step(user,user.dir))
					if(!eX.ko && !eX.IsProtected())
						etarget = eX
						break

			var/obj/wp = new/obj
			wp.dir = user.dir
			wp.icon = 'icons/water_prison.dmi'
			wp.icon_state = "start"
			spawn(4)
				wp.icon_state = "capturing"
				spawn(5)
					wp.icon_state = "captured"
			wp.pixel_x -= 32
			wp.pixel_y -= 32
			wp.layer = MOB_LAYER

			gotcha=etarget.Replacement_Start(user)
			wp.loc = gotcha.loc
			gotcha.movepenalty+=30
			if(gotcha != etarget)
				wp.loc = null
				user.icon_state=""
				spawn(5) if(gotcha) gotcha.Replacement_End()
				return
			getloc=locate(etarget.x,etarget.y,etarget.z)

			user.FaceTowards(gotcha)
			user.Timed_Stun(5)
			user.water_prison = 1
			user.usemove = 1
			user.FaceTowards(gotcha)
			gotcha.water_prison = 2
			gotcha.Begin_Stun()
			gotcha.icon_state = "Hurt"
			gotcha.Hostile(user)
			var/turf/q=user.loc
			while(user && user.usemove && user.curchakra > 15 && gotcha && !gotcha.ko && gotcha.loc==getloc && (abs(user.x-gotcha.x)*abs(user.y-gotcha.y))<=1 && user.x==q.x && user.y==q.y)
				gotcha.Protect(5)
				if(gotcha.staminaregen > -100)
					if(gotcha.staminaregen <= -97)
						gotcha.staminaregen = -100
					else
						gotcha.staminaregen -= 4
				if(gotcha.curstamina<=0)
					gotcha.curstamina=0
					spawn() gotcha.KO()
				user.curchakra -= 15
				sleep(5)
			if(gotcha)
				wp.loc = null
				if(!gotcha.ko) icon_state = ""
				gotcha.water_prison = 0
		//		gotcha.RecalculateStats()
				gotcha.End_Stun()
			user.icon_state=""
			user.water_prison = 0*/

	water_bullet
		id = SUITON_WATER_BULLET
		name = "Water Bullet"
		//description = "Fires a water projectile at your opponent"
		icon_state = "water_bullet"
		default_chakra_cost = 250
		base_charge = 50
		default_cooldown = 30
		default_seal_time = 10

		Use(mob/human/player/user)
			viewers(user) << output("[user]: Water: Water Bullet!", "combat_output")
			var/damage = 120+40*user.ControlDamageMultiplier()

			var/eicon='icons/water_bullet.dmi'
			var/estate="medium"

			//snd(user,'sounds/chidori_static1sec.wav',vol=30)
			var/mob/human/player/etarget = user.NearestTarget()

			var/speed = 40
			var/angle

			var/times = charge/200
			user.icon_state="Seal"
			spawn(times*2) user.icon_state=""
			//user.Timed_Stun(times*2)
			for(var/i=0,i <= times, i++)
				if(etarget)
					angle = get_real_angle(user, etarget)
					user.dir = angle2dir_cardinal(angle)
				else angle = dir2angle(user.dir)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+1*rand(-4,4), distance=10, damage=damage, wounds=0)
				sleep(2)


proc/Homing_Projectile_Shark(mob/U,mob/human/shark/proj,xdur,mob/human/M,lag)
	if(M && U && proj)
		proj.dir=U.dir
		var/i = 8
		if(xdur>8)
			i=xdur
		proj.density=0
		var/mob/hit
		while(i>0 && !hit)

			var/DesiredAngle
			if(M&& proj)
				DesiredAngle=get_real_angle(proj, M)
				var/angle = DesiredAngle - dir2angle(proj.dir)
				angle = normalize_angle(angle)
				proj.dir = turn(proj.dir, dir2angle(angle2dir(angle)))

				for(var/mob/human/R in get_step(proj,proj.dir))
					if(R)
						proj.density=0
						R.move_stun+=10
						R.stunned = 1.8
						spawn(1)
							if(proj) proj.density=1
			if(proj)
				walk(proj,proj.dir)
				sleep(1)
				walk(proj,0)
				for(var/mob/human/F in oview(0,proj))
					if(F!=U)
						hit=F
				sleep(1+lag)
			i--
		if(!proj) return
		if(hit)
			return hit


obj
	MistEffect
		icon = 'icons/misteffect.dmi'
		screen_loc = "1,1 to 17,17"
		icon_state="1"
		layer = 99999999999999
		New(client/C)
			if(C)
				C.screen += src
			spawn(10)
				if(src)
					del(src)
	MistEffect2
		icon = 'icons/misteffect.dmi'
		screen_loc = "1,1 to 17,17"
		icon_state="2"
		layer = 99999999999999
		New(client/C)
			if(C)
				C.screen += src
			spawn(10)
				if(src)
					del(src)
	MistEffect3
		icon = 'icons/misteffect.dmi'
		screen_loc = "1,1 to 17,17"
		icon_state="3"
		layer = 99999999999999
		New(client/C)
			if(C)
				C.screen += src
			spawn(10)
				if(src)
					del(src)
	MistEffect4
		icon = 'icons/misteffect.dmi'
		screen_loc = "1,1 to 17,17"
		icon_state="4"
		layer = 99999999999999
		New(client/C)
			if(C)
				C.screen += src
			spawn(10)
				if(src)
					del(src)


obj/waterfall_trail
	icon='blank.dmi'

obj/water_bullet
	icon='icons/water_bullet.dmi'

mob/human/shark
	water_shark
		New(loc)
			..(loc)
			overlays += image(icon = 'icons/water_shark.dmi',icon_state = "0,0",pixel_x = -16)
			overlays += image(icon = 'icons/water_shark.dmi',icon_state = "1,0",pixel_x = 16)
			overlays += image(icon = 'icons/water_shark.dmi',icon_state = "0,1",pixel_x = -16,pixel_y = 32)
			overlays += image(icon = 'icons/water_shark.dmi',icon_state = "1,1",pixel_x = 16,pixel_y = 32)

obj/water_shark
	New(loc)
		..(loc)
		overlays += image(icon = 'icons/water_shark.dmi',icon_state = "0,0",pixel_x = -16)
		overlays += image(icon = 'icons/water_shark.dmi',icon_state = "1,0",pixel_x = 16)
		overlays += image(icon = 'icons/water_shark.dmi',icon_state = "0,1",pixel_x = -16,pixel_y = 32)
		overlays += image(icon = 'icons/water_shark.dmi',icon_state = "1,1",pixel_x = 16,pixel_y = 32)

obj
	water_one
		icon='icons/water_prison.dmi'
		layer=MOB_LAYER+1
		pixel_x=-16
		icon_state="0,0"
	water_two
		icon='icons/water_prison.dmi'
		layer=MOB_LAYER+1
		pixel_x=16
		icon_state="1,0"
	water_three
		icon='icons/water_prison.dmi'
		layer=MOB_LAYER+1
		pixel_x=-16
		pixel_y=32
		icon_state="0,1"
	water_four
		icon='icons/water_prison.dmi'
		layer=MOB_LAYER+1
		pixel_x=16
		pixel_y=32
		icon_state="1,1"

obj/water_prison_full
	var
		list/dependants=new
	New()
		spawn()..()
		spawn()
			dependants+=new/obj/water_one(locate(src.x,src.y,src.z))
			dependants+=new/obj/water_two(locate(src.x,src.y,src.z))
			dependants+=new/obj/water_three(locate(src.x,src.y,src.z))
			dependants+=new/obj/water_four(locate(src.x,src.y,src.z))
	Del()
		for(var/obj/x in src.dependants)
			del(x)
		..()

obj
	water_one
		icon='icons/water_prison.dmi'
		layer=MOB_LAYER+1
		pixel_x=-16
		New()
			..()
			flick("flick 0,0",src)
	water_two
		icon='icons/water_prison.dmi'
		layer=MOB_LAYER+1
		pixel_x=16
		New()
			..()
			flick("flick 1,0",src)
	water_three
		icon='icons/water_prison.dmi'
		layer=MOB_LAYER+1
		pixel_x=-16
		pixel_y=32
		New()
			..()
			flick("flick 0,1",src)
	water_four
		icon='icons/water_prison.dmi'
		layer=MOB_LAYER+1
		pixel_x=16
		pixel_y=32
		New()
			..()
			flick("flick 1,1",src)

obj/water_prison
	var
		list/dependants=new
	New()
		spawn()..()
		spawn()
			dependants+=new/obj/water_one(locate(src.x,src.y,src.z))
			dependants+=new/obj/water_two(locate(src.x,src.y,src.z))
			dependants+=new/obj/water_three(locate(src.x,src.y,src.z))
			dependants+=new/obj/water_four(locate(src.x,src.y,src.z))
	Del()
		for(var/obj/x in src.dependants)
			del(x)
		..()

mob/var/tmp/hiddenmist

mob/proc/HideInMist()
	usr.hiddenmist=1
	usr.icon='icons/base_invisible.dmi'
	usr.overlays=0
	for(var/mob/human/H in usr.targeted_by)
		H.RemoveTarget(usr)
		H.AddTarget(usr, active=0, silent=1)

obj/mistobj
	icon = 'icons/mist.dmi'
	icon_state = ""
	pixel_x = -8
	pixel_y = -8
	layer = 6.2
	mouse_opacity = 0
	var/tmp/mob/human/muser
	New()
		..()
		spawn(200)
			if(muser in src.loc)
				muser.hiddenmist=0
				muser.Affirm_Icon()
				muser.Load_Overlays()
			loc = null
	proc/spread(turf/source, size=3, delay=2)
		var/list/dirs = list(NORTH,,EAST,SOUTH,WEST,NORTHWEST,NORTHEAST,SOUTHEAST,SOUTHWEST)
		for(var/xdir in dirs)
			var/doit = 1
			for(var/obj/mistobj/mo in get_step(src,xdir))
				if(mo.muser == src.muser) doit = 0
			if(doit)
				var/obj/mistobj/mist = new/obj/mistobj(src.loc)
				mist.muser = src.muser
				var/stepcheck = step(mist, xdir)
				if(stepcheck)
					if(size > get_dist(mist,source)) spawn(delay) mist.spread(source, size=size, delay=delay)
					sleep(1)
				else
					mist.loc = null
proc/MistSpread(mob/user, turf/source, size=3, delay=2)
	var/obj/mistobj/mist = new/obj/mistobj(source)
	mist.muser = user
	mist.spread(source, size, delay)
