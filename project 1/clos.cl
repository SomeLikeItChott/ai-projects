(defclass library-item () 
  ((title :initarg :title :reader title)
   (due-date :initform NIL :accessor due-date)
   (patron :initform NIL :accessor patron)))

(defclass CD-DVD (library-item)
  ((loan-period :initform 5 :accessor loan-period)))

(defclass book (library-item)
  ((loan-period :initform 14 : accessor loan-period)
   (num-renews :initform 1 :accessor num-renews)))

(defmethod check-out ((item library-item) date id)
  (cond 
   ((equal (due-date item) NIL) 
    (setf (patron item) id)
    (setf (due-date item) (+ date (loan-period item))))
   (t 
    (format t "This item is already checked out"))))

;;num renews
(defmethod renew ((item library-item) date id)
  (cond
   ((equal 'CD-DVD (class-name (class-of item)))
    (format t "CD-DVDs cannot be renewed"))
   ((or (equal (patron item) NIL) (equal (due-date item) NIL))
    (format t "Only items that have been checked out can be renewed"))
   ((not (equal id (patron item)))
    (format t "This item can only be renewed by the patron that checked it out"))
   ((> date (due-date item))
    (format t "Overdue items cannot be renewed"))
   ((>= 0 (num-renews item))
    (format t "Item has been renewed too many times to renew again"))
   (t
    (setf (due-date item) (+ (due-date item) (loan-period item)))
    (decf (num-renews item)))))

(defmethod deposit ((item library-item))
  (cond
   ((or (equal NIL (due-date item)) (equal NIL (patron item)))
    (format t "Items must be checked out before they can be deposited"))
   (t
    (setf (due-date item) NIL)
    (setf (patron item) NIL)
    (setf (num-renews item) 1))))

#|
----------------------

CG-USER(107): (setf a1 (make-instance 'book :title "Of Mice and Men"))
#<BOOK @ #x2155c08a>
CG-USER(108): (setf a2 (make-instance 'CD-DVD :title "Blade II"))
#<CD-DVD @ #x2156b88a>
CG-USER(109): (check-out a1 5 99)
19
CG-USER(110): (renew a1 10 98)
This item can only be renewed by the patron that checked it out
NIL
CG-USER(111): (renew a1 10 99)
0
CG-USER(112): (due-date a1)
33
CG-USER(113): (renew a1 32 99)
Item has been renewed too many times to renew again
NIL
CG-USER(114): (deposit a1)
1
CG-USER(115): (check-out a2 33 99)
38
CG-USER(116): (renew a2 35 99)
CD-DVDs cannot be renewed
NIL
|#