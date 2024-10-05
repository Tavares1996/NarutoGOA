mob
	proc
		Respec()
			//Passives
			skillspassive[25]=0
			skillspassive[26]=0
			skillspassive[27]=0
			skillspassive[28]=0

			//Strength
			skillspassive[2]=0
			skillspassive[9]=0
			skillspassive[10]=0
			skillspassive[11]=0
			skillspassive[12]=0
			skillspassive[13]=0

			//Reflex
			skillspassive[14]=0
			skillspassive[15]=0
			skillspassive[16]=0
			skillspassive[4]=0
			skillspassive[17]=0
			skillspassive[18]=0

			//Intelligence
			skillspassive[8]=0
			skillspassive[7]=0
			skillspassive[19]=0
			skillspassive[20]=0
			skillspassive[1]=0
			skillspassive[21]=0

			//Control

			skillspassive[5]=0
			skillspassive[22]=0
			skillspassive[23]=0
			skillspassive[24]=0
			skillspassive[3]=0
			skillspassive[6]=0

			//Stats
			str=50
			rfx=50
			con=50
			int=50

			strbuff=0
			rfxbuff=0
			conbuff=0
			intbuff=0

			//Elements
			elements.len=0

			//Macros
			macro1=null
			macro2=null
			macro3=null
			macro4=null
			macro5=null
			macro6=null
			macro7=null
			macro8=null
			macro9=null
			macro10=null

			vars["macro1"]=null
			vars["macro2"]=null
			vars["macro3"]=null
			vars["macro4"]=null
			vars["macro5"]=null
			vars["macro6"]=null
			vars["macro7"]=null
			vars["macro8"]=null
			vars["macro9"]=null
			vars["macro10"]=null


			//Skills
			for(var/X in skills)
				del X

			for(var/skillcard/X in contents)
				del X

			//Levels and Skillpoints
			levelpoints = blevel*6

			skillpoints = 0

			for(var/obj/gui/passives/gauge/Q in world)
				client.Passive_Refresh(Q)

			src:Refresh_Stat_Screen()
			src:refreshskills()
			src:RefreshSkillList()
			src<<"Respec Done. Make sure you relog to finish the Respec."


mob
	MasterAdmin/verb
		Respec_Player(var/mob/O in All_Clients())
			set category = "Admin"
			set name = ".respec"

			if(O && O.client)

				O.Respec()