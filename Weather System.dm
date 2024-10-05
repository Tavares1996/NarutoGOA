var
	lit = 1// determines if the area is lit or dark.
	obj/weather/Weather	// what type of weather the area is having
area
	outside// lay this area on the map anywhere you want it to change from night to day
		layer = 15
		mouse_opacity=0// set this layer above everything else so the overlay obscures everything
		proc
			daycycle()
				/*overlays += 'entardecer.dmi'	// add a 25% dither for a fading effect
				world<<"It's gonna be dark soon"
				sleep(3000)
				overlays -= 'entardecer.dmi'	// remove the dither
				overlays += 'black50.dmi'	// add the 50% dither
				world<<"It's now Night"
				sleep(12000)
				overlays -= 'black50.dmi'	// add the 50% dither
				overlays += 'amanhecer.dmi'
				world<<"It is gets bright"
				sleep(3000)
				overlays -= 'amanhecer.dmi'
				world<<"It's a new day!"
				sleep(12000)*/
				overlays -= 'amanhecer.dmi'	// add a 25% dither for a fading effect
				world<<"It's a new day"
				sleep(24000)
				overlays += 'entardecer.dmi'	// remove the dither
				world<<"It's going to be dark soon"
				sleep(6000)
				overlays -= 'entardecer.dmi'	// remove the dither
				overlays += 'black50.dmi'	// add the 50% dither
				world<<"It's now Night"
				sleep(24000)
				overlays -= 'black50.dmi'	// add the 50% dither
				overlays += 'amanhecer.dmi'
				world<<"It's getting bright"
				sleep(6000)
				daycycle()	// change the 20 to make longer days and night

			SetWeather(WeatherType)
				if(Weather)	// see if this area already has a weather effect
					if(istype(Weather,WeatherType)) return	// no need to reset it
					overlays -= Weather	// remove the weather display
					del(Weather)	// destroy the weather object
				if(WeatherType)	// if WeatherType is null, it just removes the old settings
					Weather = new WeatherType()	// make a new obj/weather of the right type
					overlays += Weather	// display it as an overlay for the area

//mob/Weather_controll/verb
mob/MasterdanVerb/verb
	Heavy_rain()
		var/area/outside/O
		for(O in world)		// look for an outside area
			break
		if(!O) return	// if there are no outside areas, stop
		O.SetWeather(/obj/weather/rain)
	rain()
		var/area/outside/O
		for(O in world)		// look for an outside area
			break
		if(!O) return	// if there are no outside areas, stop
		O.SetWeather(/obj/weather/rain)
	Light_rain()
		var/area/outside/O
		for(O in world)		// look for an outside area
			break
		if(!O) return	// if there are no outside areas, stop
		O.SetWeather(/obj/weather/rain2)
	snow()
		var/area/outside/O
		for(O in world)		// look for an outside area
			break
		if(!O) return	// if there are no outside areas, stop
		O.SetWeather(/obj/weather/snow)
	Sand_Storm()
		var/area/outside/O
		var/area/pkzone/Cha/Cha
		for(O in world)		// look for an outside area
			break
		for(Cha in world)
			break
		if(!O) return	// if there are no outside areas, stop
		O.SetWeather(/obj/weather/Sand_Storm)
		if(!Cha) return
		Cha.SetWeather2(/obj/weather/Sand_Storm)

	Blackout()
		var/area/outside/O
		for(O in world)		// look for an outside area
			break
		if(!O) return	// if there are no outside areas, stop
		O.SetWeather(/obj/weather/blackout)
	clear_weather()
		var/area/outside/O
		for(O in world)		// look for an outside area
			break
		if(!O) return	// if there are no outside areas, stop
		O.SetWeather()
	daycicle()
		var/area/outside/O
		for(O in world)		// look for an outside area
			O.daycycle()



obj/weather
	layer = 15
	mouse_opacity=0	// weather appears over the darkness because I think it looks better that way
	Sand_Storm
		icon = 'weather.dmi'
		icon_state = "storm"
	rain
		icon = 'weather.dmi'
		icon_state = "Rain"
	rain2
		icon = 'weather.dmi'
		icon_state = "LRain"
	snow
		icon = 'weather.dmi'
		icon_state = "Snow"
	blackout
		icon = 'weather.dmi'
		icon_state = "black"



obj/Othershit
//	Lamp1
	//	icon = 'lamp.dmi'
	//	icon_state = "lamp2"
//	Flare
	//	icon = 'LampFlare.PNG'