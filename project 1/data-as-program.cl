(defun data-to-program (&aux a b)
  (format t "Input a one-line function definition~%")
  (setf a (read))
  (eval a)
  (setf b (random 1.0))
  (format t "When I apply your defined function ~a 
to the argument ~a I get ~a" (nth 1 a) b (eval (list (nth 1 a) b))))

#|
----------------------

CG-USER(5): (data-to-program)
Input a one-line function definition
(defun two-pwr (x) (expt 2 x))
When I apply your defined function TWO-PWR 
to the argument 0.8218822 I get 1.7677107
NIL
CG-USER(6): (data-to-program)
Input a one-line function definition
(defun double (x) (* 2 x))
When I apply your defined function DOUBLE 
to the argument 0.31913853 I get 0.63827705
NIL
|#