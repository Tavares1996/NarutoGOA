skill
	var
		name
		icon = 'icons/gui.dmi'
		icon_state
		list/icon_overlays
		default_chakra_cost = 0
		default_stamina_cost = 0
		default_supply_cost = 0
		default_cooldown = 0
		default_seal_time = 0
		base_charge = 0
		charging = 0
		charge = 0
		id
		copyable = 1
		cooldown
		uses
		skillcards[0]
		skill/master
		face_nearest = 0
		noskillbar



	proc
		IsUsable(mob/user)
			if(cooldown > 0)
				Error(user, "Cooldown Time ([cooldown] seconds)")
				return 0
			else if(user.curchakra < ChakraCost(user))
				Error(user, "Insufficient Chakra ([user.curchakra]/[ChakraCost(user)])")
				return 0
			else if(user.curstamina < StaminaCost(user))
				Error(user, "Insufficient Stamina ([user.curstamina]/[StaminaCost(user)])")
				return 0
			else if(user.supplies < SupplyCost(user))
				Error(user, "Insufficient Supplies ([user.supplies]/[SupplyCost(user)])")
				return 0
			else if(user.gate && ChakraCost(user) && !istype(src, /skill/taijutsu/gates))
				Error(user, "This skill cannot be used while a gate is active")
				return 0
			else if(user.Size==1 && !istype(src, /skill/akimichi/size_multiplication))
				Error(user, "This skill cannot be used while Size Multiplication is active")
				return 0
			else if(user.Size==2 && !istype(src, /skill/akimichi/super_size_multiplication))
				Error(user, "This skill cannot be used while a Super Size Multiplication is active")
				return 0
			return 1


		Cooldown(mob/user)
			if(user.skillspassive[6])
				return round(default_cooldown * (1 - user.skillspassive[6] * 0.03))
			else
				return default_cooldown


		ChakraCost(mob/user)
			if (user.type == "/mob/human/player/npc/kage_bunshin")
				return 0
			if(base_charge)
				return base_charge
			else if(user.skillspassive[5])
				return round(default_chakra_cost * (1 - user.skillspassive[5] * 0.04))
			else
				return default_chakra_cost


		StaminaCost(mob/user)
			if (user.type == "/mob/human/player/npc/kage_bunshin")
				return 0
			return default_stamina_cost


		SupplyCost(mob/user)
			if (user.type == "/mob/human/player/npc/kage_bunshin")
				return 0
			return default_supply_cost

		SealTime(mob/user)
			if (user.type == "/mob/human/player/npc/kage_bunshin")
				return 0
			var/time = default_seal_time
			if(user.move_stun) time = time*2+5
			return time


		Use(mob/user)


		ActivateB(mob/human/user)
			if(user.leading)
				user.leading=0
				return

			if(user.rasengan==1)
				user.Rasengan_Fail()
			else if(user.rasengan==2)
				user.ORasengan_Fail()

			if(user.isguard)
				user.icon_state=""
				user.isguard=0

			if(user.zetsu)
				user.invisibility=1
				user.density=1
				user.targetable=1
				user.protected=0
				user.zetsu=0

		/*	if(user.camo)
				user.Affirm_Icon()
				user.Load_Overlays()
				user.camo=0*/

			if(charging)
				charging = 0
				return

			if(user.skillusecool || !user.CanUseSkills() || !IsUsable(user) || (user.mane && !istype(src,/skill/nara)))
				return

			user.skillusecool = 1

			user.curchakra -= ChakraCost(user)
			user.curstamina -= StaminaCost(user)
			user.supplies -= SupplyCost(user)

			if(base_charge)
				user.combat("[src]: Use this skill again to stop charging.")
				charge = base_charge
				charging = 1
				var/chakra_charge = 1
				while(charging && user && user.CanUseSkills())
					if(chakra_charge)
						var/charge_amt = min(base_charge, user.curchakra)
						user.curchakra -= charge_amt
						charge += charge_amt
						user.combat("[src]: Charged [charge] chakra.")
						if(user.curchakra <= 0)
							user.combat("[src]: Out of chakra. Use this skill again to finish charging.")
							chakra_charge = 0
					sleep(5)
				if(!user)
					return
				else if(!user.CanUseSkills())
					user.skillusecool = 0
					return

			if(face_nearest)
				if(user.NearestTarget()) user.FaceTowards(user.NearestTarget())
			else
				if(user.MainTarget()) user.FaceTowards(user.MainTarget())

			for(var/mob/human/player/XE in oview(8))
				var/can_copy = 0
				if(copyable && XE.HasSkill(SHARINGAN_COPY) && !XE.HasSkill(id))
					can_copy = 1
					XE.lastwitnessing=id
					spawn(50)
						if(XE) XE.lastwitnessing=0
				if(XE.sharingan)
					XE.combat("<font color=#faa21b>{Sharingan} [user] used [src].[can_copy?" Press <b>Space</b> within 5 Seconds to copy this skill.":""]</font>")

			user.lastskill = id
			++uses
			DoSeals(user)
			if(user && user.CanUseSkills())
				Use(user)
			if(!user) return



		Activate(mob/human/user)
			if(user.leading)
				user.leading=0
				return

			if(user.rasengan==1)
				user.Rasengan_Fail()
			else if(user.rasengan==2)
				user.ORasengan_Fail()
			else if(user.rasengan==3)
				usr.Rasenshuriken_Fail()

			if(user.isguard)
				user.icon_state=""
				user.isguard=0

			if(user.zetsu)
				user.invisibility=1
				user.density=1
				user.targetable=1
				user.protected=0
				user.zetsu=0

		/*	if(user.camo)
				user.Affirm_Icon()
				user.Load_Overlays()
				user.camo=0*/

			if(charging)
				charging = 0
				return

			if(user.skillusecool || !user.CanUseSkills() || !IsUsable(user) || (user.mane && !istype(src,/skill/nara)))
				return

			user.skillusecool = 1

			user.curchakra -= ChakraCost(user)
			user.curstamina -= StaminaCost(user)
			user.supplies -= SupplyCost(user)

			if(base_charge)
				user.combat("[src]: Use this skill again to stop charging.")
				charge = base_charge
				charging = 1
				var/chakra_charge = 1
				while(charging && user && user.CanUseSkills())
					if(chakra_charge)
						var/charge_amt = min(base_charge, user.curchakra)
						user.curchakra -= charge_amt
						charge += charge_amt
						user.combat("[src]: Charged [charge] chakra.")
						if(user.curchakra <= 0)
							user.combat("[src]: Out of chakra. Use this skill again to finish charging.")
							chakra_charge = 0
					sleep(5)
				if(!user)
					return
				else if(!user.CanUseSkills())
					user.skillusecool = 0
					return

			if(face_nearest)
				if(user.NearestTarget()) user.FaceTowards(user.NearestTarget())
			else
				if(user.MainTarget()) user.FaceTowards(user.MainTarget())

			for(var/mob/human/player/XE in oview(8))
				var/can_copy = 0
				if(copyable && XE.HasSkill(SHARINGAN_COPY) && !XE.HasSkill(id))
					can_copy = 1
					XE.lastwitnessing=id
					spawn(50)
						if(XE) XE.lastwitnessing=0
				if(XE.sharingan)
					XE.combat("<font color=#faa21b>{Sharingan} [user] used [src].[can_copy?" Press <b>Space</b> within 5 Seconds to copy this skill.":""]</font>")

			user.lastskill = id
			++uses
			DoSeals(user)
			if(user && user.CanUseSkills())
				Use(user)
			if(!user) return

			spawn(10)
				if(user) user.skillusecool = 0

			user.CombatFlag("offense")
			DoCooldown(user)


		DoSeals(mob/human/user)
			var/time = SealTime(user)
			if(time)
				user.icon_state="HandSeals"
				user.handseal_stun = 1
				for(, time > 0, --time)
					sleep(1)
					if(!user || !user.CanUseSkills())
						break
				if(user)
					user.icon_state=""
					user.handseal_stun = 0



		DoCooldown(mob/user, resume = 0)
			if (user.type == "/mob/human/player/npc/kage_bunshin")
				return 0
			if(!resume) cooldown = Cooldown(user)

			for(var/skillcard/card in skillcards)
				card.overlays -= 'icons/dull.dmi'
			if(master)
				for(var/skillcard/card in master.skillcards)
					card.overlays -= 'icons/dull.dmi'

			if(!cooldown) return

			for(var/skillcard/card in skillcards)
				card.overlays += 'icons/dull.dmi'
			if(master)
				for(var/skillcard/card in master.skillcards)
					card.overlays += 'icons/dull.dmi'

			while(cooldown > 0)
				sleep(10)
				--cooldown

			for(var/skillcard/card in skillcards)
				card.overlays -= 'icons/dull.dmi'
			if(master)
				for(var/skillcard/card in master.skillcards)
					card.overlays -= 'icons/dull.dmi'


		Error(mob/user, message)
			user.combat("[src] can not be used currently: [message]")


		ChangeIconState(new_state)
			icon_state = new_state
			for(var/skillcard/card in skillcards)
				card.icon_state = new_state
			if(master)
				master.IconStateChanged(src, new_state)


		IconStateChanged(skill/sk, new_state)



