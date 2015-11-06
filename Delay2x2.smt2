
(define-sort WireVoltage () (_ BitVec 3) )
(define-const wire-Neg Wire (_ bv3 3) )
(define-const wire-Gnd Wire (_ bv0 3) )
(define-const wire-Pos Wire (_ bv1 3) )

(define-fun RowVoltage ((t Bool)) WireVoltage
	(ite (t) (wire-Pos) (wire-Neg) )
)


(define-fun ColTruth ((v WireVoltage)) Bool
	(ite (= v wire-Gnd) False True)
)

; The polarities
(declare-const M11P Bool) ; True means positive
(declare-const M12P Bool)
(declare-const M21P Bool)
(declare-const M22P Bool)

(define-fun MemristorValue((prior Bool)(polarity Bool)(Vr WireVoltage)(Vc WireVoltage)) Bool
	(ite (polarity)
		(ite (bvge (bvsub Vr Vc) (_ bv1 3) ) (True)
			(ite (= Vr Vc) (prior) (False) )
		)

		(ite (bvge (bvsub Vc Vr ) (_ bv1 3) ) (True)
			(ite (= Vr Vc) (prior) (False) )
		)
	)
)



(check-sat)
(get-value ( M11 M12 M21 M22) )
