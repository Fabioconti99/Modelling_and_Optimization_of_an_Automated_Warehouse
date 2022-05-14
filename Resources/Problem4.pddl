;;;;;;;;;;;;;;;;; ARTIFICIAL INTELLIGENCE FOR ROBOTICS 2 ASSIGNMENT ;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;                 A.A. 2021/2022                    ;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; PROBLEM 4 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define 
	(problem Warehouse_P)
	(:domain Warehouse_D)

	;; Objects

	(:objects 
                m_1 m_2 - mover
				l_1 l_2 - loader 
				c_1 c_2 c_3 c_4 c_5 c_6 - crate
				A B - group

	)

	;;;;;;;;;;

	;; Init 

	(:init 

		(=(distance_mover m_1)0)
		(=(distance_mover m_2)0)

		(= (velocity m_1) 10)
		(= (velocity m_2) 10)

		(= (distance_crate c_1) 20)
		(= (weight c_1) 30)
		

		(= (distance_crate c_2) 20)
		(= (weight c_2) 20)
        (fragile c_2)
	
		(= (distance_crate c_3)10)
		(= (weight c_3) 30)
        (fragile c_3)

        (= (distance_crate c_4)20)
		(= (weight c_4) 20)
        (fragile c_4)

        (= (distance_crate c_5)30)
		(= (weight c_5) 30)
        (fragile c_5)

        (= (distance_crate c_6)10)
		(= (weight c_6) 20)
        
		(different m_1 m_2)

		(freetopoint m_1)
		(freetopoint m_2)
		
		(free_crate c_1)
		(free_crate c_2)
		(free_crate c_3)
        (free_crate c_4)
        (free_crate c_5)
        (free_crate c_6)


;;GROUP SETTINGS

		(freetogroup)
		(no_active_groups) 
		 

		(available A) (=(n_el A) 2) (=(n_el_processed A) 0)
        (available B) (=(n_el B) 3) (=(n_el_processed B) 0)
	


;; crate in groups OR not in groups

		(group c_1 A)   (=(crate_taken c_1) 0)
		(group c_2 A)   (=(crate_taken c_2) 0)
		(group c_3 B)   (=(crate_taken c_3) 0)
        (group c_4 B)   (=(crate_taken c_4) 0)
        (group c_5 B)   (=(crate_taken c_5) 0)
        (not_grouped c_6)  



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
            (crate_delivered c_4)
            (crate_delivered c_5)
            (crate_delivered c_6)
			)
		)

	;;;;;;;

)