; �� ������� ��������, ��� C - ������
(deffacts situation
(C is playing chess)
)
; �� ������� ������������ � �����, ��� C � ������ ��������, 
; ��� A � B �� ������
(defrule rule_1
(C is playing chess)
=>
(assert (A isn't playing chess))
(assert (B isn't playing chess))
)

; �� ������� ������������ � �����, ��� B �� ������ ��������,
; ��� D ������ (� � ������, �������� �� �������)
(defrule rule_2_B_is_false
(B isn�t playing chess)
=>
 (assert (D is playing chess))
)

; �� ������� ������������ � �����, ��� D �� ������ ��������,
; ��� B ������ (� � ������, �������� �� �������)
; ������ ������� ����������� �� ����� �������!!!!
 (defrule rule_2_D_is_false
(D isn't playing chess)
=>
(assert (B is playing chess))
)

; ��������������� ����� ����, ����� ��� ��� ���� �������
(defrule stop
(A ? playing chess)
(B ? playing chess)
(C ? playing chess)
(D ? playing chess)
=>
(halt)
)
