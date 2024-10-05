world/Topic(href, addr)

	// Let pings go through without a password
	if(href == "ping") return ..()
	if(dontdoshit)
		return

	var/T[] = params2list(href)
	var/P=T["Password"]

	if(P!=PASSWORD)
		return

#if DM_VERSION >= 462
	if(findtextEx(addr, ":"))
#else
	if(findText(addr, ":"))
#endif
		// It's a server we don't already know about -- assume it's new.
		if(!(addr in Serverlist))
			world.log << "Added server [addr]"
			Serverlist += addr
	else
		// Server without a port!
		// The announce scripts trigger this, so let them through
		// Anything else should be ignored because it's a copy of the game running in DS
		if(T["action"] != "announce")
			return

	switch(T["action"])
		if("newserver")
			spawn()
				update_helpers(addr)
		if("announce")
			mirror(href, addr)

		if("chat_mirror")
			T["source"] = addr
			mirror(list2params(T), addr)

		if("mute")
			world.Export("[T["server"]]?[href]")


		if("is-logged-in")
			return mirror_check(href, addr)

		if("get_chars")
			. = saves.GetCharacterNames(T["key"])

			if(istype(., /list))
				. = list2params(.)

			return .

		if("check_name")
			return saves.IsNameUsed(T["name"])

		if("new_squad")
			return saves.CreateSquad(T["name"], T["leader"])

		if("squad_delete")
			. =  saves.DeleteSquad(T["squad"])

			if(. && !T["nomirror"])
				mirror(href, addr)

			return .

		if("squad_leader_change")
			. = saves.ChangeSquadLeader(T["squad"], T["new_leader"])

			if(.)
				mirror(href, addr)

			return .

		if("squad_member_count")
			return saves.GetSquadMemberCount(T["squad"])

		if("squad_info")
			. =  saves.GetSquadInfo(T["squad"])

			if(istype(., /list))
				. = list2params(.)

			return .

		if("new_faction")
			return saves.CreateFaction(T["name"], T["leader"], T["village"], T["mouse_icon"], T["chat_icon"], T["chuunin_item"], T["member_limit"])

		if("faction_delete")
			. =  saves.DeleteFaction(T["faction"])

			if(. && !T["nomirror"])
				mirror(href, addr)

			return .

		if("faction_leader_change")
			. = saves.ChangeFactionLeader(T["faction"], T["new_leader"])

			if(.)
				mirror(href, addr)

			return .

		if("faction_member_count")
			return saves.GetFactionMemberCount(T["squad"])

		if("faction_info")
			. =  saves.GetFactionInfo(T["faction"])

			if(istype(., /list))
				. = list2params(.)

			return .

		if("add_helper")
			. = saves.AddHelper(T["name"], T["village"])

			if(.)
				update_helpers()

			return .

		if("remove_helper")
			. = saves.RemoveHelper(T["name"], T["village"])

			if(.)
				update_helpers()

			return .

		if("is_banned")
			return saves.IsBanned(T["key"], T["computer_id"])

		if("add_ban")
			return saves.AddBan(T["key"], T["computer_id"])

		if("remove_ban")
			return saves.RemoveBan(T["key"], T["computer_id"])

		if("char_info_set_comment")
			return saves.SetInfoCardComment(T["char"], T["village"], T["comment"])

		if("char_info_card")
			. =  saves.GetInfoCard(T["char"], T["village"])

			if(istype(., /list))
				. = list2params(.)

			return .

		if("rename_save")
			return saves.RenameCharacter(T["name_old"], T["name_new"])

		if("delete_save")
			return saves.DeleteCharacter(T["char"])

		if("get_save")
			. = saves.GetCharacter(T["char"], T["key"])

			if(istype(., /list))
				var/encoded[0]

				for(var/list/L in .)
					encoded += dd_list2text(L,";")

				. = dd_list2text(encoded,"$")

			return .

		if("update_save")
			return saves.SaveCharacter(T["key"], T["inv"], T["bar"], T["strg"], T["nums"], T["lst"])

		if("removeserver")
			world.log << "Removed server [addr]: Requested removal"
			Serverlist -= addr
	return ..()
