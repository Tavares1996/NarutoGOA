/*skill
	Shiki_Fujin
		id = SHIKI_FUJIN
		name = "Forbbiden:Shiki Fu-jin"
		icon_state = "DeathGOD"
		default_chakra_cost = 1500
		default_cooldown = 5
		default_seal_time = 1
		copyable = 0

		IsUsable(mob/user)
			. = ..()
			if(.)
				if(!user.MainTarget())
					Error(user, "No Target")
					return 0


		Use(mob/human/user)
			viewers(user) << output("[user]: Forbbiden:Shiki Fu-jin", "combat_output")

			var/mob/human/player/etarget = user.MainTarget()
			if(!etarget)
				for(var/mob/human/M in oview(1))
					if(!M.protected && !M.ko)
						etarget=M
			if(etarget)
				spawn(1)Death_GOD(user.x,user.y+2,user.z)

			for(var/mob/human/X in oview(2,user))
				user.stunned=100
				user.dir=SOUTH
				etarget.stunned=100
				etarget.dir=NORTH*/















obj
	Death_GOD
		density=1
		layer=MOB_LAYER+1
		icon='DeathGOD.dmi'
proc
	Death_GOD(dx,dy,dz)
		var/obj/x2=new/obj/Death_GOD(locate(dx,dy+1,dz))
		sleep(96)
		del(x2)
