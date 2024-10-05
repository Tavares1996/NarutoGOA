mob/human/player/New()
	. = ..()
	if(!istype(src,/mob/human/player/npc))
		spawn()src.regeneration()
	spawn()src.regeneration2()
	spawn()src.comboregen()


mob
	proc
		relieve_bounty()
			var/mob/jerk=0
			for(var/mob/ho in world)
				if(ho.client)
					if(ho.key==src.lasthostile)
						jerk=ho

			if(jerk && jerk!=src)
				if(!jerk.faction || !src.faction || (jerk.faction.village!=src.faction.village)||jerk.faction.village=="Missing")
					world<<"<span class='death_info'><span class='name'>[src.realname]</span> has been killed by <span class='name'>[jerk.realname]</span>!</span>"
					jerk.bounty+=round(10+src.blevel*3)/3
					if(src==jerk.MissionTarget && jerk.MissionType=="Assasinate Player PvP")
						spawn()jerk.MissionComplete()
					spawn()
						if(jerk.faction && jerk.faction.village=="Missing")
							jerk<<"You gained [src.bounty] dollars for [src.realname]'s bounty!"
							jerk.money+=src.bounty
							src.bounty=0
				else
					world<<"<span class='death_info'><span class='betrayal'><span class='name'><b><u>[jerk.realname]</span> has killed <span class='name'>[src.realname]</span> and they are in the same village!</span></span>"
			else
				world<<"<span class='death_info'><span class='name'>[src]</span> has died!</span>"

proc/different_computers(var/mob/human/A, var/mob/human/B)
	// returns true if they are the same
	// very misleading function
	if(A.client.computer_id == B.client.computer_id) return TRUE
	if(A.client.address == B.client.address) return TRUE
	return null

mob
	proc
		Killed(mob/owned)
			if(src.client && owned.client && !different_computers(owned, src) && !src:killed_recently(owned))//if(!owned.client || !client || owned.client.computer_id != client.computer_id)
				var/worth= round(owned.blevel/src.blevel * 100)/100
				owned.deaths+=worth
				src.kills+=worth

		Respawn()
			if(RP)
				return
			if(!ko || curwound<maxwound)
				return
			var/obj/mapinfo/Minfo = locate("__mapinfo__[z]")
			if(Minfo && Minfo.in_war && faction && (faction.village == Minfo.village_control || faction.village == Minfo.attacking_village))
				if(faction.village == Minfo.village_control)
					++Minfo.defender_deaths
				else if(faction.village == Minfo.attacking_village)
					++Minfo.attacker_deaths

				var/adjacent[0]
				for(var/x in list(Minfo.oX-1, Minfo.oX+1))
					if(x >= 1 && x <= map_coords.len)
						var/obj/mapinfo/map = map_coords[x][Minfo.oY+1]
						if(map)
							adjacent += map
				for(var/y in list(Minfo.oY, Minfo.oY+2))
					var/list/map_col = map_coords[Minfo.oX]
					if(y >= 1 && y <= map_col.len)
						var/obj/mapinfo/map = map_col[y]
						if(map)
							adjacent += map

				var/controlled_maps[0]
				for(var/obj/mapinfo/map in adjacent)
					if(map.village_control == faction.village)
						controlled_maps += map
				if(controlled_maps.len)
					var/turf/new_loc
					while(!new_loc || !new_loc.Enter(src))
						var/obj/mapinfo/map = pick(controlled_maps)
						if(map.oX < Minfo.oX)
							new_loc = locate(1, rand(1, world.maxy), z)
						else if(map.oX > Minfo.oX)
							new_loc = locate(world.maxx, rand(1, world.maxy), z)
						else if(map.oY < Minfo.oY)
							new_loc = locate(rand(1, world.maxx), world.maxy, z)
						else // map.oX == Minfo.oX && map.oY >= Minfo.oY
							new_loc = locate(rand(1, world.maxx), 1, z)
						sleep(-1)
					loc = new_loc
					ko = 0
					curstamina = stamina
					curchakra = chakra
					curwound = 0
					spawn(10) stunned = 1
					for(var/obj/trigger/kawarimi/T in triggers)
						RemoveTrigger(T)
					for(var/obj/trigger/kawarimi2/T in triggers)
						RemoveTrigger(T)
					for(var/obj/trigger/clay_kawa/T in triggers)
						RemoveTrigger(T)

					var/mob/killer = null
					for(var/mob/M in world)
						if(M.client)
							if(M.key == lasthostile)
								killer = M
								break
					if(killer)
						world<<"<span class='death_info'><span class='name'>[src.realname]</span> has been killed by <span class='name'>[killer.realname]</span>!</span>"
						killer<<"Gained a Faction Point"
						killer.factionpoints++
						killer.Killed(src)

			else if(src.rank!="Academy Student")
				var/mob/C=new/mob/corpse(src.loc,src)
				spawn(200)
					C.loc = null
				spawn()src.relieve_bounty()
				src.stunned=2
				var/mob/jerk=0
				for(var/mob/ho in world)
					if(ho.client)
						if(ho.key==src.lasthostile)
							jerk=ho
				if(jerk)
					jerk.Killed(src)
				if(Minfo)
					Minfo.PlayerLeft(src)
				var/Re=0
				for(var/obj/Respawn_Pt/R in world)
					if(faction)
						switch(faction.village)
							if("Konoha")
								if(R.ind == 1)
									Re = R
									break
							if("Suna")
								if(R.ind == 2)
									Re = R
									break
							if("Kiri")
								if(R.ind == 3)
									Re = R
									break
							else
								if(R.ind == 0)
									Re = R
									break
					else
						if(R.ind == 0)
							Re = R
							break
				spawn()
					var/foundbed=0
					if(Re)
						var/list/pfrom=new
						for(var/obj/interactable/hospitalbed/o in oview(15,Re))
							pfrom+=o

						var/obj/interactable/hospitalbed/F=0
						F=pick(pfrom)
						if(F && istype(F))
							foundbed=1
							src.loc=F.loc
							Minfo = locate("__mapinfo__[z]")
							if(Minfo)
								Minfo.PlayerEntered(src)
							src.icon_state="hurt"
							spawn()F.Interact(src)

					if(!foundbed)
						var/obj/interactable/hospitalbed/o = locate(/obj/interactable/hospitalbed) in world
						src.loc=o.loc
						Minfo = locate("__mapinfo__[z]")
						if(Minfo)
							Minfo.PlayerEntered(src)
						src.icon_state="hurt"
						spawn()o.Interact(src)

				src.curstamina=1
				src.curwound=src.maxwound-1
				src.waterlogged=0
				src.swamplogged=0
				src<<"You have woken up in a hospital bed, you should rest here until your wounds are gone."
				src.stunned=2
			else
				if(Minfo)
					Minfo.PlayerLeft(src)
				src.loc=locate(10,91,3)
				Minfo = locate("__mapinfo__[z]")
				if(Minfo)
					Minfo.PlayerEntered(src)
				src.curwound=0
				src.curstamina=src.stamina

				src.waterlogged=0
				src.swamplogged=0
				spawn(10)src.curstamina=src.stamina
				spawn(10)src.stunned=0
