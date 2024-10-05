skill
	medic
		face_nearest = 1
		heal
			id = MEDIC
			name = "Medical: Heal"
			icon_state = "medical_jutsu"
			default_chakra_cost = 60
			default_cooldown = 5



			Use(mob/user)
				var/mob/human/player/etarget = user.NearestTarget()

				if(etarget&&(etarget in ohearers(user,1)))
					var/turf/p=etarget.loc
					var/turf/q=user.loc
					user.icon_state="Throw2"

					user.Timed_Stun(5)
					user.usemove=1
					var/sleeptime = 20
					while(sleeptime > 0 && etarget && etarget.x==p.x && etarget.y==p.y && user.x==q.x && user.y==q.y)
						sleep(2)
						sleeptime -= 2
					if(!user.usemove)
						user.combat("Your healing was interrupted!")
						user.icon_state=""
						if(etarget) etarget.overlays-='icons/base_chakra.dmi'
						return
					if(etarget && etarget.x==p.x && etarget.y==p.y && user.x==q.x && user.y==q.y)
						if(!etarget.curwound)
							user.combat("[etarget] has no wounds")
							user.icon_state=""
							etarget.overlays-='icons/base_chakra.dmi'
							return
						etarget.overlays+='icons/base_chakra.dmi'
						sleep(3)
						user.icon_state=""
						if(etarget) etarget.overlays-='icons/base_chakra.dmi'
						if(!etarget || !user.usemove)
							user.combat("Your healing was interrupted!")
							user.icon_state=""
							if(etarget) etarget.overlays-='icons/base_chakra.dmi'
							return
						var/conroll=rand(1,2*(user.con+user.conbuff-user.conneg))
						var/woundroll=rand(round((etarget.curwound)/3),(etarget.curwound))
						if(conroll>woundroll && woundroll)
							var/effect=round(conroll/(woundroll))//*pick(1,2,3)
							if(user.skillspassive[23])effect*=(1 + 0.15*user.skillspassive[23])
							if(effect>etarget.curwound)
								effect=etarget.curwound

							etarget.curwound-=effect
							user.combat("Healed [etarget] [effect] Wound")
							etarget.combat("You have been healed by [user], [effect] Wound")
							if(etarget.curwound<=0)
								etarget.curwound=0
						else
							user.combat("You failed to do any healing!")
						user.icon_state=""
					else
						user.combat("Your healing was interrupted!")
						user.icon_state=""
						if(etarget) etarget.overlays-='icons/base_chakra.dmi'





		poison_mist
			id = POISON_MIST
			name = "Medical: Poison Mist"
			icon_state = "poisonbreath"
			default_chakra_cost = 420
			default_cooldown = 60



			Use(mob/human/user)
				var/mox=0
				var/moy=0
				user.icon_state="Seal"
				if(user.dir==NORTH)
					moy=1
				if(user.dir==SOUTH)
					moy=-1
				if(user.dir==EAST)
					mox=1
				if(user.dir==WEST)
					mox=-1
				if(!mox&&!moy)
					return
				user.stunned=10
				var/poisoning=1
				var/list/smogs=new()
				var/flagloc
				spawn()
					while(user && poisoning)
						var/list/poi=new()
						for(var/obj/XQ in smogs)
							for(var/mob/human/player/MA in view(0,XQ))
								if(!poi.Find(MA))
									poi+=MA
						for(var/mob/PP in poi)
							var/PEn0r=1 + round(1*user.ControlDamageMultiplier())
							if(PEn0r>5)
								PEn0r=5
							if(PP.protected || PP.ko)
								PEn0r=0
							PP.Poison+=PEn0r
							if(PP.movepenalty<20)
								PP.movepenalty=25
							PP.Hostile(user)

						sleep(10)

				flagloc=locate(user.x+mox,user.y+moy,user.z)

				spawn()
					var/obj/Poison_Poof/S1=new/obj/Poison_Poof(flagloc)
					var/obj/Poison_Poof/S2=new/obj/Poison_Poof(flagloc)
					var/obj/Poison_Poof/S3=new/obj/Poison_Poof(flagloc)
					var/obj/Poison_Poof/S4=new/obj/Poison_Poof(flagloc)
					var/obj/Poison_Poof/S5=new/obj/Poison_Poof(flagloc)
					smogs+=S1
					smogs+=S2
					smogs+=S3
					smogs+=S4
					smogs+=S5
					if(mox==1||mox==-1)
						spawn() if(S1)S1.Spread(5*mox,6,192,smogs)
						spawn() if(S2)S2.Spread(6.5*mox,4,192,smogs)
						spawn() if(S3)S3.Spread(8*mox,0,192,smogs)
						spawn() if(S4)S4.Spread(5*mox,-6,192,smogs)
						spawn() if(S5)S5.Spread(6.5*mox,-4,192,smogs)
					else
						spawn() if(S1)S1.Spread(6,5*moy,192,smogs)
						spawn() if(S2)S2.Spread(4,6.5*moy,192,smogs)
						spawn() if(S3)S3.Spread(0,8*moy,192,smogs)
						spawn() if(S4)S4.Spread(-6,5*moy,192,smogs)
						spawn() if(S5)S5.Spread(-4,6.5*moy,192,smogs)
				spawn(19)
					flagloc=locate(user.x+mox*2,user.y+moy*2,user.z)
					var/obj/Poison_Poof/S1=new/obj/Poison_Poof(flagloc)
					var/obj/Poison_Poof/S2=new/obj/Poison_Poof(flagloc)

					var/obj/Poison_Poof/S4=new/obj/Poison_Poof(flagloc)
					var/obj/Poison_Poof/S5=new/obj/Poison_Poof(flagloc)
					smogs+=S1
					smogs+=S2

					smogs+=S4
					smogs+=S5
					if(mox==1||mox==-1)
						spawn()if(S1)S1.Spread(5*mox,6,160,smogs)
						spawn()if(S2)S2.Spread(6.5*mox,4,160,smogs)
						spawn()if(S4)S4.Spread(5*mox,-6,160,smogs)
						spawn()if(S5)S5.Spread(6.5*mox,-4,160,smogs)
					else
						spawn()if(S1)S1.Spread(6,5*moy,160,smogs)
						spawn()if(S2)S2.Spread(4,6.5*moy,160,smogs)
						spawn()if(S4)S4.Spread(-6,5*moy,160,smogs)
						spawn()if(S5)S5.Spread(-4,6.5*moy,160,smogs)

				sleep(40)
				if(user)
					user.stunned=0
					user.icon_state=""
				sleep(80)
				poisoning=0
				for(var/obj/BO in smogs)
					del(BO)




		chakra_scalpel
			id = MYSTICAL_PALM
			name = "Medical: Chakra Scalpel"
			icon_state = "mystical_palm_technique"
			default_chakra_cost = 100
			default_cooldown = 30


			ChakraCost(mob/user)
				if(!user.scalpol)
					return ..(user)
				else
					return 0


			Cooldown(mob/user)
				if(!user.scalpol)
					return ..(user)
				else
					return 0


			Use(mob/human/user)
				if(user.scalpol)
					user.special=0
					user.scalpol=0
					user.weapon=new/list()
					user.Load_Overlays()
					ChangeIconState("mystical_palm_technique")
				else
					user.combat("This skill requires precison. Wait between attacks for critical damage!")
					user.scalpol=1
					user.overlays+='icons/chakrahands.dmi'
					user.special=/obj/chakrahands
					user.removeswords()
					user.weapon=list('icons/chakraeffect.dmi')
					user.Load_Overlays()
					ChangeIconState("mystical_palm_technique_cancel")




		cherry_blossom_impact
			id = CHAKRA_TAI_RELEASE
			name = "Medical: Cherry Blossom Impact"
			icon_state = "chakra_taijutsu_release"
			default_chakra_cost = 100
			default_cooldown = 10


			Use(mob/human/user)
				user.stunned=1
				user.overlays+='icons/sakurapunch.dmi'
				user.combat("Attack Quickly! Your chakra will drain until you attack.")
				sleep(5)
				user.overlays-='icons/sakurapunch.dmi'
				if(user.stunned<=1)
					user.stunned=0
				user.sakpunch=1
				if(user.bunshin)
					var/mob/human/etarget = user.MainTarget()
					user.AppearBehind(etarget)
					sleep(3)
					user.attackv(etarget)
					sleep(3)
					user.icon_state=""
				sleep(10)
				spawn()
					while(user && user.sakpunch && user.curchakra>100)
						user.curchakra-=100
						sleep(10)
					if(user) user.sakpunch=0

		chakra_enhancement
			id = CHAKRA_ENHANCEMENT
			name = "Medical: Chakra Enhancement"
		//	description = "Enhances your strength with chakra, allowing you break bones with multiple punches. Lasts for 15 seconds. Can be canceled."
			icon_state = "chakra_enhancement"
			default_chakra_cost = 150
			default_cooldown = 100

			Activate(mob/human/user)
				if(user.tsupunch)
					user.tsupunch = 0
					return
				..(user)

		//	EstimateStaminaDamage(mob/user)
		//		return list(round((user.con+user.conbuff+user.str+user.strbuff) * 2 + 200)*0.6, round((user.con+user.conbuff+user.str+user.strbuff) * 2 + 200)*1.4)

			Use(mob/human/user)
			//	user.Begin_Stun()
				user.overlays+='icons/sakurapunch.dmi'
				sleep(5)
				user.overlays-='icons/sakurapunch.dmi'
			//	user.End_Stun()
				user.tsupunch=1
				var/dur = 15
				while(user && user.tsupunch && dur)
					sleep(10)
					dur--
				if(user) user.tsupunch=0


		body_disruption_stab
			id = IMPORTANT_BODY_PTS_DISTURB
			name = "Medical: Body Disruption Stab"
			icon_state = "important_body_ponts_disturbance"
			default_chakra_cost = 100
			default_cooldown = 180



			IsUsable(mob/user)
				. = ..()
				var/mob/human/target = user.NearestTarget()
				if(.)
					if(!target)
						Error(user, "No Target")
						return 0
					if(target.kaiten || target.sandshield)
						Error(user, "No Valid Target")
						return 0
					var/distance = get_dist(user, target)
					if(distance > 2)
						Error(user, "Target too far ([distance]/2 tiles)")
						return 0


			Use(mob/human/user)
				var/mob/human/player/etarget = user.NearestTarget()
				var/CX=rand(1,(user.con+user.conbuff-user.conneg))
				var/Cx=rand(1,(etarget.con+etarget.conbuff-etarget.conneg))
				if(CX>Cx)
					user.combat("Nervous system disruption succeeded!")
					etarget.combat("Your nervous system has been attacked, you are unable to control your muscles!")
					etarget.overlays+='icons/disturbance.dmi'
					spawn(20)
						etarget.overlays-='icons/disturbance.dmi'
					etarget.movement_map = list()
					var/list/dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
					var/list/dirs2 = dirs.Copy()
					for(var/orig_dir in dirs)
						var/new_dir = pick(dirs2)
						dirs2 -= new_dir
						etarget.movement_map["[orig_dir]"] = new_dir
					spawn(600)
						if(etarget) etarget.movement_map = null
				else
					user.combat("Nervous system disruption failed!")




		creation_rebirth
			id = PHOENIX_REBIRTH
			name = "Medical: Creation Rebirth"
			icon_state = "pheonix_rebirth"
			default_chakra_cost = 800
			default_cooldown = 1200
			copyable = 0



			Use(mob/human/user)
				user.protected=10
				user.icon_state="hurt"
				user.overlays+='icons/rebirth.dmi'
				user.stunned+=3
				spawn(30)
					user.overlays-='icons/rebirth.dmi'
					user.protected=0
					user.icon_state=""
				sleep(30)
				if(!user.ko)
					var/oldwound=user.curwound
					user.curwound-=100
					if(user.curwound<0)
						user.curwound=0
					var/oldstam=user.curstamina
					user.curstamina=round(user.stamina*1.25)
					user.combat("[oldwound-user.curwound] Wounds and [user.curstamina - oldstam] Stamina healed!")

		delicate_extraction
			id = DELICATE_EXTRACTION
			name = "Medical: Delicate Extraction"
		//	description = "Removes poison from your ally's body."
			icon_state = "delicate_extraction"
			default_chakra_cost = 80
			default_cooldown = 5

			IsUsable(mob/user)
				. = ..()
				if(.)
					var/mob/human/etarget = user.MainTarget()
					if(etarget && etarget.mole)
						Error(user, "No Valid Target")
						return 0

			Use(mob/user)
				var/mob/human/player/etarget = user.NearestTarget()
				if(!etarget)
					for(var/mob/human/M in get_step(user,user.dir))
						if(!M.mole) etarget=M
						break

				if(etarget&&(etarget in ohearers(user,1)))
					var/turf/p=etarget.loc
					var/turf/q=user.loc
					user.icon_state="Throw2"

					user.Timed_Stun(5)
					user.usemove=1
					var/sleeptime = 50
					while(sleeptime > 0 && etarget && etarget.x==p.x && etarget.y==p.y && user.x==q.x && user.y==q.y)
						sleep(2)
						sleeptime -= 2
					if(!user.usemove)
						user.combat("Your extraction was interrupted!")
						user.icon_state=""
						if(etarget) etarget.overlays-='icons/base_chakra.dmi'
						return
					if(etarget && etarget.x==p.x && etarget.y==p.y && user.x==q.x && user.y==q.y)
						if(!etarget.Poison)
							user.combat("[etarget] is not poisoned")
							user.icon_state=""
							etarget.overlays-='icons/base_chakra.dmi'
							return
						etarget.overlays+='icons/base_chakra.dmi'
						sleep(3)
						user.icon_state=""
						if(etarget) etarget.overlays-='icons/base_chakra.dmi'
						if(!etarget || !user.usemove)
							user.combat("Your extraction was interrupted!")
							user.icon_state=""
							if(etarget) etarget.overlays-='icons/base_chakra.dmi'
							return
						var/conroll=rand(1,2*(user.con+user.conbuff-user.conneg))
						var/poisonroll=rand(round((etarget.Poison)/3),(etarget.Poison))
						if(conroll>poisonroll && poisonroll)
							var/effect=round(conroll/(poisonroll))//*pick(1,2,3)
							if(user.skillspassive[23])effect*=(1 + 0.15*user.skillspassive[23])
							if(effect>etarget.Poison)
								effect=etarget.Poison

							etarget.Poison-=effect
							if(etarget.Poison<=0)
								etarget.Poison=0
							if(etarget.Poison)
								user.combat("Extracted some of [etarget]'s poison")
								etarget.combat("[user] extracted some of your poison")
							else
								user.combat("Extracted all of [etarget]'s poison")
								etarget.combat("[user] extracted all of your poison")
						else
							user.combat("You failed to extract any poison!")
						user.icon_state=""
					else
						user.combat("Your extraction was interrupted!")
						user.icon_state=""

	menacing_palm
		id = MENACING_PALM
		name = "Menacing Palm"
	//	description = "Infuse your enemy with an explosion of chakra, dealing moderate stamina damage and minor wounds."
		icon_state = "mystical_palm_technique2"
		default_chakra_cost = 300
		default_cooldown = 150

		/*IsUsable(mob/user)
			. = ..()
			if(.)
				var/mob/human/etarget = user.MainTarget()
				var/distance = get_dist(user, etarget)
				if(etarget && !etarget.ko && distance > 1)
					Error(user, "Target too far ([distance]/1 tiles)")
					return 0
				if(!etarget || (etarget && etarget.ko || etarget.chambered))
					for(var/mob/human/eX in get_step(user,user.dir))
						if(!eX.ko && !eX.IsProtected())
							return 1 //target found
					Error(user, "No Valid Target")
					return 0*/

		Use(mob/human/player/user)
			viewers(user) << output("[user]: Medic: Menacing Palms!", "combat_output")

			var/mob/human/etarget = user.MainTarget()
			if(etarget && !etarget.ko && !(get_dist(user, etarget) > 1))
				user.FaceTowards(etarget)
			else
				etarget = null
				for(var/mob/human/eX in get_step(user,user.dir))
					if(!eX.ko && !eX.IsProtected())
						etarget = eX
						break

			if(etarget)
				etarget=etarget.Replacement_Start(user)
				user.Timed_Stun(10)
				etarget.Timed_Stun(10)
				user.icon_state="Throw2"
				user.overlays+='icons/menacing_palm.dmi'
				etarget.overlays+='icons/menacing_palm.dmi'
				sleep(10)
				etarget.overlays-='icons/menacing_palm.dmi'
				user.overlays-='icons/menacing_palm.dmi'
				user.icon_state=""
				spawn(5) if(etarget) etarget.Replacement_End()
				explosion(50,etarget.x,etarget.y,etarget.z,user,1)
				etarget.Knockback(5,get_dir(user,etarget))
				etarget.Dec_Stam(round(500 + 140*(user.con/150)*(1+0.04*user.skillspassive[23])),4,user,"Medical: Menacing Palm","Internal")

		/*Use(mob/human/player/user)
			user.Timed_Stun(20)
			user.icon_state="Throw2"
			user.overlays+='icons/menacing_palm.dmi'
			var/mob/gotcha=0
			var/turf/getloc=0

			var/mob/human/etarget = user.MainTarget()
			if(etarget && !etarget.ko && !(get_dist(user, etarget) > 1))
				user.FaceTowards(etarget)
			else
				for(var/mob/human/eX in get_step(user,user.dir))
					if(!eX.ko && !eX.IsProtected() && !eX.chambered)
						etarget = eX
						break

			if(!etarget)
				user.overlays-='icons/menacing_palm.dmi'
				world << "BUG: Menacing palm should not have gotten this far without a target"
				return
			gotcha=etarget.Replacement_Start(user)
			gotcha.overlays+='icons/menacing_palm.dmi'
			gotcha.Timed_Move_Stun(30)
			if(gotcha != etarget)
				spawn() user.Timed_Stun(20)
				sleep(20)
				gotcha.overlays-='icons/menacing_palm.dmi'
				user.overlays-='icons/menacing_palm.dmi'
				user.icon_state=""
				spawn(5) if(gotcha) gotcha.Replacement_End()
				return
			getloc=locate(etarget.x,etarget.y,etarget.z)

			sleep(5)
			user.Timed_Stun(5)
			var/turf/q=user.loc
			while(user && !user.ko && gotcha && !gotcha.ko && gotcha.loc==getloc && (abs(user.x-gotcha.x)*abs(user.y-gotcha.y))<=1 && user.x==q.x && user.y==q.y && user.curchakra > 50)
				user.curchakra -= 50
				gotcha.Damage(round(100 + 75*(user.con/150)*(1+0.04*user.skillspassive[23])),pick(0,0,0,1,1,2),user,"Medical: Menacing Palm","Internal")
				gotcha.Hostile(user)
				sleep(5)
			user.overlays-='icons/menacing_palm.dmi'
			if(gotcha) gotcha.overlays-='icons/menacing_palm.dmi'
			user.icon_state=""*/


