var/list/newbies = list()
var/list/helpers = list()

mob/human/Topic(href,href_list[])
	switch(href_list["action"])
		if("mute")
			mute=2
			world<<"[realname] is muted"
			var/c_id = client.computer_id
			mutelist+=c_id
			var/mob/M = src
			src = null
			spawn(18000)
				mutelist-=c_id
				if(M && M.mute)
					M.mute=0
					world<<"[M.realname] is unmuted"
		else
			. = ..()




var/O_Mute = 0
mob/human/player
	newbie
		verb
			NOOC(var/t as text)
				if(O_Mute)
					if(usr.key=="LILMESSI18")
						usr<<"<font size=1>You may continue"
					else
						alert("OOC's muted at the moment.")
						return
				winset(usr, "map", "focus=true")

				var/sayicon
				if(!istype(usr, /mob/human/npc))
					sayicon = "<span class='villageicon'>\icon[faction_chat[usr.faction.chat_icon]]</span> "
					if(usr.henged||usr.phenged)
						if(usr.transform_chat_icon)
							sayicon = "<span class='villageicon'>\icon[faction_chat[usr.transform_chat_icon]]</span> "
						else sayicon = null

				t = Replace_All(t,chat_filter)
				if(usr.mute||usr.tempmute)
					usr<<"You're muted"
				else
					if(usr.name!="" && usr.name!="player" && usr.initialized)
						usr.talkcool=20
						usr.talktimes+=1
						if(usr.talktimes>=8)
							usr<<"You have been temporarily muted for talking too quickly."
							usr.tempmute=1
							sleep(100)
							usr<<"temp mute lifted"
							usr.tempmute=0
							usr.talktimes=0
						if(usr.talkcooling==0)
							spawn()usr.talkcool()
						if(length(t) <= 500&&usr.say==1)
							usr.say=0
							var/rrank=usr.rank
							if((usr.faction in list(leaf_faction,mist_faction,sand_faction)) && usr.realname == usr.faction.leader)
								rrank="Kage"
							if((faction in list(blitz_faction)) && realname == faction.leader)
								rrank="Zelko Blitzkreig Leader"
							if((faction in list(crimzon_faction)) && realname == faction.leader)
								rrank="Crimzon Leader"
							if((faction in list(sound_faction)) && realname == faction.leader)
								rrank="Sound Leader"
							if((faction in list(rain_faction)) && realname == faction.leader)
								rrank="Rain Leader"
							if((faction in list(star_faction)) && realname == faction.leader)
								rrank="Star Leader"
							else
								var/all_helpers = list()
								for(var/village in helpers)
									all_helpers += helpers[village]
								if(usr.name in all_helpers)
									rrank = "Helper"
							for(var/mob/M in All_Clients())
								if(M.tooc == 0)
									if(M.ckey in admins)
										M<<"[sayicon]<span class='help'><span class='villageicon'>\icon[usr.faction.chat_icon]</span>(<a href='?src=\ref[usr];action=mute' class='admin_link'><span class='name'>[usr.realname]</span></a>){<span class='rank'>[rrank]</span>} <span class='message'>[html_encode(t)]</span></span>"
									else
										M<<"[sayicon]<span class='help'><span class='villageicon'>\icon[usr.faction.chat_icon]</span>(<span class='name'>[usr.realname]</span>){<span class='rank'>[rrank]</span>} <span class='message'>[html_encode(t)]</span></span>"
								ChatLog("newbie") << "[time2text(world.timeofday, "hh:mm:ss")]\t[usr.realname]\t[html_encode(t)]"
								spawn() SendInterserverMessage("chat_mirror", list("mode" = "newbie_help", "ref" = "\ref[usr]", "name" = usr.realname, "rank" = rrank, "faction" = "[usr.faction]", "msg" = html_encode(t)))
								sleep(2)
								usr.say=1
						else
							world<<"[html_encode(usr.realname)]/[usr.key] is temporarily muted for spamming"
							usr.tempmute=1
							sleep(200)
							usr.tempmute=0