mob
	EZ
		verb
			EZ_Remove_Flag()


				usr.verbs-=/mob/EZ/verb/EZ_Remove_Flag
				winset(usr, "ez_remove_verb", "parent=")
var
	wregenlag=1

mob/human
	proc
		KO()
			if(!pk)
				curstamina = stamina
				curwound = 0

			else if(gate >= 2)
				Wound(rand(32,37),3)
				curstamina = stamina * ((maxwound - curwound) / maxwound)
				curchakra = max(round(chakra / 4), curchakra)

			else
				if(src.pill)
					if(src.pill>=2)
						src.overlays-='icons/Chakra_Shroud.dmi'
					src.strbuff=0
					src.pill=0
					src.combat("The effects from the pill(s) wore off.")

				src.Poison=0
				src.Wound(rand(32,37),3)
				src.ko=1

				sleep(10)

				flick("Knockout",src)

				src.icon_state="Dead"
				src.layer=TURF_LAYER

				for(var/obj/items/Heavenscroll/II in src.contents)
					II.Drop()
				for(var/obj/items/Earthscroll/EI in src.contents)
					EI.Drop()

				var/maxwound1=100
				if(clan == "Will of Fire")
					maxwound1=130
				else if(clan == "Jashin")
					maxwound1=150
					if(immortality)
						maxwound1=999

				if(src.curwound<maxwound1||(src.immortality&&src.cexam!=5))
					sleep(src.curwound + 100)
					if(src.ko && src.curwound<300)
						if(clan == "Will of Fire")
							src.curstamina=src.stamina
							if(curwound > 100)
								src.curstamina=src.stamina*1.25
								src.curchakra=src.chakra*1.25
						else
							var/durr=((maxwound-curwound)/maxwound)/2
							if(durr<0)
								durr=0
							src.curstamina=src.stamina * durr + src.stamina/2
						if(src.curchakra<src.chakra/5)
							src.curchakra=src.chakra/5 +20

					src.protected=3
					src.stunned=0
					src.ko=0
					CombatFlag()
					src.icon_state=""
				else
					Die()

		Die()

			if(team_deathmatch)
				online_admins << "DEBUG - 1"
				if(src in team_deathmatch.white_team || src in team_deathmatch.black_team)
					src << "You have been eliminated from Team Deathmatch!"
					online_admins << "DEBUG - 2"

				team_deathmatch.Announce("[src] Has been knocked out of Team Deathmatch!")
				if(src in team_deathmatch.white_team) team_deathmatch.white_team -= src
				if(src in team_deathmatch.black_team) team_deathmatch.black_team -= src

				team_deathmatch.healPlayer(src)
				team_deathmatch.Respawn(src)
				return//Looks good to me.hnmm ight ill hoast on anyway ctf is good aswell? Oh forgot about t

