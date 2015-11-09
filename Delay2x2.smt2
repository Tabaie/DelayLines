
(define-sort WireVoltage () (_ BitVec 3) )
(define-const wire-Neg WireVoltage (_ bv3 3) )
(define-const wire-Gnd WireVoltage (_ bv0 3) )
(define-const wire-Pos WireVoltage (_ bv1 3) )

(define-fun RowVoltage ((t Bool)) WireVoltage
	(ite t wire-Pos wire-Neg )
)


(define-fun ColTruth ((v WireVoltage)) Bool
	(ite (= v wire-Gnd) false true)
)

; The polarities
(declare-const M11P Bool) ; True means positive
(declare-const M12P Bool)
(declare-const M21P Bool)
(declare-const M22P Bool)

(define-fun MemristorValue((prior Bool)(polarity Bool)(Vr WireVoltage)(Vc WireVoltage)) Bool
	(ite polarity
		(ite (bvsge (bvsub Vr Vc) wire-Pos ) true
			(ite (= Vr Vc) prior false )
		)

		(ite (bvsge (bvsub Vc Vr ) wire-Pos ) true
			(ite (= Vr Vc) prior false )
		)
	)
)

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

(check-sat)
(get-value ( M11P M12P M21P M22P) )
