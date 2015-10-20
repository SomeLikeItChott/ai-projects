(defun perm (atoms)
  (let ((permlist (permrec atoms)))
    (format t "There are ~a different permutations of ~a:~%~a"
      (length permlist) atoms permlist)))

(defun permrec (atoms &aux list sublist)
  (if (equal (length atoms) 1)
      (list atoms)
    (dolist (item atoms list)
      (setf sublist (permrec (remove item atoms))) ;seperate atoms
      (dolist (it sublist list)
        (push (cons item it) list))))) ;put them back together

#|
----------------------

CG-USER(11): (perm '(1 2 3))
There are 6 different permutations of (1 2 3):
((3 1 2) (3 2 1) (2 1 3) (2 3 1) (1 2 3) (1 3 2))
NIL
CG-USER(12): (perm '(A B C D))
There are 24 different permutations of (A B C D):
((D A C B) (D A B C) (D B C A) (D B A C) (D C B A) (D C A B) (C A D B) (C A B D)
 (C B D A) (C B A D) (C D B A) (C D A B) (B A D C) (B A C D) (B C D A) (B C A D)
 (B D C A) (B D A C) (A B D C) (A B C D) (A C D B) (A C B D) (A D C B) (A D B C))
NIL
CG-USER(13): (perm '(A B C D E))
There are 120 different permutations of (A B C D E):
((E A D B C) (E A D C B) (E A C B D) (E A C D B) (E A B C D) (E A B D C) (E B D A C)
 (E B D C A) (E B C A D) (E B C D A) (E B A C D) (E B A D C) (E C D A B) (E C D B A)
 (E C B A D) (E C B D A) (E C A B D) (E C A D B) (E D C A B) (E D C B A) (E D B A C)
 (E D B C A) (E D A B C) (E D A C B) (D A E B C) (D A E C B) (D A C B E) (D A C E B)
 (D A B C E) (D A B E C) (D B E A C) (D B E C A) (D B C A E) (D B C E A) (D B A C E)
 (D B A E C) (D C E A B) (D C E B A) (D C B A E) (D C B E A) (D C A B E) (D C A E B)
 (D E C A B) (D E C B A) (D E B A C) (D E B C A) (D E A B C) (D E A C B) (C A E B D)
 (C A E D B) (C A D B E) (C A D E B) (C A B D E) (C A B E D) (C B E A D) (C B E D A)
 (C B D A E) (C B D E A) (C B A D E) (C B A E D) (C D E A B) (C D E B A) (C D B A E)
 (C D B E A) (C D A B E) (C D A E B) (C E D A B) (C E D B A) (C E B A D) (C E B D A)
 (C E A B D) (C E A D B) (B A E C D) (B A E D C) (B A D C E) (B A D E C) (B A C D E)
 (B A C E D) (B C E A D) (B C E D A) (B C D A E) (B C D E A) (B C A D E) (B C A E D)
 (B D E A C) (B D E C A) (B D C A E) (B D C E A) (B D A C E) (B D A E C) (B E D A C)
 (B E D C A) (B E C A D) (B E C D A) (B E A C D) (B E A D C) (A B E C D) (A B E D C)
 (A B D C E) (A B D E C) (A B C D E) (A B C E D) (A C E B D) (A C E D B) (A C D B E)
 (A C D E B) (A C B D E) (A C B E D) (A D E B C) (A D E C B) (A D C B E) (A D C E B)
 (A D B C E) (A D B E C) (A E D B C) (A E D C B) (A E C B D) (A E C D B) (A E B C D)
 (A E B D C))
NIL
|#