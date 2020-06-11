
(ql:quickload :cl-conllu)

(in-package :conllu.user)


(defun collect-verb-from-sent (s stack)
  (do ((node (pop stack) (pop stack))
       (first t nil)
       (result nil))
      ((and (not first) (null stack)) result)
    (let ((children (sort (token-children node s) #'<= :key #'token-id)))
      (if (equal "VERB" (token-upostag node))
	  (push (list (token-lemma node)
		      (mapcar #'token-deprel (remove-if (lambda (n)
							  (equal "PUNCT" (token-upostag n)))
							children)))
		result))
      (dolist (c children) (push c stack)))))


(defun collect-verb-from-file (file stream)
  (let ((sentences (read-conllu file)))
    (loop for s in sentences
	  do (dolist (r (collect-verb-from-sent s (list (sentence-root s))))
	       (format stream "~a ~{~a~^ ~}~%" (car r) (cdr r))))))


(defun main (path)
  (with-open-file (out path :direction :output :if-exists :supersede)
    (let ((files (directory #P"~/work/cpdoc/dhbb-nlp/udp/*.conllu")))
      (mapcar (lambda (fn) (collect-verb-from-file fn out)) files))))
