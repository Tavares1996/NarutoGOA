var
	Compatibility=0
	const
		ACTION_WEAPON = 1
		ACTION_JUTSU = 2
		ACTION_KAWARIMI = 3
		ACTION_SHUNSHIN = 4
		ACTION_TAIJUTSU = 5
		ACTION_CLOSE = 6

mob/human/player/npc/creep/var/lasthurtme=0
mob/human/player/npc/akat/var/lasthurtme=0

mob/human/player/npc
	proc
		AIinitialize()
			origx=src.x
			origy=src.y
			origz=src.z
			src.Get_Global_Coords()
			if(!loc)
				spawn()
					while(!loc)
						sleep(5)
						spawn() AI_Loop()
			else
				spawn() AI_Loop()
			spawn(20)
				src.curstamina=src.stamina
				src.curchakra=src.chakra

mob/human/player/npc
	New()
		..()
		if(src.questable)
			src.dietype=0
		spawn(100)
			if(!faction)
				while(!leaf_faction && !mist_faction && !sand_faction && !missing_faction) sleep(10)
				switch(locationdisc)
					if("Konoha")
						faction=leaf_faction
					if("Suna")
						faction=sand_faction
					if("Kiri")
						faction=mist_faction
					else
						faction=missing_faction
				if(faction!=missing_faction)mouse_over_pointer = faction_mouse[faction.mouse_icon]
				CreateName(255, 255, 255)
		if(src.pants=="random")
			src.pants=pick(typesof(/obj/pants))
		if(src.overshirt=="random")
			src.overshirt=pick(typesof(/obj/shirt))
		if(src.hair_type==99)
			src.hair_type=pick(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,0)
		spawn()src.Affirm_Icon()


		origx=src.x
		origy=src.y
		origz=src.z
		if(src.projectiles)
			spawn()src.getweapon()
		spawn()src.completeLoad_Overlays()

		spawn()src.npcregeneration() //!
		spawn(5)
			for(var/m in src.skillsx)
				src.AddSkill(m)
		skillspassive[8] = 3
		spawn()src.Stun_Drain() //!
		if(auto_ai)
			Get_Global_Coords()
			if(!loc)
				spawn()
					while(!loc)
						sleep(5)
						spawn() AI_Loop()
			else
				spawn() AI_Loop()
		stamina=blevel*55 +str*20
		chakra=190 +blevel*10 + con*2.5
		spawn(20)
			curstamina=stamina
			curchakra=chakra
			staminaregen=round(stamina/100)
			chakraregen=round((chakra*3)/100)

	interact="Talk"

	verb
		Talk()
			set src in oview(1)
			set hidden=1
			for(var/mob/human/player/X in world)
				if((X.ckey in admins) && X.z == src.z)
					X<<"usr=[usr], src=[src], MissionTarget=[usr.MissionTarget], MissionType=[usr.MissionType]"
			if(MainTarget() && usr.MissionTarget == src && (usr.MissionType == "Escort" || usr.MissionType == "Escort PvP"))
				alert(usr,"Sorry, I will calm down.")
				FilterTargets()
				for(var/mob/T in targets)
					RemoveTarget(T)
				return
			if(!MainTarget())
				if(src.onquest && usr.MissionTarget==src)
					if(usr.MissionType=="Delivery")
						usr << "Thank you very much!"
						if(usr.MissionType=="Delivery")
							usr.MissionType=0

							usr.MissionComplete()
						return
					if((usr.MissionType=="Escort"||usr.MissionType=="Escort PvP") && !src.following)
						usr << "Hello, I need to get to [usr.MissionLocation].  Press Space/Interact and I will stop following you."
						if(usr.z==src.z)
							src.following=usr
							usr.leading=src
							FilterTargets()
							for(var/mob/T in targets)
								RemoveTarget(T)

						return
				else
					var/list/choicelist=new
					choicelist+="Ask about them"
					if(src.chattopic)
						choicelist+=src.chattopic

					choicelist+="Nevermind"

					var/Talkbout=input2(usr,"NPC Chat Options:","NPC",choicelist)
					if(Talkbout=="Ask about them")
						alert(usr,"[src.message]")
					else if(Talkbout!="Nevermind")
						usr.TalkTopic(src,Talkbout)

	verb
		Shop()
			set src in oview(1)
			set hidden=1
			if(!MainTarget())
				src.Check_Sales(usr)

