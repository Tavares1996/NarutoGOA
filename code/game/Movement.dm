
client
	var
		moving = 0
		run_count = 0
	proc
		Move_Loop()
			var
				mob/target_mob = mob
				end_move

			while(1)
				var/delay = 1
				if(mob.controlmob)
					target_mob = mob.controlmob
				else
					target_mob = mob
				if(mob.Primary && get_dist(mob.Primary, mob) < 20)
					target_mob = mob.Primary

				if(!target_mob.canmove||target_mob.ko||target_mob.stunned||target_mob.kstun||target_mob.asleep||target_mob.mane||target_mob.ko||!target_mob.initialized||target_mob.handseal_stun||target_mob.incombo||target_mob.frozen)
					if(run_count > 0) run_count--
					sleep(1)
				else

					walk(target_mob, 0)

					/*
					//direction selection
					var/mdir
					var/compatible = 0
					var/keycount = 0
					var/mostrecent
					for(var/i in mob.keys)
						if(mob.keys[i])
							keycount++ //count how many keys are pressed to see if compatibility is possible
							if(mostrecent) //if there is a most recent, check to see if current in loop is more recent
								if(mob.keys[i] > mob.keys[mostrecent])
									mostrecent = i
							else //if there is no most recent, use current in loop
								mostrecent = i

					if(keycount == 2) //continue compatibility check; more or less than two keys can not be compatible
						if(mob.keys["north"])
							if(mob.keys["west"])
								mdir = NORTHWEST
								compatible = 1
							else if(mob.keys["east"])
								mdir = NORTHEAST
								compatible = 1
						else if(mob.keys["south"])
							if(mob.keys["west"])
								mdir = SOUTHWEST
								compatible = 1
							else if(mob.keys["east"])
								mdir = SOUTHEAST
								compatible = 1

					if(!compatible) //if two keys being pressed are compatible we do not want to move with the most recent
						switch(mostrecent)
							if("northwest") mdir = NORTHWEST
							if("northeast") mdir = NORTHEAST
							if("north") mdir = NORTH
							if("east") mdir = EAST
							if("southwest") mdir = SOUTHWEST
							if("southeast") mdir = SOUTHEAST
							if("south") mdir = SOUTH
							if("west") mdir = WEST
					*/
					if(target_mob.movement_map)
						mdir = target_mob.movement_map["[mdir]"]

					if(mdir && step(target_mob, mdir))
						end_move = 0

						if(target_mob.mole) //underground via mole hiding jutsu
							run_count = 0
							delay = 5
						else if(target_mob.move_stun) //slowed
							//run_count = 0 //Dipic: This probably isn't necessary
							if(target_mob.icon_state=="Run") target_mob.icon_state=""
						//	delay = target_mob.Get_Move_Stun()
						else if(run_count <= 4) //walking
							run_count++
							if(target_mob.icon_state=="Run") target_mob.icon_state=""
							delay = 2
						else //running
							if(run_count < 20) run_count++
							if(!target_mob.Size && !target_mob.icon_state && !target_mob.rasengan && !target_mob.larch && (target_mob.movepenalty <= 10))
								target_mob.icon_state="Run"
							delay = 1

						if(target_mob.Size==1 && target_mob.movepenalty < 25)
							target_mob.movepenalty = 25
						else if(target_mob.Size==2 && target_mob.movepenalty < 35)
							target_mob.movepenalty = 35

						target_mob.movepenalty = min(target_mob.movepenalty, 50) //cap movepenalty at 50

						if(target_mob.move_stun)
							if(!target_mob.movepenalty || target_mob.movepenalty < 10)
								target_mob.movepenalty = 10
							delay += round(target_mob.movepenalty/3)
						else
							delay += round(target_mob.movepenalty/10)

						sleep(delay)
					else if(target_mob.Tank)
						sleep(1)
					else
						if(mdir && mdir != target_mob.dir) target_mob.dir = mdir
						if(target_mob.icon_state=="Run") target_mob.icon_state=""
						if(run_count > 0) run_count--
						end_move++
						if(end_move >= 20)
							break
						sleep(1)

			moving = 0
			run_count = 0

	verb
		Start_Move()
			if(!moving)
				moving = 1
				Move_Loop()
/*
atom/movable
	proc
		reverse_dir()
			switch(src.dir)
				if(NORTH)
					return SOUTH
				if(SOUTH)
					return NORTH
				if(EAST)
					return WEST
				if(WEST)
					return EAST
				if(NORTHEAST)
					return SOUTHWEST
				if(SOUTHWEST)
					return NORTHEAST
				if(NORTHWEST)
					return SOUTHEAST
				if(SOUTHEAST)
					return NORTHWEST
mob/proc
	dir_from_keys()
		//direction selection
		var/mdir
		var/compatible = 0
		var/keycount = 0
		var/mostrecent
		for(var/i in keys)
			if(keys[i])
				keycount++ //count how many keys are pressed to see if compatibility is possible
				if(mostrecent) //if there is a most recent, check to see if current in loop is more recent
					if(keys[i] > keys[mostrecent])
						mostrecent = i
				else //if there is no most recent, use current in loop
					mostrecent = i

		if(keycount == 2) //continue compatibility check; more or less than two keys can not be compatible
			if(keys["north"])
				if(keys["west"])
					mdir = NORTHWEST
					compatible = 1
				else if(keys["east"])
					mdir = NORTHEAST
					compatible = 1
			else if(keys["south"])
				if(keys["west"])
					mdir = SOUTHWEST
					compatible = 1
				else if(keys["east"])
					mdir = SOUTHEAST
					compatible = 1

		if(!compatible) //if two keys being pressed are compatible we do not want to move with the most recent
			switch(mostrecent)
				if("northwest") mdir = NORTHWEST
				if("northeast") mdir = NORTHEAST
				if("north") mdir = NORTH
				if("east") mdir = EAST
				if("southwest") mdir = SOUTHWEST
				if("southeast") mdir = SOUTHEAST
				if("south") mdir = SOUTH
				if("west") mdir = WEST
		return mdir
*/