client/proc/Help()
	src.eye=locate(67,40,2)
	src.mob.hidestat=1

var/newsave=0

mob/var
	cVillage
	cClan
	list/Vimages=new
	list/Cimages=new
	list/Simages=new
	image/St
	list/Iimages=new
	dd=0
	sel=0
	FIN=0
	name_selecting = 0


obj
	FinishCharCreate
		Click()
			if(!usr.initialized && usr.sel && istext(usr.sel) && !usr.FIN)
				usr.FIN=1
				switch(alert(usr,"You sure your done this stage of character creation?","Finished?","Yes","No"))
					if("Yes")
						if(!usr.client || !(usr.sel && istext(usr.sel))) return
						if(usr.cVillage=="Leaf")
							usr.faction=leaf_faction
							usr<<"You were created in Konoha"
						else if(usr.cVillage=="Sand")
							usr.faction=sand_faction
							usr<<"You were created in Suna"
						else if(usr.cVillage=="Kiri")
							usr.faction=mist_faction
							usr<<"You were created in Hidden Mist"
						else
							usr.FIN=0
							usr<<"You must choose a village."
							return

						name:
						var/surname
						var/firstname
						switch(usr.sel)
							if("Kaguya")
								surname="Kaguya"
							if("Uchiha")
								surname="Uchiha"
							if("Nara")
								surname="Nara"
							if("Hyuuga")
								surname="Hyuuga"
							if("Akimichi")
								surname="Akimichi"
							if("Aburame")
								surname="Aburame"
						usr.name_selecting = 1
						var/name = input(usr, "Enter your name. Please do not name yourself after Naruto characters.") as text
						name = Replace_All(name, chat_filter)
						if(!usr.client) return
						var/space_pos = findtext(name, " ")
						if(space_pos && !surname)
							surname = copytext(name, 1, space_pos)
							firstname = copytext(name, space_pos+1)
						else
							firstname = name

						if(surname)
							surname = Replace(surname, " ", "")
							surname = world.Name_Correct(surname)
						else
							surname = ""

						firstname = Replace(firstname, " ", "")
						firstname = world.Name_Correct(firstname)
						usr.surname=surname
						usr.firstname=firstname
						if(length(surname))
							usr.name="[usr.surname] [usr.firstname]"
						else
							usr.name="[usr.firstname]"
						if(!usr.client) return

						if(world.NameCheck(usr.name)&&usr.client)
							if(!usr || !usr.client) return
							alert(usr,"That name is taken, please enter a different one.")
							del(usr)
							online_admins << "[usr.ckey] tryed to namebug"
							if(!usr || !usr.client) return
							usr.name="Nameless"
							usr.surname=0


							goto name
						if((world.Name_No_Good(usr.name))&&usr.client)
							if(!usr || !usr.client) return
							usr << "Please relog, and try a different name"
							online_admins << "[usr] tryed to namebug"
							if(!usr || !usr.client) return
							usr.name="Nameless"
							usr.surname=0

						if(usr.firstname == "Player")
							usr<<"Please reconnect and use a different name"
							del usr
							goto name

						if(!usr.name)
							usr.surname=0
							goto name


						Names.Add(usr.name)
						usr.realname=usr.name

						usr.clan = usr.sel

						usr:AddSkill(KAWARIMI )
						usr:AddSkill(WINDMILL_SHURIKEN)
						usr:AddSkill(SHUNSHIN)
						usr:AddSkill(BUNSHIN)
						usr:AddSkill(HENGE)
						usr:AddSkill(EXPLODING_KUNAI)
						usr:AddSkill(EXPLODING_NOTE)

						switch(usr.clan)
							if("Sand Control")
								usr:AddSkill(SAND_SUMMON)
								usr:AddSkill(SAND_UNSUMMON)
						/*	if("Aburame")
								usr:AddSkill(BUG_SUMMONING)*/

						usr:RefreshSkillList()

						usr.DoneCreate()


						if(usr.initialized)

							if(!usr.levelpoints) usr.levelpoints=6

							usr.client.SaveMob()
							newsave = 1

							var/faction/faction = usr.faction
							faction.AddMember(usr)

							usr.Refresh_Faction_Verbs()
							usr.Refresh_Squad_Verbs()
							usr.name_selecting = 0
							spawn(10)usr.Refresh_Mouse()

						else
							usr.FIN = 0
					else
						usr.FIN = 0
			else
				usr<<"You need to pick both a village and a Clan/Trait First!"
