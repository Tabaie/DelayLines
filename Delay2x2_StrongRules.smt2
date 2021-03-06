;This is not runnable, just a collection of "too strong" rules thrown out of the main code in favor of more relaxed ones

(define-fun BothCols ((M11R_C Bool) (M12R_C Bool) (M21R_C Bool) (M22R_C Bool)) Bool	;Is this correct?
	(and
		(or M11R_C M21R_C)
		(or M12R_C M22R_C)
	)
)


(assert (forall ((r1p Bool) (r2p Bool) (M11 Bool) (M12 Bool) (M21 Bool) (M22 Bool))

	(=
		(BothCols
			
			(and
				M11P
				
				(MemristorValue
					M11
					M11P
					(RowVoltage r1p)
					wire-Gnd
				)
			)
			
			(and
				M12P
				
				(MemristorValue
					M12
					M12P
					(RowVoltage r1p)
					wire-Gnd
				)
			)

			(and
				M21P
				
				(MemristorValue
					M21
					M21P
					(RowVoltage r2p)
					wire-Gnd
				)
			)
			
			(and
				M22P
				
				(MemristorValue
					M22
					M22P
					(RowVoltage r2p)
					wire-Gnd
				)
			)
			
			
		)
		
		r1p
	)
))
