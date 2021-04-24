;;задается шаблон в соответствии с квадратом 3x3
(deftemplate Field
  (slot LeftTop(type NUMBER))
  (slot MiddleTop(type NUMBER))
  (slot RightTop(type NUMBER))
  (slot LeftMiddle(type NUMBER))
  (slot MiddleMiddle(type NUMBER))
  (slot RightMiddle(type NUMBER))
  (slot LeftBottom(type NUMBER))
  (slot MiddleBottom(type NUMBER))
  (slot RightBottom(type NUMBER))
  (slot Level(type NUMBER));;задает уровень в дереве
  (slot Id(type NUMBER) (default 0))
  (slot State(type NUMBER) (default 0));;0 - не рассматривалось, 1 - рассмотрено 2 - соответствует решению
  (slot From (type NUMBER))
  (slot Exp (type NUMBER));;значение целевой функции
)

;глобальная переменная
(defglobal 
  ?*Id* = 0
)

;целевая функция
(deffunction W(?Level ?LeftTop ?MiddleTop ?RightTop ?RightMiddle ?RightBottom ?MiddleBottom ?LeftBottom ?LeftMiddle)
  (bind ?a ?Level)
  (if (not (= ?LeftTop 1)) then
    (bind ?a (+ 1 ?a))
  )
  (if (not (= ?MiddleTop 2)) then
    (bind ?a (+ 1 ?a))
  )
  (if (not (= ?RightTop 3)) then
    (bind ?a (+ 1 ?a))
  )
  (if (not (= ?RightMiddle 4)) then
    (bind ?a (+ 1 ?a))
  )
  (if (not (= ?RightBottom 5)) then
    (bind ?a (+ 1 ?a))
  )
  (if (not (= ?MiddleBottom 6)) then
    (bind ?a (+ 1 ?a))
  )
  (if (not (= ?LeftBottom 7)) then
    (bind ?a (+ 1 ?a))
  )
  (if (not (= ?LeftMiddle 8)) then
    (bind ?a (+ 1 ?a))
  )
  ?a
)

;;определяет идентификатор (чтобы можно найти элементы в последовательности)
(deffunction Get_Id()
  (bind ?*Id* (+ ?*Id* 1))
  ?*Id*
)

;;задаем начальное положение
(deffacts start
  (min (W 0 2 8 3 4 5 0 7 1))
  (Field (LeftTop 2)        (MiddleTop 8)    (RightTop 3)
         (LeftMiddle 1)     (MiddleMiddle 6) (RightMiddle 4)
         (LeftBottom 7)     (MiddleBottom 0) (RightBottom 5)
         (Level 0);;это корень дерева
         (From 0) (Exp (W 0 2 8 3 4 5 0 7 1)) (Id (Get_Id))
  )
)

;;удаляем правила, которые встретились повторно
(defrule move_circle
  (declare (salience 1000))
  (Field (Exp ?X));;первый факт
  ?Field2<-(Field (Exp ?Y&~?X) (State 0));;второй факт
  (test (< ?X ?Y));;удаляется ситуация, у которой целевая функция больше 
=>
  (retract ?Field2)
  (printout t "delete rule" crlf)
)

;;выбираем узлы из множества Open, и создаем соответствующие пути из него
;;для этого создается 9 правил с одинаковым приоритетом, что дает случайность
(defrule make_new_path_LeftTop
  (declare (salience 100))
  ?fmin <- (min ?min)
  ?f<-(Field (State 0) (Level ?L) (Id ?Id)
         (LeftTop 0)    (MiddleTop ?MT) (RightTop ?RT)
	 (LeftMiddle ?LM) (MiddleMiddle ?MM) (RightMiddle ?RM)
	 (LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB) (Exp ?E& :(= ?E ?min)))
=> 
  (printout t ?min " " (fact-slot-value ?f Exp) crlf)
  (modify ?f(State 1))
  (bind ?a (W (+ 1 ?L) ?MT 0 ?RT ?RM ?RB ?MB ?LB ?LM))
  (retract ?fmin)
  (assert (min ?a))
  (assert (Field (LeftTop ?MT) (MiddleTop 0) (RightTop ?RT)
                 (LeftMiddle ?LM) (MiddleMiddle ?MM) (RightMiddle ?RM)
                 (LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB)
                 (Level (+ ?L 1)) (From ?Id) (Exp ?a) (Id (Get_Id))
         )
  )
  (assert (Field (LeftTop ?LM) (MiddleTop ?MT) (RightTop ?RT)
                (LeftMiddle 0) (MiddleMiddle ?MM) (RightMiddle ?RM)
                (LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB)
                (Level (+ ?L 1)) (From ?Id) (Exp (W (+ 1 ?L) ?LM ?MT ?RT ?RM ?RB ?MB ?LB 0)) (Id (Get_Id))
         )
   )
   (printout t "LeftTop" crlf)
)

