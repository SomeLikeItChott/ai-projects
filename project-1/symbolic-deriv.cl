(defun deriv (expression var)
  (let ((i (if (listp expression) (car expression) expression)))
    (cond
     ((numberp i) 0)
     ((equal i '+) `(+ ,(deriv(nth 1 expression) var) ,(deriv(nth 2 expression) var)))
     ((equal i '-) `(- ,(deriv(nth 1 expression) var) ,(deriv(nth 2 expression) var)))
     ((equal i '*) `(+ (* ,(nth 1 expression) ,(deriv (nth 2 expression) var)) 
                       (* ,(nth 2 expression) ,(deriv (nth 1 expression) var))))
     ((equal i '/) `(/ (- (* ,(nth 2 expression) ,(deriv (nth 1 expression) var))
                          (* ,(nth 1 expression) ,(deriv (nth 2 expression) var)))
                       (expt ,(nth 2 expression) 2)))
     ((equal i 'expt) `(* ,(nth 2 expression) 
                          (expt ,(nth 1 expression) ,(- (nth 2 expression) 1))))
     ((equal i 'exp) `(* (exp ,(deriv (nth 1 expression) var) ,(nth 1 expression))))
     ((atom i) (if (equal var i) 1 0))
     (t (print var)))))

#|
----------------------

CG-USER(102): (deriv '(* 2 (exp x)) 'x)
(+ (* 2 (* (EXP 1 X))) (* (EXP X) 0))
CG-USER(103): (deriv '(expt x 5) 'x)
(* 5 (EXPT X 4))
CG-USER(104): (deriv '(/ x (+ 5 x)) 'x)
(/ (- (* (+ 5 X) 1) (* X (+ 0 1))) (EXPT (+ 5 X) 2))
CG-USER(105): (deriv '(x) 'x)
1
|#