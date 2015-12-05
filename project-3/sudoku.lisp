(defun main (filename &aux (infile (open filename)))
	;read in that board
	(let ((numboards (read infile)))
		(dotimes (z numboards)
			(let ((board (make-array '(9 9))))
				(dotimes (x 9)
					(dotimes (y 9)
						(setf (aref board x y) (read infile))))
				;at this point the board has been correctly read in
				(print board)

				(format t "~%~%Values in domain for AC3:")
				(print (domain-from-board board))
				(format t "~%~%Values in domain for forward checking:")
				(print (get-full-domain board))


				(format t "~%~%Solution and # backtracks from dfs with backtracking")
				(let ((start (get-internal-real-time)))

				(print (dfs board 0 (get-full-domain board) nil))

				(format t "~a seconds elapsed" 
					(/ (* 1.0 (- (get-internal-real-time) start)) internal-time-units-per-second)))
				(format t "~%~%Solution and # backtracks from dfs with backtracking and AC3")
				(let ((start (get-internal-real-time)))

				(print (dfs board 0 (domain-from-board board) nil))

				(format t "~a seconds elapsed" 
					(/ (* 1.0 (- (get-internal-real-time) start)) internal-time-units-per-second)))
				(format t "~%~%Solution and # backtracks from dfs with backtracking and forward checking")
				(let ((start (get-internal-real-time)))

				(print (dfs board 0 (get-full-domain board) t))

				(format t "~a seconds elapsed ~%~%~%" 
					(/ (* 1.0 (- (get-internal-real-time) start)) internal-time-units-per-second)))))))

;; Returns a copy of the board, to modify it without affecting original
(defun copy-of-board (board)
	(let ((copy (make-array '(9 9))))
		(dotimes (x 9 copy)
			(dotimes (y 9)
				(setf (aref copy x y) (aref board x y))))))

;; Returns t if the board has no conflicts in row, column, or 3x3,
;; returns nil if conflicts are detected
(defun is-board-valid (board)
	;check that rows are valid
	(cond ((equal nil (dotimes (row 9 t)
		(when (not (is-row-valid row board))
			(return nil))))
	nil)
	;check that columns are valid
	((equal nil (dotimes (col 9 t)
		(when (not (is-col-valid col board))
			(return nil))))
	nil)
	;check that all 9 3x3's are valid
	((equal nil (dotimes (x 3 t)
		(when (not (dotimes (y 3 t)
			(when (not (is-subboard-valid x y board))
				(return nil))))
		(return nil))))
	nil)
	(t t)))

;; Returns t if the given row has no conflicts, even if there are zeroes.
;; Teturns nil if there is a conflict.
(defun is-row-valid (rownum board)
	(let ((rowlist nil))
		(dotimes (col 9 t)
			(when (and (find (aref board rownum col) rowlist) (not (equal (aref board rownum col)0)))
				(return nil))
			(push (aref board rownum col) rowlist))))

;; Returns t if the given column has no conflicts, even if there are zeroes.
;; Returns nil if there is a conflict. 
(defun is-col-valid (colnum board)
	(let ((collist nil))
		(dotimes (row 9 t)
			(when (and (find (aref board row colnum) collist) (not (equal (aref board row colnum)0)))
				(return nil))
			(push (aref board row colnum) collist))))

;; Returns t if the given 3x3 subboard has no conflicts, even if there are zeroes.
;; xinit and yinit should belong to {0, 1, 2}.
;; If there is a conflict, returns nil.
(defun is-subboard-valid (xinit yinit board)
	(let ((numlist nil) (x (* xinit 3)) (y (* yinit 3)))
		(dotimes (i 3 t)
			(when (equal nil 
				(dotimes (j 3 t)
					(when (and (find (aref board (+ x i) (+ y j)) numlist) 
						(not (equal (aref board (+ x i) (+ y j)) 0)))
					(return nil))
					(push (aref board (+ x i) (+ y j)) numlist)))
			(return nil)))))

;; Returns t if the board is full
;; returns nil if any zeroes are present
(defun is-board-full (board)
	(dotimes (row 9 t)
		(when (equal nil (dotimes (col 9 t)
			(when (equal (aref board row col) 0)
				(return nil))))
		(return nil))))
