(define (domain Warehouse_D)

	;; Requirements

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	;; Defining types 

	(:types
		mover loader crate group
	)

	;;;;;;;;;;;;;;;;;

	;; Defining predicates

	(:predicates
		(transporting ?m - mover ?c - crate)
		(pointed ?m - mover ?c - crate)
		(freetopoint ?m - mover)
		(different ?m1 - mover ?m2 - mover)
		(readytotransport ?m - mover ?c - crate)
		(readytodrop ?m - mover ?c - crate)
		(crate_at_bay ?c - crate)
		(free_crate ?c - crate)
		(transported_light ?c - crate)
		(co_transported ?c - crate)

		(freetogroup)
		(busygroup)
		(available ?g - group)
		(group ?c - crate ?g - group)
		(processing ?g - group)
		(not_grouped ?c - crate)
		(no_active_groups)
		(fragile ?c - crate)

		(can_drop_light)
		(can_drop_heavy)
		(free_bay)
		
		(different_loaders ?l1 - loader ?l2 - loader)
		(free_loader ?l - loader)
		(loading_on_belt ?l - loader ?c - crate)
		(crate_delivered ?c - crate)
		(cheap ?l - loader)


		(event_1)
		(event_2)
		(event_3)
		(event_4)

		(recharging ?m - mover)

	)

	;;;;;;;;;;;;;;;;;;;;;;

	;; Defining Functions

	(:functions
		(velocity ?m - mover)
		(distance_mover ?m - crate)
		(distance_crate ?c - crate)
		(weight ?c - crate)
		(n_el ?g - group)
		(n_el_processed ?g - group)
		(crate_taken ?c - crate)
		(time_loader ?l - loader)
		(battery ?m - mover)

	)

	;;;;;;;;;;;;;;;;;;;;;

	;; Processes

	(:process move_to_crate
		:parameters (?m - mover ?c - crate)
		:precondition (and (pointed ?m ?c)(>(battery ?m)0))
		:effect (and
			(increase (distance_mover ?m)(* #t (velocity ?m)))
			(decrease(battery ?m)#t)
			)
			
	)

	(:process move_to_bay
		:parameters (?m - mover ?c - crate)
		:precondition (and (transporting ?m ?c)(>(battery ?m)0))
		:effect (and (decrease(distance_mover ?m)(* #t (velocity ?m)))
				(decrease(battery ?m)#t)
				)
	)

	(:process loader_at_work
		:parameters (?l - loader ?c - crate)
		:precondition (and (loading_on_belt ?l ?c)
							)
		:effect (and (decrease (time_loader ?l) #t)
		)
	)

	(:process recharge
		:parameters (?m - mover)
		:precondition (and (recharging ?m)
							)
		:effect (and (increase (battery ?m) #t)
			)
	)


	;;;;;;;;;;;;

	;Events

	(:event at_crate
		:parameters (?c - crate ?m - mover)
		:precondition (and (>=(distance_mover ?m)(distance_crate ?c))(pointed ?m ?c))

		:effect (and (not(pointed ?m ?c))
			(readytotransport ?m ?c)
			(assign(distance_mover ?m)(distance_crate ?c))
			)
	)
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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



	; Action

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

	(:action stop_recharging

		:parameters(?c - crate ?m - mover)

		:precondition(and (recharging ?m)(pointed ?m ?c))

		:effect (and (not(recharging ?m)))



	)

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

	(:action start_recharge

		:parameters (?m1 - mover ?m2 - mover)

		:precondition (and (<= (distance_mover ?m1) 0)
			(not(recharging ?m1))
			(different ?m1 ?m2)
			(< (battery ?m1) 20)
			)
		:effect(and (recharging ?m1))
	)

)