(defrule make_new_path_MiddleTop
  (declare (salience 100))
  ?fmin<-(min ?min)
  ?f<-(Field (State 0) (Level ?L) (Id ?Id)
         (LeftTop ?LT)    (MiddleTop 0) (RightTop ?RT)
	 (LeftMiddle ?LM) (MiddleMiddle ?MM) (RightMiddle ?RM)
	 (LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB) (Exp ?E& :(= ?E ?min)))
=>
  (printout t ?min " " (fact-slot-value ?f Exp) crlf)
  (modify ?f(State 1))
  (bind ?a (W (+ 1 ?L) 0 ?LT ?RT ?RM ?RB ?MB ?LB ?LM))
  (retract ?fmin)
  (assert (min ?a))
  (assert (Field (LeftTop 0) (MiddleTop ?LT) (RightTop ?RT)
                 (LeftMiddle ?LM) (MiddleMiddle ?MM) (RightMiddle ?RM)
                 (LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB)
                 (Level (+ ?L 1)) (From ?Id) (Exp ?a) (Id (Get_Id))
          )
  )
  (assert (Field (LeftTop ?LT) (MiddleTop ?MM) (RightTop ?RT)
                 (LeftMiddle ?LM) (MiddleMiddle 0) (RightMiddle ?RM)
                 (LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB)
                 (Level (+ ?L 1)) (From ?Id) (Exp (W (+ 1 ?L) ?LT ?MM ?RT ?RM ?RB ?MB ?LB ?LM)) (Id (Get_Id))
          )
  )
  (assert (Field (LeftTop ?LT) (MiddleTop ?RT) (RightTop 0)
                 (LeftMiddle ?LM) (MiddleMiddle ?MM) (RightMiddle ?RM)
                 (LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB)
                 (Level (+ ?L 1)) (From ?Id) (Exp (W (+ 1 ?L) ?LT ?RT 0 ?RM ?RB ?MB ?LB ?LM)) (Id (Get_Id))
          )
  )
  (printout t "MiddleTop" crlf)
)

(defrule make_new_path_RightTop
  (declare (salience 100))
  ?fmin<-(min ?min)
  ?f<-(Field (State 0) (Level ?L) (Id ?Id)
         (LeftTop ?LT)    (MiddleTop ?MT) (RightTop 0)
	 (LeftMiddle ?LM) (MiddleMiddle ?MM) (RightMiddle ?RM)
	 (LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB) (Exp ?E& :(= ?E ?min)))
=>
 (printout t ?min " " (fact-slot-value ?f Exp) crlf)
 (modify ?f(State 1))
 (bind ?a (W (+ 1 ?L) ?LT 0 ?MT ?RM ?RB ?MB ?LB ?LM))
 (retract ?fmin)
 (assert (min ?a))
 (assert (Field (LeftTop ?LT) (MiddleTop 0) (RightTop ?MT)
                (LeftMiddle ?LM) (MiddleMiddle ?MM) (RightMiddle ?RM)
                (LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB)
                (Level (+ ?L 1)) (From ?Id) (Exp ?a) (Id (Get_Id))
         )
 )
 (assert (Field (LeftTop ?LT) (MiddleTop ?MT) (RightTop ?RM)
                (LeftMiddle ?LM) (MiddleMiddle ?MM) (RightMiddle 0)
                (LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB)
                (Level (+ ?L 1)) (From ?Id) (Exp (W (+ 1 ?L) ?LT ?MT ?RM 0 ?RB ?MB ?LB ?LM)) (Id (Get_Id))
         )
  )
  (printout t "RightTop" crlf)
)

