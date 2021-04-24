; �������
; ������ ������
(deftemplate goal
(slot action (type SYMBOL))
(slot object (type SYMBOL))
(slot from (type SYMBOL))
(slot to (type SYMBOL))
)
; ������ ��
(deftemplate in
(slot object (type SYMBOL))
(slot location (type SYMBOL))
)
; �����
; ����� � ������� �,
; ���� � ������� B,
; ���� - ���������� ���� � ������� A.
(deffacts world
(in (object robot) (location RoomA))
(in (object box) (location RoomB))
(goal (action push) (object box) (from RoomB) (to RoomA))
)
;�������
; ���������� �������, ����� ���� ����� ����������.
(defrule stop
(goal (object ?X) (to ?Y))
(in (object ?X) (location ?Y))
=>
(halt)
)
; ���� ����� ����������� � ��� �����, ��� ��������� ������,
; ������� ����� �����������,
; ����������� ���� �����.
(defrule move
(goal (object ?X) (from ?Y))
(in (object ?X) (location ?Y))
?robot-position <- (in (object robot) (location ~?Y))
=>
(modify ?robot-position (location ?Y))
)
; ���� ����� � ������ �� � ��� ���������,
; ������� ������� � ����,
; ����������� ���� ����� � ������.
(defrule push
(goal (object ?X) (from ?Y) (to ?Z))
?object-position <- (in (object ?X) (location ?Y))
?robot-position <- (in (object robot) (location ?Y))
=>
(modify ?robot-position (location ?Z))
(modify ?object-position (location ?Z))
)
