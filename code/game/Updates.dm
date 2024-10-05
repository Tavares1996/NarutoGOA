mob
	human/player
		verb
			ShowUpdates1()
				src.ShowUpdates()
mob
	proc
		ShowUpdates()
			var/updates={"
			<center>Big thanks to Naruke and Nui for getting the server back up.</center>
			<BR>
			<BR>
			<center>Updates #1</center>
			-Fixed Shunshin (It now acts as it used to)<BR>
			-Fixed Nara binding stun<BR>
			-Made an update log<BR>
			-Added Respec for $15,000<BR>
			-Mission cd is now 5 mins<BR>
			-Mission exp and money is buffed<BR>
			-Level cap is 100<BR>
			-Level point's returned to its original max 650,000<BR>
			-Increased Exploding Note cd to 30 seconds<BR>
			-Updated the update log<BR>
			<BR>
			<BR>
			<BR>
			<BR>
			<center>Updates #2</center>
			<BR>Doton Armor will not be affected by projectiles anymore
			<BR>Gates are no longer available to non Youths
			<BR>Sand Sheild will give wounds if attacked using Taijutsu
			<BR>Rasengan and Odama rasengan damage's will be shown initial to there knockback stun's
			<BR>Taijutsu critical ratio was buffed slightly from very rarley to rarley
			<BR>Slight Buff to ruthless boost, its damage var was greatly decresed due to a typo
			<BR>Arena target bug has been resolved
			<BR>Player names and Village icons will show up ontop of there head in text, also when targeted there village icon will be shown.
			<BR>
			<BR>
			<BR>
			<BR>
			<center>Updates #3 (Mostly Fixes)</center>
			<BR>Fixed Fear's durration and genjutsu block roll
			<BR>Fixed Nara binding cd, and its low static damage
			<BR>Fixed invisible airbullet
			<BR>Fixed moving handseal's
			<BR>Fixed Defending then trying to use F delay
			<BR>Fixed OOC button disappearing
			<BR>Added Suggestion's/Bug Fixes
			<BR>
			<BR>
			<BR>
			<BR>
			<center>Updates #4</center>
			<BR>Wind Sword is now two tiles but it will miss unless you are within two tiles of your target.
			<BR>Nerfed ctr's slowdown
			<BR>Instead of weakspot raising the chance by 5% to do 1-4 wounds it will now do 1-2
			<BR>Weapons supply cost now reflects how much weapons are thrown, needles = 5 ,shuriken = 3, kunai = 1
			<BR>SA now has a DMG cap of 2000 damage, until it breaks all damage will be done to Sand Armor (Excpet Blood Bind)
			<BR>
			<BR>
			<BR>
			<BR>
			<center>Updates #5</center>
			<BR>Akimichi pills now last 1:40 seconds (duration was to long thus killing you) and i lowered curry pills wounds no changes to spinach besides duration.
			<BR>New event called Team Deathmatch, Creates to teams and fight will one wins.
			<BR>Fixed Bs affecting Hyuuga's
			<BR>Healing will now cancel if you move or kawa.
			<BR>A-Ranks will be Npc only
			<BR>Added S-ranks PvP kills only
			<BR>Fixed some defending bug's
"}
			winshow(src, "browser-popup", 1)
			src<<browse(updates)

