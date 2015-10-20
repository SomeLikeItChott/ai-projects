;;;*******************************************************************************************
;;;*											     *
;;;*			Minimax and alpha-beta procedures (integrated)                       *	
;;;*											     *
;;;*******************************************************************************************
;;;
;;;*******************************************************************************************
;;;  Top level decision procedure to implement minimax procedure.  If the cutoff
;;; depth is reached, it evaluates the board with static_eval and the number of nodes
;;; evaluated in the current search process is updated.  If the cutoff
;;; depth is not reached, find out if the current board contains a winning or losing
;;; configuration.  If so, return the winning or losing value and the incremented
;;; boards-evaluated.  If not, evaluate the current board by calling either max-value or
;;; min-value depending on whether it is my turn to make a move. Returns a list of three numbers: 
;;; (i) the number of boards evaluated, 
;;; (ii) the slot corresponding to the successor with the best evaluation, and 
;;; (iii) that value.
;;;*******************************************************************************************

(defun minimax-decision (board level alpha-beta? 
	&optional (my-turn t) (alpha *MINUS-INFINITY*) (beta *PLUS-INFINITY*)) 
	(cond ((equal 0 level) (list 1 -1 (static_eval board))) ;base case
		((not (equal nil (winning_or_losing board))) (list 1 -1 (static_eval board))) ;also base case
		(t (if my-turn (max-value board my-turn level alpha-beta? alpha beta 0) ;recurse to max
			(min-value board my-turn level alpha-beta? alpha beta 0))))) ;recurse to min


;;;*******************************************************************************************
;;; This function first generates the children of the current board.  If this board has no
;;; children it is evaluated by static_eval and the corresponding value together with incremented
;;; boards-evaluated is returned.  If the input board has one or more children, they are 
;;; evaluated by calling the minimax procedure after decrementing the level and changing the 
;;; player.  This function then returns the maximum evaluation of the successor nodes. 
;;;   If alpha-beta pruning is to be performed, successors are evaluated until alpha
;;; becomes greater than or equal to beta.  If that happens, beta is returned, otherwise
;;; alpha is returned.  In both cases, the number of boards evaluated and the preferred move (slot)
;;; is returned.
;;; INPUT: board - board to be evaluated
;;;        player - t, if computer is to play, nil otherwise
;;;        level - current depth of search
;;;        alpha, beta - pruning parameters
;;;        alpha-beta? - t if alpha-beta pruning is to be performed, nil otherwise
;;;        boards-evaluated - number of boards evaluated so far
;;;*******************************************************************************************

(defun max-value (board player level alpha-beta? alpha beta boards-evaluated) 
	(let ((children (get-children board (if player 'black 'white))))
		(cond ((equal nil children) (list 1 -1 (static_eval board)))
			(t (let ((best-child nil) (highest-val *MINUS-INFINITY*))
				(dolist (child children)
					(when (not (equal nil (first child)))
						(let ((new-child (minimax-decision (first child) (- level 1) alpha-beta? (not player) alpha beta)))
							(setf (second new-child) (second child))
							(incf boards-evaluated (first new-child))
							(when alpha-beta?
								(when (>= (third new-child) beta)
									(setf (first new-child) boards-evaluated)
									(return-from max-value new-child))
								(when (> (third new-child) alpha)
									(setf alpha (third new-child))))
							(when (> (third new-child) highest-val)
								(setf best-child new-child)
								(setf highest-val (third new-child))))))
				(setf (first best-child) boards-evaluated)
				best-child)))))


;;;*******************************************************************************************
;;; This function first generates the children of the current board.  If this board has no
;;; children it is evaluated by static_eval and the corresponding value together with incremented
;;; boards-evaluated is returned.  If the input board has one or more children, they are 
;;; evaluated by calling the minimax procedure after decrementing the level and changing the 
;;; player.  This function then returns the minimum evaluation of the successor nodes. 
;;;   If alpha-beta pruning is to be performed, successors are evaluated until alpha
;;; becomes greater than or equal to beta.  If that happens, alpha is returned, otherwise
;;; beta is returned.  In both cases, the number of boards evaluated and the preferred move (slot)
;;; is returned.
;;; INPUT: board - board to be evaluated
;;;        player - t, if computer is to play, nil otherwise
;;;        level - current depth of search
;;;        alpha, beta - pruning parameters
;;;        alpha-beta? - t if alpha-beta pruning is to be performed, nil otherwise
;;;*******************************************************************************************

(defun min-value (board player level alpha-beta? alpha beta boards-evaluated)
	(let ((children (get-children board (if player 'black 'white))))
		(cond ((equal nil children) (list 1 -1 (static_eval board)))
			(t (let ((best-child nil) (lowest-val *PLUS-INFINITY*))
				(dolist (child children)
					(when (not (equal nil (first child)))
						(let ((new-child (minimax-decision (first child) (- level 1) alpha-beta? (not player) alpha beta)))
							(setf (second new-child) (second child))
							(incf boards-evaluated (first new-child))
							(when alpha-beta?
								(when (<= (third new-child) alpha)
									(setf (first new-child) boards-evaluated)
									(return-from min-value new-child))
								(when (< (third new-child) beta)
									(setf beta (third new-child))))
							(when (< (third new-child) lowest-val)
								(setf best-child new-child)
								(setf lowest-val (third new-child))))))
				(setf (first best-child) boards-evaluated)
				best-child)))))

;;*********************************************************************************************
;; Returns nil if board is full, otherwise returns children as calculated by 'successors' function
;; INPUT: Current board and color to be dropped into board to generate children
;;*********************************************************************************************
(defun get-children (board color)
	(let ((children (successors board color)) (is-empty t))
		(dolist (child children children)
			(if (not (equal (first child) nil)) (setf is-empty nil)))
		(if is-empty nil children)))

;;*********************************************************************************************
;; This is the board-evaluator function called from minimax to check if board has win or loss.
;; It returns a 1 if there is a win on the board, a -1 if a loss, and a nil if nothing.
;; INPUT: Current board
;;*********************************************************************************************
(defun winning_or_losing (board)
	(win_lose_with_array (convert_to_array board)))

;;**********************************************************************************************
;; This function, on being given the array representation of a board returns an integer that is
;; 1 if the board contains a win for black, -1 for a loss, and nil otherwise.
;; INPUT: array representation of current board.
;;*********************************************************************************************
(defun win_lose_with_array (board_array)
	(let ((state nil))
		(dolist (win *win_positions* state)
			(let ((black_count 0) (white_count 0))
				(dolist (pos win)
					(when (equal 'black (aref board_array pos)) (incf black_count))
					(when (equal 'white (aref board_array pos)) (incf white_count)))
				(when (equal black_count 4) (setf state 1) )
				(when (equal white_count 4) (setf state -1) )))))

