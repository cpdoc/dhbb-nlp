
(ql:quickload '(:alexandria :cl-json :cl-ppcre))


(defun offset (obj)
  (let ((sents (cdr (assoc :sentences obj)))
	(res nil))
    (dolist (s sents (reverse res))
      (let ((tks (cdr (assoc :tokens s))))
	(push (list (parse-integer (cdr (assoc :begin (car tks))))
		    (parse-integer (cdr (assoc :end (car (last tks))))))
	      res)))))


(defun offsets (file)
  (let (res)
    (with-open-file (in file)
      (handler-case 
	  (loop for obj = (cl-json:decode-json in)
		do (setf res (append res (offset obj))))
	(end-of-file () res)))))


(defun splitter (txt json stream)
  (let ((txt     (alexandria:read-file-into-string txt :external-format :utf-8))
	(offsets (offsets json)))
    (dolist (o offsets)
      (format stream "~a~%"
	      (cl-ppcre:regex-replace-all "\\n+" (subseq txt (nth 0 o) (nth 1 o)) " ")))))

(defun main ()
  (let ((opts sb-ext:*posix-argv*))
    (with-open-file (out (nth 3 opts) :direction :output :if-exists :supersede)
      (splitter (nth 1 opts) (nth 2 opts) out))))
