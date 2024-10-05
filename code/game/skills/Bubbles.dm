skill
	bubbles
		copyable = 0

		bubblebarrage
			id = BUBBLE_BARRAGE
			name = "Bubble Jutsu: Bubble Control"
			icon_state = "Bubblebar"
			default_chakra_cost = 10
			default_cooldown = 2




			Use(mob/user)
				viewers(user) << output("[user]: Secret Art: Bubble Control!", "combat_output")
				var/eicon = 'icons/projectiles.dmi'
				var/estate = "Bubble-m"

				if(!user.icon_state)
					user.icon_state="Seal"
					spawn(20)
						user.icon_state=""
				var/damage = 100
				var/angle
				var/speed = 10
				var/spread = 18
				if(user.MainTarget()) angle = get_real_angle(user, user.MainTarget())
				else angle = dir2angle(user.dir)



				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*4, distance=10, damage=damage, wounds=0)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*3, distance=10, damage=damage, wounds=0)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*2, distance=10, damage=damage, wounds=0)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread, distance=10, damage=damage, wounds=0)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle, distance=10, damage=damage, wounds=0)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle-spread, distance=10, damage=damage, wounds=0)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle-spread*2, distance=10, damage=damage, wounds=0)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle-spread*3, distance=10, damage=damage, wounds=0)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle-spread*4, distance=10, damage=damage, wounds=0)
				sleep(4)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*4, distance=10, damage=damage, wounds=0)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*3, distance=10, damage=damage, wounds=0)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*2, distance=10, damage=damage, wounds=0)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread, distance=10, damage=damage, wounds=0)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle, distance=10, damage=damage, wounds=0)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle-spread, distance=10, damage=damage, wounds=0)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle-spread*2, distance=10, damage=damage, wounds=0)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle-spread*3, distance=10, damage=damage, wounds=0)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle-spread*4, distance=10, damage=damage, wounds=0)
				sleep(4)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*4, distance=10, damage=damage, wounds=0)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*3, distance=10, damage=damage, wounds=0)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*2, distance=10, damage=damage, wounds=0)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread, distance=10, damage=damage, wounds=0)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle, distance=10, damage=damage, wounds=0)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle-spread, distance=10, damage=damage, wounds=0)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle-spread*2, distance=10, damage=damage, wounds=0)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle-spread*3, distance=10, damage=damage, wounds=0)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle-spread*4, distance=10, damage=damage, wounds=0)
				sleep(4)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*4, distance=10, damage=damage, wounds=0)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*3, distance=10, damage=damage, wounds=0)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*2, distance=10, damage=damage, wounds=0)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread, distance=10, damage=damage, wounds=0)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle, distance=10, damage=damage, wounds=0)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle-spread, distance=10, damage=damage, wounds=0)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle-spread*2, distance=10, damage=damage, wounds=0)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle-spread*3, distance=10, damage=damage, wounds=0)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle-spread*4, distance=10, damage=damage, wounds=0)


		exploding_bubbles
			id = EXPLODING_BUBBLES
			name = "Bubble Jutsu: Exploding Bubbles"
			icon_state = "bubble4"
			default_chakra_cost = 10
			default_cooldown = 2



			IsUsable(mob/user)
				. = ..()
				var/mob/human/target = user.MainTarget()
				if(.)
					if(!target)
						Error(user, "No Target")
						return 0
					var/distance = get_dist(user, target)
					if(distance > 10)
						Error(user, "Target too far ([distance]/10 tiles)")
						return 0


			Use(mob/human/user)
				flick("Seal",user)

				var/hit=0
				var/mob/human/player/etarget = user.MainTarget()
				if(etarget)
					if(!etarget.protected && !etarget.ko)
						hit=1
				if(hit)
					var/conmult = user.ControlDamageMultiplier()
					var/mob/human/clay/bubble/B=new/mob/human/clay/bubble(locate(user.x-1,user.y,user.z),rand(1000,(1000+300*conmult)),user)
					var/mob/human/clay/bubble/A=new/mob/human/clay/bubble(locate(user.x+1,user.y,user.z),rand(1000,(1000+300*conmult)),user)
					var/mob/human/clay/bubble/C=new/mob/human/clay/bubble(locate(user.x,user.y-1,user.z),rand(1000,(1000+300*conmult)),user)
					var/mob/human/clay/bubble/D=new/mob/human/clay/bubble(locate(user.x,user.y+1,user.z),rand(1000,(1000+300*conmult)),user)
					spawn(1)Poof(D.x,D.y,D.z)
					spawn(3)Homing_Projectile_bang(user,D,8,etarget,1)
					spawn(1)Poof(C.x,C.y,C.z)
					spawn(3)Homing_Projectile_bang(user,C,8,etarget,1)
					spawn(1)Poof(B.x,B.y,B.z)
					spawn(3)Homing_Projectile_bang(user,B,8,etarget,1)
					spawn(1)Poof(A.x,A.y,A.z)
					spawn(3)Homing_Projectile_bang(user,A,8,etarget,1)
					spawn(50)
						if(B)
							B.Explode()
						if(A)
							A.Explode()
						if(C)
							A.Explode()
						if(D)
							A.Explode()
