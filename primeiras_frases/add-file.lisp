
(ql:quickload :cl-conllu)

(in-package :cl-conllu)

(defun merge-it (old new)
  (setf (sentence-meta new)
	(sentence-meta old))
  (push (cons "status" "revisado")
	(sentence-meta new))
  new)


(defun update-file (fn sents)
  (format t "update-file ~a ~a~%" fn (length sents))
  (labels ((update (osents rsents changed remain updated)
	     (cond ((null osents)
		    (values changed (append rsents remain) (reverse updated)))
		   
		   ((null rsents)
		    (values changed remain (append (reverse updated) osents)))

		   ((string= (sentence-text (car osents))
			     (sentence-text (car rsents)))
		    (update (cdr osents) (cdr rsents) t
			    remain (cons (merge-it (car osents) (car rsents)) updated)))

		   ((string< (sentence-text (car osents))
			     (sentence-text (car rsents)))
		    (update (cdr osents) rsents changed
			    remain (cons (car osents) updated)))

		   ((string> (sentence-text (car osents))
			     (sentence-text (car rsents)))
		    (update osents (cdr rsents) changed
			    (cons (car rsents) remain) updated)))))

    (multiple-value-bind (changed remain updated)
	(update (sort (read-conllu fn) #'string<= :key #'sentence-text)
		(sort sents #'string<= :key #'sentence-text) nil nil nil)
      (if changed
	  (write-conllu (sort updated #'< :key (lambda (s) (parse-integer (sentence-id s)))) fn))
      remain)))


(defun update-files (files sents)
  (if (or (null sents) (null files))
      sents
      (update-files (cdr files) (update-file (car files) sents))))


(defun main ()
  (update-files (directory "~/work/cpdoc/dhbb-nlp/udp/*.conllu")
		(remove-if-not (lambda (s)
				 (equal "revisado" (sentence-meta-value s "status")))
			       (read-conllu #P"frases.conllu"))))