//hm you think something wrong with team_deathmatch.respawn? Nope, this shit looks fine, don't understand why it just stops

			if(cexam == 5)
				src.curwound=0
				src.curstamina=src.stamina
				src.curchakra=src.chakra

				src.cexam=4
				src.inarena=0
				src.CArena()

			else if(inarena)
				world<<"<font color=Blue size= +1>[src] Has lost!</font>"
				src.inarena=0
				src.curwound=0
				src.curstamina=src.stamina
				src.curchakra=src.chakra
				if(src.oldx &&src.oldy && src.oldz)
					src.loc=locate(src.oldx,src.oldy,src.oldz)
					src.oldx=0
					src.oldy=0
					src.oldz=0

			else if(dojo)
				var/ei=0
				var/dist=1000
				var/obj/SPWN=0
				for(var/obj/dojorespawn/Dj in world)
					if(Dj.z==src.z)
						if(get_dist(Dj,src)<dist)
							dist=get_dist(Dj,src)
							SPWN=Dj
				var/obj/dojorespawn/Respawn=SPWN

				ei+=5
				if(Respawn)
					src.curwound=0
					src.loc=locate(Respawn.x,Respawn.y-1,Respawn.z)
				else
					src.curwound=0
				src.stunned=0
				spawn(10)
					src.stunned=0
					src.curwound=0
				src.curstamina = 1
				src<<"You were Defeated"

			else
				for(var/mob/human/Xe in world)
					if(Xe.Contract2==src)
						if(Xe.Contract)
							Xe.Contract.loc = null
							Xe.Contract = null
						Xe.Contract2=0
						Xe.Affirm_Icon()
				if(!RP)
					src<<"You're wounded beyond your limit, to respawn at a hospital press Space. If you are not brought back to life in 60 seconds you'll automatically respawn."
					var/count=0

					while(curwound>=maxwound)
						src.stunned=1000
						count++
						if(count>60)
							src.Respawn()
						sleep(10)

				else
					src<<"You're wounded beyond your limit, because this is a Role-Play server if your not revived by a medic within 5 minutes you'll die and have to wait till a new round to come back.(This takes hours, your best to log in to a Non-RP server)"
					var/count=0

					while(curwound>=maxwound && count<=300)
						sleep(10)
						src.stunned=1000
						count++
						src.icon_state="Dead"

					if(count>300)
						DeathList+=src.client.computer_id
						src<<"You have Died!"
						new/mob/corpse(src.loc,src)
						src.verbs.Cut()
						src.verbs+=/mob/Admin/verb/Spectate

		GateStress()
			if(gate)
				CombatFlag("offense")
				var/stress=0

				switch(gate)
					if(1)
						stress = 65
					if(2)
						stress = 80
					if(3)
						stress = 140
					if(4)
						stress = 175
					if(5)
						stress = 250

				gatestress += stress / str * 100 * wregenlag

				var/wound_stress = 150
				if(clan == "Youth")
					wound_stress = 300

				while(gatestress>wound_stress)
					gatestress-=wound_stress
					Wound(1,3)

				gatetime+=1 * wregenlag

				var/overgated = 0
				if((clan != "Youth" && gatetime>600) || gatetime>1200)
					overgated = 1

				if(overgated)
					Wound(300,3)
					CloseGates()
					src<<"The stress from the gates have taken a significant toll on your body."
					Hostile(src)
				if(curstamina <= 0)
					Wound(300,3)
					CloseGates()
					KO(src)

		comboregen()
			set background = 1
			while(1)
				if(c)
					var/lc=c
					sleep(30)
					if(c==lc)
						c=0
				sleep(10)

		regeneration2()
			set background = 1
			if(!initialized)
				sleep(100)
				spawn() regeneration2()
				return
			if(immortality)
				immortality-=0.1
				if(immortality<0)
					immortality=0
			if(!client)
				sleep(50)
			if(!EN[13])
				sleep(300)
				spawn()regeneration2()
				return
			if(!pk || !client)
				sleep(10)
				stunned-=1
				kstun-=1
				move_stun -= 10
				cc-=10
				attackbreak-=40
			else
				if(kstun)
					kstun-=0.10
				if(stunned)
					stunned-=0.10
				if(cc)
					cc--
				if(attackbreak)
					attackbreak-=2
				if(move_stun)
					--src.move_stun
			if(stunned<0)
				src.stunned=0
			if(kstun<0)
				src.kstun=0
			if(move_stun<0)
				src.move_stun=0
			if(cc<0)
				cc=0
			if(attackbreak<0)
				attackbreak=0
			sleep(1)
			spawn()regeneration2()

		regeneration()
			set background = 1
			if(!initialized)
				sleep(100)
				spawn()regeneration()
				return

			if(client && client.inactivity > 6000 && !(ckey in admins)) //10 minutes
				src << "You were booted for inactivity."
				client.SaveMob()
				del(client)

			if(Tank)
				step(src,dir)

			if(!client)
				sleep(50)

			var/regenlag=wregenlag

			if(!EN[12])
				sleep(300)
				spawn()regeneration()
				return

			sleep(10 *regenlag)
			strbuff-=src.astrbuff
			rfxbuff-=src.arfxbuff
			conbuff-=src.aconbuff
			astrbuff=0
			arfxbuff=0
			aconbuff=0

			if(pill==1)
				if(prob(15))
					src.Wound(1,3)
				strbuff=round(src.str * 0.30)
				conbuff=round(src.con * 0.30)
				spawn(15)
					if(pill < 1)
						strbuff = 0
						conbuff = 0
			else if(pill==2)
				if(prob(45))
					Wound(1,3)
				strbuff=round(src.str * 0.60)
				conbuff=round(src.con * 0.60)
				spawn(15)
					if(pill < 2)
						strbuff = 0
						conbuff = 0
			else if(pill==3)
				if(prob(25))
					Wound(1,3)
				strbuff=round(src.str*0.80)
				conbuff=round(src.con*0.80)
				spawn(15)
					if(pill < 3)
						strbuff = 0
						conbuff = 0

			curchakra = min(chakra*3, curchakra)

			if(scalpol)
				scalpoltime = min(10, scalpoltime + 1*regenlag)
			if(alertcool)
				alertcool = max(0, alertcool - 1*regenlag)
			if(MissionCool)
				MissionCool = max(0, MissionCool - 1*regenlag)

			strbuff = max(0, strbuff)
			rfxbuff = max(0, rfxbuff)
			intbuff = max(0, intbuff)
			conbuff = max(0, conbuff)
			Poison = max(0, min(100, Poison))
			adren = min(100, adren)

			if(adren)
				if(strbuff<round(str*adren/200))
					astrbuff=round(str*(adren/200))-strbuff
					strbuff+=astrbuff
				if(rfxbuff<round(rfx*(adren/200)))
					arfxbuff=round(rfx*(adren/200))-rfxbuff
					rfxbuff+=arfxbuff
				if(conbuff<round(con*(adren/200)))
					aconbuff=round(con*(adren/200))-conbuff
					conbuff+=aconbuff
				if(prob(33))
					adren-=1*regenlag


			if(mind_attack>4)
				var/mob/human/player/X = usr.MainTarget()
				usr.client:eye = usr
				usr.client:Controling= usr
				usr.client:perspective = EYE_PERSPECTIVE
				if(X)
					X.Transfered=0
					X.client:hellno= 0
				usr.stunned=0
				usr.icon_state=""
				usr.mind_attack=0
				usr.controlling_yamanaka=0

			if(src.shukaku||src.nibi||src.sanbi||src.yonbi||src.rokubi||src.gobi||src.hachibi||src.kyuubi||src.shichibi)
				var/D=rand(3,10)
				sleep(D)
				curwound+=rand(0,3)


			if(stunned>300 && !pk)
				stunned=0

			var/area/A
			if(loc)
				A = loc.loc
			if(istype(A,/area/nopkzone))
				pk = 0
				dojo = 1
				risk = 0
			else if(istype(A,/area/pkzone_dojo))
				pk = 1
				dojo = 1
				risk = 0
			else
				pk = 1
				dojo = 0

			if(!pk)
				nopktime++
			else
				nopktime=0


			if(movepenalty)
				if(!pk)
					movepenalty=0
				else if(prob(33))
					movepenalty-=5
					if(movepenalty<0)
						movepenalty=0

			if(clan == "Will of Fire")
				maxwound=130
			else if(clan == "Jashin")
				maxwound=150

			if(client)
				if(!client.eye)
					client.eye=client.mob

				if(ezing && !(/mob/EZ/verb/EZ_Remove_Flag in verbs))
					verbs+=/mob/EZ/verb/EZ_Remove_Flag
					winset(src, "ez_remove_verb", "parent=menu_commands;name=\"&Remove EZ-Flag\";command=EZ-Remove-Flag")

				if(VoteM && votecool2<=0 && !(/mob/vote/verb/Vote_Yes in verbs))
					verbs+=/mob/vote/verb/Vote_No
					verbs+=/mob/vote/verb/Vote_Yes
					verbs+=/mob/vote/verb/Vote_What
					winset(src, "vote_menu", "parent=menu;name=\"&Vote\"")
					winset(src, "vote_verb_yes", "parent=vote_menu;name=\"Vote &Yes\";command=Vote-Yes")
					winset(src, "vote_verb_no", "parent=vote_menu;name=\"Vote &No\";command=Vote-No")
					winset(src, "vote_verb_what", "parent=vote_menu;name=\"Voting for &What\";command=Vote-What")

				if(votecool || votecool2)
					votecool-= 1 * regenlag
					votecool2-= 1 * regenlag
					if(votecool < 0)
						votecool = 0
					if(votecool2 < 0)
						votecool2 = 0

				if(controlmob || tajuu)
					for(var/obj/gui/skillcards/interactcard/x in client.screen)
						x.icon_state="ibunshindispell"
				else
					for(var/obj/gui/skillcards/interactcard/x in client.screen)
						if(x.icon_state=="ibunshindispell")
							x.icon_state="interact0"

				if(MissionTimeLeft > 0)
					MissionTimeLeft--
					if(MissionTimeLeft <= 0)
						MissionFail()
						alert(src,"You ran out of time!")

				if(cexam==5)
					if(!pk)
						cexam=4

						world<<"<span class='chuunin_exam'>[src] ran out of the match!</span>"

						curwound=0
						curstamina=src.stamina
						curchakra=src.chakra
						CArena()

				if(chuuninwatch && !haschuuninwatch)
					verbs+=/mob/Chuunin/verb/Watch_Fight_Chuunin
					winset(src, "chuunin_menu", "parent=menu;name=\"&Chuunin Exam\"")
					winset(src, "chuunin_verb_watch", "parent=chuunin_menu;name=\"&Watch Fight\";command=Watch-Fight-Chuunin")
					haschuuninwatch=1
				else if(haschuuninwatch && !chuuninwatch)
					verbs-=/mob/Chuunin/verb/Watch_Fight_Chuunin
					winset(src, "chuunin_menu", "parent=")
					winset(src, "chuunin_verb_watch", "parent=")
					haschuuninwatch=0

				if(cexam)
					verbs+=/mob/Chuunin/verb/Leave_Exam
					winset(src, "chuunin_menu", "parent=menu;name=\"&Chuunin Exam\"")
					winset(src, "chuunin_verb_leave", "parent=chuunin_menu;name=\"&Leave Exam\";command=Leave-Exam")
				else if(rank == "Genin" && chuuninreg)
					winset(src, "chuunin_menu", "parent=menu;name=\"&Chuunin Exam\"")
					winset(src, "chuunin_verb_join", "parent=chuunin_menu;name=\"&Enter Exam\";command=Join-Chuunin")
					verbs+=/mob/Chuunin/verb/Join_Chuunin

				if(tourney && !has_tourney_verbs)
					verbs+=typesof(/mob/Tourney/verb)
					winset(src, "tourney_menu", "parent=menu;name=\"&Tournament\"")
					winset(src, "tourney_verb_check", "parent=tourney_menu;name=\"&Check Registered Fighters\";command=Check-Registered-Fighters")
					winset(src, "tourney_verb_watch", "parent=tourney_menu;name=\"&Watch Fight\";command=Watch-Fight")
					has_tourney_verbs=1

				else if(!tourney && has_tourney_verbs)
					verbs-=typesof(/mob/Tourney/verb)
					winset(src, "tourney_verb_watch", "parent=")
					winset(src, "tourney_verb_check", "parent=")
					winset(src, "tourney_menu", "parent=")
					has_tourney_verbs=0


				//Feral
				if(client)
					if(team_deathmatch)
						if((team_deathmatch)&&team_deathmatch.checkTeam(src) != null)
							if(!winexists(src,"tdm_leave"))
								winset(src, "tdm_menu", "parent=menu;name=\"&Team Deathmatch\"")
								winset(src, "tdm_leave", "parent=tdm_menu;name=\"&Leave TDM\";command=Leave-TDM")
								verbs+=/mob/team_deathmatch/verb/Leave_TDM
						else if((team_deathmatch)&&team_deathmatch.checkTeam(src) == null&&team_deathmatch.status <> 0)
							if(!winexists(src,"tdm_join"))
								winset(src, "tdm_menu", "parent=menu;name=\"&Team Deathmatch\"")
								winset(src, "tdm_join", "parent=tdm_menu;name=\"&Join TDM\";command=Join-TDM")
								verbs+=/mob/team_deathmatch/verb/Join_TDM
					else if(!team_deathmatch)
						if(winexists(src,"tdm_menu"))
							winset(src,"tdm_menu","parent=")


			if(protected)
				protected-=1*regenlag
				if(protected<=0)
					protected=0

			if(!pk && gate)
				CloseGates()

			if(client || RP)
				if(!pk&&!AFK&&curstamina>=stamina && curchakra>=src.chakra && client.inactivity >= 600)
					AFK=1

				if(pk||(AFK && client.inactivity <600))
					AFK=0

				if(!pk&&!AFK2&&curstamina>=stamina && curchakra>=chakra)
					AFK2=1

				if(pk)
					AFK2=0

				if(usedelay>0)
					usedelay--
					if(usedelay<0)
						usedelay=0


				if(movedrecently)
					movedrecently--
				if(movedrecently<0)
					movedrecently=0

				if(skillspassive[15])
					maxsupplies=100 + 100*0.20*skillspassive[15]
				else
					maxsupplies=100

				var/maxwound1=100
				var/maxwound2=200
				if(clan == "Will of Fire")
					maxwound1=130
					maxwound2=230
				else if(clan == "Jashin")
					maxwound1=150
					maxwound2=250
					if(immortality)
						maxwound1=300
						maxwound2=99999

				if(curwound>(maxwound1*1.5)&&gate)
					CloseGates()

				if(curwound>=maxwound2 && !immortality)
					curstamina=0

				if(curstamina<=0)
					KO()

				if(client.computer_id in DeathList)
					return

				if(ko)
					if(curstamina>0)
						protected=3
						stunned=0
						ko=0
						icon_state=""
				//end ko stuff

				if(layer!=MOB_LAYER && !ko &&!incombo)
					sleep(10)
					if(!incombo)
						layer=MOB_LAYER

				if(hasbonesword)
					if(boneuses<=0)
						hasbonesword=0
						boneuses=0
						for(var/obj/items/weapons/xox in contents)
							if(istype(xox,/obj/items/weapons/melee/sword/Bone_Sword))
								weapon=new/list

								xox.loc = null
						Load_Overlays()

				var/stammultiplier=1
				var/chakramultiplier=1
				if(clan == "Youth")
					stammultiplier=1.5
					chakramultiplier=0.5
				else if(clan == "Capacity")
					stammultiplier=1.25
					chakramultiplier=1.5

				if(gate >= 5)
					rfxbuff=src.rfx*0.5
					strbuff=src.str*0.6
				else if(gate>=3)
					rfxbuff=src.rfx*0.5
					strbuff=src.str*0.5
				else if(gate>=1)
					rfxbuff=src.rfx*0.3
					strbuff=src.str*0.3

				if(gate)
					GateStress()
				else
					if(gatetime)
						gatetime-=regenlag
					if(gatetime<=0)
						gatetime=0

				var/cmul=1
				var/smul=1
				if(skillspassive[3])
					cmul*=0.03*skillspassive[3] + 1
					smul*=0.03*skillspassive[3] + 1

				if(gentle_fist_block)
					gentle_fist_block = min(20, gentle_fist_block)
					cmul *= 1-(gentle_fist_block*0.01)
				if(pill == 1)
					cmul *= 1.5
					smul *= 1.10
				else if(pill == 2)
					cmul *= 2
					smul *= 1.25
				if(boneharden)
					cmul *= 0.65

				if(gate<3)
					stamina=2000+(blevel*25 +(str+strbuff+strneg)*13)*stammultiplier
					chakra=(500 + (con+conbuff+conneg)*5)*chakramultiplier
				else
					stamina=2000+(blevel*25 +(str+strbuff+strneg)*18)*stammultiplier
					chakra=(500 + (con+conbuff+conneg)*7)*chakramultiplier

				chakraregen=round(cmul*(chakra*1.5)/100)
				staminaregen=round(smul*stamina/100)

				if(skillspassive[22])
					chakra*=1 + skillspassive[22]*0.04

				if(usr.cutchakra==1)
					usr.chakra= usr.chakra * 1 / 4

				if(chakrablocked>0)
					chakraregen=0
					chakrablocked-=1*regenlag
					if(chakrablocked<0)
						chakrablocked=0

				var/ei=0
				for(var/obj/items/o in src.contents)
					if(o.weight>0)
						ei+=o.weight
				weight=ei

				if(asleep)
					icon_state="Dead"

				if(byakugan)
					for(var/mob/human/x in orange(10))
						var/image/I = image('icons/base_chakra.dmi',x,x.icon_state,99999,x.dir)
						src << I
						spawn(10*regenlag)
							if(client)
								client.images -= I
				else if(sharingan)
					for(var/mob/human/x in orange(10))
						var/chakra_level = x.curchakra / x.chakra
						var/chakra_state
						if(chakra_level > 0.67)
							chakra_state = "high"
						else if(chakra_level > 0.33)
							chakra_state = "med"
						else
							chakra_state = "low"
						var/image/I = image('icons/sharingan_chakra.dmi',x,chakra_state,MOB_LAYER+0.01,x.dir)
						src << I
						spawn(10*regenlag)
							if(client)
								client.images -= I
						if(istype(x, /mob/human/player/npc/bunshin) || istype(x, /mob/human/player/npc/kage_bunshin))
							var/image/J = image('icons/sharingan_chakra.dmi',x,"bunshin",MOB_LAYER+0.01,x.dir)
							src << J
							spawn(10*regenlag)
								if(client)
									client.images -= J

				waterlogged=0

				for(var/obj/Water/x in loc)
					waterlogged=1
				for(var/turf/water/x in loc)
					waterlogged=1

				if(!waterlogged)
					waterlogged=Iswater(x, y, z)

				if(waterlogged)
					var/obj/haku_ice/ice = locate(/obj/haku_ice) in loc
					if(ice)
						waterlogged = 0
						chakraregen *= 0.75

				if(waterlogged&&!protected)
					if(curchakra<15)
						curstamina=0

				if(!paralysed && !incombo)
					layer=MOB_LAYER
				if(maned)
					if(stunned<2)
						stunned=3

				var/missregen=0

				if(Poison)
					if(prob(50))
						missregen=1

				if(client && client.inputting)
					missregen=1

				if(!missregen)
					var/r = 80
					if(risk == 1)
						r += 20
					else if(risk > 1)
						r += 100

					if(src.blevel<20)
						r=max(100,r)

					if((curwound < maxwound || immortality) && !mane && !maned && !waterlogged && !ezing && !RP)
						if(curchakra < chakra)
							if(chakraregen*regenlag > (chakra-curchakra))
								curchakra= chakra
							else
								curchakra += chakraregen*regenlag
								if(nopktime<100)
									body+=r*regenlag*lp_mult
									bodycheck()

						else if(curstamina<stamina)
							if((staminaregen)*regenlag > (stamina-curstamina))
								curstamina=stamina
							else
								curstamina+=staminaregen*regenlag
								body+=r*regenlag*lp_mult
								bodycheck()

				if(Poison)
					var/poison_multiplier = 1
					if(clan == "Battle Conditioned")
						poison_multiplier = 0.1

					curchakra -= round(Poison / 2 * poison_multiplier) * regenlag
					curstamina -= round(Poison * poison_multiplier) * regenlag

					++Recovery
					if(Recovery >= 2)
						Recovery = 0
						Poison -= 1 * regenlag

				spawn() refresh_rank()
				spawn() regeneration()

