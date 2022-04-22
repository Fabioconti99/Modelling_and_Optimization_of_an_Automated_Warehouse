;; Problem 

(define 
	(problem Warehouse_P)
	(:domain Warehouse_D)

	;; Objects

	(:objects m_1 m_2 - mover

				l_1 - loader 

				c_1 c_2 c_3 - crate

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
		(leggera c_1)


		(= (distance_crate c_2) 10)
		(= (weight c_2) 80)
		(pesante c_2)
	

		(= (distance_crate c_3)40)
		(= (weight c_3) 25)
		(leggera c_3)

		(different m_1 m_2)

		(freetopoint m_1)
		(freetopoint m_2)
		
		(free_crate c_1)
		(free_crate c_2)
		(free_crate c_3)

		(free_bay)

	)

	;;;;;;;

	;; Goal

	(:goal	(and (crate_at_bay  c_1)
			(crate_at_bay  c_2)
			(crate_at_bay  c_3)

			)
		)

	;;;;;;;

)