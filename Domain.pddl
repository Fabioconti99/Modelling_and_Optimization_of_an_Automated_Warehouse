;;;;;;;;;;;;;;;;; ARTIFICIAL INTELLIGENCE FOR ROBOTICS 2 ASSIGNMENT ;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;                 A.A. 2021/2022                    ;;;;;;;;;;;;;;;;;;;;;;;;
;;; The following code has been developed by:                                            ;;;
;;;     - Matteo Carlone (S4652067)                                                      ;;;
;;;     - Fabio Conti (S4693053)                                                         ;;;
;;;     - Alessandro Perri (S4476726)                                                    ;;;
;;;     - Luca Predieri (S4667708)                                                       ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (domain Warehouse_D)

	;; Defining types 

	(:types
		mover loader crate group
	)

	;;;;;;;;;;;;;;;;;

	;; PREDICATES

	(:predicates
		
		(different ?m1 - mover ?m2 - mover) ;Mover 'm1' is different from mover 'm2'
		(freetopoint ?m - mover) ;Mover 'm' is free to point a  crate
		(pointed ?m - mover ?c - crate) ;Mover 'm' has pointed a crate 'c'
		(readytotransport ?m - mover ?c - crate) ;Mover 'm' is ready to transport a crate 'c'
		(transporting ?m - mover ?c - crate) ;Mover 'm' is transporting a crate 'c'
		(readytodrop ?m - mover ?c - crate) ;Mover 'm' is ready to drop a crate 'c' at the laoding bay
		(crate_at_bay ?c - crate) ;Crate 'c' is at the loading bay
		(free_crate ?c - crate) ;Crate 'c' has not been taken yet
		(transported_light ?c - crate) ;The transported crate 'c' is light
		(co_transported ?c - crate) ;The transported crate 'c' is actually co-transported

		(freetogroup) ;True when there are no currently processing groups
		(busygroup) ;True when a certain group is being processed
		(available ?g - group) ;Group 'g' is available to be processed
		(group ?c - crate ?g - group) ;Crate 'c' belongs to the group 'g'
		(processing ?g - group) ;Group 'g' is being processed
		(not_grouped ?c - crate) ;Crate 'c' doesn't belong to any group 
		(no_active_groups) ;True when any group is being processed
		(fragile ?c - crate) ;Crate 'c' is fragile

		(free_bay) ;True when the loading bay is free
		(can_drop_light) ;True when the mover is allowed to drop a light crate to the loading bay
		(can_drop_heavy) ;True when the mover is allowed to drop a heavy crate to the loading bay
		
		
		(different_loaders ?l1 - loader ?l2 - loader) ;Loader 'l1' is different from loader 'l2'
		(cheap ?l - loader) ;Loader 'l' is the cheap one
		(free_loader ?l - loader) ;Loader 'l' is currently free to load a crate
		(loading_on_belt ?l - loader ?c - crate) ;Loader 'l' is loading the crate 'c' onto the conveyor belt
		(crate_delivered ?c - crate) ;Crate 'c' has been delivered to the conveyor belt
		

	    ;Boolean predicates needed to synchronize the events that state all the possible combination of the loaders in terms of its availability
		(event_1)
		(event_2)
		(event_3)
		(event_4)


	)

	;;;;;;;;;;;;;;;;;;;;;;

	;; FUNCTIONS

	(:functions
		(velocity ?m - mover) ;Velocity of the mover 'm'
		(distance_mover ?m - mover) ;Distance of the mover 'm' from the loading bay
		(distance_crate ?c - crate) ;Distance of the crate 'c' from the loading bay
		(weight ?c - crate) ;Weight of the crate 'c'
		(n_el ?g - group) ;Number of crates in group 'g'
		(n_el_processed ?g - group) ;Number of already processed creates in group 'g' 
		(crate_taken ?c - crate) ;Number of movers that have taken the crate 'c'
		(time_loader ?l - loader) ;Time needed to load the crate on the conveyor belt with the loader 'l'
		(battery ?m - mover) ;remaining battery of the mover 'm'

	)

	;;;;;;;;;;;;;;;;;;;;;

	;; PROCESSES

	;Process which simulates the motion of the mover from the bay to the pointed crate
	(:process move_to_crate
		:parameters (?m - mover ?c - crate)
		:precondition (and (pointed ?m ?c)(>(battery ?m)0))
		:effect (and
			(increase (distance_mover ?m)(* #t (velocity ?m)))
			(decrease(battery ?m)#t)
			)
			
	)

	;Process which simulates the motion of the mover from the just taken crate to the loading bay
	(:process move_to_bay
		:parameters (?m - mover ?c - crate)
		:precondition (and (transporting ?m ?c)(>(battery ?m)0))
		:effect (and (decrease(distance_mover ?m)(* #t (velocity ?m)))
				(decrease(battery ?m)#t)
			)
	)

	;Process which simulates the mechanism through which the crate is loaded up onto the conveyor belt
	(:process loader_at_work
		:parameters (?l - loader ?c - crate)
		:precondition (and (loading_on_belt ?l ?c)
							)
		:effect (and (decrease (time_loader ?l) #t)
		)
	)

	;Process which simulates the action of recharging
	(:process recharge
		:parameters (?m - mover)
		:precondition (and (<= (distance_mover ?m) 0)(< (battery ?m) 20)
							)
		:effect (and (increase (battery ?m) #t)
		)
	)


	;;;;;;;;;;;;

	;; EVENTS

	;Event which is triggered when the mover reaches the pointed crate
	(:event at_crate
		:parameters (?c - crate ?m - mover)
		:precondition (and (>=(distance_mover ?m)(distance_crate ?c))(pointed ?m ?c))

		:effect (and (not(pointed ?m ?c))
			(readytotransport ?m ?c)
			(assign(distance_mover ?m)(distance_crate ?c))
			)
	)

	;Event which is triggered when the mover turns back to the loading bay
	(:event at_bay
		:parameters (?c - crate ?m - mover)
		:precondition (and 
			(<=(distance_mover ?m)0)
			(transporting ?m ?c))

		:effect (and (not(transporting ?m ?c))
			(readytodrop ?m ?c)
			(assign(distance_mover ?m)0)
			)
	)



	;Event which is triggered when the crate is loaded up onto the conveyor belt
	(:event crate_on_belt

		:parameters (?c - crate ?l - loader)
		:precondition (and 
				(loading_on_belt ?l ?c)
				(<=(time_loader ?l)0)
		)
		:effect (and
				(not(loading_on_belt ?l ?c))
				(free_loader ?l)
				(crate_delivered ?c)
		)
	)


	;Event which is used to increase the function which takes into account the number of already processed crates in a group.
	;The number is increased only when the crate has not already been taken from the other mover.
	(:event increasing_n_els
		:parameters (?g - group ?c - crate)
		:precondition (and
			(=(crate_taken ?c)1)
			(processing ?g)
			(group ?c ?g)
		)

		:effect (and
			(increase (n_el_processed ?g) 1)
		)
	)

	;Event which interrupts the group pointing mechanism when all crates in that group have been processed.
	(:event stop_group_pointing
		:parameters (?g - group)
		:precondition (and
			(>=(n_el_processed ?g)(n_el ?g))
			(processing ?g)
			(busygroup)
		)

		:effect (and
			(not(processing ?g))
			(not (busygroup))
			(freetogroup)
			(no_active_groups)
		)
	)


	;Event which occurs when either the normal loader and the cheap one are not busy.
	;In this case, both light and heavy crates can be dropped to the loading bay.
	(:event normal_free_cheap_free
		:parameters (?l1 - loader ?l2 - loader)
		:precondition (and
			(not(cheap ?l1))
			(cheap ?l2)
			(free_loader ?l1)
			(free_loader ?l2)
			(different_loaders ?l1 ?l2)
			(event_1)
		)
		:effect (and
			(can_drop_light)
			(can_drop_heavy)
			(not (event_1))
			(event_2)
			(event_3)
			(event_4)
		)
	)

	;Event which occurs when the normal loader is free and the cheap one is busy.
	;In this case, both light and heavy crates can be dropped to the loading bay.
	(:event normal_free_cheap_busy
		:parameters (?l1 - loader ?l2 - loader)
		:precondition (and
			(not(cheap ?l1))
			(cheap ?l2)
			(different_loaders ?l1 ?l2)
			(free_loader ?l1)
			(not(free_loader ?l2))
			(event_2)
		)

		:effect (and
			(can_drop_light)
			(can_drop_heavy)
			(not (event_2))
			(event_1)
			(event_3)
			(event_4)
		)
	)

	;Event which occurs when the normal loader is busy and the cheap one is free.
	;In this case, only light crates can be dropped to the loading bay.
	(:event normal_busy_cheap_free
		:parameters (?l1 - loader ?l2 - loader)
		:precondition (and
			(cheap ?l2)
			(not(cheap ?l1))
			(different_loaders ?l1 ?l2)
			(not(free_loader ?l1))
			(free_loader ?l2)
			(event_3)
		)
		:effect (and
			(can_drop_light)
			(not (can_drop_heavy))
			(not (event_3))
			(event_2)
			(event_1)
			(event_4)

		)
	)

	;Event which occurs when either the normal loader and the cheap one are busy.
	;In this case, no crates can be dropped to the loading bay.
	(:event all_loaders_busy
		:parameters (?l1 ?l2 - loader)
		:precondition (and
			(not(free_loader ?l1))
			(not(free_loader ?l2))
			(different_loaders ?l1 ?l2)
			(not(cheap ?l1))
			(cheap ?l2)
			(event_4)
		)
		:effect (and
			(not(can_drop_light))
			(not(can_drop_heavy))
			(not (event_4))
			(event_2)
			(event_3)
			(event_1)
		)
	)


	;;;;;;;;;;;;;;;;;;;;;

	;; ACTIONS



	;Action called when the mover decides to point a certain crate.
	(:action pointing
		:parameters (?c - crate ?m - mover)
		:precondition (and (freetopoint ?m)
			(>(distance_crate ?c)0)
			(free_crate ?c)
			(not_grouped ?c)
			(no_active_groups)
		)

		:effect (and
			(pointed ?m ?c)
			(not(freetopoint ?m))
		)
	)

	;Action called when the mover decides to start processing a new group.
	(:action pointing_group
		:parameters (?g - group)
		:precondition (and
			(freetogroup)
			(available ?g)
		)
		:effect (and
			(not(freetogroup))
			(busygroup)
			(not (available ?g))
			(processing ?g)
			(not(no_active_groups))
		)
	)


	;Action called when the mover decides to point a certain crate which belongs to the current processed group.
	(:action group_pointing
		:parameters (?c - crate ?m - mover ?g - group)
		:precondition (and
			(group ?c ?g)
			(free_crate ?c)
			(>(distance_crate ?c)0)
			(freetopoint ?m)
			(processing ?g)
			(busygroup)
			(<(n_el_processed ?g)(n_el ?g))
		)
		:effect (and
			(pointed ?m ?c)
			(not(freetopoint ?m))
			(increase(crate_taken ?c)1)

		)
	)
	;Action called when a mover starts transporting a light crate. 
	;The velocity of the mover will be reduced directly proportional to the weight of the crate
	(:action transporting_light
		:parameters (?c - crate ?m - mover)
		:precondition (and (readytotransport ?m ?c)
			(<=(weight ?c)50)
			(free_crate ?c)
			(not(fragile ?c))
		)
		:effect (and (transporting ?m ?c)
			(not(readytotransport ?m ?c))
			(assign(velocity ?m) (/ 100 (weight ?c)) )
			(not(free_crate ?c))
			(transported_light ?c)
		)

	)

	;Action called when both movers are at the same light crate and decide to co-transport it.
	;The velocity of the movers will be reduced directly proportional to the weight of the crate.
	(:action co_transporting_light
		:parameters (?c - crate ?m1 - mover ?m2 - mover)
		:precondition (and (readytotransport ?m1 ?c)(readytotransport ?m2 ?c)
			(<=(weight ?c)50)
			(different ?m1 ?m2)
			(free_crate ?c)
		)
		:effect (and (transporting ?m1 ?c)(transporting ?m2 ?c)
			(not(readytotransport ?m1 ?c))
			(not(readytotransport ?m2 ?c))
			(assign(velocity ?m1) (/ 150 (weight ?c)) )
			(assign(velocity ?m2) (/ 150 (weight ?c)))
			(not(free_crate ?c))
			(co_transported ?c)
		)

	)

	;Action called when both movers are at the same heavy crate and decide to co-transport it.
	;The velocity of the movers will be reduced directly proportional to the weight of the crate.
	(:action co_transporting_heavy
		:parameters (?c - crate ?m1 - mover ?m2 - mover)
		:precondition (and (readytotransport ?m1 ?c)(readytotransport ?m2 ?c)
			(>(weight ?c)50)
			(different ?m1 ?m2)
			(free_crate ?c)
		)
		:effect (and (transporting ?m1 ?c)(transporting ?m2 ?c)
			(not(readytotransport ?m1 ?c))
			(not(readytotransport ?m2 ?c))
			(assign(velocity ?m1) (/ 100 (weight ?c)) )
			(assign(velocity ?m2) (/ 100 (weight ?c)))
			(not(free_crate ?c))(co_transported ?c)
		)
	)

	;Action called when a mover is arrived at the loading bay and it is possible to drop a light crate.
	;As one of the effects, the velocity of the mover is reset to 10.
	(:action dropping_light
		:parameters (?c - crate ?m - mover)
		:precondition (and 
			(readytodrop ?m ?c)
			(transported_light ?c)
			(can_drop_light)
			(free_bay)
		)
		:effect (and 
			(not(readytodrop ?m ?c))
			(crate_at_bay ?c)
			(freetopoint ?m)
			(not(free_bay))
			(assign(velocity ?m)10 )
		)
	)

	;Action called when the two movers are arrived at the loading bay and it is possible to co-drop a light crate.
	;As one of the effects, the velocity of the movers is reset to 10.
	(:action co_dropping_light

		:parameters (?c - crate ?m1 - mover ?m2 - mover)
		:precondition (and (readytodrop ?m1 ?c)
			(readytodrop ?m2 ?c)
			(different ?m1 ?m2)
			(co_transported ?c)
			(<=(weight ?c)50)
			(free_bay)
			(can_drop_light))

		:effect (and 
			(not(readytodrop ?m1 ?c))
			(not(readytodrop ?m2 ?c))
			(freetopoint ?m1)
			(freetopoint ?m2)
			(crate_at_bay ?c)
			(not(free_bay))
			(assign(velocity ?m1)10 )
			(assign(velocity ?m2)10 )
		)
	)

	;Action called when the two movers are arrived at the loading bay and it is possible to co-drop a heavy crate.
	;As one of the effects, the velocity of the movers is reset to 10.
	(:action co_dropping_heavy

		:parameters (?c - crate ?m1 - mover ?m2 - mover)
		:precondition (and 
			(readytodrop ?m1 ?c)
			(readytodrop ?m2 ?c)
			(different ?m1 ?m2)
			(co_transported ?c)
			(>(weight ?c)50)
			(free_bay)
			(can_drop_heavy))

		:effect (and 
			(not(readytodrop ?m1 ?c))
			(not(readytodrop ?m2 ?c))
			(freetopoint ?m1)
			(freetopoint ?m2)
			(crate_at_bay ?c)
			(not(free_bay))
			(assign(velocity ?m1)10 )
			(assign(velocity ?m2)10 )
		)
	)


	;Action which triggers the mechanism through which the normal loader starts loading a certain (not fragile) crate onto the conveyor belt.
	(:action activate_loader_normal

		:parameters (?c - crate ?l - loader)
		:precondition (and 
			(crate_at_bay ?c)
			(free_loader ?l)
			(not(cheap ?l))
			(not(fragile ?c))
			(not(free_bay))
		)
		:effect (and
			(loading_on_belt ?l ?c)
			(not(free_loader ?l))
			(not(crate_at_bay ?c))
			(assign(time_loader ?l)4)
			(free_bay)
		)
	)

	;Action which triggers the mechanism through which the cheap loader starts loading a certain (not fragile) crate onto the conveyor belt.
	(:action activate_loader_cheap

		:parameters (?c - crate ?l - loader)
		:precondition (and 
			(crate_at_bay ?c)
			(free_loader ?l)
			(cheap ?l)
			(<=(weight ?c)50)
			(not(fragile ?c))
			(not(free_bay))
		)
		:effect (and
			(loading_on_belt ?l ?c)
			(not(free_loader ?l))
			(not(crate_at_bay ?c))
			(assign(time_loader ?l)4)
			(free_bay)
		)
	)


	;Action which triggers the mechanism through which the normal loader starts loading a fragile crate onto the conveyor belt.
	(:action activate_loader_fragile_normal

		:parameters (?c - crate ?l - loader)
		:precondition (and 
			(crate_at_bay ?c)
			(free_loader ?l)
			(fragile ?c)
			(not (cheap ?l))
			(not(free_bay))
		)
		:effect (and
			(loading_on_belt ?l ?c)
			(not(free_loader ?l))
			(not(crate_at_bay ?c))
			(assign(time_loader ?l)6)
			(free_bay)
		)
	)

	;Action which triggers the mechanism through which the cheap loader starts loading a fragile crate onto the conveyor belt.
	(:action activate_loader_fragile_cheap

		:parameters (?c - crate ?l - loader)
		:precondition (and 
			(crate_at_bay ?c)
			(free_loader ?l)
			(cheap ?l)
			(<=(weight ?c)50)
			(fragile ?c)
			(not(free_bay))
		)
		:effect (and
			(loading_on_belt ?l ?c)
			(not(free_loader ?l))
			(not(crate_at_bay ?c))
			(assign(time_loader ?l)6)
			(free_bay)
		)
	)


)