mob/human
	str=50
	con=50
	rfx=50
	int=50
	stamina=1000
	chakra=300
	icon='icons/base_m1.dmi'
	icon_state=""

mob/human/player/npc
	var
		patrol_spot = 1
		mob/human/player/following = null
	proc
		stop_following()
			following.leading = null
			following = null
			FilterTargets()
			for(var/mob/T in targets)
				RemoveTarget(T)
			walk(src,0)
		Stun_Drain()
			set background = 1
			sleep(10)
			while(loc)
				if(z && invisibility<2)
					//if(move_stun)
					//	move_stun = max(0, move_stun-10)
					//if(stunned)
					//	stunned--
					if(tired)
						tired--
				sleep(10)

		npcDie()
			if(src.onquest)
				var/questdone=0

				for(var/mob/human/player/X in ohearers(8))
					if(X.MissionTarget==src)
						questdone=1
						if(X.MissionType=="Escort"||X.MissionType=="Escort PvP")
							X.MissionFail(0, "The person you were to escort has died!")
						else if(X.MissionType=="Assasinate"||X.MissionType=="Kill Npc PvP"||X.MissionType=="Invade PvP")
							X.MissionComplete()

				if(questdone)
					src.density=0
					src.icon_state="Dead"
					src.targetable=0
					src.onquest=1
					sleep(900)
					src.onquest=0
					src.curwound=0
					FilterTargets()
					for(var/mob/T in targets)
						RemoveTarget(T)
					src.curstamina=src.stamina
					src.density=1
					src.targetable=1
					src.icon_state=""
					src.loc=locate(src.origx,src.origy,src.origz)

			FilterTargets()
			for(var/mob/T in targets)
				RemoveTarget(T)

			switch(src.dietype) //0=KO,no death 1=delayed respawn 2=death till repop
				if(0)
					src.icon_state="Dead"
					sleep(200)
					src.curwound=0
					src.curstamina=src.stamina
					src.icon_state=""
					FilterTargets()
					for(var/mob/T in targets)
						RemoveTarget(T)
					for(var/mob/human/player/npc/X in ohearers(5))
						X.FilterTargets()
						if(src in X.targets)
							X.RemoveTarget(src)

				if(1)
					src.density=0
					src.icon_state="Dead"
					src.targetable=0
					src.dead=1
					spawn(src.respawndelay)
						new src.type (locate(src.origx,src.origy,src.origz))
						del(src)

				if(2)
					src.density=0
					src.icon_state="Dead"
					src.targetable=0
					src.dead=1

				if(3)//exp gain
					src.density=0
					src.icon_state="Dead"
					src.targetable=0
					src.dead=1

					if(istype(src,/mob/human/player/npc/creep))
						var/mob/human/player/npc/creep/C=src
						var/mob/human/player/X = C.lasthurtme
						if(X)
							if(!RP)
								var/gain=min(1200,round(600 * src.blevel/X.blevel))*lp_mult
								X.body+=gain
								X<<"You have gained [gain] experience points!"
								X.bodycheck()
								var/mgain = 3*src.blevel
								X.money+=mgain
								X<<"You have gained [mgain] ryo!"
							C.lasthurtme=null
					spawn(100)
						del(src)


				if(4)//exp gain
					src.density=0
					src.icon_state="Dead"
					src.targetable=0
					src.dead=1

					if(istype(src,/mob/human/player/npc/akat))
						var/mob/human/player/npc/akat/C=src
						var/mob/human/player/X = C.lasthurtme
						if(X)
							if(!RP)
								var/gain=min(12000,round(6000 * src.blevel/X.blevel))*lp_mult
								X.body+=gain
								X<<"You have gained [gain] experience points!"
								X.bodycheck()
								var/mgain = 6*src.blevel
								X.money+=mgain
								X<<"You have gained [mgain] ryo!"
							C.lasthurtme=null
					spawn(100)
						del(src)

		getweapon()
			switch(src.projectiles)
				if(1)
					var/x=new/obj/items/weapons/projectile/Kunai_p(src)
					x:Use(src)
				if(2)
					var/x=new/obj/items/weapons/projectile/Shuriken_p(src)
					x:Use(src)
				if(3)
					var/x=new/obj/items/weapons/projectile/Needles_p(src)
					x:Use(src)
				if(4)
					var/x=new/obj/items/weapons/melee/knife/Kunai_Melee(src)
					x:Use(src)

		AI_Loop()
			while(loc)
				AI_Tick()
				sleep(10)

		AI_Tick()
			if(dead)
				return

			if(following)
				if(following in ohearers(10,src))
					walk_to(src,following,1,3)
			else if(Squad)
				var/mob/human/player/npc/leader = Squad[1]
				if(!leader)
					Squad -= src
					Squad[1] = src
					leader = src
				if(leader.dead || !leader.loc)
					var/sloc = Squad.Find(src)
					Squad[sloc] = leader
					Squad[1] = src
					leader = src
				if(leader == src)
					var/list/merged_targets = targets.Copy()
					var/list/merged_actives = active_targets.Copy()
					for(var/mob/human/player/npc/M in Squad)
						merged_targets |= M.targets
						merged_actives |= M.active_targets
					for(var/mob/human/player/npc/M in Squad)
						M.targets = merged_targets.Copy()
						M.active_targets = merged_actives.Copy()
				else
					if(get_dist(src, leader) > 10 || src.z != leader.z)
						AppearAt(leader.x, leader.y, leader.z)

			if(!following)
				var/mob/human/player/target = MainTarget()
				if(target)
					AI_Attack(target)
				else
					if(targets.len)
						step_to(src,targets[1])
					else
						if(patrol)
							AI_Patrol()
						else
							AI_Random_Move()

		AI_Target(mob/human/player/M)
			AddTarget(M, active=1)

		AI_Canmove()
			return !stunned && !ko && !maned && !kaiten && !incombo

		AI_Patrol()
			var/busy=0
			var/maxspot=min(length(px), length(py))

			if(patrol_spot < maxspot)
				var/turf/targ=locate(px[patrol_spot],py[patrol_spot],z)
				step_to(src, targ)
				busy++
				if(get_dist(src, targ) <= 1)
					patrol_spot++

			else
				var/turf/targ=locate(origx,origy,z)
				step_to(src, targ)
				busy++
				if(get_dist(src, targ) <= 1)
					patrol_spot = 1

			if(busy > 200)
				AppearAt(origx,origy,origz)
				busy = 0

		AI_Random_Move()
			if(!AI_Canmove())
				return

			var/list/dirs = list(NORTH, NORTHEAST, EAST, SOUTHEAST, SOUTH, SOUTHWEST, WEST, NORTHWEST)
			var/success = 0

			while(dirs.len && !success)
				var/dir = pick(dirs)
				dirs -= dir
				success = step(src, dir)
			sleep(rand(40,60))

		AI_Determine_Attack(mob/human/player/M)
			var/jutsu_priority = con/str
			var/distance = max(1,get_dist(src,M))
			var/health_val = curstamina/max(1,stamina)
			var/chakra_val = curchakra/max(1,chakra)

			var/tai_val = health_val * 1/jutsu_priority * (3/distance)
			var/jutsu_val = chakra_val * jutsu_priority * (distance/3)
			var/weapon_val = distance/3
			var/kawarimi_val = 1 - health_val

			var/valid_jutsu = 0
			var/valid_kawa = 0
			var/valid_shun = 0

			if(!(rasengan || sakpunch2 || skillusecool))
				for(var/skill/sk in skills)
					if((!(sk.id in list(KAWARIMI, SHUNSHIN))) && !sk.cooldown)
						valid_jutsu = 1
					else if(sk.id == KAWARIMI && !sk.cooldown)
						valid_kawa = 1
					else if(sk.id == SHUNSHIN && !sk.cooldown)
						valid_shun = 1

			var/list/liked_options = list()
			if(tai_val > 1.5)
				liked_options += ACTION_TAIJUTSU
			if(jutsu_val > 0.5 && valid_jutsu && !skillusecool && CanUseSkills())
				liked_options += ACTION_JUTSU
			if(weapon_val > 1 && projectiles)
				liked_options += ACTION_WEAPON
			if(kawarimi_val > 0.5 && !AIKawa && valid_kawa)
				liked_options += ACTION_KAWARIMI

			var/action
			if(!liked_options.len || prob(10)) // Do something unexpected
				var/list/valid_options = list(ACTION_TAIJUTSU)
				if(projectiles)
					valid_options += ACTION_WEAPON
				if(valid_jutsu)
					valid_options += ACTION_JUTSU
				if(valid_kawa)
					valid_options += ACTION_KAWARIMI
				if(valid_shun)
					valid_options += ACTION_SHUNSHIN
				action = pick(valid_options)
			else
				action = pick(liked_options)

			if(rasengan || sakpunch2) // Punch them if we're using rasengan or ctr
				action = ACTION_TAIJUTSU

			if(distance > 6 && action != ACTION_TAIJUTSU && action != ACTION_SHUNSHIN)
				if(jutsu_priority >= 1)
					action = ACTION_CLOSE
				else
					action = ACTION_TAIJUTSU
			if(action == ACTION_TAIJUTSU && distance > 3 && valid_shun)
				action = list(ACTION_SHUNSHIN, ACTION_TAIJUTSU)
			else
				action = list(action)

			return action

		AI_Attack(mob/human/player/M)
			if(AI_Canmove())
				usr = src

				curchakra=chakra

				var/list/attacks=AI_Determine_Attack(M)

				for(var/attack in attacks)
					switch(attack)
						if(ACTION_WEAPON)
							var/steps = 0
							while(get_dist(src,M) <= 3 && steps < 10)
							if(projectiles >= 4)
								sleep(1)
							else
								++steps
								step_away(src,M)
								sleep(1)
							if(get_dist(src,M) > 3)
								src.supplies=100
								src.usedelay=0
								usr.usev()

						if(ACTION_JUTSU)
							if(M)
								var/list/options = list()
								for(var/skill/sk in skills)
									if(!(sk.id in list(KAWARIMI, SHUNSHIN)))
										options += sk
								if(options.len)
									var/skill/x
									do
										x = pick(options)
										options -= x
									while(options.len && !x.IsUsable(src))
									if(x && x.IsUsable(src))
										spawn() x.Activate(src)

						if(ACTION_KAWARIMI)
							if(src.HasSkill(KAWARIMI))
								var/skill/x = src.GetSkill(KAWARIMI)
								spawn() x.Activate(src)

						if(ACTION_SHUNSHIN)
							if(M&&src&&M.z==src.z && src.HasSkill(SHUNSHIN))
								var/skill/x = src.GetSkill(SHUNSHIN)
								spawn() x.Activate(src)

						if(ACTION_TAIJUTSU)
							if(get_dist(src,M) <= 3)
								var/steps = 0
								while(get_dist(src,M) > 1 && steps < 10)
									++steps
									step_to(src,M)
									sleep(1)

								if(get_dist(src,M) <= 1)
									src.rand_attack_ani()
									src.attackv(M)
									src.icon_state=""

						if(ACTION_CLOSE)
							if(get_dist(src,M) > 3)
								var/steps = 0
								while(get_dist(src,M) > 3 && steps < 10)
									++steps
									step_to(src,M)
									sleep(1)

					sleep(1)

