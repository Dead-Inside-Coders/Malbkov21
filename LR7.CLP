(defrule determine-working-state ""
(not (working-state ?))
(not (repair ?))
=>
(if (yes-or-no-p «Загружается ли OS? (yes/no)? „)
then
(if (yes-or-no-p “OS работает корректно? (yes/no)? „)
then
(assert (working-state not-stable))
else
(assert (repair “Remont ne trebuetsa»))
(assert (working-state stable))
)
else
(assert (working-state disenabled))
)
)
(deffunction yes-or-no-p (?question)
(bind ?response (ask-question ?question yes no y n))
(if (or (eq ?response yes) (eq ?response y))
then TRUE
else FALSE))
(deffunction ask-question (?question $?allowed-values)
(printout t ?question)
(bind ?answer (read))
(if (lexemep ?answer)
then (bind ?answer (lowcase ?answer)))
(while (not (member ?answer ?allowed-values)) do
(printout t ?question)
(bind ?answer (read))
(if (lexemep ?answer)
then (bind ?answer (lowcase ?answer))))
?answer)
(defrule determine-power-state ""
(working-state disenabled)
(not (power-state ?))
(not (repair ?))
=>
(if (yes-or-no-p "Подается ли питание? (yes/no)? ")
then
(assert (repair "Следует проверить исправность "железа" или переставить ОС"))
(assert (power-state be))
else
(assert (repair "Подайте питание"))
(assert (power-state not))
)
)