(defrule make_new_path_LeftMiddle
  (declare (salience 100))
  ?fmin<-(min ?min)
  ?f<-(Field (State 0) (Level ?L) (Id ?Id)
         (LeftTop ?LT)    (MiddleTop ?MT) (RightTop ?RT)
	 (LeftMiddle 0) (MiddleMiddle ?MM) (RightMiddle ?RM)
	 (LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB) (Exp ?E& :(= ?E ?min)))
=>
 (printout t ?min " " (fact-slot-value ?f Exp) crlf)
 (modify ?f(State 1))
 (bind ?a (W (+ 1 ?L) 0 ?MT ?RT ?RM ?RB ?MB ?LB ?LT))
 (retract ?fmin)
 (assert (min ?a))
 (assert (Field (LeftTop 0) (MiddleTop ?MT) (RightTop ?RT)
                (LeftMiddle ?LT) (MiddleMiddle ?MM) (RightMiddle ?RM)
                (LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB)
                (Level (+ ?L 1)) (From ?Id) (Exp ?a) (Id (Get_Id))
         )
 )
 (assert (Field (LeftTop ?LT) (MiddleTop ?MT) (RightTop ?RT)
                (LeftMiddle ?MM) (MiddleMiddle 0) (RightMiddle ?RM)
                (LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB)
                (Level (+ ?L 1)) (From ?Id) (Exp (W (+ 1 ?L) ?LT ?MT ?RT ?RM ?RB ?MB ?LB ?MM)) (Id (Get_Id))
         )
  )
 (assert (Field (LeftTop ?LT) (MiddleTop ?MT) (RightTop ?RT)
                (LeftMiddle ?LB) (MiddleMiddle ?MM) (RightMiddle ?RM)
                (LeftBottom 0) (MiddleBottom ?MB) (RightBottom ?RB)
                (Level (+ ?L 1)) (From ?Id) (Exp (W (+ 1 ?L) ?LT ?MT ?RT ?RM ?RB ?MB 0 ?LB)) (Id (Get_Id))
         )
  )
  (printout t "LeftMiddle" crlf)
)

(defrule make_new_path_MiddleMiddle
  (declare (salience 100))
  ?fmin<-(min ?min)
  ?f<-(Field (State 0) (Level ?L) (Id ?Id)
         (LeftTop ?LT)    (MiddleTop ?MT) (RightTop ?RT)
	 (LeftMiddle ?LM) (MiddleMiddle 0) (RightMiddle ?RM)
	 (LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB) (Exp ?E& :(= ?E ?min)))
=>
 (printout t ?min " " (fact-slot-value ?f Exp) crlf)
 (modify ?f(State 1))
 (bind ?a (W (+ 1 ?L) ?LT 0 ?RT ?RM ?RB ?MB ?LB ?LM))
 (retract ?fmin)
 (assert (min ?a))
 (assert (Field (LeftTop ?LT) (MiddleTop 0) (RightTop ?RT)
                (LeftMiddle ?LM) (MiddleMiddle ?MT) (RightMiddle ?RM)
                (LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB)
                (Level (+ ?L 1)) (From ?Id) (Exp ?a) (Id (Get_Id))
         )
 )
 (assert (Field (LeftTop ?LT) (MiddleTop ?MT) (RightTop ?RT)
                (LeftMiddle ?LM) (MiddleMiddle ?RM) (RightMiddle 0)
                (LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB)
                (Level (+ ?L 1)) (From ?Id) (Exp (W (+ 1 ?L) ?LT ?MT ?RT 0 ?RB ?MB ?LB ?LM)) (Id (Get_Id))
         )
  )
 (assert (Field (LeftTop ?LT) (MiddleTop ?MT) (RightTop ?RT)
                (LeftMiddle ?LM) (MiddleMiddle ?MB) (RightMiddle ?RM)
                (LeftBottom ?LB) (MiddleBottom 0) (RightBottom ?RB)
                (Level (+ ?L 1)) (From ?Id) (Exp (W (+ 1 ?L) ?LT ?MT ?RT ?RM ?RB 0 ?LB ?LM)) (Id (Get_Id))
         )
  )
 (assert (Field (LeftTop ?LT) (MiddleTop ?MT) (RightTop ?RT)
                (LeftMiddle 0) (MiddleMiddle ?LM) (RightMiddle ?RM)
                (LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB)
                (Level (+ ?L 1)) (From ?Id) (Exp (W (+ 1 ?L) ?LT ?MT ?RT ?RM ?RB ?MB ?LB 0)) (Id (Get_Id))
         )
  )
  (printout t "MiddleMiddle" crlf)
)