mob/human/player/verb
	Check_Ninja_Report_Card()
		var/grade=0
		usr<<"Level Grade: <b>[blevel]</b>/100"
		grade+=min(100,blevel)
		/*usr<<"FactionPoint Grade: [src.factionpoints] /500"
		grade+=min(10,round(src.factionpoints/500 *10)) //10% of grade based on factionpoints
		usr<<"Kill/Death Ratio Grade: [src.kills/(src.deaths+1)] /3.0"
		grade+=min(30,round((src.kills/(src.deaths+1))/3 * 30))*/
		usr<<"Total Grade <b>[grade]</b>% / 100%"
		if(usr.faction && usr.faction.village != "Missing") usr<<"Note that your Faction Rank (Genin, Chuunin etc) will effect what percent is required for each letter grade."
		usr<<"Current Rank: [ninrank]"

mob/proc/refresh_rank()
	var/r="D"
	var/grade=0
	var/pos=RankGrade() //1-5
	grade+=min(100,blevel)//min(60,round(src.blevel/80 *60)) //60% of grade based on level
	//grade-=src.VillageKills/2
//	grade+=min(10,round(src.factionpoints/500 *10)) //10% of grade based on factionpoints

//	grade+=min(30,round((src.kills/(src.deaths+1))/3 * 30)) //30% based on kill2deaths

