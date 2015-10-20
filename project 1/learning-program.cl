(defun read-train-file (f1 &aux temp (infile (open f1 :direction :input :if-does-not-exist :error)))
" Function to read in training data"

  (loop 
   (let ((next (read infile nil 'end-of-file)))
     (when (eq next 'end-of-file)
	   (close infile) 
	   (return temp))
     (push (list next
		 (read infile nil 'end-of-file)
		 (read infile nil 'end-of-file)
		 (read infile nil 'end-of-file))
	   temp))))

(defun read-test-file (f1 &aux temp (infile (open f1 :direction :input :if-does-not-exist :error)))
" Function to read in test data"
  (loop 
   (let ((next (read infile nil 'end-of-file)))
     (when (eq next 'end-of-file)
	   (close infile) 
	   (return temp))
     (push (list next
		 (read infile nil 'end-of-file)
		 (read infile nil 'end-of-file))
	   temp))))

(defun find-neighbors (k new stored)
  " You have to write this function to implement the k-nearest neighbors algorithm"
  (let ((newlist NIL))
    (dotimes (i k ()) (push (nth i stored) newlist))
    (dolist (storedelem stored newlist)
      (dolist (newelem newlist ())
        (when (and (< (distance new storedelem) (distance new newelem))
                   (equal (find storedelem newlist) NIL))
          ;(print newlist)
          (setf newlist (remove newelem newlist))
          (setf newlist (append (list storedelem) newlist))
          (return))))))

(defun distance (p1 p2)
  (+ (abs (- (getx p1) (getx p2))) (abs (- (gety p1) (gety p2)))))

(defun getx (p1)
  (nth (- (length p1) 3) p1))

(defun gety (p1)
  (nth (- (length p1) 2) p1))

(defun find-classes (neighbors class &aux seglist)
  (dolist (elem neighbors seglist)
    (when (equal class (nth 0 elem))
      (setf seglist (append seglist (list elem))))))
    
(defun nearest-neighbor (&aux winner loser)
  "Driver function for the learning program"
  (format t "Input training file name: ")
  (let ((train-set (read-train-file (read))))
    (format t "Read ~d training instances~&~%" (length train-set))
    (format t "Input test file name: ")
    (let ((test-set (read-test-file (read))))
      (format t "Read ~d test instances~&~%" (length test-set))
      (format t "~&Input value of k for calculating k-nearest-neighbors: ")
      (let ((k (read)))
        (dolist (triplet test-set (format t "~&~%!!!!Aint I a good learner??!!"))
          (let ((neighbors (find-neighbors k triplet train-set)))
            (format t "*************************************~&")
            (if (< (length (find-classes neighbors 0)) (length (find-classes neighbors 1)))
                (setq winner (find-classes neighbors 1) loser (find-classes neighbors 0))
              (setq winner (find-classes neighbors 0) loser (find-classes neighbors 1)))
            ;there's probably a better way to organize this
            (format t "The likely classification of ~a is ~a because 
of the ~a closest stored points the following ~a are of class ~a:
~a~%" 
              triplet (nth 0 (nth 0 winner)) k (length winner) (nth 0 (nth 0 winner)) winner)
            (when (< (length winner) k)
              (format t "Other neighboring points include the following:
Belonging to class ~a:
~a~%" (nth 0 (nth 0 loser)) loser))))))))

#|
----------------------

CG-USER(1): (nearest-neighbor)
Input training file name: "learn-train-file"
Read 1000 training instances

Input test file name: "learn-test-file"
Read 4 test instances

Input value of k for calculating k-nearest-neighbors: 3
*************************************
The likely classification of (0.55 0.75 D) is 1 because 
of the 3 closest stored points the following 3 are of class 1:
((1 0.541214 0.719744 ITEM-538) (1 0.545673 0.724451 ITEM-541)
 (1 0.55829 0.766468 ITEM-567))
*************************************
The likely classification of (0.73 0.86 C) is 1 because 
of the 3 closest stored points the following 2 are of class 1:
((1 0.733953 0.892897 ITEM-728) (1 0.751332 0.880799 ITEM-743))
Other neighboring points include the following:
Belonging to class 0:
((0 0.752077 0.84836 ITEM-744))
*************************************
The likely classification of (0.11 0.95 B) is 0 because 
of the 3 closest stored points the following 3 are of class 0:
((0 0.0852329 0.942662 ITEM-89) (0 0.120649 0.920144 ITEM-122)
 (0 0.12267 0.974407 ITEM-127))
*************************************
The likely classification of (0.22 0.5 A) is 1 because 
of the 3 closest stored points the following 3 are of class 1:
((1 0.204234 0.489816 ITEM-194) (1 0.210684 0.508477 ITEM-206)
 (1 0.252098 0.493085 ITEM-250))

!!!!Aint I a good learner??!!
NIL
|#