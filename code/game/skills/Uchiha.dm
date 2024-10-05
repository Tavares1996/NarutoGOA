skill
	uchiha
		copyable = 0




		sharingan_1
			id = SHARINGAN1
			name = "Sharingan"
			icon_state = "sharingan1"
			default_chakra_cost = 150
			default_cooldown = 150



			IsUsable(mob/user)
				. = ..()
				if(.)
					if(user.sharingan)
						Error(user, "Sharingan is already active")
						return 0


			Cooldown(mob/user)
				return default_cooldown


			Use(mob/user)
				viewers(user) << output("[user]: Sharingan!", "combat_output")
				user.sharingan=1

				var/buffrfx=round(user.rfx*0.25)
				var/buffint=round(user.int*0.25)

				user.rfxbuff+=buffrfx
				user.intbuff+=buffint
				user.Affirm_Icon()

				spawn(Cooldown(user)*10)
					if(!user) return
					user.rfxbuff-=round(buffrfx)
					user.intbuff-=round(buffint)

					user.special=0
					user.sharingan=0

					user.Affirm_Icon()
					user.combat("Your sharingan deactivates.")




		sharingan_2
			id = SHARINGAN2
			name = "Sharingan"
			icon_state = "sharingan2"
			default_chakra_cost = 350
			default_cooldown = 250



			IsUsable(mob/user)
				. = ..()
				if(.)
					if(user.sharingan)
						Error(user, "Sharingan is already active")
						return 0


			Cooldown(mob/user)
				return default_cooldown


			Use(mob/user)
				viewers(user) << output("[user]: Sharingan!", "combat_output")
				user.sharingan=1

				var/buffrfx=round(user.rfx*0.33)
				var/buffint=round(user.int*0.33)

				user.rfxbuff+=buffrfx
				user.intbuff+=buffint
				user.Affirm_Icon()

				spawn(Cooldown(user)*10)
					if(!user) return
					user.rfxbuff-=round(buffrfx)
					user.intbuff-=round(buffint)

					user.special=0
					user.sharingan=0

					user.Affirm_Icon()
					user.combat("Your sharingan deactivates.")
		sharingan_3
			id = MANGEKYOUI
			name = "Itachi Sharingan"
			icon_state = "mangekyouI"
			default_chakra_cost = 550
			default_cooldown = 350



			IsUsable(mob/user)
				. = ..()
				if(.)
					if(user.sharingan)
						Error(user, "Sharingan is already active")
						return 0


			Cooldown(mob/user)
				return default_cooldown


			Use(mob/user)
				viewers(user) << output("[user]: Mangekyou Sharingan!", "combat_output")
				user.sharingan=2

				var/buffrfx=round(user.rfx*0.66)
				var/buffint=round(user.int*0.66)

				user.rfxbuff+=buffrfx
				user.intbuff+=buffint
				user.Affirm_Icon()

				spawn(Cooldown(user)*10)
					if(!user) return
					user.rfxbuff-=round(buffrfx)
					user.intbuff-=round(buffint)

					user.special=0
					user.sharingan=0

					user.Affirm_Icon()
					user.combat("Your Mangekyou Sharingan deactivates.")




		sharingan_copy
			id = SHARINGAN_COPY
			name = "Sharingan Copy"
			icon_state = "sharingancopy"
			var
				skill/copied_skill



			Activate(mob/user)
				if(copied_skill)
					return copied_skill.Activate(user)
				else
					Error(user, "You do not have a copied skill.")
					return 0


			IconStateChanged(skill/sk, new_state)
				if(sk == copied_skill)
					ChangeIconState(new_state)



			proc
				CopySkill(id)
					var/skill_type = SkillType(id)
					var/skill/skill
					if(!skill_type)
						skill = new /skill()
						skill.id = id
						skill.name = "Unknown Skill ([id])"
					else
						skill = new skill_type()
					skill.master = src
					copied_skill = skill
					icon_overlays = list(icon('icons/gui_badges.dmi', "sharingan_copy"))
					icon = skill.icon
					icon_state = skill.icon_state
					for(var/skillcard/card in skillcards)
						card.icon = icon
						card.icon_state = icon_state
						card.overlays = icon_overlays
					return skill

		amaterasu
			id = AMATERASU
			name = "Amaterasu"
			icon_state = "amaterasu"
			default_chakra_cost = 3000
			default_cooldown = 200



			Use(mob/human/user)
				user.icon_state="Seal"

				viewers(user) << output("[user]: Amaterasu!", "combat_output")

				if (user.sharingan==2)
					spawn()
						var/eicon='icons/amaterasu.dmi'
						var/estate=""
						var/conmult = user.ControlDamageMultiplier()
						var/mob/human/player/etarget = user.NearestTarget()

						if(!etarget)
							etarget=straight_proj2(eicon,estate,8,user)
							if(etarget)
								var/ex=etarget.x
								var/ey=etarget.y
								var/ez=etarget.z
								spawn()AOE(ex,ey,ez,1,(3000 +300*conmult),20,user,3,1,1)
						else
							var/ex=etarget.x
							var/ey=etarget.y
							var/ez=etarget.z
							var/mob/x=new/mob(locate(ex,ey,ez))

							projectile_to(eicon,estate,user,x)
							del(x)
							spawn()AOE(ex,ey,ez,1,(3000 +300*conmult),20,user,3,1,1)
				else
					Error(user, "You need Mangekyou Sharingan activated to use this skill")

/*		amaterasu_explosion
			id = SASUKE_AMATERASU
			name = "Amaterasu Explosion"
			icon_state = "amaterasu"
			base_charge = 500
			default_cooldown = 300
			default_seal_time = 15



			Use(mob/user)
				viewers(user) << output("[user]: Amaterasu Explosion!", "combat_output")
				var/range=1 //200
				while(charge>base_charge && range<10)
					range+=1
					charge-=base_charge
				spawn()AmatCircle(user.x,user.y,user.z,range,user)*/