//	grade+=min(30,round((src.kills/(src.deaths+1))/3 * 30)) //30% based on kill2deaths
	if(pos==1 && grade>30 || pos==2 && grade>20 || pos==3 && grade>17 || pos==4 && grade>15 ||pos==5 && grade>10)
		r="C"
	if(pos==1 && grade>60 || pos==2 && grade>40 || pos==3 && grade>35 || pos==4 && grade>30 ||pos==5 && grade>27)
		r="B"
	if(pos==1 && grade>85 || pos==2 && grade>80 || pos==3 && grade>75 || pos==4 && grade>70 ||pos==5 && grade>65)
		r="A"
	if(pos==1 && grade>98 || pos==2 && grade>95 || pos==3 && grade>93 || pos==4 && grade>89 ||pos==5 && grade>85)
		r="S"
	src.ninrank=r


mob
	MasterdanVerb
		verb
			Set_Level(mob/human/player/M in All_Clients(), level as num)
				level = min(100, level)
				while(M && M.blevel < level)
					M.body=Req2Level(M.blevel)+1
					M.bodycheck()
					sleep(4)
				usr<<"Complete!"

mob
	MasterdanVerb
		verb
			Edit(atom/O in world)

				var/html="<html><div style=align: center; border-width: 10px; border-style: ridge; border-color: #FAEBD7; background-color: #FAEBD7><div style=align: center; padding: 1em; border-width: 10px; border-style: ridge; border-color: #778899; background-color: #FAEBD7; font-family: Garamond, sans-serif;><font color =#2F4F4F>"
				var/variables[0]
				html+="<h3 align=center>[O.name] ([O.type])</h3>"
				html+="<table width=100%>\n"
				html+="<tr>"
				html+="<td><b>VARIABLE NAME</b></td>"
				html+="<td><b>PROBABLE TYPE</b></td>"
				html+="<td><b>CURRENT VALUE</b></td>"
				html+="</tr>\n"
				for(var/X in O.vars) variables += X
				variables-="key"
				variables-="contents"
				variables-="overlays"
				variables-="underlays"
				variables-="verbs"
				variables-="vars"
				variables-="group"
				variables-="Admin"
				variables-="Moderator"
				for(var/X in variables)
					html+="<tr>"
					html+="<td><a href=byond://?src=\ref[O];action=edit;var=[X]>"
					html+=X
					html+="</a>"
					if(!issaved(O.vars[X]) || istype(X,/list))
						html+=" <font size=1><font color=red>(*)</font></td>"
					else html+="</td>"
					html+="<td>[DetermineVarType(O.vars[X])]</td>"
					html+="<td>[DetermineVarValue(O.vars[X])]</td>"
					html+="</tr>"
				html+="</table>"
				html+="<br><br><font size=1><font color=red>(*)</font> A warning is given when a variable \
					may potentially cause an error if modified.  If you ignore that warning and \
					continue to modify the variable, you alone are responsible for whatever \
					mayhem results!</body></html>"
				usr<<browse(html,"window=Edit;size=400x400")

