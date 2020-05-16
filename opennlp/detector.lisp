
;; to be runned in ABCL

(ql:quickload '(:cl-ppcre :alexandria))

(mapcar #'add-to-classpath
	(directory "/Users/ar/work/apache-opennlp-1.9.2/lib/*.jar"))

;; we can also use ¶ to mark paragraphs. we can avoid the two calls
;; for regex-replace-all.
(defun read-content (fn)
  (let* ((d1 (cl-ppcre:regex-replace-all "\\n" (alexandria:read-file-into-string fn) " "))
	 (d3 (string-trim '(#\Space) (cl-ppcre:regex-replace-all "[ ]+" d1 " "))))
    d3))


(defun main ()
  (let* ((mfile    (jinput-stream "bosque_model.bin"))
	 (model    (jnew "opennlp.tools.sentdetect.SentenceModel" mfile))
	 (detector (jnew "opennlp.tools.sentdetect.SentenceDetectorME" model))
	 (detect   (jmethod "opennlp.tools.sentdetect.SentenceDetectorME" "sentDetect" 1)))
    (dolist (fn (directory "~/work/cpdoc/dhbb-nlp/raw/*.raw"))
      (let* ((sents   (jcall detect detector (read-content fn)))
	     (fout    (make-pathname :directory nil :type "sent" :defaults fn)))
	(format t "=> Processing ~a.~%" fn)
	(with-open-file (out fout :direction :output :if-exists :supersede)
	  (dotimes (n (array-dimension sents 0))
	    (format out "~a~%" (aref sents n))))))))
