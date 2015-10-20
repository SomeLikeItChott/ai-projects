(defun grep-file (file1 string file2 &optional case-sense &aux line (linenum 0)
                        (infile (open file1 :direction :input :if-does-not-exist :error))
                        (outfile (open file2 :direction :output :if-does-not-exist :create 
                                       :if-exists :supersede)))
  (loop
    (setf line (read-line infile nil 'end-of-file))
    (when (eq line 'end-of-file) (close outfile) (close infile) (return))
    (incf linenum)
    (when (if case-sense (search string line) (search string line :test #'char-equal))
      (format t "Line ~d: ~a~&" linenum line)
      (format outfile "~a~&" line))))

#|
----------------------

Used lyrics to The Root's "Wake Up Everybody"
CG-USER(119): (grep-file "infile.txt" "sleep" "outfile.txt")
Line 2: Wake up everybody, no more sleeping in bed
NIL
CG-USER(120): (grep-file "infile.txt" "wake" "outfile.txt")
Line 2: Wake up everybody, no more sleeping in bed
Line 8: Wake up all the teachers, time to teach a new way
Line 20: Wake up all the doctors, make the old people well
Line 26: Wake up, all the builders time to build a new land
Line 34: It's the God hour, the morning I wake up
Line 53: Wake up, everybody
Line 54: Wake up, everybody
Line 59: Wake up everybody
Line 60: Wake up everybody
Line 61: Wake up everybody
NIL
CG-USER(121): (grep-file "infile.txt" "wake" "outfile.txt" t)
Line 34: It's the God hour, the morning I wake up
NIL
CG-USER(122): (grep-file "infile.txt" "Wake" "outfile.txt" t)
Line 2: Wake up everybody, no more sleeping in bed
Line 8: Wake up all the teachers, time to teach a new way
Line 20: Wake up all the doctors, make the old people well
Line 26: Wake up, all the builders time to build a new land
Line 53: Wake up, everybody
Line 54: Wake up, everybody
Line 59: Wake up everybody
Line 60: Wake up everybody
Line 61: Wake up everybody
NIL
|#