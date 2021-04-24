; из услови€ известно, что C - играет
(deffacts situation
(C is playing chess)
)
; из первого высказывани€ и факта, что C Ц играет вы€сн€ем, 
; что A и B не играют
(defrule rule_1
(C is playing chess)
=>
(assert (A isn't playing chess))
(assert (B isn't playing chess))
)

; из второго высказывани€ и факта, что B не играет вы€снаем,
; что D играет (— Ц играет, известно из услови€)
(defrule rule_2_B_is_false
(B isnТt playing chess)
=>
 (assert (D is playing chess))
)

; из второго высказывани€ и факта, что D не играет вы€сн€ем,
; что B играет (— Ц играет, известно из услови€)
; данное правило выполн€тьс€ не будет никогда!!!!
 (defrule rule_2_D_is_false
(D isn't playing chess)
=>
(assert (B is playing chess))
)

; останавливаемс€ после того, когда все про всех вы€сним
(defrule stop
(A ? playing chess)
(B ? playing chess)
(C ? playing chess)
(D ? playing chess)
=>
(halt)
)