//bubble blind
//						etarget.sight=(BLIND|SEE_SELF|SEE_OBJS)
//						spawn(d*10)
//							if(etarget) etarget.sight=0
//
//							del(I)


//donate only

		exploding_bubblesm
			id = EXPLODING_BUBBLESM
			name = "Bubble Jutsu: Exploding Bubbles Reverse"
			icon_state = "Explodes"
			default_chakra_cost = 10
			default_cooldown = 2




			IsUsable(mob/user)
				. = ..()
				var/mob/human/target = user.MainTarget()
				if(.)
					if(!target)
						Error(user, "No Target")
						return 0
					var/distance = get_dist(user, target)
					if(distance > 10)
						Error(user, "Target too far ([distance]/10 tiles)")
						return 0


			Use(mob/human/user)
				flick("Seal",user)

				var/hit=0
				var/mob/human/player/etarget = user.MainTarget()
				if(etarget)
					if(!etarget.protected && !etarget.ko)
						hit=1
				if(hit)
					var/conmult = user.ControlDamageMultiplier()
					var/mob/human/clay/bubble/B=new/mob/human/clay/bubble(locate(etarget.x-2,etarget.y,etarget.z),rand(1200,(1800+300*conmult)),user)
					var/mob/human/clay/bubble/A=new/mob/human/clay/bubble(locate(etarget.x+2,etarget.y,etarget.z),rand(1200,(1800+300*conmult)),user)
					var/mob/human/clay/bubble/C=new/mob/human/clay/bubble(locate(etarget.x,etarget.y-2,etarget.z),rand(1200,(1800+300*conmult)),user)
					var/mob/human/clay/bubble/D=new/mob/human/clay/bubble(locate(etarget.x,etarget.y+2,etarget.z),rand(1200,(1800+300*conmult)),user)
					spawn(1)Poof(D.x,D.y,D.z)
					spawn(3)Homing_Projectile_bang(user,D,8,etarget,1)
					spawn(1)Poof(C.x,C.y,C.z)
					spawn(3)Homing_Projectile_bang(user,C,8,etarget,1)
					spawn(1)Poof(B.x,B.y,B.z)
					spawn(3)Homing_Projectile_bang(user,B,8,etarget,1)
					spawn(1)Poof(A.x,A.y,A.z)
					spawn(3)Homing_Projectile_bang(user,A,8,etarget,1)
					spawn(50)
						if(B)
							flick("bubble-pop",B)
							B.Explode()
						if(A)
							flick("bubble-pop",A)
							A.Explode()
						if(C)
							flick("bubble-pop",C)
							A.Explode()
						if(D)
							flick("bubble-pop",D)
							A.Explode()
//
		blinding_bubbles
			id = BLINDING_BUBBLES
			name = "Bubble Jutsu: Blinding Bubbles"
			icon_state = "Explodes"
			default_chakra_cost = 10
			default_cooldown = 2



			IsUsable(mob/user)
				. = ..()
				var/mob/human/target = user.MainTarget()
				if(.)
					if(!target)
						Error(user, "No Target")
						return 0
					var/distance = get_dist(user, target)
					if(distance > 10)
						Error(user, "Target too far ([distance]/10 tiles)")
						return 0


			Use(mob/human/user)
				flick("Seal",user)

				var/hit=0
				var/mob/human/player/etarget = user.MainTarget()
				if(etarget)
					if(!etarget.protected && !etarget.ko)
						hit=1
				if(hit)
					var/conmult = user.ControlDamageMultiplier()
					var/mob/human/clay/bubble/A=new/mob/human/clay/bubble(locate(user.x,user.y,user.z),rand(200,(400+300*conmult)),user)
					spawn(1)Poof(A.x,A.y,A.z)
					spawn(3)Homing_Projectile_bang(user,A,8,etarget,1)
					spawn(50)
						if(A)
							A.Explode()
							etarget.sight=(BLIND|SEE_SELF|SEE_OBJS)
							sleep(100)
							etarget.sight=0

