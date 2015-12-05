;; Runs depth-first-search on the given domain, optionally using forward checking
;; Returns a list, where the first element is the completed board, 
;; and the second element is the number of backtracks created
(defun dfs (board numbacktracks domain forward-check)
	;(print board)
	;(break)
	(when (not (is-board-valid board))
		;the current board is invalid
		(return-from dfs (list nil 1)))
	(when (is-board-full board)
		;the board is full and valid (ie, an answer)
		(return-from dfs (list board 0)))
	(let ((children (get-children board domain forward-check)))
		;go through children, see if any are valid
		(dolist (child children)
			(let ((result (dfs (nth 0 child) 0 (nth 1 child) forward-check)))
				(incf numbacktracks (nth 1 result))
				(when (not (equal nil (nth 0 result)))
					(setf (nth 1 result) numbacktracks)
					(return-from dfs result)))))
	;there are no more possible children on this space
	(return-from dfs (list nil numbacktracks)))


;; Returns a list of all possible children of the current board.
;; This function handles finding the correct variable to check values for.
;; If there are no possible children, returns nil
(defun get-children (board domain forward-check)
	(dotimes (x 9)
		(dotimes (y 9)
			(when (equal 0 (aref board y x))
				(return-from get-children (generate-children x y board domain forward-check))))))

;; Returns a list of all possible children of the current board,
;; in terms of a given variable/cell.
;; If there are no possible children, returns nil
(defun generate-children (x y board domain forward-check)
	(let ((children nil))
		(dolist (num (aref domain y x) children)
			(let ((child (copy-of-board board)) (newdomain (if forward-check (forward-check-adjust-domain x y domain num) domain)))
				(setf (aref child y x) num)
				(push (list child newdomain) children)))))

;; Runs AC3 on a sudoku board to create a new domain
;; Returns a 9x9 array of lists
(defun domain-from-board (board)
	(let ((domain (make-array '(9 9))) (possibles '(1 2 3 4 5 6 7 8 9)))
		(dotimes (x 9 domain)
			(dotimes (y 9)
				(if (equal 0 (aref board y x))
					(setf (aref domain y x) (set-difference 
						possibles 
						(append (get-nums-in-col board x) 
							(get-nums-in-row board y) 
							(get-nums-in-subboard board (get-sub-of-point y) (get-sub-of-point x)))))
					(setf (aref domain y x) (list (aref board y x))))))))

;; Returns a list of all the different values in a given column, for a given board.
;; If there are no values in that column, returns nil.
(defun get-nums-in-col (board colnum)
	(let ((numlist nil))
		(dotimes (row 9 numlist)
			(when (not (equal 0 (aref board row colnum)))
				(push (aref board row colnum) numlist)))))

;; Returns a list of all the different values in a given row, for a given board.
;; If there are no values in that row, returns nil.
(defun get-nums-in-row (board rownum)
	(let ((numlist nil))
		(dotimes (col 9 numlist)
			(when (not (equal 0 (aref board rownum col)))
				(push (aref board rownum col) numlist)))))

;; Returns a list of all the different values in a given 3x3 subboard, for a given board.
;; If there are no values in that subboard, returns nil.
(defun get-nums-in-subboard (board xinit yinit)
	(let ((numlist nil) (x (* xinit 3)) (y (* yinit 3)))
		(dotimes (i 3 numlist)
			(dotimes (j 3)
				(when (not (equal 0 (aref board (+ x i) (+ y j))))
					(push (aref board (+ x i) (+ y j)) numlist))))))

;; Returns which subboard a point is in the x or y dimension, 
;; when given that point's x or y coordinate.
(defun get-sub-of-point (var)
	(floor var 3))

;; Returns a domain that's completely full, with the exception of
;; values that are already set.
;; Returns the domain as a 9x9 array of lists.
(defun get-full-domain (board)
	(let ((domain (make-array '(9 9))))
		(dotimes (x 9 domain)
			(dotimes (y 9)
				(if (equal 0 (aref board x y))
				(dotimes (num 9)
					(push (1+ num) (aref domain x y)))
				(push (aref board x y) (aref domain x y))
				)))))

;; Returns a domain that's been adjusted by the forward checking algorithm,
;; for a given point and value.
;; This function (admittedly, inefficiently) changes the domains of every cell
;; in the given point's row, column, and subboard to not have the given value.
;; Returns a 9x9 array of lists.
(defun forward-check-adjust-domain (x y domain num)
	(let ((newdomain (copy-of-domain domain)))
	;adjust domain of row
	(dotimes (height 9)
		(when (find num (aref newdomain height x))
			(setf (aref newdomain height x) (remove num (aref newdomain height x)))))
	(dotimes (width 9)
		(when (find num (aref newdomain y width))
			(setf (aref newdomain y width) (remove num (aref newdomain y width)))))
	(dotimes (height 3)
		(dotimes (width 3)
			(let ((subx (+ width (* 3 (get-sub-of-point x)))) (suby (+ height (* 3 (get-sub-of-point y)))))
				(when (find num (aref newdomain suby subx))
					(setf (aref newdomain suby subx) (remove num (aref newdomain suby subx)))))))
	newdomain))

;; Returns a copy of the domain, to edit it without changing the original.
;; Returns the domain as a 9x9 array of lists.
(defun copy-of-domain (domain)
	(let ((copy (make-array '(9 9))))
		(dotimes (x 9 copy)
			(dotimes (y 9)
				(dolist (num (aref domain y x))
					(push num (aref copy y x)))))))


