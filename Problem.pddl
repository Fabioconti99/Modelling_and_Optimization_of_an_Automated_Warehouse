;; Problem 

(define 
	(problem Warehouse_P)
	(:domain Warehouse_D)

	;; Objects

	(:objects m_1 m_2 - mover

				l_1 - loader 

				c_1 c_2 c_3 c_4 c_5 c_6 c_7 c_8 c_9 c_10 - crate

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
		

		(= (distance_crate c_2) 15)
		(= (weight c_2) 80)
	
	
		(= (distance_crate c_3)15)
		(= (weight c_3) 25)

		(= (distance_crate c_4) 15)
		(= (weight c_4) 30)

		(= (distance_crate c_5) 15)
		(= (weight c_5) 30)

		;;(= (distance_crate c_6) 15)
		;;(= (weight c_6) 30)
		

		;;(= (distance_crate c_7) 15)
		;;(= (weight c_7) 80)
	
	
		;;(= (distance_crate c_8)15)
		;;(= (weight c_8) 25)

		;;(= (distance_crate c_9) 15)
		;;(= (weight c_9) 30)

		;;(= (distance_crate c_10) 15)
		;;(= (weight c_10) 90)
		

		(different m_1 m_2)

		(freetopoint m_1)
		(freetopoint m_2)
		
		(free_crate c_1)
		(free_crate c_2)
		(free_crate c_3)
		(free_crate c_4)
		(free_crate c_5)
		;;(free_crate c_6)
		;;(free_crate c_7)
		;;(free_crate c_8)
		;;(free_crate c_9)
		;;(free_crate c_10)

		(free_bay)

	)

	;;;;;;;

	;; Goal

	(:goal	(and (crate_at_bay  c_1)
			(crate_at_bay  c_2)
			(crate_at_bay  c_3)
			(crate_at_bay c_4)
			(crate_at_bay c_5)
			;;(crate_at_bay  c_6)
			;;(crate_at_bay  c_7)
			;;(crate_at_bay c_8)
			;;(crate_at_bay c_9)
			;;(crate_at_bay c_10)

			)
		)

	;;;;;;;

)