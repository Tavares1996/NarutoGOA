skill
	wood
		copyable = 0





		wood_chamber
			id = WOOD_CHAMBER
			name = "Hidden Jutsu: Wood Chamber"
			icon_state = "Chamber"
			default_chakra_cost = 100
			default_cooldown = 40
			default_seal_time = 5




			IsUsable(mob/user)
				. = ..()
				if(.)
					if(!user.MainTarget())
						Error(user, "No Target")
						return 0


			Use(mob/human/user)
				user.stunned=1
				viewers(user) << output("[user]: Hidden Jutsu: Wood Chamber!", "combat_output")

				var/mob/human/player/etarget = user.MainTarget()
				if(!etarget)
					for(var/mob/human/M in oview(1))
						if(!M.protected && !M.ko)
							etarget=M
				if(etarget)
					var/ex=etarget.x
					var/ey=etarget.y
					var/ez=etarget.z
					spawn()Wood_Cage(ex,ey,ez,100)
					sleep(4)
					if(etarget)
						if(ex==etarget.x&&ey==etarget.y&&ez==etarget.z)
							etarget.stunned=10
							etarget.layer=MOB_LAYER-1
							etarget.paralysed=1
							spawn()
								while(etarget&&ex==etarget.x&&ey==etarget.y&&ez==etarget.z)
									sleep(2)
								if(etarget)
									etarget.paralysed=0
									etarget.stunned=0
							spawn(100)
								if(etarget)
									etarget.paralysed=0


		hidden_wood
			id = WOOD_SPIKES
			name = "Hidden Jutsu: Wood Spikes"
			icon_state = "spike"
			default_chakra_cost = 10
			default_cooldown = 2




			IsUsable(mob/user)
				. = ..()
				var/mob/human/target = user.MainTarget()
				if(.)
					if(!target)
						Error(user, "No Target")
						return 0
					var/distance = get_dist(user, target)
					if(distance > 10)
						Error(user, "Target too far ([distance]/10 tiles)")
						return 0


			Use(mob/human/user)
				flick("Seal",user)

				var/hit=0
				var/mob/human/player/etarget = user.MainTarget()
				if(etarget)
					if(!etarget.protected && !etarget.ko)
						hit=1
				if(hit)
					var/conmult = user.ControlDamageMultiplier()
					var/mob/human/clay/woods/B=new/mob/human/clay/woods(locate(etarget.x-2,etarget.y,etarget.z),rand(1200,(1800+300*conmult)),user)
					var/mob/human/clay/woods/A=new/mob/human/clay/woods(locate(etarget.x+2,etarget.y,etarget.z),rand(1200,(1800+300*conmult)),user)
					var/mob/human/clay/woods/C=new/mob/human/clay/woods(locate(etarget.x,etarget.y-2,etarget.z),rand(1200,(1800+300*conmult)),user)
					var/mob/human/clay/woods/D=new/mob/human/clay/woods(locate(etarget.x,etarget.y+2,etarget.z),rand(1200,(1800+300*conmult)),user)
					spawn(1)Poof(D.x,D.y,D.z)
					spawn(3)Homing_Projectile_bang(user,D,8,etarget,1)
					spawn(1)Poof(C.x,C.y,C.z)
					spawn(3)Homing_Projectile_bang(user,C,8,etarget,1)
					spawn(1)Poof(B.x,B.y,B.z)
					spawn(3)Homing_Projectile_bang(user,B,8,etarget,1)
					spawn(1)Poof(A.x,A.y,A.z)
					spawn(3)Homing_Projectile_bang(user,A,8,etarget,1)
					spawn(50)
						if(B)
							flick("bubble-pop",B)
							B.Explode()
						if(A)
							flick("bubble-pop",A)
							A.Explode()
						if(C)
							flick("bubble-pop",C)
							A.Explode()
						if(D)
							flick("bubble-pop",D)
							A.Explode()


		growing_wood
			id = GROW_WOOD
			name = "Hidden Jutsu: Growing Wood"
			icon_state = "dragonfire"
			default_chakra_cost = 500
			default_cooldown = 70
			default_seal_time = 7



			Use(mob/human/user)
				user.icon_state="Seal"
				viewers(user) << output("[user]: Hidden Jutsu: Growing Wood Jutsu!", "combat_output")
				user.stunned=15
				var/obj/trailmaker/o=new/obj/trailmaker/grow_wood()
				o.layer=MOB_LAYER+2

				var/mob/result=Trail_Straight_Projectile(user.x,user.y,user.z,user.dir,o,14,user)
				if(result)
					result.move_stun=100

					spawn(45)
						del(o)
						user.stunned=0
						if(result)result.move_stun=0
					o.overlays+=image('icons/gwood2.dmi',icon_state="hurt")
					var/turf/T=result.loc
					var/conmult = user.ControlDamageMultiplier()
					result.Dec_Stam(rand(1500,2000)+500*conmult,0,user)
					spawn()result.Wound(rand(5,10)+round(conmult),0,user)
					var/ie=3
					while(result&&T==result.loc && ie>0)
						ie--
						result.Dec_Stam(rand(250,600)+50*conmult,0,user)
						spawn()result.Wound(rand(1,3)+round(conmult/2),0,user)
						spawn()result.Hostile(user)
						sleep(15)

				else
					user.stunned=0
				user.icon_state=""





		snake
			id = SNAKE_SUMMON
			name = "Hidden Jutsu: Growing Wood"
			icon_state = "dragonfire"
			default_chakra_cost = 500
			default_cooldown = 70
			default_seal_time = 7




			Use(mob/human/user)
				user.stunned=5
				viewers(user) << output("[user]: Water: Collision Destruction!", "combat_output")

				var/conmult = user.ControlDamageMultiplier()
				var/mob/human/player/etarget = user.MainTarget()
				if(etarget)
					user.icon_state="Seal"
					var/turf/L=etarget.loc
					sleep(5)
					var/hit=0
					if(L && L==etarget.loc)
						hit=1
						etarget.stunned=7
						user.stunned=7

					var/obj/O =new(locate(L.x,L.y,L.z))
					O.layer=MOB_LAYER+3
					O.overlays+=image('icons/oro_snake_attack.dmi',pixel_x=0,pixel_y=0)
					var/found=0

					for(var/obj/Water/X in oview(4,user))
						found++
						break
					if(found>10)found=10
					if(hit && etarget)
						etarget.Dec_Stam((1400 + 400*conmult + found*50),0,user)
						spawn()etarget.Hostile(user)
					sleep(50)
					if(etarget)etarget.stunned=0
					user.stunned=0

					if(O)del(O)




		shukaku
			id = SHUKAKU_PUSESSION
			name = "Shukaku Posession"
			icon_state = "shukau"
			default_chakra_cost = 10
			default_cooldown = 200


			IsUsable(mob/user)
				. = ..()
				if(.)
					if(user.sharingan)
						Error(user, "Your power is already awaken")
						return 0


			Cooldown(mob/user)
				return default_cooldown


			Use(mob/user)
				viewers(user) << output("[user]:Shukaku Posession!!", "combat_output")
				user.overlays+='icons/shukaku.dmi'
				user.overlays+=image('icons/1tl.dmi',pixel_x=-32)
				user.overlays+=image('icons/1tr.dmi',pixel_x=32)
				user.overlays+=image('icons/1tb.dmi',pixel_y=-32)
				user.overlays+=image('icons/1tbl.dmi',pixel_x=-32,pixel_y=-32)
				user.overlays+=image('icons/1tbr.dmi',pixel_x=32,pixel_y=-32)
				user.overlays+=image('icons/1ttl.dmi',pixel_x=-32,pixel_y=32)
				user.overlays+=image('icons/1tt.dmi',pixel_y=32)
				user.overlays+=image('icons/1ttr.dmi',pixel_x=32,pixel_y=32)
				user.immortality=900

				var/buffstr=round(user.str*19.9999)
				var/buffcon=round(user.con*19.9999)
				var/buffrfx=round(user.rfx*19.9999)
				var/buffint=round(user.int*19.9999)

				user.strbuff+=buffstr
				user.conbuff+=buffcon
				user.rfxbuff+=buffrfx
				user.intbuff+=buffint
				user.Affirm_Icon()

				spawn(Cooldown(user)*10)
					if(!user) return
					user.overlays-='icons/shukaku.dmi'
					user.overlays-=image('icons/1tl.dmi',pixel_x=-32)
					user.overlays-=image('icons/1tr.dmi',pixel_x=32)
					user.overlays-=image('icons/1tb.dmi',pixel_y=-32)
					user.overlays-=image('icons/1tbl.dmi',pixel_x=-32,pixel_y=-32)
					user.overlays-=image('icons/1tbr.dmi',pixel_x=32,pixel_y=-32)
					user.overlays-=image('icons/1ttl.dmi',pixel_x=-32,pixel_y=32)
					user.overlays-=image('icons/1tt.dmi',pixel_y=32)
					user.overlays-=image('icons/1ttr.dmi',pixel_x=32,pixel_y=32)

					user.strbuff-=round(buffstr)
					user.conbuff-=round(buffcon)
					user.rfxbuff-=round(buffrfx)
					user.intbuff-=round(buffint)

					user.special=0

					user.Affirm_Icon()
					user.combat("Your Power is now asleep")




	/*	Yonbi
			id = YONBI
			name = "Yonbi Awakening"
			icon_state = "shukau"
			default_chakra_cost = 10
			default_cooldown = 200


			IsUsable(mob/user)
				. = ..()
				if(.)
					if(user.sharingan)
						Error(user, "Your power is already awaken")
						return 0


			Cooldown(mob/user)
				return default_cooldown


			Use(mob/user)
				viewers(user) << output("[user]:Awake 4 Tailed Beast, Yonbi!!", "combat_output")
				user.overlays+='icons/yonbim2.dmi'
				user.overlays+=image('icons/yonbim1.dmi',pixel_x=-32)
				user.overlays+=image('icons/yonbir.dmi',pixel_x=32)
				user.overlays+=image('icons/tonbimb2.dmi',pixel_y=-32)
				user.overlays+=image('icons/yonbimb1.dmi',pixel_x=-32,pixel_y=-32)
				user.overlays+=image('icons/yonbirb.dmi',pixel_x=32,pixel_y=-32)
				user.overlays+=image('icons/yonbimt1.dmi',pixel_x=-32,pixel_y=32)
				user.overlays+=image('icons/yonbimt2.dmi',pixel_y=32)
				user.overlays+=image('icons/yonbirt.dmi',pixel_x=32,pixel_y=32)
				user.overlays+=image('icons/yonbilt.dmi',pixel_x=-64,pixel_y=32)
				user.overlays+=image('icons/yonbil.dmi',pixel_x=-64)
				user.overlays+=image('icons/yonbilb.dmi',pixel_x=-64,pixel_y=-32)
				user.overlays+=image('icons/yonbimlb2.dmi',pixel_y=-64)
				user.overlays+=image('icons/yonbimlb1.dmi',pixel_x=-32,pixel_y=-64)
				user.overlays+=image('icons/yonbillb.dmi',pixel_x=-64,pixel_y=-64)
				user.overlays+=image('icons/yonbirlb.dmi',pixel_x=32,pixel_y=-64)
				user.overlays+=image('icons/yonbimtm2.dmi',pixel_y=64)
				user.overlays+=image('icons/yonbimtm1.dmi',pixel_x=-32,pixel_y=64)
				user.overlays+=image('icons/yonbiltm.dmi',pixel_x=-64,pixel_y=64)
				user.overlays+=image('icons/yonbirtm.dmi',pixel_x=32,pixel_y=64)

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
					user.overlays-='icons/yonbim2.dmi'
					user.overlays-=image('icons/yonbim1.dmi',pixel_x=-32)
					user.overlays-=image('icons/yonbir.dmi',pixel_x=32)
					user.overlays-=image('icons/tonbimb2.dmi',pixel_y=-32)
					user.overlays-=image('icons/yonbimb1.dmi',pixel_x=-32,pixel_y=-32)
					user.overlays-=image('icons/yonbirb.dmi',pixel_x=32,pixel_y=-32)
					user.overlays-=image('icons/yonbimt1.dmi',pixel_x=-32,pixel_y=32)
					user.overlays-=image('icons/yonbimt2.dmi',pixel_y=32)
					user.overlays-=image('icons/yonbirt.dmi',pixel_x=32,pixel_y=32)
					user.overlays-=image('icons/yonbilt.dmi',pixel_x=-64,pixel_y=32)
					user.overlays-=image('icons/yonbil.dmi',pixel_x=-64)
					user.overlays-=image('icons/yonbilb.dmi',pixel_x=-64,pixel_y=-32)
					user.overlays-=image('icons/yonbimlb2.dmi',pixel_y=-64)
					user.overlays-=image('icons/yonbimlb1.dmi',pixel_x=-32,pixel_y=-64)
					user.overlays-=image('icons/yonbillb.dmi',pixel_x=-64,pixel_y=-64)
					user.overlays-=image('icons/yonbirlb.dmi',pixel_x=32,pixel_y=-64)
					user.overlays-=image('icons/yonbimtm2.dmi',pixel_y=64)
					user.overlays-=image('icons/yonbimtm1.dmi',pixel_x=-32,pixel_y=64)
					user.overlays-=image('icons/yonbiltm.dmi',pixel_x=-64,pixel_y=64)
					user.overlays-=image('icons/yonbirtm.dmi',pixel_x=32,pixel_y=64)

					user.strbuff-=round(buffstr)
					user.conbuff-=round(buffcon)
					user.rfxbuff-=round(buffrfx)
					user.intbuff-=round(buffint)

					user.special=0

					user.Affirm_Icon()
					user.combat("Your Power is now asleep")*/