mob/var/AIKawa=0

mob/human
	var
		cooldown2=0
		list/Squad=0

mob/human/player/npc/creep/var/ambusher=0
mob/human/player/npc/akat/var/ambusher=0

m/*ob/Admin/verb/Ambush_GM()
	var/list/Ambushees=new
	var/num=input("How many to ambush","Ambush") as num
	var/lvl=input("What level?") as num
	for(var/mob/human/player/O in world)
		if(O.client) Ambushees+=O
	Ambushees+="(Below me)"
	Ambushees+="(Nevermind)"
	var/pik = input("Pick somebody to be Ambushed","Ambush") in Ambushees
	if(istype(pik,/mob))
		var/mob/human/player/M = pik
		if(!lvl)lvl=M.blevel
		AkatAmbush(pik,lvl,num)
	else
		if(pik=="(Below me)")
			AkatAmbush(locate(usr.x,usr.y-10,usr.z),lvl,num)

proc/AkatAmbush(atom/Tgt,lvl,num,notambush)
	var/list/S=new
	var/list/Landing=new
	Landing+=oview(6,Tgt)
	for(var/atom/O in oview(6,Tgt))
		if(O.density && (Landing.Find(O)||Landing.Find(O.loc)))
			if(istype(O,/turf))Landing-=O
			else Landing-=O.loc

	for(var/turf/O in oview(2,Tgt))
		if(Landing.Find(O))Landing-=O //too close

	while(num && length(Landing))
		num--
		var/turf/La=pick(Landing)
		Landing-=La
		var/mob/human/U=new/mob/human/player/npc/akat(locate(0,0,0),lvl)
		spawn(pick(1))
			if(U && La)
				U.AppearAt(La.x,La.y,La.z)
		S+=U

	for(var/mob/human/player/npc/akat/U in S)
		walk_to(U,Tgt,3,1)
		spawn(1)walk(U,0)
		U.Squad=S
		if(!notambush)U.ambusher=1
		U.mouse_over_pointer='faction_icons/akatsuki-mouse.dmi'
		if(istype(Tgt,/mob))
			spawn() U.AI_Target(Tgt)


mob/human/player/npc/akat
	New(loc,lvl)
		..()
	//	lvl+=pick(-2,-1,0,1,2)
		lvl=200
	//	src.name="Akatsuki Member([lvl])"

		src.blevel=100
		switch(pick(1))
			if(1)//Itachi
				src.name="Uchiha Itachi"
				int=50+(lvl-1)*4
				rfx=50+(lvl-1)*3
				con=50+(lvl-1)*2
				str=50+(lvl-1)*1
		src.stamina=(src.blevel*55 +(src.str)*20)
		src.chakra=(100 + (src.con)*8)
		src.staminaregen=round(src.stamina/100)
		src.chakraregen=round((src.chakra*1.5)/100)
		src.delay=5
		if(src.rfx>150)src.delay=4
		if(src.rfx>200)src.delay=3
		if(src.rfx>250)src.delay=2
		if(src.rfx>350)src.delay=1
		var/points=round(int/40)
		var/list/valid_skills=list(WINDMILL_SHURIKEN,KATON_FIREBALL,LEAF_WHIRLWIND,EXPLODING_KUNAI,KATON_PHOENIX_FIRE,PARALYZE_GENJUTSU,SLEEP_GENJUTSU,LION_COMBO,KAGE_BUNSHIN,TAJUU_KAGE_BUNSHIN,SHUIRKEN_KAGE_BUNSHIN,EXPLODING_KAGE_BUNSHIN,STAKES_GENJUTSU,ILLUSION_GENJUTSU,DARKNESS_GENJUTSU,ITACHI_MANGEKYOU,TSUKUYOMI,AMATERASU,ITACHI_SUSANOO)
		while(points && valid_skills.len)
			points--
			var/newskill = pick(valid_skills)
			valid_skills -= newskill
			skillsx+=newskill
		spawn(18000) if(src) del(src) //delete the rogue nin after a half an hour of existance to reduce lag

	nisguard=0
	hostile=1
	name="Uchiha Itachi"
	locationdisc="Unknown"
	wander=1
	questable=0
	blevel=30
	delay=5

	dietype=3//0=KO,no death 1=delayed respawn 2=death till repop 3=expgain
	str=100
	guard=0
	interact
	con=100
	rfx=100
	int=100
	stamina=4000
	chakra=700
	sharingan=4
	pants=/obj/item_appearence/pants/blue
	undershirt=/obj/item_appearence/fishnet
	overshirt
	armor=/obj/item_appearence/chuunin/akatsuki_suit
	facearmor = /obj/item_appearence/headband/black
	legarmor=/obj/Kunai_Holster
	hair_type=8
	hair_color="#000000"
	killable=1
	projectiles=4
	message ="Foolish little kid, you dont stand a chance against me!!"*/