mob/proc
	Refresh_Mouse()
		if(faction && faction.mouse_icon)
			src.mouse_over_pointer=faction_mouse[faction.mouse_icon]
		else
			src.mouse_over_pointer=null

obj/Creation2
	var
		image/tog
		im

	Konoha_C
		im='CreationScreen/leafS.png'
		icon='CreationScreen/leaf.png'
		Click()
			if(usr.name_selecting) return
			usr.cVillage="Leaf"
			usr.mouse_over_pointer = 'konohamouse.dmi'
			usr.client.images-=usr.Vimages
			usr.sel=0
			usr.Vimages=new/list()
			for(var/obj/Creation2/Konoha_C/X in oview(10,usr))
				if(X.tog)
					usr.Vimages+=X.tog
			for(var/image/X in usr.Vimages)
				usr<<X
			usr.LoadSelect()

	Suna_C
		im='CreationScreen/sandS.png'
		icon='CreationScreen/sand.png'
		Click()
			if(usr.name_selecting) return
			usr.cVillage="Sand"
			usr.mouse_over_pointer = 'sunamouse.dmi'
			usr.client.images-=usr.Vimages
			usr.sel=0
			usr.Vimages=new/list()
			for(var/obj/Creation2/Suna_C/X in oview(10,usr))
				if(X.tog)
					usr.Vimages+=X.tog
			for(var/image/X in usr.Vimages)
				usr<<X
			usr.LoadSelect()

	Mist_C
		im='CreationScreen/mistS.png'
		icon='CreationScreen/mist.png'
		Click()
			if(usr.name_selecting) return
			usr.cVillage="Kiri"
			usr.mouse_over_pointer = 'mistmouse.dmi'
			usr.client.images-=usr.Vimages
			usr.sel=0
			usr.Vimages=new/list()
			for(var/obj/Creation2/Mist_C/X in oview(10,usr))
				if(X.tog)
					usr.Vimages+=X.tog
			for(var/image/X in usr.Vimages)
				usr<<X
			usr.LoadSelect()

	Nonclan_C
		im='CreationScreen/non-clanS.png'
		icon='CreationScreen/non-clan.png'
		Click()
			if(usr.name_selecting) return
			if(!usr.cVillage)
				alert(usr,"You need to pick a Village First!")
				return
			usr.cClan=0
			usr.sel=0
			usr.client.images-=usr.Cimages
			usr.Cimages=new/list()
			for(var/obj/Creation2/Nonclan_C/X in oview(10,usr))
				if(X.tog)
					usr.Cimages+=X.tog
			for(var/image/X in usr.Cimages)
				usr<<X
			usr.LoadSelect()

	Clan_C
		im='CreationScreen/clanS.png'
		icon='CreationScreen/clan.png'
		Click()
			if(usr.name_selecting) return
			if(!usr.cVillage)
				alert(usr,"You need to pick a Village First!")
				return
			usr.cClan=1
			usr.sel=0
			usr.client.images-=usr.Cimages
			usr.Cimages=new/list()
			for(var/obj/Creation2/Clan_C/X in oview(10,usr))
				if(X.tog)
					usr.Cimages+=X.tog
			for(var/image/X in usr.Cimages)
				usr<<X
			usr.LoadSelect()

	Info_C
		var
			list/cardz=list('CreationScreen/info/info-byakugan.png','CreationScreen/info/info-capacity.png','CreationScreen/info/info-fire.png','CreationScreen/info/info-genius.png','CreationScreen/info/info-haku.png','CreationScreen/info/info-kaguya.png','CreationScreen/info/info-nara.png','CreationScreen/info/info-puppet.png','CreationScreen/info/info-ruthless.png','CreationScreen/info/info-sand.png','CreationScreen/info/info-spring.png','CreationScreen/info/info-uchiha.png','CreationScreen/info/info-battle.png','CreationScreen/info/info-akimichi.png','CreationScreen/info/info-clay.png','CreationScreen/info/info-jashin.png')
			cardi[16]
		icon='CreationScreen/info.png'
		New()
			..()
			var/i=1
			while(i<=16)
				src.cardi[i]=image(src.cardz[i],icon_state=src.icon_state,loc=src)
				i++
		Click()
			if(!usr.cVillage)
				alert(usr,"You need to pick a Village First!")
				return
			usr.client.images-=usr.Cimages
			usr.Cimages=new/list()
			for(var/obj/Creation2/Clan_C/X in oview(10,usr))
				if(X.tog)
					usr.Cimages+=X.tog
			for(var/image/X in usr.Cimages)
				usr<<X
			usr.LoadSelect()

	New()
		..()
		if(im)
			tog=image(im,icon_state=src.icon_state,loc=src)