skillcard
	parent_type = /obj/gui
	layer = 11



	var
		skill/skill
		noskillbar


	New(loc, skill/sk)
		..(loc)
		skill = sk
		name = sk.name
		icon = sk.icon
		icon_state = sk.icon_state
		overlays = sk.icon_overlays
		mouse_drag_pointer = icon('icons/guidrag.dmi', sk.icon_state)
		if(sk.cooldown || (istype(sk, /skill/uchiha/sharingan_copy) && sk:copied_skill && sk:copied_skill:cooldown)) overlays += 'icons/dull.dmi'
		sk.skillcards += src
		if(sk.noskillbar) noskillbar = 1


	Click()
		skill.Activate(usr)


	MouseDrop(obj/over_object, src_location, over_location, src_control, over_control, params_text)
		if(src == over_object)
			return

		var/params = params2list(params_text)

		var/screen_loc = params["screen-loc"]
		var/screen_loc_lst = dd_text2list(screen_loc, ",")
		var/screen_loc_non_pixel_lst = list()

		for(var/loc in screen_loc_lst)
			var/loc_lst = dd_text2list(loc, ":")
			screen_loc_non_pixel_lst += loc_lst[1]

		screen_loc = dd_list2text(screen_loc_non_pixel_lst, ",")

		if(istype(over_object, /obj/gui/placeholder) || istype(over_object, /skillcard))
			if(noskillbar)
				var/skill/skill = src.skill
				if(skill.id >= 1300 && skill.id <= 1360)
					usr << "[src] does not need to go on your skill bar. The Opening Gate skill card will automatically update as needed."
				return
			var/spot
			switch(screen_loc)
				if("2,1")
					spot=1
				if("3,1")
					spot=2
				if("4,1")
					spot=3
				if("5,1")
					spot=4
				if("6,1")
					spot=5
				if("7,1")
					spot=6
				if("8,1")
					spot=7
				if("9,1")
					spot=8
				if("10,1")
					spot=9
				if("11,1")
					spot=10
				if("12,1")
					spot=11
				if("13,1")
					spot=12
				if("14,1")
					spot=13

			if(spot)
				if(usr.vars["macro[spot]"])
					var/skill/s = usr.vars["macro[spot]"]
					for(var/skillcard/c in s.skillcards)
						if(c.screen_loc == screen_loc)
							usr.client.screen -= c
							usr.player_gui -= c
				usr.player_gui += src
				src.screen_loc = screen_loc
				usr.client.screen += src
				usr.vars["macro[spot]"] = skill


