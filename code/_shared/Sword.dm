mob
	MasterAdmin
		verb
			Give_Sword(var/mob/O in All_Clients())
				var/X = input(usr,"Please pick a sword you want to handout") in list ("Samehada","Zabuza","Kabutowari","Shibuki","Nuibari","Kiba","Hiramekarei","Hidan","Chakra Blade","Samurai Sword")
				if(X=="Samehada")
					new/obj/items/weapons/melee/sword/Samehada(O)
				if(X=="Zabuza")
					new/obj/items/weapons/melee/sword/ZSword(O)
				if(X=="Kabutowari")
					new/obj/items/weapons/melee/sword/Kabutowari(O)
				if(X=="Shibuki")
					new/obj/items/weapons/melee/sword/Shibuki(O)
				if(X=="Nuibari")
					new/obj/items/weapons/melee/sword/Nuibari(O)
				if(X=="Kiba")
					new/obj/items/weapons/melee/sword/Kiba(O)
				if(X=="Hiramekarei")
					new/obj/items/weapons/melee/sword/Hiramekarei(O)
				if(X=="Hidan")
					new/obj/items/weapons/melee/sword/HidanS(O)
				if(X=="Chakra Blade")
					new/obj/items/weapons/melee/sword/Chakra_Blade(O)
				if(X=="Samurai Sword")
					new/obj/items/weapons/melee/sword/SamuraiSword(O)

			Advertisement(var/T as text)
				set name = ".ad"
				msg = T
var
	msg = ""