proc/Ambush(atom/Tgt,lvl,num,notambush)
	var/list/S=new
	var/list/Landing=new
	Landing+=oview(6,Tgt)
	for(var/atom/O in oview(6,Tgt))
		if(O.density && (Landing.Find(O)||Landing.Find(O.loc)))
			if(istype(O,/turf))Landing-=O
			else Landing-=O.loc

	for(var/turf/O in oview(2,Tgt))
		if(Landing.Find(O))Landing-=O //too close

	while(num && length(Landing))
		num--
		var/turf/La=pick(Landing)
		Landing-=La
		var/mob/human/M=new/mob/human/player/npc/creep(locate(0,0,0),lvl)
		spawn(pick(1,3,5))
			if(M && La)
				M.AppearAt(La.x,La.y,La.z)
		S+=M

	for(var/mob/human/player/npc/creep/M in S)
		walk_to(M,Tgt,3,1)
		spawn(3)walk(M,0)
		M.Squad=S
		if(!notambush)M.ambusher=1
		M.mouse_over_pointer='icons/mouse_icons/questionmouse.dmi'
		if(istype(Tgt,/mob))
			spawn() M.AI_Target(Tgt)

mob/human/player/npc/creep
	New(loc,lvl)
		..()
		lvl+=pick(-2,-1,0,1,2)
		lvl=max(1,lvl)
		src.name="Rogue Shinobi([lvl])"

		src.blevel=lvl
		switch(pick(1,2,3,4))
			if(1)//jutsu user
				int=50+(lvl-1)*4
				rfx=50+(lvl-1)*2
				con=50+(lvl-1)*3
				str=50+(lvl-1)*1
			if(2)//tank
				int=50+(lvl-1)*1
				rfx=50+(lvl-1)*2
				con=50+(lvl-1)*3
				str=50+(lvl-1)*4
			if(3)//Well rounded
				int=50+round((lvl-1)*2.5)
				rfx=50+round((lvl-1)*2.5)
				con=50+round((lvl-1)*2.5)
				str=50+round((lvl-1)*2.5)
			if(4)//taijutsu user
				int=50+(lvl-1)*1
				rfx=50+(lvl-1)*4
				con=50+(lvl-1)*1
				str=50+(lvl-1)*4
			if(5)//heavy jutsu user
				int=50+(lvl-1)*4
				rfx=50+(lvl-1)*1
				con=50+(lvl-1)*4
				str=50+(lvl-1)*1
			if(6)//fast generalist
				int=50+(lvl-1)*1
				rfx=50+(lvl-1)*4
				con=50+(lvl-1)*3
				str=50+(lvl-1)*2
		src.stamina=(src.blevel*55 +(src.str)*20)
		src.chakra=(100 + (src.con)*8)
		src.staminaregen=round(src.stamina/100)
		src.chakraregen=round((src.chakra*1.5)/100)
		src.delay=5
		if(src.rfx>150)src.delay=4
		if(src.rfx>200)src.delay=3
		if(src.rfx>250)src.delay=2
		if(src.rfx>350)src.delay=1
		var/points=round(int/40)
		var/list/valid_skills=list(WINDMILL_SHURIKEN,KATON_FIREBALL,LEAF_WHIRLWIND,NIRVANA_FIST,EXPLODING_KUNAI,/*KATON_TAJUU_PHOENIX,*/KATON_PHOENIX_FIRE,DOTON_IRON_SKIN,DOTON_CHAMBER,PARALYZE_GENJUTSU,SUITON_VORTEX,CHIDORI,FUUTON_PRESSURE_DAMAGE,CHIDORI_CURRENT,FUUTON_GREAT_BREAKTHROUGH,SLEEP_GENJUTSU,FUUTON_AIR_BULLET/*,SUITON_SYRUP_FIELD*/,LION_COMBO,IMPORTANT_BODY_PTS_DISTURB,POISON_MIST,TWIN_RISING_DRAGONS)
		while(points && valid_skills.len)
			points--
			var/newskill = pick(valid_skills)
			valid_skills -= newskill
			skillsx+=newskill
		if(blevel > 50 && 0==1)//Dipic: Disabled
			var/list/s_ranks = list(FUUTON_RASENSHURIKEN)
			var/s_points = round(int/100)
			while(s_points && s_ranks.len)
				s_points--
				var/newskill = pick(s_ranks)
				s_ranks -= newskill
				skillsx+=newskill
		spawn(18000) if(src) del(src) //delete the rogue nin after a half an hour of existance to reduce lag

	nisguard=0
	hostile=1
	name="Rogue Shinobi"
	locationdisc="Unknown"
	wander=1
	questable=0
	blevel=30
	delay=5

	dietype=3//0=KO,no death 1=delayed respawn 2=death till repop 3=expgain
	str=100
	guard=0
	interact
	con=100
	rfx=100
	int=100
	stamina=4000
	chakra=700
	pants=/obj/pants/black
	undershirt=/obj/fishnet
	overshirt
	armor=/obj/plate/body/brown
	facearmor = /obj/headband/black
	hair_type=99
	hair_color="#000000"
	killable=1
	projectiles=2
	message ="..."

	skillsx=list(KAWARIMI,SHUNSHIN,BUNSHIN)

