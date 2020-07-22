#!/usr/bin/env /usr/local/bin/sbcl --script

(load (merge-pathnames ".sbclrc" (user-homedir-pathname)))
(ql:quickload :alexandria :silent t)

(defun read-segments (fn)
  (with-open-file (in fn)
    (loop for x = (read in nil nil)
	  for y = (read in nil nil)
	  while (and x y)
	  collect (cons x y))))

(defun main (rawfile tuples)
  (let ((pairs (read-segments tuples))
	(raw   (alexandria:read-file-into-string rawfile)))
    (loop for x in pairs
	  do (format t "~a~%" (subseq raw (car x) (cdr x))))))

(main (nth 1 sb-ext:*posix-argv*) (nth 2 sb-ext:*posix-argv*))