/*b
	proc
		Auto_Set_Level(mob/human/player/M,level as num)
			level = min(100, level)
			while(M && M.blevel < level)
				M.body=Req2Level(M.blevel)+1
				M.bodycheck()
				sleep(2)
			M.money=1000000
			M.levelpoints=600
			M.Refresh_Levelpoints()
			M.Refresh_Skillpoints()*/

var/lp_mult=1
mob/human
	proc
		bodycheck()
			if(src.body>Req2Level(src.blevel) && blevel < 100)
				src.body=0
				src.blevel++

				if(src.blevel==20)
					src<<"<b><font color=red>Now that you are past level 20, you will gain lower level points by training in the dojo. To level up the fastest you need to fight enemy ninja!</font></b>"

				if(src.blevel==100)
					src<<"<b><font color=red>You have reached the level cap!</font></b>"

				var/all_helpers = list()
				for(var/village in helpers)
					all_helpers += helpers[village]


				src.levelpoints+=6

				src.Refresh_Levelpoints()
				src.Refresh_Skillpoints()

mob
	proc
		Auto_Set_Level(mob/human/player/M,level as num)
			src<<"\red Leveling... there will be a small delay while you are being leveled."
			level = min(100, level)
			while(M && M.blevel < level)
				M.body=Req2Level(M.blevel)+1
				M.bodycheck()
				sleep(2)
			M.money=0
			M.levelpoints=300
			M.Refresh_Levelpoints()
			M.Refresh_Skillpoints()

		Auto_Set_Level2(mob/human/player/M,level as num)
			src<<"\red Leveling... there will be a small delay while you are being leveled."
			level = min(100, level)
			while(M && M.blevel < level)
				M.body=Req2Level(M.blevel)+1
				M.bodycheck()
				sleep(2)
			M.money=0
			M.levelpoints=600
			M.Refresh_Levelpoints()
			M.Refresh_Skillpoints()

proc
	Req2Level(L)
		if(L<=15)
			return ((L*L*100)+1000)
		else if(L>15 && L<=30)
			return(25000+ L*500)
		else if(L>30 && L<=55)
			return (40000+(L-30)*L*50)  //35:53750 45:78750 55:113750 56:123500
		else if(L>55)
			return (((L-20)*(L-20)*100))