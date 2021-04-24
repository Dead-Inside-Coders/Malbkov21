;;������
(deftemplate gangster
  (slot name (type SYMBOL));;���
  (slot guilty (type SYMBOL) (default Unk));;���������� 
  (slot truthful (type SYMBOL) (default Unk));;������� �� ������������
)

;;�������� ����� � ������������ � �������� ������
(deffacts content
  (gangster (name Jack))
  (gangster (name Bob)(truthful No))
  (gangster (name Fred)(guilty No));;���� �� ����������
  (gangster (name Tom)(truthful Yes))
)

;;��������������� ����� ��� ���� ��� ��������
(defrule stop
  (gangster (name Jack) (guilty ~Unk) (truthful ~Unk))
  (gangster (name Bob) (guilty ~Unk) (truthful ~Unk))
  (gangster (name Fred) (guilty ~Unk) (truthful ~Unk))
  (gangster (name Tom) (guilty ~Unk) (truthful ~Unk))
=>
  (halt)
)

;;� ������������ � ����������� ����� � ����

(defrule Jack_Tom_truthful_1
  (gangster (name Jack|Tom) (truthful Yes))
  (gangster (name Tom) (guilty No))
  ?Bob<-(gangster(name Bob) (guilty Unk))
=>
  (modify ?Bob(guilty Yes))
) 

(defrule Jack_Tom_truthful_2
  (gangster (name Jack|Tom) (truthful Yes))
  (gangster (name Bob) (guilty No))
  ?Tom<-(gangster(name Tom) (guilty Unk))
=>
  (modify ?Tom(guilty Yes))
)

(defrule Jack_Tom_not_truthful
  (gangster (name Jack|Tom) (truthful No))
  ?X<-(gangster (name Bob|Tom) (guilty Unk))
=>
  (modify ?X(guilty No))
)

;;� ������������ � ����������� ���� � �����

(defrule Bob_Fred_truthful_1
  (gangster (name Bob|Fred) (truthful Yes))
  (gangster (name Jack) (guilty No))
  ?Tom<-(gangster(name Tom) (guilty Unk))
=>
  (modify ?Tom(guilty Yes))
) 

(defrule Bob_Fred_truthful_2
  (gangster (name Bob|Fred) (truthful Yes))
  (gangster (name Tom) (guilty No))
  ?Jack<-(gangster(name Jack) (guilty Unk))
=>
  (modify ?Jack(guilty Yes))
)

(defrule Bob_Fred_not_truthful
  (gangster (name Bob|Fred) (truthful No))
  ?X<-(gangster (name Jack|Tom) (guilty Unk))
=>
  (modify ?X(guilty No))
)

;;�������� ��� ������� ������, � ��� ���

(defrule Jack_Tom_is_truthful
  ?X<-(gangster(name Jack|Tom) (truthful Unk))
  (gangster(name Tom|Bob) (guilty Yes))
=>
  (modify ?X(truthful Yes))
) 

(defrule Jack_Tom_is_not_truthful
  ?X<-(gangster(name Jack|Tom) (truthful Unk))
  (gangster(name Tom) (guilty No))
  (gangster(name Bob) (guilty No))
=>
  (modify ?X(truthful No))
) 

(defrule Bob_Fred_is_truthful
  ?X<-(gangster(name Bob|Fred) (truthful Unk))
  (gangster(name Tom|Jack) (guilty Yes))
=>
  (modify ?X(truthful Yes))
) 

(defrule Bob_Fred_is_not_truthful
  ?X<-(gangster(name Bob|Fred) (truthful Unk))
  (gangster(name Tom) (guilty No))
  (gangster(name Jack) (guilty No))
=>
  (modify ?X(truthful No))
)
