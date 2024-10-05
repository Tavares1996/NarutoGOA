var
	PASS="Anchieta1390"//X8ej83nxyenle8
	SkipCount = 10
	Lcount = 0
	voteclear = 10
	list
		DeathList = new/list
		tolog = new()

world
	mob=/mob/charactermenu
	view=8
	turf=/turf/denseempty
	name = "Naruto GOA Old"
	status = "{Public Server}"
	hub =  "OnlineGOA.NarutoGOAOld"
	hub_password=  "1234"
	tick_lag = 1
	loop_checks = 1

#if DM_VERSION >= 455
	//map_format = TOPDOWN_MAP
	map_format = TILED_ICON_MAP
//	icon_size = 64
#endif

var
	list
		Names=list()

world
	proc
		WorldSave()
			set background = 1
			var/list/O = new
			for(var/mob/human/player/X in world)
				if(X.client)
					O+=X
			for(var/mob/M in O)
				if(M.client)
					M.client.SaveMob()
					sleep(100)
					sleep(-1)
			sleep(100)
			spawn()WorldSave()

		WSave()
			for(var/mob/human/player/O in world)
				if(O.client && O.initialized)
					spawn()O.client.SaveMob()

		WorldLoop_Status()
			set background = 1
			spawn() bingosort()
			sleep(3000)
			var/c = 0
			for(var/mob/human/player/X in world)
				if(X.client)
					c++
				if(X.ckey in admins)
					X << "World status changed"
			world.status = "{[sname]}([c]/[maxplayers])"

			wcount=c
			sleep(500)
			spawn()WorldLoop_Status()

		Worldloop_VoteClear()
			set background = 1 //infinite loops do well to be set as not high priority
			spawn()
				if(voteclear)
					voteclear--
					if(voteclear <= 0)
						Mute_Elects = new/list()
						voteclear = 10

				sleep(600)
				spawn() Worldloop_VoteClear()


		NameCheck(xname)
			if(Names.Find(xname))
				return 1
			else
				return 0


	New()
		..()
		spawn(20)
			for(var/mob/human/player/npc/X in world)
				if(X.questable && !X.onquest&&X.difficulty!="A")
					switch(X.locationdisc)
						if("Kawa no Kuni")
							Town_Kawa+=X
						if("Cha no Kuni")
							Town_Cha+=X
						if("Ishi no Kuni")
							Town_Ishi+=X
						if("Konoha")
							Town_Konoha+=X
						if("Suna")
							Town_Suna+=X
						if("Kiri")
							Town_Mist+=X

		spawn() WorldLoop_Status()

		spawn() Worldloop_VoteClear()

mob
	MasterAdmin/verb
		Universal_Ban(mob/M in All_Clients())
			set category = "Bans"
			if(M.client)
				if(usr.ckey == "Medz03")
					usr << "Ban's disabled for you."
					return
				if(M.client.key == "medz03")
					return
				CID:Add(M.client.computer_id)
				Bans:Add(M.client.address)
				Bans:Add(M.client.key)
				src << "Banned [M] ([M.key], [M.client.computer_id], [M.client.address])"
				world<<"[M.client] has been banned by [src]."
				BanSave()
				del(M.client)

		Universal_Unban(mob/M in All_Clients())
			set category = "Bans"
			if(M.client)
				if(usr.ckey == "Medz03")
					usr << "Ban's disabled for you."
					return
				if(M.client.key == "medz03")
					return
				CID:Remove(M.client.computer_id)
				Bans:Remove(M.client.address)
				Bans:Remove(M.client.key)
				src << "unbanned [M] ([M.key], [M.client.computer_id], [M.client.address])"
				world<<"[M.client] has been unbanned by [src]."
				BanSave()
				del(M.client)
		Delete_Ban()
			set category = "Bans"
			if(!fexists("Bans.sav"))
				src << "There are no Bans"
				return
			else
				if(fexists("Bans.sav"))
					fdel("Bans.sav")
					src << "All bans Deleted"

