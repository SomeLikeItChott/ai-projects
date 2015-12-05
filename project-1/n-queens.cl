(defun nqueens (n &optional (max-steps 500))
  (let ((board (generate-initial-board n)))
    (format t "Initial:~%~a~%" board)
    (dotimes (i max-steps board)
      (when (is-solution-correct board)
        (format t "~%found correct solution in ~a steps" i)
        (print-output board)
        (return))
      (format t "~a " i)
      (let ((col (get-col-with-conflict board)))
        (setf (aref board col) (get-min-conflict board col))))))

(defun print-output (board)
  (format t "~%~a" board)
  (format t "~%A Solution for ~a-queen problem
Note: charts are flipped 90 degrees" (array-dimension board 0))
  (dotimes (i (array-dimension board 0) ())
    (format t "~%~a: " i)
    (dotimes (j (array-dimension board 0) ())
      (if (equal j (aref board i))
          (format t "~a " 'Q) (format t "~a " '_))))
  (dotimes (i (array-dimension board 0) ())
    (format t "~%~a: " i)
    (dotimes (j (array-dimension board 0) ())
      (format t "~a " (num-conflicts board i j)))))

(defun num-conflicts (board x &optional (y (aref board x)))
  (let ((numconflicts 0))
    (dotimes (i (array-dimension board 0) ())
      ;there will never be two queens in the same col
      (when (not (equal x i))
        (when (equal (aref board i) y)
          (incf numconflicts))
        (when (equal (- y (aref board i)) (- x i))
          (incf numconflicts))
        (when (equal (- (aref board i) y) (- x i))
          (incf numconflicts))))
    numconflicts))

(defun is-solution-correct (board)
  (dotimes (i (array-dimension board 0) t)
    (when (> (num-conflicts board i) 0)
      (return nil))))

(defun get-col-with-conflict (board)
  (let ((conflict-list (get-col-conflict-list board)))
    (nth (random (length conflict-list)) conflict-list)))

(defun get-col-conflict-list (board &aux list)
  (dotimes (i (array-dimension board 0) list)
    (when (> (num-conflicts board i) 0)
      (push i list))))

(defun get-min-conflict (board x)
  (let ((conflict-list (get-min-conflicts-list board x)))
    (nth (random (length conflict-list)) conflict-list)))

(defun get-min-conflicts-list (board x &aux list)
  (let ((absmin (get-min-conflicts-in-col board x)))
    (dotimes (i (array-dimension board 0) list) 
      (when (equal (num-conflicts board x i) absmin) 
        (push i list)))))

(defun get-min-conflicts-in-col (board x)
  (let ((min (num-conflicts board x)))
    (dotimes (i (array-dimension board 0) min)
      (when (< (num-conflicts board x i) min)
        (setf min (num-conflicts board x i))))))

(defun generate-initial-board (n)
  (let ((board (make-array n :initial-element 0)))
    (dotimes (i n board)
      (setf (aref board i) (get-min-conflict board I)))))

#|
----------------------

CG-USER(7): (nqueens 4)
Initial:
#(2 3 3 0)
0 1 2 3 4 5 6 7 
found correct solution in 8 steps
#(2 0 3 1)
A Solution for 4-queen problem
Note: charts are flipped 90 degrees
0: _ _ Q _ 
1: Q _ _ _ 
2: _ _ _ Q 
3: _ Q _ _ 
0: 1 3 0 1 
1: 0 2 2 3 
2: 3 2 2 0 
3: 1 0 3 1 
NIL
CG-USER(8): (nqueens 8)
Initial:
#(5 7 4 6 3 5 2 4)
0 1 2 3 4 5 6 7 8 9 
found correct solution in 10 steps
#(1 5 0 6 3 7 2 4)
A Solution for 8-queen problem
Note: charts are flipped 90 degrees
0: _ Q _ _ _ _ _ _ 
1: _ _ _ _ _ Q _ _ 
2: Q _ _ _ _ _ _ _ 
3: _ _ _ _ _ _ Q _ 
4: _ _ _ Q _ _ _ _ 
5: _ _ _ _ _ _ _ Q 
6: _ _ Q _ _ _ _ _ 
7: _ _ _ _ Q _ _ _ 
0: 1 0 3 2 2 1 2 2 
1: 3 2 2 2 2 0 2 2 
2: 0 2 1 2 3 3 3 2 
3: 2 2 2 2 3 3 0 2 
4: 2 2 3 0 2 3 2 3 
5: 1 3 3 3 3 1 3 0 
6: 2 2 0 3 2 3 2 2 
7: 2 2 2 2 0 3 2 1 
NIL
CG-USER(9): (nqueens 12)
Initial:
#(6 11 7 10 1 9 4 8 8 11 3 0)
0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 
found correct solution in 19 steps
#(4 0 7 10 1 6 8 3 11 9 2 5)
A Solution for 12-queen problem
Note: charts are flipped 90 degrees
0: _ _ _ _ Q _ _ _ _ _ _ _ 
1: Q _ _ _ _ _ _ _ _ _ _ _ 
2: _ _ _ _ _ _ _ Q _ _ _ _ 
3: _ _ _ _ _ _ _ _ _ _ Q _ 
4: _ Q _ _ _ _ _ _ _ _ _ _ 
5: _ _ _ _ _ _ Q _ _ _ _ _ 
6: _ _ _ _ _ _ _ _ Q _ _ _ 
7: _ _ _ Q _ _ _ _ _ _ _ _ 
8: _ _ _ _ _ _ _ _ _ _ _ Q 
9: _ _ _ _ _ _ _ _ _ Q _ _ 
10: _ _ Q _ _ _ _ _ _ _ _ _ 
11: _ _ _ _ _ Q _ _ _ _ _ _ 
0: 2 3 2 2 0 3 1 2 1 2 2 2 
1: 0 2 2 3 3 2 2 1 3 2 2 2 
2: 1 2 3 3 2 2 2 0 2 3 2 2 
3: 2 2 3 2 2 2 3 3 3 2 0 2 
4: 3 0 1 2 2 3 3 3 3 3 2 2 
5: 2 2 2 1 3 3 0 3 3 3 2 2 
6: 2 1 2 3 2 3 3 3 0 2 3 2 
7: 1 2 2 0 3 2 3 3 2 3 2 3 
8: 2 2 3 2 3 3 2 2 3 2 3 0 
9: 2 3 2 3 2 3 2 2 2 0 3 2 
10: 2 2 0 2 3 1 3 2 2 3 2 2 
11: 2 2 2 3 1 0 1 3 3 1 2 2 
NIL
|#