/*		transfer
			id = TRANSFER
			name = "Medical: Chakra Transfer"
			icon_state = "Transfer"
			default_chakra_cost = 500
			default_cooldown = 5


			Use(mob/user)
				var/mob/human/player/etarget = user.NearestTarget()
				if(!etarget)
					for(var/mob/human/M in get_step(user,user.dir))
						etarget=M
						break



				if(etarget&&(etarget in oview(user,5)))
					var/turf/p=etarget.loc
					user.icon_state="Chakra"
					etarget.icon_state="Chakra"


					user.stunned=2
					etarget.stunned=2
					sleep(20)
					if(etarget && etarget.x==p.x && etarget.y==p.y)
						etarget.overlays+='icons/base_chakra.dmi'
						usr.overlays+='icons/base_chakra.dmi'
						sleep(10)
						if(!etarget)
							return
						user.icon_state=""
						etarget.overlays-='icons/base_chakra.dmi'
						usr.overlays-='icons/base_chakra.dmi'
						etarget.curchakra += 500
						user.icon_state=""
						etarget.icon_state=""*/




		poisoned_needles
			id = POISON_NEEDLES
			name = "Medical: Poisoned Needles"
			icon_state = "poison_needles"
			default_supply_cost = 5
			default_cooldown = 60
			face_nearest = 0



			Use(mob/human/user)
				user.icon_state="Throw1"
				user.stunned=10
				sleep(5)
				var/list/hit=new
				var/oX=0
				var/oY=0
				var/devx=0
				var/devy=0
				var/mob/human/player/etarget = user.NearestTarget()
				if(etarget)
					user.dir = angle2dir_cardinal(get_real_angle(user, etarget))
				if(user.dir==NORTH)
					oY=1
					devx=8
				if(user.dir==SOUTH)
					oY=-1
					devx=8
				if(user.dir==EAST)
					oX=1
					devy=8
				if(user.dir==WEST)
					oX=-1
					devy=8
				spawn()
					if(user)
						hit+=advancedprojectile_returnloc(/obj/needle,user,(32*oX),(32*oY),5,100,user.x,user.y,user.z)
				spawn()
					if(user)
						var/turf/T=advancedprojectile_returnloc(/obj/needle,user,32*oX +devx,32*oY + devy,5,100,user.x,user.y,user.z)
						for(var/mob/human/mX in locate(T.x,T.y,T.z))
							hit+=mX
				spawn()
					if(user)
						var/turf/T=advancedprojectile_returnloc(/obj/needle,user,32*oX +1.5*devx,32*oY + 1.5*devy,5,100,user.x,user.y,user.z)
						for(var/mob/human/mX in locate(T.x,T.y,T.z))
							hit+=mX
				spawn()
					if(user)
						var/turf/T=advancedprojectile_returnloc(/obj/needle,user,32*oX +-1*devx,32*oY + -1*devy,5,100,user.x,user.y,user.z)
						for(var/mob/human/mX in locate(T.x,T.y,T.z))
							hit+=mX
				spawn()
					if(user)
						var/turf/T=advancedprojectile_returnloc(/obj/needle,user,32*oX +-1.5*devx,32*oY + -1.5*devy,5,100,user.x,user.y,user.z)
						for(var/mob/human/mX in locate(T.x,T.y,T.z))
							hit+=mX
				sleep(5)

				if(user)
					user.stunned=0
					user.icon_state=""
				var/turf/T=advancedprojectile_returnloc(/obj/needle,user,32*oX +-1.5*devx,32*oY + -1.5*devy,5,100,user.x,user.y,user.z)
				for(var/mob/human/mX in locate(T.x,T.y,T.z))
					if(mX.triggers && mX.triggers.len)
						for(var/obj/trigger/kawarimi2/P in mX.triggers)
							P.AutoUse()
							return
				spawn(20)
					for(var/mob/human/M in hit)
						spawn()
							if(M && !M.ko && !M.protected && M!=user)
								M.Poison+=rand(4,8)
								M.Dec_Stam(500,user)
								M.Hostile(user)




