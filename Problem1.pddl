;;;;;;;;;;;;;;;;; ARTIFICIAL INTELLIGENCE FOR ROBOTICS 2 ASSIGNMENT ;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;                 A.A. 2021/2022                    ;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; PROBLEM 1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define 
	(problem Warehouse_P)
	(:domain Warehouse_D)

	;; Objects

	(:objects m_1 m_2 - mover

				l_1 l_2 - loader 
				c_1 c_2 c_3 - crate
				A - group

	)

	;;;;;;;;;;

	;; Init 

	(:init 

		(=(distance_mover m_1)0)
		(=(distance_mover m_2)0)

		(= (velocity m_1) 10)
		(= (velocity m_2) 10)

		(= (distance_crate c_1) 10)
		(= (weight c_1) 70)
		

		(= (distance_crate c_2) 20)
		(= (weight c_2) 20)
        (fragile c_2)
	
		(= (distance_crate c_3)20)
		(= (weight c_3) 20)
        
		(different m_1 m_2)

		(freetopoint m_1)
		(freetopoint m_2)
		
		(free_crate c_1)
		(free_crate c_2)
		(free_crate c_3)





;;GROUP SETTINGS

		(freetogroup)
		(no_active_groups) 
		 

		(available A) (=(n_el A) 2) (=(n_el_processed A) 0)
	


;; crate in groups OR not in groups

		(not_grouped c_1)
		(group c_2 A)   (=(crate_taken c_2) 0)
		(group c_3 A)   (=(crate_taken c_3) 0) 



;; LOADER SETTINGS

	(different_loaders l_1 l_2)
	(cheap l_2)
	(free_loader l_1)
	(free_loader l_2)
	(=(time_loader l_1) 0 )
	(=(time_loader l_2) 0 )

	(event_1)
	(free_bay)

;; Battery

	(=(battery m_1)20)
	(=(battery m_2)20)

	)


	;;;;;;;

	;; Goal

	(:goal	(and 
			(crate_delivered c_1)
			(crate_delivered c_2)
			(crate_delivered c_3)
			)
		)

	;;;;;;;

)