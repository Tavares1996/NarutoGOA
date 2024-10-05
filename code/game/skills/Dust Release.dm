skill
	dust_release
		copyable = 0

		dust_release_detachment_of_the_primitive_world_technique_cubical_variant
			id = CUBICAL_VARIANT
			name = "Dust Release: Detachment of the Primitive World Technique (Cubical Variant)"
			icon_state = "cubical"
			default_chakra_cost = 600
			default_cooldown = 70
			default_seal_time = 10

			IsUsable(mob/user)
				. = ..()
				if(.)
					if(!user.MainTarget())
						Error(user, "No Target")
						return 0

			Use(mob/human/user)
				viewers(user) << output("[user]: Dust Release: Detachment of the Primitive World Technique!", "combat_output")
				var/conmult = user.ControlDamageMultiplier()
				var/mob/human/player/etarget = user.MainTarget()
				if(etarget)
					if(user)
						user.stunned=3
						user.icon_state="Seal"
						spawn(30)
							user.icon_state=""
					else if(!user) return
					var/obj/x=new/obj/expand(user.loc)
					sleep(5)
					del(x)
					var/obj/trailmaker/o=new/obj/dust/expansion
					var/mob/result=Trail_Homing_Projectile(user.x,user.y,user.z,user.dir,o,8,etarget)
					if(result)
						spawn(1)
							del(o)
						var/obj/f=new/obj/expansion(result.loc)
						result.stunned=100
						sleep(15)
						del(f)
						var/obj/g=new/obj/blast(result.loc)
						result.Dec_Stam((1500 + 600*conmult),0,user)
						result.Wound(rand(4,18))
						sleep(7)
						del(g)
						spawn()result.Hostile(user)
						result.stunned=0

obj
	dust
		expansion
			icon='icons/cubical_variant.dmi'
			icon_state="trail"

obj
	pp
		icon='icons/cubical_variant.dmi'
		layer=MOB_LAYER+1
		New()
			..()
			flick("flick",src)
obj
	ll
		icon='icons/cubical_variant2.dmi'
		layer=MOB_LAYER+1
		icon_state="state 1"
		pixel_x=-16
		New()
			..()
			flick("expand 1",src)
	xx
		icon='icons/cubical_variant2.dmi'
		layer=MOB_LAYER+1
		icon_state="state 2"
		pixel_x=16
		New()
			..()
			flick("expand 2",src)
	yy
		icon='icons/cubical_variant2.dmi'
		layer=MOB_LAYER+1
		icon_state="state 3"
		pixel_x=-16
		pixel_y=32
		New()
			..()
			flick("expand 3",src)
	zz
		icon='icons/cubical_variant2.dmi'
		layer=MOB_LAYER+1
		icon_state="state 4"
		pixel_x=16
		pixel_y=32
		New()
			..()
			flick("expand 4",src)
obj
	aa
		icon='icons/cubical_variant2.dmi'
		layer=MOB_LAYER+1
		pixel_x=-16
		New()
			..()
			flick("blast 1",src)
	ss
		icon='icons/cubical_variant2.dmi'
		layer=MOB_LAYER+1
		pixel_x=16
		New()
			..()
			flick("blast 2",src)
	ff
		icon='icons/cubical_variant2.dmi'
		layer=MOB_LAYER+1
		pixel_x=-16
		pixel_y=32
		New()
			..()
			flick("blast 3",src)
	dd
		icon='icons/cubical_variant2.dmi'
		layer=MOB_LAYER+1
		pixel_x=16
		pixel_y=32
		New()
			..()
			flick("blast 4",src)

obj
	expand
		var/list/youtube=new
		New()
			spawn()..()
			spawn()
				youtube+=new/obj/pp(locate(src.x,src.y,src.z))
	expansion
		var/list/google=new
		New()
			spawn()..()
			spawn()
				google+=new/obj/ll(locate(src.x,src.y,src.z))
				google+=new/obj/xx(locate(src.x,src.y,src.z))
				google+=new/obj/zz(locate(src.x,src.y,src.z))
				google+=new/obj/yy(locate(src.x,src.y,src.z))
		Del()
			for(var/obj/x in src.google)
				del(x)
			..()
	blast
		var/list/facebook=new
		New()
			spawn()..()
			spawn()
				facebook+=new/obj/aa(locate(src.x,src.y,src.z))
				facebook+=new/obj/ss(locate(src.x,src.y,src.z))
				facebook+=new/obj/dd(locate(src.x,src.y,src.z))
				facebook+=new/obj/ff(locate(src.x,src.y,src.z))