(defrule make_new_path_RightMiddle
  (declare (salience 100))
  ?fmin<-(min ?min)
  ?f<-(Field (State 0) (Level ?L) (Id ?Id)
         (LeftTop ?LT)    (MiddleTop ?MT) (RightTop ?RT)
	 (LeftMiddle ?LM) (MiddleMiddle ?MM) (RightMiddle 0)
	 (LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB) (Exp ?E& :(= ?E ?min)))
=>
 (printout t ?min " " (fact-slot-value ?f Exp) crlf)
 (modify ?f(State 1))
 (bind ?a (W (+ ?L 1) ?LT ?MT 0 ?RT ?RB ?MB ?LB ?LM))
 (retract ?fmin)
 (assert (min ?a))
 (assert (Field (LeftTop ?LT) (MiddleTop ?MT) (RightTop 0)
                (LeftMiddle ?LM) (MiddleMiddle ?MM) (RightMiddle ?RT)
                (LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB)
                (Level (+ ?L 1)) (From ?Id) (Exp ?a) (Id (Get_Id))
         )
 )
 (assert (Field (LeftTop ?LT) (MiddleTop ?MT) (RightTop ?RT)
                (LeftMiddle ?LM) (MiddleMiddle 0) (RightMiddle ?MM)
                (LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB)
                (Level (+ ?L 1)) (From ?Id) (Exp (W (+ ?L 1) ?LT ?MT ?RT ?MM ?RB ?MB ?LB ?LM)) (Id (Get_Id))
         )
  )
 (assert (Field (LeftTop ?LT) (MiddleTop ?MT) (RightTop ?RT)
                (LeftMiddle ?LM) (MiddleMiddle ?MM) (RightMiddle ?RB)
                (LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom 0)
                (Level (+ ?L 1)) (From ?Id) (Exp (W (+ ?L 1) ?LT ?MT ?RT ?RB 0 ?MB ?LB ?LM)) (Id (Get_Id))
         )
  )
  (printout t "RightMiddle" crlf)
)

(defrule make_new_path_LeftBottom
  (declare (salience 100))
  ?fmin<-(min ?min)
  ?f<-(Field (State 0) (Level ?L) (Id ?Id)
         (LeftTop ?LT)    (MiddleTop ?MT) (RightTop ?RT)
	 (LeftMiddle ?LM) (MiddleMiddle ?MM) (RightMiddle ?RM)
	 (LeftBottom 0) (MiddleBottom ?MB) (RightBottom ?RB) (Exp ?E& :(= ?E ?min)))
=>
 (printout t ?min " " (fact-slot-value ?f Exp) crlf)
 (modify ?f(State 1))
 (bind ?a (W (+ ?L 1) ?LT ?MT ?RT ?RM ?RB ?MB ?LM 0))
 (retract ?fmin)
 (assert (min ?a))
 (assert (Field (LeftTop ?LT) (MiddleTop ?MT) (RightTop ?RT)
                (LeftMiddle 0) (MiddleMiddle ?MM) (RightMiddle ?RM)
                (LeftBottom ?LM) (MiddleBottom ?MB) (RightBottom ?RB)
                (Level (+ ?L 1)) (From ?Id) (Exp ?a) (Id (Get_Id))
         )
 )
 (assert (Field (LeftTop ?LT) (MiddleTop ?MT) (RightTop ?RT)
                (LeftMiddle ?LM) (MiddleMiddle ?MM) (RightMiddle ?RM)
                (LeftBottom ?MB) (MiddleBottom 0) (RightBottom ?RB)
                (Level (+ ?L 1)) (From ?Id) (Exp (W (+ ?L 1) ?LT ?MT ?RT ?RM ?RB 0 ?MB ?LM)) (Id (Get_Id))
         )
  )
  (printout t "LeftBottom" crlf)
)

(defrule make_new_path_MiddleBottom
  (declare (salience 100))
  ?fmin<-(min ?min)
  ?f<-(Field (State 0) (Level ?L) (Id ?Id)
         (LeftTop ?LT)    (MiddleTop ?MT) (RightTop ?RT)
	 (LeftMiddle ?LM) (MiddleMiddle ?MM) (RightMiddle ?RM)
	 (LeftBottom ?LB) (MiddleBottom 0) (RightBottom ?RB) (Exp ?E& :(= ?E ?min)))
=>
 (printout t ?min " " (fact-slot-value ?f Exp) crlf)
 (modify ?f(State 1))
 (bind ?a (W (+ ?L 1) ?LT ?MT ?RT ?RM ?RB ?LB 0 ?LM))
 (retract ?fmin)
 (assert (min ?a))
 (assert (Field (LeftTop ?LT) (MiddleTop ?MT) (RightTop ?RT)
                (LeftMiddle ?LM) (MiddleMiddle ?MM) (RightMiddle ?RM)
                (LeftBottom 0) (MiddleBottom ?LB) (RightBottom ?RB)
                (Level (+ ?L 1)) (From ?Id) (Exp ?a) (Id (Get_Id))
         )
 )
 (assert (Field (LeftTop ?LT) (MiddleTop ?MT) (RightTop ?RT)
                (LeftMiddle ?LM) (MiddleMiddle 0) (RightMiddle ?RM)
                (LeftBottom ?LB) (MiddleBottom ?MM) (RightBottom ?RB)
                (Level (+ ?L 1)) (From ?Id) (Exp (W (+ ?L 1) ?LT ?MT ?RT ?RM ?RB ?MM ?LB ?LM)) (Id (Get_Id))
         )
  )
 (assert (Field (LeftTop ?LT) (MiddleTop ?MT) (RightTop ?RT)
                (LeftMiddle ?LM) (MiddleMiddle ?MM) (RightMiddle ?RM)
                (LeftBottom ?LB) (MiddleBottom ?RB) (RightBottom 0)
                (Level (+ ?L 1)) (From ?Id) (Exp (W (+ ?L 1) ?LT ?MT ?RT ?RM 0 ?RB ?LB ?LM)) (Id (Get_Id))
         )
  )
  (printout t "MiddleBottom" crlf)
)

