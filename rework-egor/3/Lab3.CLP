(deffacts f0
(a a)
(b b)
(c c)
(d d)
(e e))
(defrule r01
(declare(salience 2000))
(a a)
(b b)
(c c)
=>
(assert (r r)))
(defrule r02
(declare (salience 2000))
(e e)
(c c)
(d d)
=>
(assert (p p)))
(defrule r03
(declare (salience 3000))
(a a)
(d d)
=>
(assert (m m)))
(defrule r04
(declare (salience 3000))
(a a)
(e e)
=>
(assert (n n)))
(defrule r05
(declare (salience 4000))
(c c)
(n n)
(r r)
=>
(assert (t t)))
(defrule r06
(declare (salience 5000))
(m d)
=>
(assert (s s)))
