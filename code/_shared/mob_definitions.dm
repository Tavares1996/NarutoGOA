mob
	var
		tmp/skinowner = 0
		canwalk=1
		Tank=0
		list/bloodrem=new
		skillusecool=0
		tmp/hassword=0
		pressured=0
		nopktime=0
		scalpol=0
		shunshin=0
		auto_ai = 1
		usedrespec=0
		scalpoltime=0
		tsupunch=0
		sakpunch2=0
		bonedrill=0
		senjublood = 0
		bonedrilluses=0
		sakpunch=0
		tmp/transform_chat_icon=""
		qued2=0
		tmp/loggedin = 0
		tmp/loggingout = 0
		tmp/alertcool=0
		tmp/replacement_active
		tmp/turf/replacement_loc
		tmp/combatflago
		tmp/combatflagd
		tmp/burning=0
		tmp/burndur=0
		tmp/burner=null
		tmp/burnid=null
		tmp/build_creating = 0
		tmp/build_level = 0
		cantreact=0
		MissionCool=0
		list/player_gui=new
		Hastargetpos=0
		kstun=0
		surname=""
		firstname=""
		respec = 0
		adren=0
		astrbuff=0
		arfxbuff=0
		aconbuff=0
		movepenalty=0
		lastwitnessing=0
		list/pins=new
		projectileblocking=0
		maxsupplies=100
		Poison=0
		Recovery=0
		mob/human/Puppet/Puppet1=0
		mob/human/Puppet/Puppet2=0
		phenged=0
		Primary=0
		votecool=0
		votecool2=0
		FU=0
		zetsu=0
		movedrecently=0
		medicing=0
		hasjoinverb=0
		hasleaveverb=0
		incombo=0
		AFK=0
		AFK2=0
		overband=0
		Aki=0
		qued=0
		demonmirrored=0
		list/Imgs=new
		usemove=0
		tajuu=0
		larch=0
		//mission
		leading=0
		disp
		cutchakra=0
		MissionClass
		mob/MissionTarget
		TargetLocation
		MissionTime
		MissionTimeLeft
		lightning = 0
		MissionType
		MissionLocation
		Missionstatus=0
		Rank_A=0
		Rank_S=0
		Rank_B=0
		Rank_C=0
		Rank_D=0
		pay=0
		//end mission
		realname
		henged=0
		haschuuninwatch=0
		cexam=0
		frozen=0
		inchuunin=0
		sleeping=0
		curpick=0
		tmp/sandarmor
		list/pet=new
		factionpoints=0
		hasbonesword=0
		initialized=0
		rank="Genin"
		rankgrade=0 //0 academy student, 1 gennin, 2 chuunin, 3 special jounin / 4 Jounin/ 5 Anbu/ 6 Anbu Capitain/ 7 Elite jounin/ 8 Sannin
		targetpractice=0
		protected=0
		screener=new/list()
		lasthostile=0
		bounty=0
		boneharden=0
		dojo=0
		oldx
		oldy
		oldz
		inarena=0
		spectate=0
		elfasto=0
		has_tourney_verbs=0
		allowrespec=0
		allowdrespec=0
		//oocverbs
		mute=0
		tempmute=0
		talkcool=0
		talktimes=0
		talkcooling=0
		say=1

		//olays
		weapon[]
		undershirt
		overshirt
		armor
		pants
		legarmor
		armarmor
		facearmor
		foreheadarmor
		glasses
		cloak
		back
		shoes
		special
		hair_type=0
		hair_color="Black"
		//non olay
		runlevel=0
		kaiten=0
		gatestress=0
		gatetime=0
		gatepwn=0
		gate=0
		sharingan=0
		sage=0
		bandaged=0
		canattack=1
		busy=0
		soldierpill=0
		targetable=1
		mane=0
		maned=0
		mole=0
		rasengan=0
		chakrablocked=0
		gentlefist=0
		asleep=0
		shopping=0
		resurrection=0
		eye_r=0
		eye_g=0
		eye_b=0
		pk=0
		nudge=0
		skill
			macro1
			macro2
			macro3
			macro4
			macro5
			macro6
			macro7
			macro8
			macro9
			macro10


		tmp/hidestat=0
		skillpoints=0
		levelpoints=0
		tmp/pstr=0
		tmp/pcon=0
		tmp/pint=0
		tmp/prfx=0
		tmp/controlmob=0
		tmp/paralysed=0
		tmp/waterlogged=0
	//	tmp/targetaddress=0
		mob/target=0
		tmp/canmove=1
		money=0
		stamina = 1000
		curstamina=1000
		chakra =300
		curchakra=300
		str=50
		tmp/strbuff=0
		supplies=100
		tmp/strneg=0
		con=50
		tmp/byakugan=0
		tmp/conbuff=0
		tmp/makeswamp=0
		tmp/conneg=0
		rfx=50
		combomax=2
		tmp/rfxbuff=0
		tmp/rfxneg=0
		tmp/shun=0
		specialover=""
		int=50
		tmp/intbuff=0
		tmp/interact=0
		intneg=0
		maxwound=100
		curwound=0
		exp=0
		elevel=1
		body=0
		blevel=1
		injury[20]
		staminaregen=17 //%
		chakraregen=50 //pts
		skills[0]
		skillspassive[40]
		tmp/stunned=0
		tmp/attackbreak=0
		//backup
		backupoverlays[]
		backupicon=0
		backuptargetaddress=0
		ko=0
		//village="Missing"
		tmp/blocked=0
		tmp/kocheck=0
		tmp/usedelay=0
		ironskin=0
		icon_name="base_m1"
		playergender="male"
		tmp/swamplogged=0
		boneuses=0
		clan
		elements[0]
		tmp/gen_effective_int = 0
		tmp/gen_cancel_cooldown = 0
		tmp/move_stun = 0
		tmp/handseal_stun = 0
		tmp/gentle_fist_block = 0
		list/build_info
		//save_num = 1

	proc
		LocationEnter(dropoff)

	human/player
		npc

/*mob/human/var
	owner = 0
	bunshinowner = ""
	ownerkey = ""*/