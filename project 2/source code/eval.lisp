;;;********************************************************************************************
;;;*											      *
;;;*			Board Evaluation Routines					      *
;;;*											      *
;;;********************************************************************************************
;;;
;;; WINNING is a very high value returned when a winning configuration is detected.
;;; LOSING is a very low value returned when a losing configuration is detected.
;;;
(defvar *WINNING* (* 10 *WIN*))
(defvar *LOSING*  (* 10 *LOSE*))

;;*********************************************************************************************
;; This is the board-evaluator function called from minimax to evaluate a board.It returns an
;; integral value that reflect the promise of the input board.
;; INPUT: Current board
;;*********************************************************************************************
(defun static_eval (board)
	(rank_board (convert_to_array board)))

;;**********************************************************************************************
;; The following function convert an input board to array representation.  It
;; is this array representation that is passed by the function static_eval() to 
;; the function rank_board() 
;; INPUT: current board.
;;*********************************************************************************************
(defun convert_to_array (board)
  (let ((index 0)
	(squares (make-array (* *Dimension* *Dimension*))))
    (dotimes (i *Dimension* squares)
	     (dotimes (j *Dimension*)
		      (setf (aref squares index)
			    (aref board i j))
		      (incf index)))))

;;**********************************************************************************************
;; This function, on being given the array representation of a board returns an integer that is
;; the rank of the board from the view-point of the maximising player. Note that the variable
;; win_positions is a list of all possible winning configurations.
;; INPUT: array representation of current board.
;;*********************************************************************************************
(defun rank_board (board_array)
	(let ((score 0))
		(dolist (win *win_positions* score)
			(incf score (rank_win (win_to_win_array win board_array) board_array)))))

;;*********************************************************************************************
;; Given a single array representation of a potential win (ie (EMPTY EMPTY WHITE EMPTY)) 
;; and a board array, returns the score for that part of the possible wins.
;; INPUT: Win list of form (EMPTY EMPTY WHITE EMPTY) and array representation of board
;;*********************************************************************************************
(defun rank_win (win_array board_array)
	(let ((score 0))
		(if (find 'white win_array) 
			(if (find 'black win_array)
				0 ;we really don't care about possible wins that can't be earned by either player
				(- (win_score 'white win_array))) 
			(win_score 'black win_array))))

;;*********************************************************************************************
;; Converts a potential win from (0 1 2 3) format to (EMPTY EMPTY WHITE EMPTY) format
;; INPUT: Win of format (0 1 2 3) and array representation of board
;;*********************************************************************************************
(defun win_to_win_array (win board_array)
	(let ((win_array (list)))
	(dolist (pos win win_array)
		(push (aref board_array pos) win_array))))

;;*********************************************************************************************
;; Returns the numerical subscore for the given win array and color.
;; INPUT: Color and win list of format (EMPTY EMPTY WHITE EMPTY)
;;*********************************************************************************************
(defun win_score (color win_array)
	(let ((num 0))
		(dolist (piece win_array num)
			(if (equal piece color) (incf num)))
		(cond ((equal num 4) *WINNING*)
			((equal num 3) 50)
			((equal num 2) 20)
			((equal num 1) 3)
			((equal num 0) 0))))


