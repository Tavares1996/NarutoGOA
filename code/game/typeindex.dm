proc/type2index(t)
	if(t)
		var/obj/T = new t()
		return T.code
proc/index2type(i)
	if(!i)
		return /obj/temporary
	var/mob/objserver/O=locate("oserver")
	if(!O)
		return /obj/temporary
	for(var/obj/X in O.contents)
		if(X.code==i)
			return X.type

world/New()
	..()
	spawn(30)
		var/mob/objserver/O = new(locate(29,93,2))
		O.tag = "oserver"


obj/temporary
	New()
		..()
		spawn(50)
			del(src)