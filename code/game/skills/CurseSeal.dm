skill
	curseseal
		copyable = 0

		curseseal
			id = CURSE_SEAL
			name = "Curse Seal"
			icon_state = "Curse_Seal"
			default_chakra_cost = 1550
			default_cooldown = 1500



			IsUsable(mob/user)
				. = ..()
				if(.)
					if(user.sharingan)
						Error(user, "Curse Seal is already active")
						return 0



			Cooldown(mob/user)
				return default_cooldown


			Use(mob/user)
				viewers(user) << output("[user]: Curse Seal", "combat_output")
				user.overlays+='icons/SasukeLeftWing.dmi'
				user.overlays+='icons/SasukeRightWing.dmi'

				var/buffrfx=round(user.rfx*15.9999)
				var/buffstr=round(user.str*15.9999)
				var/buffcon=round(user.con*15.9999)

				user.rfxbuff+=buffrfx
				user.strbuff+=buffstr
				user.conbuff+=buffcon
				user.Affirm_Icon()

				spawn(Cooldown(user)*10)
					if(!user) return

					user.overlays-='icons/SasukeLeftWing.dmi'
					user.overlays-='icons/SasukeRightWing.dmi'
					user.rfxbuff-=round(buffrfx)
					user.strbuff-=round(buffstr)
					user.conbuff-=round(buffcon)

					user.special=0

					user.Affirm_Icon()
					user.combat("Your Curse Seal deactivates.")