obj
	chakrahands
		icon='icons/chakrahands.dmi'
		layer=FLOAT_LAYER




	Poison_Poof
		proc
			PixelMove(dpixel_x, dpixel_y, list/smogs)
				var/new_pixel_x = pixel_x + dpixel_x
				var/new_pixel_y = pixel_y + dpixel_y


				while(abs(new_pixel_x) > 16)
					var/kloc = loc
					if(new_pixel_x > 16)
						new_pixel_x -= 32
						var/Phail=0

						for(var/obj/Poison_Poof/x in oview(0,src))
							Phail=1
							break

						x++

						if(!Phail)
							smogs+=new/obj/Poison_Poof(kloc)

					else if(new_pixel_x < -16)
						new_pixel_x += 32

						var/Phail=0
						for(var/obj/Poison_Poof/x in oview(0,src))
							Phail=1
							break

						x--

						if(!Phail)
							smogs+=new/obj/Poison_Poof(kloc)

				while(abs(new_pixel_y) > 16)
					var/kloc = loc
					if(new_pixel_y > 16)
						new_pixel_y -= 32

						var/Phail=0
						for(var/obj/Poison_Poof/x in oview(0,src))
							Phail=1
							break

						y++

						if(!Phail)
							smogs+=new/obj/Poison_Poof(kloc)

					else if(new_pixel_y < -16)
						new_pixel_y += 32

						var/Phail=0
						for(var/obj/Poison_Poof/x in oview(0,src))
							Phail=1
							break

						y--

						if(!Phail)
							smogs+=new/obj/Poison_Poof(kloc)

				pixel_x = new_pixel_x
				pixel_y = new_pixel_y


			Spread(motx,moty,mom,list/smogs)
				while(mom>0)
					PixelMove(motx/3, moty/3, smogs)
					sleep(1)

					PixelMove(motx/3, moty/3, smogs)
					sleep(1)

					PixelMove(motx/3, moty/3, smogs)
					sleep(1)

					mom -= (abs(motx)+abs(moty))