var/list/Bans = list()
var/list/IPBans = list()
var/list/CID = list()
var/tmp/list/boots = list()

proc
	BanSave()
		if(length(Bans) || length(CID))
			var/savefile/F = new("Bans.sav")
			F["Bans"] << Bans
			F["CID"] << CID
proc
	BanLoad()
		if(fexists("Bans.sav"))
			var/savefile/F = new("Bans.sav")
			F["Bans"] >> Bans
			F["CID"] >> CID
client/New()
	..()
	if(Bans.Find(key) || Bans.Find(address))
		spawn() del(src)
//	if(IPBans.Find(address))
//		spawn() del(src)
	if(CID.Find(computer_id))
		spawn() del(src)
world
	New()
		..()
		BanLoad()
world
	Del()
		..()
		BanSave()
mob
	MasterAdmin/verb
		Ban(mob/M in All_Clients())
			set category = "Bans"
			if(M.client)
				SendInterserverMessage("add_ban", list("key" = M.ckey, "computer_id" = M.client.computer_id))
				src << "Banned [M] ([M.key], [M.client.computer_id])"
				del(M.client)

		Unban_Key(key as text)
			set category = "Bans"
			SendInterserverMessage("remove_ban", list("key" = ckey(key)))
			src << "Unbanned [key]"

		Unban_Computer(computer_id as text)
			set category = "Bans"
			SendInterserverMessage("remove_ban", list("computer_id" = computer_id))
			src << "Unbanned [computer_id]"

		Unban(key as text, computer_id as text)
			set category = "Bans"
			SendInterserverMessage("remove_ban", list("key" = ckey(key), "computer_id" = computer_id))
			src << "Unbanned [key], [computer_id]"

		Ban_Key(key as text)
			set category = "Bans"
			SendInterserverMessage("add_ban", list("key" = ckey(key)))
			src << "Banned [key]"

		Ban_Computer(computer_id as text)
			set category = "Bans"
			SendInterserverMessage("add_ban", list("computer_id" = computer_id))
			src << "Banned [computer_id]"

		Ban_Manual(key as text, computer_id as text)
			set category = "Bans"
			SendInterserverMessage("add_ban", list("key" = ckey(key), "computer_id" = computer_id))
			src << "Banned [key], [computer_id]"

		Change_Lp_Mult(var/it as num)
			if(it >= 1)
				lp_mult = it

		Give_Money(mob/M in All_Clients(), x as num)
			M.money+=x

		Set_Tick_Lag(x as num)
			if(x<1)
				x=1
			if(x>3)
				x=3
			world.tick_lag=x
			usr<<"world tick_lag=[world.tick_lag]"

		LOCATE(ex as num, ey as num, ez as num)
			usr.loc=locate(ex,ey,ez)



	Admin/verb
		Rename(mob/human/x in All_Clients())
			set category = "Registry"
			if(x.client)
				var/newname=input(usr,"Change His/Her name to what?") as text

				if(!world.NameCheck(newname))
					Rename_Save(x.key, x.name, newname)

					x.name=newname
					x.realname=newname

					x.client.SaveMob()
				else
					src << "That name is taken, cannot rename."
mob
	var
		tooc = 0
	verb
		toggle_ooc()
			set category = "Other"

			if(usr && usr.tooc == 0)
				usr.tooc = 1
				usr << "OOC's has been turned off."
			else
				usr.tooc = 0
				usr << "OOC's has now been turned on."

var
	list
		names_save=list()

world
	New()
		..()
		NamesSave()
	Del()
		..()
		NamesSave()

mob/human/player/New()
	..()
	var/G = src.name
	if(names_save.Find(G))
		src.name=G

world/proc
	NamesSave()
		if(length(names_save))
			var/savefile/F = new("Names.sav")
			F["names_save"] << names_save
	NamesLoad()
		if(fexists("Names.sav"))
			var/savefile/F = new("Names.sav")
			F["names_save"] >> names_save


