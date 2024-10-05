/*skill
	hokagepower
		copyable = 0

		hokagepower
			id = HOKAGE_POWER
			name = "Hokage Power"
			icon_state = "Power"
			default_chakra_cost = 150
			default_cooldown = 1500



			IsUsable(mob/user)
				. = ..()
				if(.)
					if(user.sharingan)
						Error(user, "Your power is already awaken")
						return 0


			Cooldown(mob/user)
				return default_cooldown


			Use(mob/user)
				viewers(user) << output("[user]: Hokage Power", "combat_output")
				user.overlays+='icons/Chakra_Shroud.dmi'
				user.overlays+='icons/gate3chakra.dmi'

				var/buffstr=round(user.str*15.9999)
				var/buffcon=round(user.con*15.9999)
				var/buffrfx=round(user.rfx*15.9999)
				var/buffint=round(user.int*15.9999)

				user.strbuff+=buffstr
				user.conbuff+=buffcon
				user.rfxbuff+=buffrfx
				user.intbuff+=buffint
				user.Affirm_Icon()

				spawn(Cooldown(user)*10)
					if(!user) return
					user.overlays-='icons/Chakra_Shroud.dmi'
					user.overlays-='icons/gate3chakra.dmi'
					user.strbuff-=round(buffstr)
					user.conbuff-=round(buffcon)
					user.rfxbuff-=round(buffrfx)
					user.intbuff-=round(buffint)

					user.special=0

					user.Affirm_Icon()
					user.combat("Your Power is now asleep")*/