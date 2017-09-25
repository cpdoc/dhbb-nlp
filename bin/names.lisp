
(ql:quickload :cl-conllu)


;; names: sequence of names from a gazette

(defun expand-names (names &optional res)
  (if (null names)
      (nreverse res)
      (expand-names (cdr names)
		    (cond ((member (car names) '("dos" "do")
				   :test #'equal)
			   (cons "o" (cons "de" res)))
			  ((member (car names) '("das" "da")
				   :test #'equal)
			   (cons "a" (cons "de" res)))
			  (t (cons (car names) res))))))

(defun sentences ()
  (mapcar (lambda (s) (mapcar #'token-form (sentence-tokens s)))
	  (reduce (lambda (l a) (append l (read-conllu a)))
		  (directory #P"~/work/cpdoc/dhbb-nlp/udp/21*.conllu")
		  :initial-value nil)))

(defun names ()
  (with-open-file (in #P"~/work/cpdoc/dhbb/dic/pessoa-individuo.txt")
    (loop for line = (read-line in nil nil)
	  while line
	  collect (expand-names (cl-ppcre:split "[ ]+"
						(string-trim '(#\Space #\Tab) line))))))


(defun block-scanner (trigger)
  (let* ((curr trigger))
    (lambda (data)
      (dolist (w data (not curr))
	(if curr
	    (setq curr (if (equal (car curr) w)
			   (cdr curr) 
			   trigger)))))))


(defun find-occurrences ()
  (let ((sents (sentences))
	(names (names)))
    (time (loop for n in names
		for v = (remove-if-not (lambda (sent)
					 (search n sent :test #'equal))
				       sents)
		when v
		collect (list n (length v))))))


(defun find-occurrences ()
  (let ((sents (sentences))
	(names (names)))
    (time (loop for n in names
		for scanner = (block-scanner n)
		for v = (remove-if-not (lambda (sent)
					 (funcall scanner sent))
				       sents)
		when v
		collect (list n (length v))))))



(with-open-file (in #P"~/work/cpdoc/dhbb/dic/pessoa-individuo.txt")
  (let ((names (loop for line = (read-line in nil nil)
		     while line
		     collect (string-trim '(#\Space #\Tab) line)))
	(sents (mapcar (lambda (sent) (sentence-meta-value sent "text"))
		       (cl-conllu:read-conllu #P"/Users/arademaker/work/cpdoc/dhbb-nlp/udp/"))))
    (time (loop for n in names
		for v = (remove-if-not (lambda (sent) (search n sent :test #'equal))
				       sents)
		when v
		collect (list n (length v))))))

(defvar teste *)

(in-package :rcl)
(r-init)

(with-open-file (out "saida.txt" :direction :output)
  (format out "~a~%~%" cl-conllu::teste)
  (format out "~a" (r "summary" (mapcar #'cadr cl-conllu::teste))))

