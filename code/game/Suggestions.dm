mob/human/player
	verb
		Suggestion()//The verb!
			set category = "Character"
			//All this is basic stuff, inputs, and checks to make sure no one abuses this to the max and just spams it
			var/reportcategory = input("Making a suggestion, go with whatever category your suggestionn is supposed to be in.","File Report")\
			in list("Bug / Glitch","Map / Villages","Nerfs / Buffs","New Jutsus","Other","Cancel")
			var/reportname = input("Please name your Suggestion.","Suggestion Name") as text | null
			set category = "Other"
			if(!reportname)
				usr<<"<small><b><font color=red>Your report failed to send, beause it has no name</font color></b></small>"
				return
			if(length(reportname) > 50)
				usr<<"<small><b><font color=red>Your report failed to send, because it was longer than 50 characters</font color></b></small>"
				return
			var/reportdesc = input("Now please describe your Suggestion\n- Your IP, Key, and Name are being logged","Explanation") as text | null
			if(!reportdesc)
				usr<<"<small><b><font color=red>Your report failed to send, because it had no explanation</font color></b></small>"
				return
			//Log the report in the list so it can be later viewed!
			Reports+="[time2text(world.realtime)] - <b>[reportcategory]</b> [usr.client.address] - [usr] ([usr.key])<br><b><u>[html_encode(reportname)]</u></b><br>[html_encode(reportdesc)]<br>---"
			usr<<"<small><b>Your suggestion has been sent and will be read.</b></small>"//Tell them that their report was successfully sent

proc //the Proc!
	ServerSave()// Proc name so we can call it to save the reports
		if(length(Reports))//If there are any reports in the list
			var/savefile/F = new("Server Saves/Reports.sav")// Makes a save file for them to go to
			F["Reports"] << Reports//Writes the reports so they can be loaded later
	ServerLoad()// Proc name so we can call it to load the reports
		if(fexists("Server Saves/Reports.sav"))// if there is a file that has reports
			var/savefile/F = new("Server Saves/Reports.sav")// load all the reports so you can view them
			F["Reports"] >> Reports//just gives the reports back into the list

world
	New()
		ServerLoad()//Load the reports if there are any!
		..()
	Del()
		ServerSave()//Save them so we can load them later or even view them later
		..()
var
	list
		Reports = list()// The list we use to put all the reports in!

mob
	Admin
		verb
			Read_Suggestion()
				set category = "Admin"
				var/list/suggestions = new
				suggestions += "Cancel"
				for(var/x in Reports)
					suggestions += x
				var/read = input("Which one would you like to read") as anything in suggestions
				if(read == "Cancel")
					return
				usr << browse(read,"window=browser-popup")
