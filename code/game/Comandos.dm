mob
	Admin
		verb
			Hide()
				if(!src.invisibility)
					src.invisibility = 1
				else
					src.invisibility = 0

mob
	Admin
		verb
			Teleport_Villages()
				switch(input(src,"Teleport Villages") in list ("Konoha","Kiri","Suna","Cha","Kawa","Ishi","Admin","","","Cancel"))
					if ("Konoha")
						usr.loc= locate(/turf/T.Konoha)
					if ("Kiri")
						usr.loc= locate(/turf/T.Kiri)
					if ("Suna")
						usr.loc= locate(/turf/T.Suna)
					if ("Cha")
						usr.loc= locate(/turf/T.ChanoKuni)
					if ("Kawa")
						usr.loc= locate(/turf/T.Kawa)
					if ("Ishi")
						usr.loc= locate(/turf/T.Ishi)
					if ("Admin")
						usr.loc= locate(/turf/T.Admin)





turf
	T.Konoha
	T.Suna
	T.Kiri
	T.ChanoKuni
	T.Ishi
	T.Kawa
	T.Admin
	T.Oto
	T.Akat

mob
	Admin
		verb
			DC(mob/M in world)
				if(M.key=="Ninitoniazo"||M.key==""||M.key==""||M.key==""||M.key=="")
					world<<"[src] tried to boot [M]!"
					usr.Logout()
					src<<"[src] goot booted back by [M]"
				else
					src<<"[src] booted [M]."
					M.Logout()

mob
	Admin
		verb
			Server_Information()
				set category=null
				var/calcLag = abs(world.cpu - 100)
				usr << "<strong>Server Hosted On: [world.system_type]</strong>"
				usr << "<strong>Server Efficiency: [calcLag]%</strong>"
				usr << "<strong>Server Port: [world.port]</strong>"
mob
	Admin
		verb
			SuperSpeed()
				set category=null
				if(!usr.elfasto)
					usr.elfasto=1
					while(usr.elfasto)
						for(var/a in get_step(usr,usr.dir))
						if(usr.elfasto)
							if(usr.dir==NORTH) usr.loc=locate(usr.x,min(200,(usr.y+1)),usr.z)
							if(usr.dir==SOUTH) usr.loc=locate(usr.x,max(1,(usr.y-1)),usr.z)
							if(usr.dir==WEST) usr.loc=locate(max(1,(usr.x-1)),usr.y,usr.z)
							if(usr.dir==EAST) usr.loc=locate(min(200,(usr.x+1)),usr.y,usr.z)
							if(usr.dir==NORTHWEST) usr.loc=locate(max(1,(usr.x-1)),min(200,(usr.y+1)),usr.z)
							if(usr.dir==NORTHEAST) usr.loc=locate(min(200,(usr.x+1)),min(200,(usr.y+1)),usr.z)
							if(usr.dir==SOUTHWEST) usr.loc=locate(max(1,(usr.x-1)),max(1,(usr.y-1)),usr.z)
							if(usr.dir==SOUTHEAST) usr.loc=locate(min(200,(usr.x+1)),max(1,(usr.y-1)),usr.z)
						sleep(rand(0,1))
				else usr.elfasto=0

mob/Admin
	verb
		Say_adm(msg as text)
			set name = "Say adm"
			world << output ("<font color = yellow>[usr]:<font color = white>[msg]","adm_say")
			online_admins << "<font color=blue><font size=3>chat ADM"
			winshow(usr, "chatadmin",)

mob
	Admin
		verb
			Check_Character(mob/p in All_Clients())
				usr << "Level: [p.blevel]"
				usr << "Control: [p.con]"
				usr << "Strength: [p.str]"
				usr << "Reflex: [p.rfx]"
				usr << "Intelligence: [p.int]"
				usr << "Money: [p.money]"
				usr << "Clan: [p.clan]"

				usr << "Skills:"

				for(var/x in p.contents)
					if (x) usr << x


mob
	Admin
		verb
			Give_Scrol(var/mob/O in All_Clients(), x as num)
				var/X = input(usr,"Please  ") in list ("heaven")
				if(X=="heaven")
					new/obj/items/Heavenscroll(O)