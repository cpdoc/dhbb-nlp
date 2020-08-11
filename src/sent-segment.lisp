
;; to be runned with ABCL Lisp
;; useful info https://abcl.org/releases/1.7.0/abcl-1.7.0.pdf

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
	       (make-array (list (length res) 2) :initial-contents (reverse res)))
      (push (list (nth 0 o) (nth 1 o)) res))))


;; we can also use ¶ to mark paragraphs. we can avoid the two calls
;; for regex-replace-all? we can pre-compile the regular expressions
;; too.
(defun read-content (fn)
  (alexandria:read-file-into-string fn))

(defun save-array (arr fn)
  (with-open-file (out fn :direction :output :if-exists :supersede)
    (dotimes (n (array-dimension arr 0))
      (format out "~a ~a~%" (aref arr n 0) (aref arr n 1)))))

(defun get-2-array (spans)
  (let* ((nsent (array-dimension spans 0))
	 (start (jmethod "opennlp.tools.util.Span" "getStart" 0))
	 (end   (jmethod "opennlp.tools.util.Span" "getEnd" 0))
	 (res   (make-array (list nsent 2) :initial-element 0)))
    (dotimes (n nsent res)
      (setf (aref res n 0) (jcall start (aref spans n))
	    (aref res n 1) (jcall end (aref spans n))))))


(defun diff (array1 array2)
  (labels ((a2l (array)
	     (loop for i below (array-dimension array 0)
		   collect (cons (aref array i 0) (aref array i 1)))))
    (let* ((l1 (a2l array1))
	   (l2 (a2l array2))
	   (int (intersection l1 l2 :test #'equal))
	   (u-i (set-difference (union l1 l2  :test #'equal) int :test #'equal)))
      (values (sort int #'<= :key #'car) (sort u-i #'<= :key #'car)))))


(defun construct-out-path (fn suffix extension)
  (let ((dir (reverse (cons "sents" (cdr (reverse (pathname-directory fn))))))
	(nm  (format nil "~a-~a" (pathname-name fn) suffix)))
    (make-pathname :directory dir :name nm :type extension :defaults fn)))

(defun main ()
  (let* ((mfile    (jinput-stream "model_opennlp.bin"))
	 (model    (jnew "opennlp.tools.sentdetect.SentenceModel" mfile))
	 (detector (jnew "opennlp.tools.sentdetect.SentenceDetectorME" model))
	 (detect   (jmethod "opennlp.tools.sentdetect.SentenceDetectorME" "sentPosDetect" 1)))
    (dolist (fn (directory "~/work/cpdoc/dhbb-nlp/raw/*.raw"))
      (let* ((txt     (read-content fn))
	     (spans-1 (get-2-array (jcall detect detector txt)))
	     (spans-2 (freeling txt)))
	(format t "=> Processing ~a~%" fn)
	(save-array spans-1 (construct-out-path fn "op" "sent"))
	(save-array spans-2 (construct-out-path fn "fl" "sent"))))))
