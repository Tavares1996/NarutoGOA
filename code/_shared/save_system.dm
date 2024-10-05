client
	proc
		SaveMob()
			spawn()world.SaveMob(src.mob,src)

mob/var/save1 = 0
mob/var/save2 = 0
mob/var/save3 = 0

world
	proc
		SaveMob(mob/x,client/vrc, xkey=x.ckey)

			if(RP)
				return
			if(!x)
				return
			if(!x.initialized)
				return
			if(!istype(x,/mob/human/player))
				return
			var/oldname=x.name
			if(x.realname)
				x.name=x.realname
			var/list/S=new/list()
			var/list/inv=new/list()

			//var/save1 = 0
			//var/save2 = 0
			//var/save3 = 0
			var/list/bar=new/list()
			var/list/strg=new/list()
			var/list/nums=new/list()
			var/list/lst=new/list()

			if(x)
				var/kay=x.ckey
				if(!kay)
					kay=vrc.ckey
				if(!kay)
					return

				var/newbounty = round(x.bounty * 0.9)
				var/savex=x.x
				var/savey=x.y

				var/savez=x.z

				if(x.cexam)
					var/obj/Respawn_Pt/Re=null
					for(var/obj/Respawn_Pt/R in world)
						if(x.faction.village=="Missing"&&R.ind==0)
							Re=R
						if(x.faction.village=="Konoha"&&R.ind==1)
							Re=R
						if(x.faction.village=="Suna"&&R.ind==2)
							Re=R
						if(x.faction.village=="Kiri"&&R.ind==3)
							Re=R
					if(Re)
						savex = Re.x
						savey = Re.y
						savez = Re.z
					else
						savex=31
						savey=74
						savez=1
				var/skillcounts=0
				for(var/X in x.skills)
					if(isnum(X))
						skillcounts+=X

				var/itemlist[]=new

				var/puppetsave1[]=new
				var/puppetsave2[]=new
				var/puppetsave3[]=new

				for(var/obj/items/o in x.contents)

					if(!istype(o,/obj/items/weapons/melee/sword/Bone_Sword))
						if(!istype(o,/obj/items/Puppet))
							if(o.deletable==0)
								var/id = type2index(o.type)
								if(id && isnum(id))
									itemlist+=id
									itemlist+=o.equipped
						else

							if(x&&x.Puppets&&x.Puppets.len>=1&&o==x.Puppets[1])

								puppetsave1+=type2index(o.type)
								puppetsave2+=o.name
								puppetsave3+=1
							else if(x&&x.Puppets&&x.Puppets.len>=2&&o==x.Puppets[2])

								puppetsave1+=type2index(o.type)
								puppetsave2+=o.name
								puppetsave3+=2
							else
								puppetsave1+=type2index(o.type)
								puppetsave2+=o.name
								puppetsave3+=0

				var
					skill_info[0]

				for(var/skill/skill in x.skills)
					skill_info += skill.id
					skill_info += skill.cooldown
					skill_info += skill.uses

				nums.len=34
				nums[1]=x.ezing
				nums[2]=x.MissionCool
				nums[3]=0
				nums[4]=x.votecool
				nums[5]=x.votecool2
				nums[6]=x.factionpoints
				nums[7]=x.overband
				nums[8]=x.Rank_D
				nums[9]=x.Rank_C
				nums[10]=x.Rank_B
				nums[11]=x.Rank_A
				nums[12]=x.Rank_S
				nums[13]=newbounty
				nums[14]=x.hair_type
				nums[15]=x.con
				nums[16]=x.str
				nums[17]=x.int
				nums[18]=x.rfx
				nums[19]=x.skillpoints
				nums[20]=x.levelpoints
				nums[21]=x.money
				nums[22]=max(0,x.stamina)
				nums[23]=max(0,x.curstamina)
				nums[24]=max(0,x.chakra)
				nums[25]=max(0,x.curchakra)
				nums[26]=max(0,x.maxwound)
				nums[27]=max(0,x.curwound)
				nums[28]=x.body
				nums[29]=x.blevel
				nums[30]=x.ko
				nums[31]=x.supplies
				nums[32]=savex
				nums[33]=savey
				nums[34]=savez

				lst.len=8
				lst[1]=list2params(x.skillspassive)
				lst[2]=list2params(skill_info)
				lst[3]=list2params(puppetsave1)
				lst[4]=list2params(puppetsave2)
				lst[5]=list2params(puppetsave3)
				lst[6]=list2params(x.macro_set)
				lst[7]=list2params(x.elements)

				strg.len=10
				strg[1]=x.Last_Hosted
				strg[2]=x.lasthostile
				strg[3]=x.rank
				strg[4]=x.icon_name
				strg[5]=x.name
				strg[6]=x.faction.name
				if(x.squad)
					strg[7]=x.squad.name
				else
					strg[7]=null
				strg[8]=x.hair_color
				strg[9]=x.clan
				strg[10]=md5("[nums[28]]["squad_delete"][nums[15]+nums[16]+nums[17]+nums[18]]["faction_info"][nums[29]]["get_chars"][nums[20]]["check_name"][nums[19]]")

				bar.len=10
				bar[1]=x.macro1?(x.macro1.id):0
				bar[2]=x.macro2?(x.macro2.id):0
				bar[3]=x.macro3?(x.macro3.id):0
				bar[4]=x.macro4?(x.macro4.id):0
				bar[5]=x.macro5?(x.macro5.id):0
				bar[6]=x.macro6?(x.macro6.id):0
				bar[7]=x.macro7?(x.macro7.id):0
				bar[8]=x.macro8?(x.macro8.id):0
				bar[9]=x.macro9?(x.macro9.id):0
				bar[10]=x.macro10?(x.macro10.id):0

				inv=itemlist

				x.name=oldname
				S.len=5
				nums[22]=round(nums[22]*100)/100
				nums[23]=round(nums[23]*100)/100
				nums[24]=round(nums[24]*100)/100
				nums[25]=round(nums[25]*100)/100
				S[1]=inv
				S[2]=bar
				S[3]=strg
				S[4]=nums
				S[5]=lst

				for(var/client/M in SaveListen)
					M<<"Saved [x.name] ([xkey])"
				//spawn()Update_Save(xkey,S)

				//var/save_number = 2
				//var/savefile/F=new("Saves/[xkey]/[xkey]([save_number]).sav")
			/*	var_dump(x.usedrespec)
				if(x.usedrespec==0)
					var_dump(x.usedrespec)
					x.usedrespec=1
					x.Respec()*/


				if(newsave == 1)
					for(var/numero = 1; numero <= max_saves; numero++)
						if(!fexists("Saves/[xkey]/[xkey][numero].sav"))
							var/savefile/F=new("Saves/[xkey]/[xkey][numero].sav")
				//			x.usedrespec=1
							F["S"] << S
					//		F["Faction"] << x.faction
							x.client.save_num = numero
							newsave = 0
							return
				else
					var/savefile/F=new("Saves/[xkey]/[xkey][x.client.save_num].sav")
			//		x.usedrespec=1
					F["S"] << S
					F["Faction"] << x.faction
				//	F["Respec"] << x.usedrespec
					newsave = 0


			/*	if(fexists("Saves/[xkey]/[xkey](1).sav"))
					var/savefile/E=new("Saves/[xkey]/[xkey](2).sav")
					E["S"] << S

				if(fexists("Saves/[xkey]/[xkey](2).sav"))
					var/savefile/H=new("Saves/[xkey]/[xkey](3).sav")
					H["S"] << S*/

			/*	var/savefile/F=new("Saves/[xkey]/[xkey].sav")
			//	spawn()Update_Save(xkey,S)
				F["S"] << S*/