(defrule make_new_path_RightBottom
  (declare (salience 100))
  ?fmin<-(min ?min)
  ?f<-(Field (State 0) (Level ?L) (Id ?Id)
         (LeftTop ?LT)    (MiddleTop ?MT) (RightTop ?RT)
	 (LeftMiddle ?LM) (MiddleMiddle ?MM) (RightMiddle ?RM)
	 (LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom 0) (Exp ?E& :(= ?E ?min)))
=>
 (printout t ?min " " (fact-slot-value ?f Exp) crlf)
 (modify ?f(State 1))
 (bind ?a (W (+ ?L 1) ?LT ?MT ?RT 0 ?RM ?MB ?LB ?LM))
 (retract ?fmin)
 (assert (min ?a))
 (assert (Field (LeftTop ?LT) (MiddleTop ?MT) (RightTop ?RT)
                (LeftMiddle ?LM) (MiddleMiddle ?MM) (RightMiddle 0)
                (LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RM)
                (Level (+ ?L 1)) (From ?Id) (Exp ?a) (Id (Get_Id))
         )
 )
 (assert (Field (LeftTop ?LT) (MiddleTop ?MT) (RightTop ?RT)
                (LeftMiddle ?LM) (MiddleMiddle ?MM) (RightMiddle ?RM)
                (LeftBottom ?LB) (MiddleBottom 0) (RightBottom ?MB)
                (Level (+ ?L 1)) (From ?Id) (Exp (W (+ ?L 1) ?LT ?MT ?RT ?RM ?MB 0 ?LB ?LM)) (Id (Get_Id))
         )
  )
  (printout t "RightBottom" crlf)
)

(defrule find_min
  (declare (salience 150))
;;приоритет ниже чем у правила исключающего циклы и выше чем у правил порождения новых ходов
  ?fmin<-(min ?min)
  (Field (Exp ?E& :(< ?E ?min)) (State 0))
=>
 (retract ?fmin)
 (assert (min ?E))
)

;;если нашли решение, то выделяем его
(defrule start_select_answer
  (declare (salience 500))
  ?f<-(Field (LeftTop 1)    (MiddleTop 2) (RightTop 3)
	 (LeftMiddle 8) (MiddleMiddle 0) (RightMiddle 4)
	 (LeftBottom 7) (MiddleBottom 6) (RightBottom 5) (State ~2) (From ?Id))
=>
  (printout t "start select answer Id=" (fact-slot-value ?f Id) crlf)
  (modify ?f(State 2))
)

(defrule select_answer
  (declare (salience 500))
  (Field (State 2) (From ?Id))
  ?f<-(Field (Id ?Id) (State ~2))
=>
  (modify ?f(State 2))
  (printout t "select answer Id=" ?Id crlf)
)

;;удаляем остальные
(defrule delete_not_answer
  (declare (salience 400))
  (Field (State 2))
  ?f<-(Field (State ~2))
=>
  (retract ?f)
  (printout t "delete not answer" crlf)
)

;;делаем останов если решений нет
(defrule Stop_1
  (declare (salience 200))
  (Field(State ?x))
  (not (Field(State 0|2)))
=>
  (halt)
  (printout t "no solutions" crlf)
)

;;делаем останов если решение есть
(defrule Stop_2
  (declare (salience 200))
  (Field(State 2))
=>
  (halt)
  (printout t "fined solution" crlf)
)