obj
	Blank_Slot
		icon='CreationScreen/blank.png'
		var
			Slotnum=0
			list/im
			list/aim
			list/img=list(null,null,null,null,null,null,null)
			aimg[6]
			ind[6]

		Click()
			if(usr.dd)
				usr.client.images-=usr.St
				usr.St=new/list()
				for(var/obj/Blank_Slot/X in view(3,src))
					if(istype(X,src.type))
						if(X.aim[usr.dd])
							usr.St+=X.aimg[usr.dd]
							for(var/image/O in usr.St)
								usr<<O
				usr.sel=src.ind[usr.dd]
				usr.Showinfo()

		Slot1
			pixel_x=12
			im=list(null,null,null,null,null,null)
			aim=list(null,null,null,null,null,null)
			ind=list(null,null,null,null,null,null)
		Slot2
			pixel_x=-8
			im=list('CreationScreen/clan/clan-uchiha.png','CreationScreen/clan/clan-clay.png','CreationScreen/clan/clan-jashin.png','CreationScreen/traits/trait-fire.png','CreationScreen/traits/trait-battle.png','CreationScreen/traits/trait-ruthless.png')
			aim=list('CreationScreen/clan/clan-uchihaS.png','CreationScreen/clan/clan-clayS.png','CreationScreen/clan/clan-jashinS.png','CreationScreen/traits/trait-fireS.png','CreationScreen/traits/trait-battleS.png','CreationScreen/traits/trait-ruthlessS.png')
			ind=list("Uchiha","Deidara","Jashin","Will of Fire","Battle Conditioned","Ruthless")
		Slot3
			pixel_x=5
			im=list('CreationScreen/clan/clan-nara.png','CreationScreen/clan/clan-puppet.png','CreationScreen/clan/clan-kaguya.png','CreationScreen/traits/trait-youth.png','CreationScreen/traits/trait-youth.png','CreationScreen/traits/trait-youth.png')
			aim=list('CreationScreen/clan/clan-naraS.png','CreationScreen/clan/clan-puppetS.png','CreationScreen/clan/clan-kaguyaS.png','CreationScreen/traits/trait-youthS.png','CreationScreen/traits/trait-youthS.png','CreationScreen/traits/trait-youthS.png')
			ind=list("Nara","Puppeteer","Kaguya","Youth","Youth","Youth")
		Slot4
			pixel_x=-15
			im=list('CreationScreen/clan/clan-hyuuga.png','CreationScreen/clan/cland-sand.png','CreationScreen/clan/clan-haku.png','CreationScreen/traits/trait-capacity.png','CreationScreen/traits/trait-capacity.png','CreationScreen/traits/trait-capacity.png')
			aim=list('CreationScreen/clan/clan-hyuugaS.png','CreationScreen/clan/cland-sandS.png','CreationScreen/clan/clan-hakuS.png','CreationScreen/traits/trait-capacityS.png','CreationScreen/traits/trait-capacityS.png','CreationScreen/traits/trait-capacityS.png')
			ind=list("Hyuuga","Sand Control","Haku","Capacity","Capacity","Capacity")
		Slot5
			pixel_x=1
			im=list('CreationScreen/clan/clan-akimichi.png','CreationScreen/traits/trait-genius.png',null,null,null,null)
			aim=list('CreationScreen/clan/clan-akimichiS.png','CreationScreen/traits/trait-geniusS.png',null,null,null,null)
			ind=list("Akimichi","Genius",null,null,null,"")
		Slot6
			pixel_x=-16
			im=list(null,null,null,null,null,null)
			aim=list(null,null,null,null,null,null)
			ind=list(null,null,null,null,null,"")
		New()
			..()

			if(im[1])
				var/t=image(im[1],icon_state=src.icon_state,loc=src)
				img[1]=t
			if(im[2])
				var/t=image(im[2],icon_state=src.icon_state,loc=src)
				img[2]=t
			if(im[3])
				var/t=image(im[3],icon_state=src.icon_state,loc=src)
				img[3]=t
			if(im[4])
				var/t=image(im[4],icon_state=src.icon_state,loc=src)
				img[4]=t
			if(im[6])
				var/t=image(im[6],icon_state=src.icon_state,loc=src)
				img[6]=t
			if(im[5])
				var/t=image(im[5],icon_state=src.icon_state,loc=src)
				img[5]=t
			if(aim[1])
				var/t=image(aim[1],icon_state=src.icon_state,loc=src)
				aimg[1]=t
			if(aim[2])
				var/t=image(aim[2],icon_state=src.icon_state,loc=src)
				aimg[2]=t
			if(aim[3])
				var/t=image(aim[3],icon_state=src.icon_state,loc=src)
				aimg[3]=t
			if(aim[4])
				var/t=image(aim[4],icon_state=src.icon_state,loc=src)
				aimg[4]=t
			if(aim[6])
				var/t=image(aim[6],icon_state=src.icon_state,loc=src)
				aimg[6]=t
			if(aim[5])
				var/t=image(aim[5],icon_state=src.icon_state,loc=src)
				aimg[5]=t