/*mob/var/save1 = 0
mob/var/save2 = 0
mob/var/save3 = 0
client
	proc
		SaveAdv(src.mob,src)
			var/list/S=new/list()
			var/save1 = 0

			var/savefile/F=new("Saves/[xkey]/[xkey](1).sav")
			//	spawn()Update_Save(xkey,S)
			F["S"] << S
			src.save1 == 1

			if(fexists("Saves/[xkey]/[xkey](1).sav")
				var/savefile/F=new("Saves/[xkey]/[xkey](2).sav")
				//	spawn()Update_Save(xkey,S)
				F["S"] << S
				src.save2 == 1

			if(fexists("Saves/[xkey]/[xkey](1)") && fexists("Saves/[xkey]*/


client
	proc
		LoadMob(list/S)

			if(!S || S.len<5)
				return
			var/list/inv=S[1]
			var/list/bar=S[2]
			var/list/strg=S[3]
			var/list/nums=S[4]
			var/list/lst=S[5]

			for(var/i = 1; i <= nums.len; ++i)
				nums[i] = text2num(nums[i])
				if(!nums[i]) nums[i] = 0

			var/hash=md5("[nums[28]]["squad_delete"][nums[15]+nums[16]+nums[17]+nums[18]]["faction_info"][nums[29]]["get_chars"][nums[20]]["check_name"][nums[19]]")
			if(strg[10] != hash)
				src << "Character verification failed."
				del(src)

			var/newx
			var/newy
			var/newz

			newx=nums[32]
			newy=nums[33]
			newz=nums[34]
			var/mob/human/player/x=new/mob/human/player(locate(newx,newy,newz))
			if(x && x.loc && x.loc.loc) x.loc.loc.Entered(x)

			x.name=""

			var/list/itemlist
			var/list/puppetsave1
			var/list/puppetsave2
			var/list/puppetsave3

		//	x.ezing=nums[1]
			x.MissionCool=nums[2]
			//x.survivalistcool=nums[3]
			x.votecool=nums[4]
			x.votecool2=nums[5]
			x.factionpoints=nums[6]
			x.overband=nums[7]
			x.Rank_D=nums[8]
			x.Rank_C=nums[9]
			x.Rank_B=nums[10]
			x.Rank_A=nums[11]
			x.Rank_S=nums[12]
			x.bounty=nums[13]
			x.hair_type=nums[14]
			x.con=nums[15]
			x.str=nums[16]
			x.int=nums[17]
			x.rfx=nums[18]
			x.skillpoints=nums[19]
			x.levelpoints=nums[20]
			x.money=nums[21]
			x.stamina=nums[22]
			x.curstamina=nums[23]
			x.chakra=nums[24]
			x.curchakra=nums[25]
			x.maxwound=nums[26]
			x.curwound=nums[27]
			x.body=nums[28]
			x.blevel=nums[29]
			x.ko=nums[30]
			x.supplies=nums[31]

			x.Last_Hosted=strg[1]
			x.lasthostile=strg[2]
			x.rank=strg[3]
			x.icon_name=strg[4]
			x.name=strg[5]
			x.realname = x.name
			x.hair_color=strg[8]
			x.clan=strg[9]
			var/faction_name = strg[6]
			var/faction/faction_ref = load_faction(faction_name)

			if(!faction_ref)
				del(x)
				src << "Load failed."

			x.faction = faction_ref
			x.mouse_over_pointer = faction_mouse[faction_ref.mouse_icon]
			faction_ref.online_members += x

			x.Refresh_Faction_Verbs()

			if(!x.loc)
				for(var/obj/Respawn_Pt/R in world)
					if((x.faction.village=="Missing"&&R.ind==0)||(x.faction.village=="Konoha"&&R.ind==1)||(x.faction.village=="Suna"&&R.ind==2)||(x.faction.village=="Kiri"&&R.ind==3))
						x.loc = R.loc
						break

			var/squad_name = strg[7]
			if(squad_name)
				var/squad/squad_ref = load_squad(squad_name)
				if(!squad_ref)
					x.squad = null
				else
					x.squad = squad_ref
					squad_ref.online_members += x
			else
				x.squad = null

			x.Refresh_Squad_Verbs()

			if(!x.name)
				x.name = "Nameless"
				del(x)
				src << "Load failed."

			x.skillspassive=dd_text2List(lst[1],"&")
			for(var/i = 1; i <= x.skillspassive.len; ++i)
				x.skillspassive[i] = text2num(x.skillspassive[i])
				if(!x.skillspassive[i]) x.skillspassive[i] = 0

			x.skillspassive.len=50

			var
				skill_info[]

			skill_info=dd_text2List(lst[2],"&")

			for(var/i = 0; i <= (skill_info.len-3);)
				var/id = text2num(skill_info[++i])
				var/cooldown = text2num(skill_info[++i])
				var/uses = text2num(skill_info[++i])
				var/skill/skill = x:AddSkill(id)
				skill.cooldown = cooldown
				skill.uses = uses

			if(!x.HasSkill(KAWARIMI))
				x.AddSkill(KAWARIMI)

			if(!x.HasSkill(WINDMILL_SHURIKEN))
				x.AddSkill(WINDMILL_SHURIKEN)

			if(!x.HasSkill(SHUNSHIN))
				x.AddSkill(SHUNSHIN)

			if(!x.HasSkill(BUNSHIN))
				x.AddSkill(BUNSHIN)

			if(!x.HasSkill(HENGE))
				x.AddSkill(HENGE)

			if(!x.HasSkill(EXPLODING_KUNAI))
				x.AddSkill(EXPLODING_KUNAI)

			if(!x.HasSkill(EXPLODING_NOTE))
				x.AddSkill(EXPLODING_NOTE)

			switch(x.clan)
				if("Sand Control")
					if(!x.HasSkill(SAND_SUMMON))
						x.AddSkill(SAND_SUMMON)
					if(!x.HasSkill(SAND_UNSUMMON))
						x.AddSkill(SAND_UNSUMMON)

			puppetsave1=dd_text2List(lst[3],"&")
			for(var/i = 1; i <= puppetsave1.len; ++i)
				puppetsave1[i] = text2num(puppetsave1[i])
				if(!puppetsave1[i]) puppetsave1[i] = 0

			puppetsave2=dd_text2List(lst[4],"&")

			puppetsave3=dd_text2List(lst[5],"&")
			for(var/i = 1; i <= puppetsave3.len; ++i)
				puppetsave3[i] = text2num(puppetsave3[i])
				if(!puppetsave3[i]) puppetsave3[i] = 0

			itemlist=inv
			for(var/i = 1; i <= itemlist.len; ++i)
				itemlist[i] = text2num(itemlist[i])
				if(!itemlist[i]) itemlist[i] = 0

			for(var/i = 1; i <= 10; ++i)
				var/skill_id = text2num(bar[i])
				if(skill_id)
					for(var/skill/skill in x.skills)
						if(skill.id == skill_id)
							x.vars["macro[i]"] = skill
							var/skillcard/card = new /skillcard(null, skill)
							card.screen_loc = "[i+1],1"
							x.player_gui += card
							screen += card

			x.elements=params2list(lst[7])
			for(var/element in x.elements)
				if(!istext(element) || element == "/list")
					x.elements -= element

		/*	if(x.money>100000000)
				x.money=0*/
		/*	if(x.blevel>150)
				x.blevel=1
			if(x.rfx>((x.blevel-1)*4+50))
				x.rfx=0
			if(x.str>((x.blevel-1)*4+50))
				x.str=0
			if(x.con>((x.blevel-1)*4+50))
				x.con=0
			if(x.int>((x.blevel-1)*4+50))
				x.int=0
			if((x.rfx + x.int + x.con + x.rfx) > (200 + 6*(x.blevel-1)))
				x.rfx = 0
				x.str = 0
				x.con = 0
				x.int = 0*/
			if(x.maxwound>200)
				x.maxwound=100
			if(x.skillpoints > (x.blevel * (165 + 4.5 * x.int)))
				x.skillpoints = 0

			x.Puppets.len=2

			if(puppetsave1)
				var/i2=length(puppetsave1)
				if(i2>100)
					i2=100
				while(i2>0)
					if(!(puppetsave1.len>=i2) ||!(puppetsave2.len>=i2)||!(puppetsave3.len>=i2))
						break
					var/otype = index2type(puppetsave1[i2])
					var/oname = puppetsave2[i2]
					var/ostatus= puppetsave3[i2]
					if(otype)
						var/obj/items/o = new otype(x)
						o.name=oname
						if(ostatus==1)
							x.Puppets[1]=o
							x.overlays+='icons/Equipped1.dmi'
						if(ostatus==2)
							x.Puppets[2]=o
							x.overlays+='icons/Equipped2.dmi'
					i2--

		//ets

			var/list/L=list(0,0,0,0,0)
			for(var/i = 0; i <= (itemlist.len-2);)
				var/id = itemlist[++i]
				var/equipped = itemlist[++i]
				var/type = index2type(id)

				if(type==/obj/items/weapons/projectile/Kunai_p)
					L[1]=1
				if(type==/obj/items/weapons/projectile/Needles_p)
					L[2]=1
				if(type==/obj/items/weapons/projectile/Shuriken_p)
					L[3]=1
				if(type==/obj/items/weapons/melee/knife/Kunai_Melee)
					L[4]=1
				if(type==/obj/items/equipable/Kunai_Holster)
					L[5]=1
				if(type!=null && ispath(type,/obj/items))
					var/obj/items/o = new type(x)
					if(equipped && !istype(o,/obj/items/usable) && !istype(o,/obj/items/Puppet_Stuff))
						spawn(rand(10,30))o:Use(x)
					else if(istype(o,/obj/items/usable))
						o.equipped=equipped
						spawn(30)if(o) o:Refreshcountdd(src.mob)
					else if(istype(o,/obj/items/Puppet_Stuff))
						if(equipped)
							o.equipped=equipped
							if(i==1)
								o.overlays+='icons/Equipped1.dmi'
							if(i==2)
								o.overlays+='icons/Equipped2.dmi'
					else
						o.equipped=0

			if(!L[1])
				new/obj/items/weapons/projectile/Kunai_p(x)
			if(!L[2])
				new/obj/items/weapons/projectile/Needles_p(x)
			if(!L[3])
				new/obj/items/weapons/projectile/Shuriken_p(x)
			if(!L[4])
				new/obj/items/weapons/melee/knife/Kunai_Melee(x)
			if(!L[5])
				new/obj/items/equipable/Kunai_Holster(x)

			if(x.rank != "Academy Student" && x.rank != "Genin" && x.faction && x.faction.chuunin_item)
				var/chuunin_type = index2type(x.faction.chuunin_item)
				var/has_chuunin = locate(chuunin_type) in x
				if(!has_chuunin) new chuunin_type(x)

			for(var/skill/skill in x.skills)
				if(skill.cooldown) spawn() skill.DoCooldown(x, 1)

			x.macro_set = params2list(lst[6])
			// winset uses params form, so just pass that through to restore macros
			if(x.macro_set.len)
				winset(src, null, lst[6])
