mob
	var
		sandshield=0
skill
	sand_control
		copyable = 0




		sand_summon
			id = SAND_SUMMON
			name = "Sand Summoning"
			icon_state = "sand_control"
			default_chakra_cost = 300
			default_cooldown = 10



			Use(mob/human/user)
				var/lim=0
				for(var/mob/human/x in user.pet)
					if(x)
						if(++lim > 3)
							del(x)
				if(!istype(user.pet, /list))user.pet=new/list
				viewers(user) << output("[user]: Sand Summoning!", "combat_output")

				var/mob/human/p=new/mob/human/sandmonster(user.loc)
				user.pet+=p
				p.initialized=1
				p.faction = user.faction
				p.con=user.con

				spawn()
					var/ei=1
					while(ei)
						ei=0
						for(var/mob/human/x in oview(10,p))
							if(x==user)
								ei=1
						sleep(20)
					if(p)
						//user.pet-=p
						del(p)




		sand_unsummon
			id = SAND_UNSUMMON
			name = "Sand Unsummoning"
			icon_state = "sand_unsummon"
			default_chakra_cost = 20
			default_cooldown = 3



			Use(mob/human/user)
				viewers(user) << output("[user]: Sand Unsummoning!", "combat_output")
				for(var/mob/human/sandmonster/X in user.pet)
					del(X)


		bursting_sand_burial
			id = SAND_WAVE
			name = "Sand Secret Attack: Sand Wave!!"
			icon_state = "exploading_water_shockwave"
			default_chakra_cost = 500
			default_cooldown = 120
			default_seal_time = 30



			Use(mob/human/user)
				viewers(user) << output("[user]: Sand Secret Attack: Sand Wave!!", "combat_output")

				var/conmult = user.ControlDamageMultiplier()

				user.stunned=3
				spawn()wet_proj(user.x,user.y,user.z,'icons/sandwave.dmi',"",user,14,(1000+500*conmult),6)
				if(user.dir==NORTH||user.dir==SOUTH)
					spawn()wet_proj(user.x+1,user.y,user.z,'icons/sandwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x-1,user.y,user.z,'icons/sandwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x+2,user.y,user.z,'icons/sandwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x-2,user.y,user.z,'icons/sandwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x+3,user.y,user.z,'icons/sandwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x-3,user.y,user.z,'icons/sandwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x+4,user.y,user.z,'icons/sandwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x-4,user.y,user.z,'icons/sandwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x+5,user.y,user.z,'icons/sandwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x-5,user.y,user.z,'icons/sandwave.dmi',"",user,14,(1000+500*conmult),0)
				if(user.dir==EAST||user.dir==WEST)
					spawn()wet_proj(user.x,user.y+1,user.z,'icons/sandwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x,user.y-1,user.z,'icons/sandwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x,user.y+2,user.z,'icons/sandwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x,user.y-2,user.z,'icons/sandwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x,user.y+3,user.z,'icons/sandwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x,user.y-3,user.z,'icons/sandwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x,user.y+4,user.z,'icons/sandwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x,user.y-4,user.z,'icons/sandwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x,user.y+5,user.z,'icons/sandwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x,user.y-5,user.z,'icons/sandwave.dmi',"",user,14,(1000+500*conmult),0)


		sand_shield
			id = SAND_SHIELD
			name = "Sand Shield"
			icon_state = "sand_shield"
			default_chakra_cost = 100
			default_cooldown = 20



			IsUsable(mob/user)
				. = ..()
				if(.)
					if(!user.Get_Sand_Pet())
						Error(user, "Cannot be used without summoned sand")
						return 0



			Use(mob/human/user)
				viewers(user) << output("[user]: Sand Shield!", "combat_output")
				var/mob/p=user.Get_Sand_Pet()

				if(p)
					p.density=0
					while(user && get_dist(user, p) > 1)
						user.stunned=2
						step_to(p,user,1)
						sleep(1)
						if(!p)
							if(user)
								user.stunned=0
								user.sandshield=0
							break
					if(!user)
						return
					if(p)
						p.invisibility=30
						var/obj/x=new/obj/sandshield(user.loc)
						user.protected=10
						user.sandshield=2
						while(user && user.protected)
							user.stunned=2
							sleep(1)
						if(user)
							user.stunned=0
							user.sandshield=0
							user.movepenalty=0
						del(x)
						if(p)
							p.invisibility=1
							p.density=1




		desert_funeral
			id = DESERT_FUNERAL
			name = "Desert Funeral"
			icon_state = "desert_funeral"
			default_chakra_cost = 400
			default_cooldown = 120



			IsUsable(mob/user)
				. = ..()
				var/mob/human/target = user.MainTarget()
				if(.)
					if(!target)
						Error(user, "No Target")
						return 0
					if(!user.Get_Sand_Pet())
						Error(user, "Cannot be used without summoned sand")
						return 0



			Use(mob/human/user)
				var/mob/p=user.Get_Sand_Pet()
				var/mob/human/etarget = user.MainTarget()
				viewers(user) << output("[user]: Desert Funeral!", "combat_output")

				if(p)
					p.density=0
					var/effort=5
					while(p && etarget && get_dist(etarget, p) > 1 && effort > 0)
						step_to(p,etarget,0)
						sleep(2)
						effort--
					walk(p,0)
					if(!etarget || !p)
						return
					if(get_dist(etarget, p) <= 1)
						p.loc = etarget.loc
						var/target_loc = etarget.loc

						etarget.stunned=10
						p.layer=MOB_LAYER+1
						p.icon='icons/Gaara.dmi'
						p.icon_state="D-funeral"
						p.overlays=0
						for(var/obj/u in user.pet)
							user.pet-=u
						flick("D-Funeral-flick",p)

						sleep(20)
						spawn(50)
							if(p)
								del(p)
						if(etarget && etarget.loc == target_loc)
							etarget.Dec_Stam(3000,0,user)
							etarget.Wound(rand(5,15),0,user)
							etarget.Hostile(user)




		sand_armor
			id = SAND_ARMOR
			name = "Sand Armor"
			icon_state = "sand_armor"
			default_chakra_cost = 200
			default_cooldown = 60



			IsUsable(mob/user)
				.=..()
				if(.)
					if(user.sandarmor)
						Error(user, "Sand Armor is already active.")
						return 0

			Use(mob/human/user)
				viewers(user) << output("[user]: Sand Armor!", "combat_output")
				var/O = 2000
				user.sandarmor = O// + (50 * user.ControlDamageMultiplier())
				if(!user.sandarmor)
					var/obj/o = new/obj/sandarmor(user.loc)
					flick("break",o)
					o.density=0
					user.icon_state=""





		sand_shuriken
			id = SAND_SHURIKEN
			name = "Sand Shuriken"
			icon_state = "sand_shuriken"
			default_chakra_cost = 200
			default_cooldown = 40



			IsUsable(mob/user)
				. = ..()
				if(.)
					if(user.qued || user.qued2)
						Error(user, "A conflicting skill is already activated")
						return 0
					var/has_sand = 0
					for(var/mob/human/sandmonster/X in oview(10,user))
						has_sand = 1
						break
					if(!has_sand)
						for(var/turf/Terrain/Sand/X in oview(10,user))
							has_sand = 1
							break
					if(!has_sand)
						Error(user, "No sand available")
						return 0



			Use(mob/human/user)
				viewers(user) << output("[user]: Sand Shuriken!", "combat_output")

				user.stunned=1

				var/turf/From=null
				for(var/mob/human/sandmonster/X in oview(10,user))
					if(!From)
						From=X.loc
				if(!From)
					for(var/turf/Terrain/Sand/X in oview(10,user))
						if(!From)
							From=X
							break
				if(From)
					var/obj/O = new/obj(From)
					O.icon='icons/sandshuriken.dmi'
					O.icon_state="sand"
					O.density=0
					O.layer=MOB_LAYER+1
					sleep(2)
					var/t=0
					while(O && user && O.loc != user.loc)
						step_to(O,user,0)
						t++
						sleep(5)
						if(t>100)
							if(O)
								O.loc = null
							if(user)
								user.icon_state=""
								user.stunned=0
							return
					if(O)
						O.loc = null

						if(user)
							user.overlays+=image('icons/sandshuriken.dmi',icon_state="sand")

							user.qued2=1

					if(user)
						user.icon_state=""
						user.stunned=0




obj
	sandarmor
		icon='icons/sandarmor.dmi'
		icon_state="break"
		layer=MOB_LAYER+1




mob/proc
	Get_Sand_Pet()
		for(var/mob/human/sandmonster/X in src.pet)
			if(X && get_dist(X, src) <= 10 && !X.tired)
				return X


	Return_Sand_Pet(mob/owner)
		var/mob/human/sandmonster/x=src
		if(!x.tired)
			spawn()
				x.density=0
				walk_to(x,owner,0,1)
				sleep(6)
				x.density=1
				walk(x,0)
				x.tired=0


/*		bursting_sand_burial
			id = SAND_WAVE
			name = "Sand Secret Attack: Sand Wave!!"
			icon_state = "exploading_water_shockwave"
			default_chakra_cost = 500
			default_cooldown = 120
			default_seal_time = 30



			Use(mob/human/user)
				viewers(user) << output("[user]: Sand Secret Attack: Sand Wave!!", "combat_output")

				var/conmult = user.ControlDamageMultiplier()

				user.stunned=3
				spawn()wet_proj(user.x,user.y,user.z,'icons/sandwave.dmi',"",user,14,(1000+500*conmult),6)
				if(user.dir==NORTH||user.dir==SOUTH)
					spawn()wet_proj(user.x+1,user.y,user.z,'icons/sandwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x-1,user.y,user.z,'icons/sandwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x+2,user.y,user.z,'icons/sandwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x-2,user.y,user.z,'icons/sandwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x+3,user.y,user.z,'icons/sandwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x-3,user.y,user.z,'icons/sandwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x+4,user.y,user.z,'icons/sandwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x-4,user.y,user.z,'icons/sandwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x+5,user.y,user.z,'icons/sandwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x-5,user.y,user.z,'icons/sandwave.dmi',"",user,14,(1000+500*conmult),0)
				if(user.dir==EAST||user.dir==WEST)
					spawn()wet_proj(user.x,user.y+1,user.z,'icons/sandwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x,user.y-1,user.z,'icons/sandwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x,user.y+2,user.z,'icons/sandwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x,user.y-2,user.z,'icons/sandwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x,user.y+3,user.z,'icons/sandwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x,user.y-3,user.z,'icons/sandwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x,user.y+4,user.z,'icons/sandwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x,user.y-4,user.z,'icons/sandwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x,user.y+5,user.z,'icons/sandwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x,user.y-5,user.z,'icons/sandwave.dmi',"",user,14,(1000+500*conmult),0)*/
