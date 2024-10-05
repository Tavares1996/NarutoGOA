mob
	team_deathmatch
		verb
			Join_TDM()
				set category = "Team Deathmatch"

				if(client) winset(src, "tdm_menu", "parent=")

				if(!team_deathmatch) return

				team_deathmatch.Join(src)


			Leave_TDM()
				set category = "Team Deathmatch"

				if(client) winset(src, "tdm_menu", "parent=")

				if(!team_deathmatch) return

				team_deathmatch.Leave(src)

	MasterAdmin
		verb
			Host_TDM()
				set name = ".tdm"
				del team_deathmatch

				team_deathmatch = new
				team_deathmatch.Initiate()

			End_TDM()
				set name = ".end tdm"
				if(team_deathmatch)
					team_deathmatch.End()





var
	team_deathmatch
		team_deathmatch

team_deathmatch
	var
		list
			white_team = new
			orig_white_team = new

			black_team = new
			orig_black_team = new

		status
		levelpoints = 40000
		money = 5000//msn




	proc
		Announce(announcement)
			if(istext(announcement)) world << "<font size = +1>[announcement]</font>"


		Join(mob/player)
			if(player in white_team || player in black_team)return
			if(status != "Join")return

			if(white_team.len >= black_team.len)
				black_team += player
				online_admins << "[player] Joined the Black Team."

			else if(black_team.len > white_team.len)
				white_team += player
				online_admins << "[player] Joined the White Team."

			player.loc = locate_tag("tdm_waiting")
			player.Load_Overlays()
			player << "You joined Team Deathmatch."

			if(player.shopping)
				player.shopping = 0
				player.canmove = 1
				player.see_invisible = 0



		Leave(mob/player)
			if(player in white_team)
				white_team -= player
			else if(player in black_team)
				black_team -= player
			else
				return

			player << "You left Team Deathmatch."
			online_admins << "[player] left Team Deathmatch."

			Respawn(player)


		Initiate()
			var
				time = 60 * 10 * 3

			Announce("An Admin has started a Team Deathmatch Event! You have 3 minutes to join!")

			status = "Join"

			white_team = new
			black_team = new

			spawn(time)
				status = 0
				Announce("Team Deathmatch enlistment is over.")

				if(!white_team.len || !black_team.len)
					for(var/list/List in list(white_team, black_team))
						for(var/mob/Mobile in List)
							Respawn(Mobile)
					return

				Start()



		End()
			status = 0

			for(var/list/List in list(white_team, black_team))
				for(var/mob/Mobile in List)
					Respawn(Mobile)

			Announce("Team Deathmatch is now over.")

			white_team = new
			black_team = new

			del team_deathmatch



		Start()
			Announce("Team Deathmatch is starting...!")

			orig_white_team = white_team.Copy()
			orig_black_team = black_team.Copy()

			sleep(50)

			for(var/list/List in list(white_team, black_team))
				for(var/mob/m in List)
					Spawn(m)

			spawn()
				while(team_deathmatch && white_team.len>0 && black_team.len>0)
					sleep(50)

				if(!team_deathmatch)
					return

				if(white_team.len)
					Announce("The White team wins Team Deathmatch!")
					WinningTeam("White")

				else if(black_team.len)
					Announce("The Black team wins Team Deathmatch!")
					WinningTeam("Black")

				End()


		checkTeam(mob/player)
			if(player in white_team) return "White"
			if(player in black_team) return "Black"
			return null


		healPlayer(mob/player)
			player.curwound = 0
			player.curstamina = player.stamina
			player.curchakra = player.curchakra


		Spawn(mob/user)
			if(user in white_team)
				user.loc = locate_tag("white_team")
				user.stunned = 0
				user.frozen = 0
				user.canmove = 1
				healPlayer(user)

			else if(user in black_team)
				user.loc = locate_tag("black_team")
				user.stunned = 0
				user.frozen = 0
				user.canmove = 1
				healPlayer(user)

			user.Load_Overlays()



		Respawn(mob/user)
			if(user.client)
				if(user in white_team)
					white_team -= user
				if(user in black_team)
					black_team -= user

				var
					obj/Re = null

				for(var/obj/Respawn_Pt/R in world)
					if(R.ind == 0)
						Re = R
					if(user.faction.village == "Konoha" && R.ind == 1)
						Re = R
					if(user.faction.village == "Suna" && R.ind == 2)
						Re = R
					if(user.faction.village == "Kiri" && R.ind == 3)
						Re = R
					if(user.faction.village == "Iwa" && R.ind == 4)
						Re = R
				if(Re)
					user.x = Re.x
					user.y = Re.y
					user.z = Re.z
				else
					user.x=31
					user.y=74
					user.z=1



		WinningTeam(winningteam)
			if(winningteam == "White")
				for(var/mob/winning in orig_white_team)
					winning << "Congratulations on winning Team Deathmatch!"
					winning << "Gained [levelpoints] Level Points"
					winning << "Gained [money] Dollars"
					winning.body += levelpoints
					winning.money += money
					if(winning.client) Respawn(winning)

			else if(winningteam == "Black")
				for(var/mob/winning in orig_black_team)
					winning << "Congratulations on winning Team Deathmatch!"
					winning << "Gained [levelpoints] Level Points"
					winning << "Gained [money] Dollars"
					winning.body += levelpoints
					winning.money += money
					if(winning.client) Respawn(winning)