mob
	proc
		Showinfo()
			if(!src.client)
				return
			var/e
			switch(src.sel)
				if("Hyuuga")
					e=1
				if("Capacity")
					e=2
				if("Will of Fire")
					e=3
				if("Genius")
					e=4
				if("Haku")
					e=5
				if("Kaguya")
					e=6
				if("Nara")
					e=7
				if("Puppeteer")
					e=8
				if("Ruthless")
					e=9
				if("Sand Control")
					e=10
				if("Youth")
					e=11
				if("Uchiha")
					e=12
				if("Battle Conditioned")
					e=13
				if("Akimichi")
					e=14//akimichi
				if("Deidara")
					e=15//clay
				if("Jashin")
					e=16//jashin
				if("Genius")
					e=17
			src.client.images-=src.Iimages
			src.Iimages=new/list()
			for(var/obj/Creation2/Info_C/X in oview(10,src))
				src.Iimages+=X.cardi[e]
			for(var/image/X in src.Iimages)
				src<<X
		LoadSelect()
			if(src.client)
				var/d=1
				if(src.cVillage && (src.cClan==0||src.cClan==1))
					if(src.cVillage=="Leaf"&&src.cClan==1)
						d=1
					if(src.cVillage=="Sand"&&src.cClan==1)
						d=2
					if(src.cVillage=="Kiri"&&src.cClan==1)
						d=3
					if(src.cVillage=="Leaf"&&src.cClan==0)
						d=4
					if(src.cVillage=="Sand"&&src.cClan==0)
						d=5
					if(src.cVillage=="Kiri"&&src.cClan==0)
						d=6
					src.dd=d
					src.client.images-=src.Simages
					src.Simages=new/list()
					src.client.images-=src.St
					src.St=new/list()
					for(var/obj/Blank_Slot/X in oview(10,src))
						var/list/O=X.img
						if(X.img&&O.len>=d&&length(O)>=d)
							if(X.img[d])
								src.Simages+=X.img[d]
					for(var/image/X in src.Simages)
						src<<X


					//list/Simages
					//list/St