/*			var/list/cusmac=params2list(lst[7])
			var/list/used=new
			spawn(30)
				for(var/obj/O in x.contents)
					if(cusmac["[type2index(O.type)]"]&&!used.Find(type2index(O.type)))
						used+=type2index(O.type)
						O.cust_macro=cusmac["[type2index(O.type)]"]
						O.macover=image('fonts/Cambriacolor.dmi',icon_state="[O.cust_macro]")
						O.overlays+=O.macover
						var/mac = cusmac["[type2index(O.type)]"]
						winset(src, "custom_macro_[mac]", "parent=macro;name=\"[mac]+REP\";command=\"custom-macro \\\"[mac]\\\"\"")*/
			x.initialized = 1
			src.mob=x
			x.RefreshSkillList()



mob
	proc
		ChooseCharacter()
			if(src.client)
				var/list/S = new/list()
				var/list/menu = new()
				var/total_chars = 0
				for(var/numero = 1; numero <= max_saves; numero++)
					if(fexists("Saves/[src.ckey]/[src.ckey][numero].sav"))
						menu += numero
						total_chars++

				if (total_chars == 0)
					src<<"Character doesnt exist"
					return

				if(!length(menu))
					return
				menu += "Cancel"
				var/pickd = input2(src, "Load a Character","Load",menu)
				if(pickd=="Cancel")
					return
				var/savefile/F = new("Saves/[src.ckey]/[src.ckey][pickd].sav")
				F["S"] >> S
				F["Faction"] >> src.faction
			//	F["Respec"] >> src.usedrespec
				src.client.save_num = pickd
			//	var/resp = alert("You want to respec your character?!","Respec", "Yes", "No")
				src.client.LoadMob(S)
			//	src<<"resp=[resp]"
			//	if(resp == "Yes")
			//		src.Respec()
				//var_dump(usedrespec)
			/*	if(usedrespec==0)
					usedrespec=1
					Respec()*/
				src<<"Grabbing Character ..."


			/*var/save1="Saves/[src.ckey]/[src.ckey][numero].sav"
			var/list/S = new/list()

			var/list/menu = new()
			menu += save1
			var/pickd
			if(length(menu))
				menu += "Cancel"
				pickd=input2(src, "Load a Character","Load",menu)
				if(pickd=="Cancel")
					return
				if(pickd==save1)
					if(!fexists(save1))
						src<<"Character doesnt exist"
						return
					var/savefile/F = new(save1)
					F["S"] >> S
					save_num = numero
					src.client.LoadMob(S)
					src<<"Grabbing Character ..."*/

	/*	ChooseCharacter()
			while(1)

				var/list/characters = new/list()
				var/save_file = "Saves/[src.ckey].sav"
				if(fexists(save_file))//this save only holds references to characters
					var/savefile/F=(save_file)
					F["Characters"] >> characters
				else
					src<<"Save file [save_file] not found!"

				var/nevermind = "Nevermind"
				var/list/menu = new()
				menu += characters
				menu += nevermind
				var/pickd
				if(length(menu))
					menu += "Cancel"
					pickd=input2(src,"Load a Character","Load",menu)
					if(pickd==nevermind)
						return
					src<<"Grabbing Character ([pickd]).."

				else
					if(characters.len>3)
						alert(src,"You have more than the maximum amount of characters, please delete your unused ones and try again")
					else
						if(!fexists("Saves/[copytext(ckey(pickd),1,2)]/[ckey(pickd)].sav"))
							var/list/C=new
							for(var/X in characters)if(X!=pickd)C+=X
							var/savefile/F=new("Saves/Index/[copytext(src.ckey,1,2)]/[src.ckey].sav")
							F["Characters"]<<C
							world.log<<"[pickd]/[src.key] was missing!"
							src<<"Character does not exist!"

							return
						src.client.LoadMob(ckey(pickd))
						del(src)
						return*/

/*		ChooseCharacter()
			if(src.client)
				var/savefile/F = new("Saves/[src.ckey].sav")
				var/list/S = new/list()
				F["S"] >> S
				src.client.LoadMob(S)*/

	/*	ChooseCharacter()
			if(src.client&&src.client.chars)
				var/list/characters = src.client.chars

				var/list/menu = new()
				menu += characters
				if(length(menu))
					menu += "Cancel"
					var/pickd=input2(src,"Load a Character","Load",menu)
					if(pickd=="Cancel")
						return
					src<<"Grabbing Character ([pickd]).."
					var/list/Char=dd_text2List(SendInterserverMessage("get_save", list("char" = pickd, "key" = ckey)),"$")
					for(var/i = 1; i <= Char.len; ++i)
						Char[i] = dd_text2List(Char[i],";")
					if(Char)src<<"[pickd] Loaded!"
					if(src.client)src.client.LoadMob(Char)*/



