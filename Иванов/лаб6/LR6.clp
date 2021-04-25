(defglobal ?*in-heap* = 4)
(deftemplate block
(slot color (type SYMBOL))
(slot size (type INTEGER))
(slot place (type SYMBOL))
)
(deftemplate goal
(slot found (type SYMBOL))
)
(deftemplate on-block
(slot color (type SYMBOL))
(slot up-block (type SYMBOL))
(slot down-block (type SYMBOL))
)
(deftemplate task
(slot current (type SYMBOL)(allowed-symbols find build))
)
(deffacts init
(block
(color black)
(size 18)
(place heap) 
)
(block
(color yellow)
(size 15)
(place heap) 
)
(block
(color red)
(size 20)
(place heap) 
)
(block
(color white)
(size 10)
(place heap) 
)
)
(defrule init-r
(initial-fact)
=>
(assert
(task
(current find)
)
)
)
(defrule find-biggest
?tf<-(task
(current find)
)
(test (> ?*in-heap* 0))
?pbl<-(block
(size ?sz0)
(place heap)
)
(not (exists (block (place heap)(size ?sz1&:(> ?sz1 ?sz0))) ) )
=>
(modify ?pbl
(place hand)
)
(bind ?*in-heap* (- ?*in-heap* 1))
(modify ?tf
(current build)
)
)
;----------------------------------------------
(defrule build-first
?tf<-( task
(current build)
)
?fbl<-(block
(place hand)
(color ?cl)
)
(not (exists (on-block (up-block undefined))))
=>
(assert (on-block
(color ?cl)
(down-block undefined)
(up-block undefined)
)
)
(modify ?tf
(current find)
)
(modify ?fbl
(place tower)
)
)
;--------------------------------------------
(defrule build-next
?tf<-( task
(current build)
)
?fbl<-(block
(place hand)
(color ?cl)
)
?onf<-(on-block
(up-block undefined)
(color ?cl-old)
)
=>
(assert (on-block
(color ?cl)
(down-block ?cl-old)
(up-block undefined)
)
)
(modify ?tf
(current find)
)
(modify ?fbl
(place tower)
)
(modify ?onf
(up-block ?cl)
)
)
;-----------------------------------------
(defrule goal-test
(not (exists (block (place heap))))
=>
(printout t "Built! Print from top to bottom" crlf)
(assert (goal (found done)))
)
;-----------------------------------------
(defrule print-tower
(exists (goal (found done)))
?bl<-(on-block
(color ?cl)
(up-block undefined)
(down-block ?cl-down)
)
?bl-under<-(on-block
(color ?cl-down)
)
=>
(printout t "Block: "?cl crlf)
(retract ?bl)
(modify ?bl-under
(up-block undefined)
)
)
;-----------------------------------------
(defrule print-last
?bl<-(on-block
(up-block undefined)
(down-block undefined)
(color ?cl)
)
=>
(printout t "Block: "?cl crlf)
(retract ?bl)
)
