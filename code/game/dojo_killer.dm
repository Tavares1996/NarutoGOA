mob/var
	list/oppo=new/list()
	tmp/risk=0

mob/proc/register_opponent(mob/human/O)
	var/K
	if(!src.client)return
	if(O.client && O.client.computer_id!=src.client.computer_id)
		K = O.client.computer_id
	else
		return
	if(!src.oppo["[K]"] || abs(time2hours()-src.oppo["[K]"]) >2)// now-then
		src.oppo["[K]"] = time2hours()
		if(src.risk < 3)
			++src.risk
			spawn(10*60*10)//10minutes
				if(src.risk>=1)
					--src.risk


proc/time2hours()
	var/D=text2num(time2text(world.realtime,"DD"))
	var/H=text2num(time2text(world.realtime,"hh"))
	return D*24 + H