mob/human
	proc
		RemoveSkill(id)
			var/skill_type = SkillType(id)
			var/skill/skill
			skills -= skill
			if(!skill_type)
				skill = new /skill()
				skill.id = id
				skill.name = "Unknown Skill ([id])"
			else
				skill = new skill_type()
			for(var/skillcard/X in contents)
				if(X.name==skill.name)
					del(X)
					skills -= skill
			skills -= skill
			return skill
		AddSkill(id)
			var/skill_type = SkillType(id)
			var/skill/skill
			if(!skill_type)
				skill = new /skill()
				skill.id = id
				skill.name = "Unknown Skill ([id])"
			else
				skill = new skill_type()
			skills += skill
			new /skillcard(src, skill)
			return skill


		HasSkill(id)
			for(var/skill/skill in skills)
				if(skill.id == id)
					return 1
			return 0


		GetSkill(id)
			for(var/skill/skill in skills)
				if(skill.id == id)
					return skill

		BunshinTrickz(id)
			for(var/skill/skill in skills)
				if (skill.id == 301 || skill.id == 311 || skill.id == 401 || skill.id == 411 || skill.id == 501 || skill.id == 1000 || skill.id == 1010 || skill.id == 1020 || skill.id == 1300 || skill.id == 1310 || skill.id == 1320 || skill.id == 1330 || skill.id == 1340 || skill.id == 1400 || skill.id == 1401 || skill.id == 2000 || skill.id == 2011 || skill.id == 2022 || skill.id == 2030 || skill.id == 3000 || skill.id == 3010 || skill.id == 3020 || skill.id == 3100 || skill.id == 3110 || skill.id == 3112 || skill.id == 3200 || skill.id == 3210 || skill.id == 3300 || skill.id == 3301 || skill.id == 3310 || skill.id == 3400 || skill.id == 3410 || skill.id == 3420 || skill.id == 3500 || skill.id == 3501 || skill.id == 3520 || skill.id == 3600 || skill.id == 3601 || skill.id == 3602 || skill.id == 3611 || skill.id == 3700 || skill.id == 3710 || skill.id == 3711 || skill.id == 3712 || skill.id == 3720 || skill.id == 3799 || skill.id == 3800 || skill.id == 3810 || skill.id == 3811 || skill.id == 3812 || skill.id == 3900 || skill.id == 3901 || skill.id == 3902 || skill.id == 3903 || skill.id == 4 || skill.id == 1 || skill.id == 5 || skill.id == 6 || skill.id == 7 || skill.id == 8)
					return


		ControlDamageMultiplier()
			var/conmult=(con + conbuff - conneg)/150
			if(skillspassive[24]) conmult *= 1 + 0.04 * skillspassive[24]
			return conmult


		CanUseSkills(inskill = 0)
			return !cantreact && !spectate && !larch && !frozen && !sleeping && !ko && canattack && !stunned && !kstun && !Tank && pk


		RefreshSkillList()
			if(client)
				var/grid_item = 0
				for(var/skillcard/X in contents)
					if(client) src << output(X, "skills_grid:[++grid_item]")
				if(client) winset(src, "skills_grid", "cells=[grid_item]")


		AppearBefore(mob/human/x,effect=/obj/overfx2)
			if(!x)return

			var/turf/t = get_step(x, x.dir)
			var/list/dirs = list(NORTH, SOUTH, EAST, WEST)
			while((!t || t.density) && dirs.len)
				var/dir = pick(dirs)
				dirs -= dir
				t = get_step(x, dir)
			if(t && !t.density)
				new effect(t)
				src.loc=t
				src.Facedir(x)

				for(var/mob/human/player/npc/N in oview(10))
					if(N.aggro==src && N.aggrod)
						spawn()N.AppearBehind(src)


		AppearBehind(mob/human/x, effect=/obj/overfx)
			if(!x)return

			var/turf/t = get_step(x, turn(x.dir, 180))
			var/list/dirs = list(NORTH, SOUTH, EAST, WEST)
			while((!t || t.density) && dirs.len)
				var/dir = pick(dirs)
				dirs -= dir
				t = get_step(x, dir)
			if(t && !t.density)
				new effect(t)
				src.loc=t
				src.Facedir(x)

				for(var/mob/human/player/npc/N in oview(10))
					if(N.aggro==src && N.aggrod)
						spawn()N.AppearBehind(src)


		AppearMyDir(mob/human/x, effect=/obj/overfx)
			if(!x)return 0

			var/turf/t = get_step(x, dir)
			var/list/dirs = list(turn(dir, 45), turn(dir, -45))
			while((!t || t.density) && dirs.len)
				var/dir = pick(dirs)
				dirs -= dir
				t = get_step(x, dir)
			if(t && !t.density)
				new effect(t)
				src.loc=t
				src.Facedir(x)

				for(var/mob/human/player/npc/N in oview(10))
					if(N.aggro==src && N.aggrod)
						spawn()N.AppearBehind(src)
				return 1
			return 0


		AppearAt(ax,ay,az, effect=/obj/overfx)
			new effect(locate(ax,ay,az))
			src.loc=locate(ax,ay,az)
			for(var/mob/human/player/npc/N in oview(10))
				if(N.aggro==src && N.aggrod)
					spawn()N.AppearBehind(src)



proc
	SkillType(id)
		for(var/skill/skill in all_skills)
			if(skill.id == id)
				return skill.type




var
	all_skills[0]




world/New()
	. = ..()
	for(var/type in typesof(/skill))
		all_skills += new type()