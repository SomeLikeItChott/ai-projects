(defun f(c x)
  (-(expt x 4) c))

(defun fderiv(x)
  (* 4 (expt x 3)))

(defun newton (num tolerance &optional (estimate (/ num 4)))
  (cond ((< (abs (f num estimate) ) tolerance) estimate)
        (T (newton (* 1.0 num) tolerance (- estimate (/ (f num estimate) (fderiv estimate)))))))

#|
----------------------

CG-USER(96): (newton 256 0.01)
4.0
CG-USER(97): (newton 4294967296 0.01)
256.0
CG-USER(98): (newton 625 1)
5.0000033
CG-USER(99): (newton 500 1)
4.728811
CG-USER(100): (newton 16 1)
2.0074282
|#