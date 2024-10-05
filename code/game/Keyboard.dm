
// File:    keyboard.dm
// Library: Forum_account.Sidescroller
// Author:  Forum_account
//
// Contents:
//   This file handles keyboard input. It adds keyboard macros
//   at runtime which call the KeyUp and KeyDown verbs. These
//   verbs call the key_up and key_down procs which you can
//   override to create new input behavior.

mob
	var
		tmp/list/keys = list()
		tmp/list/movement_keys = list("north","east","south","west","northeast","northwest","southeast","southwest")
		input_lock = 0

	proc
		// You can override the key_down and key_up procs
		// to add new commands.
		key_down(k)
			if(k in movement_keys) if(!client.moving) client.Start_Move()

		key_up(k)
			..(k)

		// While input is locked the KeyUp/KeyDown verbs still get called
		// but they don't call the key_up/key_down procs.
		lock_input()
			input_lock += 1

		unlock_input()
			input_lock -= 1
			if(input_lock < 0)
				input_lock = 0

		clear_input(unlock_input = 1)
			if(unlock_input)
				input_lock = 0
			for(var/k in keys)
				keys[k] = 0

	// These verbs are called for all key press and release events,
	// k is the key being pressed or released.
	verb
		KeyDown(k as text)
			set hidden = 1
			set instant = 1
			if(input_lock) return

			keys[k] = world.time
			key_down(k)

		KeyUp(k as text)
			set hidden = 1
			set instant = 1

			keys[k] = 0
			if(input_lock) return

			key_up(k)
