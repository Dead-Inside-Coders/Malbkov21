(deftemplate student 
	(slot name)
	(slot age)
	(slot year)
	(slot spec)
	(slot aver_mark))
	(deffacts students
		(student (name Smirnov) (age 20) (year 4) (spec "hard") (aver_mark 4))
		(student (name Ivanov) (age 21) (year 4) (spec "soft") (aver_mark 4.8))
		(student (name Kuznetsov) (age 22) (year 5) (spec "ai") (aver_mark 4.1))
		(student (name Popov) (age 19) (year 3) (spec "soft") (aver_mark 4))
		(student (name Sokolov) (age 20) (year 5) (spec "ai") (aver_mark 3.5))
		(student (name Lebedev) (age 21) (year 2) (spec "soft") (aver_mark 3.4))
		(student (name Kozlov) (age 20) (year 3) (spec "hard") (aver_mark 4.3))
		(student (name Novikov) (age 19) (year 4) (spec "hard") (aver_mark 4.2))
		(student (name Morozov) (age 20) (year 4) (spec "ai") (aver_mark 4))
		(student (name Petrov) (age 21) (year 2) (spec "soft") (aver_mark 5))
)
(defrule R1
(student (name ?name) (age ?age) (year 2) (spec ?spec) (aver_mark ?ave_mark))
(test (>= ?ave_mark 4.5))
=>
(printout t crlf "Student 2-ogo kyrsa " ?name " imeeet srednii ball " ?spec " " crlf ))
