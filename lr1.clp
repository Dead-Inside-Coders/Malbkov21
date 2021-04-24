; ШАБЛОНЫ
; Шаблон «цель»
(deftemplate goal
(slot action (type SYMBOL))
(slot object (type SYMBOL))
(slot from (type SYMBOL))
(slot to (type SYMBOL))
)
; Шаблон “в”
(deftemplate in
(slot object (type SYMBOL))
(slot location (type SYMBOL))
)
; ФАКТЫ
; Робот в комнате А,
; ящик в комнате B,
; цель - вытолкнуть ящик в комнату A.
(deffacts world
(in (object robot) (location RoomA))
(in (object box) (location RoomB))
(goal (action push) (object box) (from RoomB) (to RoomA))
)
;ПРАВИЛА
; Прекратить процесс, когда цель будет достигнута.
(defrule stop
(goal (object ?X) (to ?Y))
(in (object ?X) (location ?Y))
=>
(halt)
)
; Если робот отсутствует в том месте, где находится объект,
; который нужно передвинуть,
; переместить туда робот.
(defrule move
(goal (object ?X) (from ?Y))
(in (object ?X) (location ?Y))
?robot-position <- (in (object robot) (location ~?Y))
=>
(modify ?robot-position (location ?Y))
)
; Если робот и объект не в том помещении,
; которое указано в цели,
; переместить туда робот и объект.
(defrule push
(goal (object ?X) (from ?Y) (to ?Z))
?object-position <- (in (object ?X) (location ?Y))
?robot-position <- (in (object robot) (location ?Y))
=>
(modify ?robot-position (location ?Z))
(modify ?object-position (location ?Z))
)
