
;; to be runned with ABCL Lisp

(ql:quickload '(:alexandria :cl-json :cl-ppcre))

(mapcar #'add-to-classpath
	(directory "/Users/ar/work/apache-opennlp-1.9.2/lib/*.jar"))

(defun offset (obj)
  (let ((sents (cdr (assoc :sentences obj)))
	(res nil))
    (dolist (s sents (reverse res))
      (let ((tks (cdr (assoc :tokens s))))
	(push (list (parse-integer (cdr (assoc :begin (car tks))))
		    (parse-integer (cdr (assoc :end (car (last tks))))))
	      res)))))


(defun offsets (txt)
  (let (res)
    (with-input-from-string (in txt)
      (handler-case 
	  (loop for obj = (cl-json:decode-json in)
		do (setf res (append res (offset obj))))
	(end-of-file () res)))))


(defun freeling (txt)
  (let* ((in  (make-string-input-stream txt))
	 (out (uiop:run-program (list "analyzer_client" "8000") :input in :output :string))
	 (res nil))
    (dolist (o (offsets out)
	       (make-array (length res) :initial-contents (reverse res)))
      (push (cl-ppcre:regex-replace-all "\\n+" (subseq txt (nth 0 o) (nth 1 o)) " ")
	    res))))


;; we can also use ¶ to mark paragraphs. we can avoid the two calls
;; for regex-replace-all? we can pre-compile the regular expressions
;; too.
(defun read-content (fn)
  (let* ((d1 (cl-ppcre:regex-replace-all "\\n" (alexandria:read-file-into-string fn) " ")))
    (string-trim '(#\Space) (cl-ppcre:regex-replace-all "[ ]{2,}" d1 " "))))


(defun save-array (arr fn)
  (with-open-file (out fn :direction :output :if-exists :supersede)
    (dotimes (n (array-dimension arr 0))
      (format out "~a~%" (aref arr n)))))



(defun main ()
  (let* ((mfile    (jinput-stream "bosque_model.bin"))
	 (model    (jnew "opennlp.tools.sentdetect.SentenceModel" mfile))
	 (detector (jnew "opennlp.tools.sentdetect.SentenceDetectorME" model))
	 (detect   (jmethod "opennlp.tools.sentdetect.SentenceDetectorME" "sentDetect" 1)))
    (dolist (fn (directory "~/work/cpdoc/dhbb-nlp/raw/*.raw"))
      (let* ((txt     (read-content fn))
	     (sents-1 (jcall detect detector txt))
	     (sents-2 (freeling txt)))
	(format t "=> Processing ~a~%" fn)
	(if (equal (array-dimension sents-1 0)
		   (array-dimension sents-2 0))
	    (progn
	      (format t "=> OpenNLP and Freeling agree~%")
	      (save-array sents-1 (make-pathname :directory nil :type "sent" :defaults fn)))
	    (progn
	      (format t "=> OpenNLP and Freeling disagree~%")
	      (save-array sents-1 (make-pathname :name (format nil "~a-~a" (pathname-name fn) "op")
						 :directory nil :type "sent" :defaults fn))
	      (save-array sents-2 (make-pathname :name (format nil "~a-~a" (pathname-name fn) "fl")
						 :directory nil :type "sent" :defaults fn))))))))

