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
		(loaded ?m - mover ?c - crate)
		(pointed ?m - mover ?c - crate)
		(freetopoint ?m)
		(different ?m1 - mover ?m2 - mover)
		(readytoload ?m ?c)
		(readytodrop ?m ?c)
		(free_bay)
		(crate_at_bay ?c - crate)
		(free_crate ?c - crate)
		(loaded_light ?c - crate)
		(co_loaded ?c - crate)

		(freetogroup)
		(busygroup)
		(available ?g)
		(group ?c - crate ?g - group)
		(processing ?g - group)
		(not_grouped ?c - crate)
		(no_active_groups)
		(fragile ?c - crate)

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

	)

	;;;;;;;;;;;;;;;;;;;;;

	;; Processes

	(:process move_to_crate
		:parameters (?m - mover ?c - crate)
		:precondition (and (pointed ?m ?c))
		:effect (increase
			(distance_mover ?m)
			(* #t (velocity ?m)))
	)

	(:process move_to_bay
		:parameters (?m - mover ?c - crate)
		:precondition (and (loaded ?m ?c))
		:effect (and (decrease
				(distance_mover ?m)
				(* #t (velocity ?m)))
			(decrease
				(distance_crate ?c)
				(* #t (velocity ?m)))
		)
	)

	;;;;;;;;;;;;

	;Events

	(:event at_crate
		:parameters (?c - crate ?m - mover)
		:precondition (and (>=(distance_mover ?m)(distance_crate ?c))(pointed ?m ?c))

		:effect (and (not(pointed ?m ?c))
			(readytoload ?m ?c))
	)
	(:event at_bay
		:parameters (?c - crate ?m - mover)
		:precondition (and (<=(distance_mover ?m)0)
			(<=(distance_crate ?c)0)(loaded ?m ?c))

		:effect (and (not(loaded ?m ?c))
			(readytodrop ?m ?c))
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

	(:action loading_light
		:parameters (?c - crate ?m - mover)
		:precondition (and (readytoload ?m ?c)
			(<=(weight ?c)50)
			(free_crate ?c)
			(not(fragile ?c))

		)

		:effect (and (loaded ?m ?c)
			(not(readytoload ?m ?c))
			(assign(velocity ?m) (/ 100 (weight ?c)) )
			(not(free_crate ?c))
			(loaded_light ?c)
		)

	)

	(:action co_loading_light
		:parameters (?c - crate ?m1 - mover ?m2 - mover)
		:precondition (and (readytoload ?m1 ?c)(readytoload ?m2 ?c)
			(<=(weight ?c)50)
			(different ?m1 ?m2)
			(free_crate ?c)
		)

		:effect (and (loaded ?m1 ?c)(loaded ?m2 ?c)
			(not(readytoload ?m1 ?c))
			(not(readytoload ?m2 ?c))
			(assign(velocity ?m1) (/ 150 (weight ?c)) )
			(assign(velocity ?m2) (/ 150 (weight ?c)))
			(not(free_crate ?c))
			(co_loaded ?c)
		)

	)

	(:action co_loading_heavy
		:parameters (?c - crate ?m1 - mover ?m2 - mover)
		:precondition (and (readytoload ?m1 ?c)(readytoload ?m2 ?c)
			(>(weight ?c)50)
			(different ?m1 ?m2)
			(free_crate ?c)
		)

		:effect (and (loaded ?m1 ?c)(loaded ?m2 ?c)
			(not(readytoload ?m1 ?c))
			(not(readytoload ?m2 ?c))
			(assign(velocity ?m1) (/ 100 (weight ?c)) )
			(assign(velocity ?m2) (/ 100 (weight ?c)))
			(not(free_crate ?c))(co_loaded ?c)
		)

	)

	(:action unloading

		:parameters (?c - crate ?m - mover)
		:precondition (and (readytodrop ?m ?c)(loaded_light ?c)
			(free_bay))

		:effect (and (not(readytodrop ?m ?c))(crate_at_bay  ?c)(freetopoint ?m)

			(assign(velocity ?m)10 )

		)

	)

	(:action co_unloading

		:parameters (?c - crate ?m1 - mover ?m2 - mover)
		:precondition (and (readytodrop ?m1 ?c)(readytodrop ?m2 ?c)(free_bay)(different ?m1 ?m2)(co_loaded ?c))
		:effect (and (not(readytodrop ?m1 ?c))
			(not(readytodrop ?m2 ?c))(freetopoint ?m1)(freetopoint ?m2)(crate_at_bay ?c)

			(assign(velocity ?m1)10 )
			(assign(velocity ?m2)10 )

		)
	)
)