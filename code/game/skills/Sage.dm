skill
	sage
		copyable = 0


		sagemode
			id = SAGE_MODE
			name = "Sage Mode"
			icon_state = "sage"
			default_chakra_cost = 1550
			default_cooldown = 300



			IsUsable(mob/user)
				. = ..()
				if(.)
					if(user.sage)
						Error(user, "Sage Mode is already active")
						return 0


			Cooldown(mob/user)
				return default_cooldown


			Use(mob/user)
				viewers(user) << output("[user]: Sage Mode!", "combat_output")
				user.sage=1

				var/buffcon=round(user.con*0.5000)
				var/buffstr=round(user.str*0.5000)
				//user.overlays+=image('icons/sageeye.dmi')
				user.conbuff+=buffcon
				user.strbuff+=buffstr
				user.Affirm_Icon()

				spawn(Cooldown(user)*10)
					if(!user) return
					//user.overlays-=image('icons/sageeye.dmi')
					user.conbuff-=round(buffcon)
					user.strbuff-=round(buffstr)
					user.special=0
					user.sage=0
					user.Affirm_Icon()
					user.combat("You are back to normal.")