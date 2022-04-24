;; Problem 

(define 
	(problem Warehouse_P)
	(:domain Warehouse_D)

	;; Objects

	(:objects m_1 m_2 - mover

				l_1 - loader 

				c_1 c_2 c_3 c_4 c_5 - crate
				;c_6 c_7 - crate

				A B - group

	)

	;;;;;;;;;;

	;; Init 

	(:init 

		(=(distance_mover m_1)0)
		(=(distance_mover m_2)0)

		(= (velocity m_1) 10)
		(= (velocity m_2) 10)

		(= (distance_crate c_1) 15)
		(= (weight c_1) 30)
		

		(= (distance_crate c_2) 20)
		(= (weight c_2) 80)
	
	
		(= (distance_crate c_3)25)
		(= (weight c_3) 25)

		(= (distance_crate c_4) 20)
		(= (weight c_4) 50)

		(= (distance_crate c_5) 10)
		(= (weight c_5) 20)

		;(= (distance_crate c_6) 25)
		;(= (weight c_6) 30)
		

		;(= (distance_crate c_7) 40)
		;(= (weight c_7) 40)
	
	
		;(= (distance_crate c_8) 40)
		;(= (weight c_8) 60)

		;(= (distance_crate c_9) 15)
		;(= (weight c_9) 30)

		;(= (distance_crate c_10) 15)
		;(= (weight c_10) 90)
		

		(different m_1 m_2)

		(freetopoint m_1)
		(freetopoint m_2)
		
		(free_crate c_1)
		(free_crate c_2)
		(free_crate c_3)
		(free_crate c_4)
		(free_crate c_5)
		;(free_crate c_6)
		;(free_crate c_7)
		;(free_crate c_8)
		;(free_crate c_9)
		;(free_crate c_10)

		(free_bay)


;;GROUP SETTINGS

		(freetogroup)
		(no_active_groups) 
		 

;;		(available A) (=(n_el A) 2) (=(n_el_processed A) 0)
;;		(available B) (=(n_el B) 2) (=(n_el_processed B) 0)
		


;; crate in groups OR not in groups
;;		(group c_1 A)   (=(crate_taken c_1) 0)
		(not_grouped c_1)
;;		(group c_2 A)   (=(crate_taken c_2) 0)
		(not_grouped c_2)
;;		(group c_3 B)   (=(crate_taken c_3) 0) 
		(not_grouped c_3)
;;		(group c_4 B)   (=(crate_taken c_4) 0)
		(not_grouped c_4)
;;		(group c_5 A)   (=(crate_taken c_5) 0)
		(not_grouped c_5)

		
		


;; FRAGILE SETTINGS
		(fragile c_1)
;;		(fragile c_2) 
		(fragile c_3)
;;		(fragile c_4)
;;		(fragile c_5)  

	)

	;;;;;;;

	;; Goal

	(:goal	(and 
			;(busygroup)
			;(pointed m_1 c_1)
			(crate_at_bay  c_1)
			(crate_at_bay  c_2)
			(crate_at_bay  c_3)
			(crate_at_bay c_4)
			(crate_at_bay c_5)
			;(crate_at_bay  c_6)
			;(crate_at_bay  c_7)
			;(crate_at_bay c_8)
			;(crate_at_bay c_9)
			;;(crate_at_bay c_10)

			)
		)

	;;;;;;;

)