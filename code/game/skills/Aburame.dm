skill
	aburame
		copyable = 0


		bug_summoning
			id = BUG_SUMMONING
			name = "Bug Summoning"
			icon_state = "bug_summoning"
			default_chakra_cost = 300
			default_cooldown = 10


			Use(mob/user)
				if(user.bugs_summoned)
					user.bugs_summoned=0
					user.bug_cooldown=0
					user.overlays-='icons/bug_summoning.dmi'
					ChangeIconState("bug_summoning")
					return
				viewers(user) << output("[user]: Bug Summoning!", "combat_output")
				ChangeIconState("cancel_bugs")
				user.bugs_summoned=1
				user.bug_cooldown=0
				user.overlays+='icons/bug_summoning.dmi'
				spawn(600*10) //10 minutes
					if(user&&user.bugs_summoned)
						user.bugs_summoned=0
						user.bug_cooldown=0
						user.overlays-='icons/bug_summoning.dmi'
						ChangeIconState("bug_summoning")
						return

		insect_breakthrough
			id = INSECT_BREAKTHROUGH
			name = "Insect Breakthrough"
			icon_state = "insect_breakthrough"
			default_chakra_cost = 100
			default_cooldown = 90
			default_seal_time = 3


			IsUsable(mob/user)
				. = ..()
				if(.)
					if(!user.bugs_summoned)
						Error(user, "Cannot be used without summoned bugs")
						return 0


			Use(mob/human/user)
				viewers(user) << output("[user]: Insect Breakthrough!", "combat_output")

				user.icon_state="HandSeals"
				user.stunned=5

				var/dir = user.dir
				var/mob/human/player/etarget = user.MainTarget()
				if(etarget)
					dir = angle2dir_cardinal(get_real_angle(user, etarget))
					user.dir = dir

				spawn()
					InsectWaveDamage(user,3,(200+150*user.ControlDamageMultiplier()),3,14)
				InsectGust(user.x,user.y,user.z,user.dir,2,14)

				user.stunned=0
				user.icon_state=""

		insect_cocoon_technique
			id = INSECT_COCOON_TECHNIQUE
			name = "Insect Cocoon Technique"
			icon_state = "insect_cocoon_technique"
			default_chakra_cost = 150
			default_cooldown = 100



			IsUsable(mob/user)
				. = ..()
				if(.)
					if(!user.bugs_summoned)
						Error(user, "Cannot be used without summoned bugs")
						return 0



			Use(mob/human/user)
				if(user.insect_cocoon)
					user.insect_cocoon=0
					user.overlays-='icons/bug_summoning.dmi'
					ChangeIconState("insect_cocoon_technique")
					return
				viewers(user) << output("[user]: Secret Technique: Insect Cocoon Technique!", "combat_output")
				ChangeIconState("cancel_cocoon")
				user.overlays+='icons/bug_shield.dmi'
				user.insect_cocoon=3
				spawn()
					while(user && user.insect_cocoon)
						sleep(1)
					if(!user) return
					user.overlays-='icons/bug_shield.dmi'
					ChangeIconState("insect_cocoon_technique")

mob/var
	bugs_summoned=0
	insect_cocoon=0
	bug_cooldown=0

obj
	bug_projectile
		icon='icons/bug_projectile.dmi'
		density=1
		var
			mob/Owner=null
			hit=0

		New(mob/human/player/p, dx, dy, dz, ddir)
			..()
			src.Owner=p
			src.dir=ddir
			src.loc=locate(dx,dy,dz)
			walk(src,src.dir)
			spawn(100)
				if(src&&!src.hit) del(src)

		Bump(O)
			if(src.hit) return
			if(istype(O,/mob))
				src.hit=1
				if(!istype(O,/mob/human/player)||O==src.Owner)
					del(src)
				src.icon=0
				var/mob/p = O
				var/mob/M = src.Owner
				p.Bug_Projectile_Hit(p,M)
				spawn() del(src)

			if(istype(O,/turf))
				var/turf/T = O
				if(T.density)
					src.hit=1
					del(src)

			if(istype(O,/obj))
				var/obj/T = O
				if(T.density)
					src.hit=1
					del(src)

mob/proc
	Bug_Projectile_Hit(mob/human/player/M,mob/human/player/P)
		var/mob/gotcha=0
		var/turf/getloc=0
		var/obj/b = new/obj()
		b.layer=MOB_LAYER+1
		if(!M.ko && !M.protected)
			b.icon='insect_sphere.dmi'
			b.loc=locate(M.x,M.y,M.z)
			flick("form",b)
			b.icon_state="formed"
			M.stunned=5
			M.paralysed=1
			gotcha=M
			getloc=locate(M.x,M.y,M.z)
		var/drains=0
		while(gotcha && gotcha.loc==getloc)
			sleep(10)
			if(!gotcha||drains>=5) break
			drains++
			gotcha.curchakra-= round(100)
			gotcha.curstamina-= round(100)
			gotcha.Hostile(P)
			if(gotcha.curchakra<0||gotcha.curstamina<0)
				gotcha.paralysed=0
				gotcha.curstamina=0
				gotcha=0

		M.paralysed=0
		del(b)




