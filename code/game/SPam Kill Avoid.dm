

// A temporary list to hold who the player has killed in the last five minutes
mob/human/var/tmp/list/killed

// Has src killed M in the last five minutes?
mob/human/proc/killed_recently(var/mob/human/M)
	return M.realname in src.killed

// Register src's kill and remove it in five minutes
mob/human/proc/register_kill(var/mob/human/M)
	spawn()
		if(!src.killed)
			src.killed = new()
		if(M)
			var/killed_name = M.realname
			src.killed += killed_name
			spawn(3000)
				if(src)
					src.killed -= killed_name
					if(!src.killed.len)
						src.killed.Cut()