mob/human/proc
	rand_attack_ani()
		var/ans=pick(1,2,3,4)
		if(ans==1)
			src.icon_state="PunchA-1"

		if(ans==2)
			src.icon_state="PunchA-2"
		if(ans==3)
			src.icon_state="KickA-1"
		if(ans==4)
			src.icon_state="KickA-2"

var/npcdelay=5

mob/human/player/npc
	proc
		npcregeneration()
			set background = 1
			/*if(src.protected) //this is no longer npcregeneration()'s responsibility
				src.protected-=1*npcdelay*/

			if(src.alertcool)
				src.alertcool = max(0, src.alertcool - 1 * npcdelay)
			//	if(src.alertcool<0)
			//		src.alertcool=0

			spawn(10*npcdelay)
				if(!MainTarget()) /*ENABLE*/
					src.curwound = max(0, src.curwound - 1)

				var/area/A
				if(loc)
					A = loc.loc
				if(A) //&& !A.pkzone)
					pk = 0
					dojo = 1
					risk = 0
			/*	else if(istype(A,/area/dojo))
					pk = 1
					dojo = 1
					risk = 0*/
				else
					pk = 1
					dojo = 0

				if(src.asleep)
					//src.icon_state="Dead"
					sleep(100)
					src.asleep=0
					src.icon_state=""

				//ko stuff
				if(src.curwound>=200)
					src.curstamina=0

				if(src.curstamina<=0)
					src.Dec_Stam(0,rand(32,37),src,"KO","Internal")
					//src.Wound(rand(32,37),1)
					src.ko=1
					sleep(10)
					flick("Knockout",src)
					src.icon_state="Dead"
					src.layer=TURF_LAYER+1
					if(src.curwound<32)
						sleep(src.curwound +100)
						src.curstamina=src.stamina * ((maxwound-curwound)/maxwound)
						if(src.curchakra<src.chakra/5)
							src.curchakra=src.chakra/5 +20
						src.Protect(30)
						src.stunned=0
						src.ko=0
						src.icon_state=""

					else
						src.npcDie()

				if(src.ko)
					if(src.curstamina>0)
						src.ko=0
						src.icon_state=""
				//end ko stuff
				if(src.layer!=MOB_LAYER && !src.ko &&!src.incombo)
					src.layer=MOB_LAYER

				if(curwound<maxwound&&!mane&&!maned &&!waterlogged)
					if(curchakra<chakra)
						if(chakraregen > (chakra-curchakra))
							curchakra= chakra
						else
							curchakra +=chakraregen*npcdelay

					else
						if(curstamina<stamina)
							if((staminaregen) > (stamina-curstamina))
								curstamina=stamina
							else
								curstamina+=staminaregen*npcdelay

				if(!dead)
					spawn()npcregeneration()
