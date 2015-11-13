
; Electrical Representation of Wire Voltages
(define-sort WireVoltage () (_ BitVec 2) )	;Needs to cover 3 possible values, hence 2 bits needed
(define-const wire-Neg WireVoltage (_ bv3 2) ) ; 3 = -1  (!!)
(define-const wire-Gnd WireVoltage (_ bv0 2) )
(define-const wire-Pos WireVoltage (_ bv1 2) )

(define-fun RowVoltage ((t Bool)) WireVoltage
	(ite t wire-Pos wire-Neg )	;"true" logical value on row means Vth, "false" means -Vth
)


(define-fun ColTruth ((v WireVoltage)) Bool
	(ite (= v wire-Gnd) false true)	;"true" logical value on column means Vth or -Vth, "false" means Gnd
)

; The polarities, the objective is to find these
(declare-const M11P Bool) ; True means positive
(declare-const M12P Bool)
(declare-const M21P Bool)
(declare-const M22P Bool)

;The rules for the change in memristors' on/off state
(define-fun MemristorValue((prior Bool)(polarity Bool)(Vr WireVoltage)(Vc WireVoltage)) Bool
	(ite polarity	;Positive polarity
		(ite (bvsgt Vr Vc) true
			(ite (= Vr Vc) prior false )
		)

		(ite (bvsgt Vc Vr ) true
			(ite (= Vr Vc) prior false )
		)
	)
)



(define-fun BothCols ((M11 Bool) (M12 Bool) (M21 Bool) (M22 Bool)) Bool
	(and
		(or M11 M21)
		(or M12 M22)
	)
)




;This is the weak rule

(assert (forall ((r1p Bool) (r2p Bool) (M11 Bool) (M12 Bool) (M21 Bool) (M22 Bool))

	(=
		(BothCols
			
				(MemristorValue
					M11
					M11P
					(RowVoltage r1p)
					wire-Gnd
				)
			
				(MemristorValue
					M12
					M12P
					(RowVoltage r1p)
					wire-Gnd
				)

				(MemristorValue
					M21
					M21P
					(RowVoltage r2p)
					wire-Gnd
				)
			
				(MemristorValue
					M22
					M22P
					(RowVoltage r2p)
					wire-Gnd
				)
						
		)
		
		r1p
	)
))


(check-sat)
(get-value ( M11P M12P M21P M22P) )


