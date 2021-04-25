(deffacts f0
(a a)
(b b)
(c c)
(d d)
(e e))
(defrule r01
(declare(salience 5000))
(a a)
(b b)
=>
(assert (m m)))
(defrule r02
(declare (salience 6000))
(a a)
(c c)
=>
(assert (n n)))
(defrule r03
(declare (salience 5000))
(b b)
(c c)
(d d)
=>
(assert (p p)))
(defrule r04
(declare (salience 6000))
(a a)
(d d)
(c c)
=>
(assert (r r)))
(defrule r05
(declare (salience 6000))
(m m)
(n n)
=>
(assert (s s)))
(defrule r06
(declare (salience 5000))
(n n)
(p p)
(r r)
=>
(assert (t t)))
