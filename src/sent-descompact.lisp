#!/usr/bin/env /usr/local/bin/sbcl --script

(load (merge-pathnames ".sbclrc" (user-homedir-pathname)))
(ql:quickload '(:cl-ppcre :alexandria) :silent t)

(defun read-segments (fn)
  (with-open-file (in fn)
    (loop for x = (read-line in nil nil)
	  while x
	  collect (cl-ppcre:split " " x))))

(defun main (rawfile tuples)
  (let ((pairs (read-segments tuples))
	(raw   (alexandria:read-file-into-string rawfile)))
    (loop for x in pairs
	  do (format t "~a: ~a~%" (subseq x 2) (subseq raw
						       (parse-integer (car x))
						       (parse-integer (cadr x)))))))

(main (nth 1 sb-ext:*posix-argv*) (nth 2 sb-ext:*posix-argv*))
