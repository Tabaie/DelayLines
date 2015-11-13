
;(define-sort ColSubset () (_ BitVec 3) ) ; #Defining the Subset type


(declare-const M11P Bool)
(declare-const M12P Bool)
(declare-const M13P Bool)
(declare-const M21P Bool)
(declare-const M22P Bool)
(declare-const M23P Bool)

(declare-const SubR1_C1 Bool)
(declare-const SubR1_C2 Bool)
(declare-const SubR1_C3 Bool)
(declare-const SubR2_C1 Bool)
(declare-const SubR2_C2 Bool)
(declare-const SubR2_C3 Bool)

; #The value of a memristor in t+1
(define-fun MemristorVal((polarity Bool)(Vr Bool)) Bool
	(= polarity Vr) ; #Positive polarity memristors turn on when row in true (i.e. Vt)
)

(define-fun ColVal((m1_ Bool)(m2_ Bool)) Bool
	(or  m1_ m2_)
)

(assert (forall ((r1 Bool)(r2 Bool))
	(and
		(= r1
			(and
				(or (not SubR1_C1) (ColVal (MemristorVal M11P r1)(MemristorVal M21P r2)))
				(or (not SubR1_C2) (ColVal (MemristorVal M12P r1)(MemristorVal M22P r2)))
				(or (not SubR1_C3) (ColVal (MemristorVal M13P r1)(MemristorVal M23P r2)))
			)
		)
		(= r2
			(and
				(or (not SubR2_C1) (ColVal (MemristorVal M11P r1)(MemristorVal M21P r2)))
				(or (not SubR2_C2) (ColVal (MemristorVal M12P r1)(MemristorVal M22P r2)))
				(or (not SubR2_C3) (ColVal (MemristorVal M13P r1)(MemristorVal M23P r2)))
			)
		)
	)
))

(check-sat)

(get-value ( M11P SubR1_C1 M12P SubR1_C2 M13P SubR1_C3 M21P SubR2_C1 M22P SubR2_C2 M23P SubR2_C3))

