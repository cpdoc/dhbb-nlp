
(ql:quickload :cl-conllu)

(in-package :conllu.user)

(defun add-meta-and-save (fn)
  (let ((sents (read-conllu fn))
	(changed nil))
    (dolist (s sents)
      (mapc (lambda (field)
	      (if (not (sentence-meta-value s field))
		  (progn
		    (setf changed t)
		    (push (cons field "no")
			  (sentence-meta s)))))
	    '("golden_split" "golden_syntactic")))
    (if changed (write-conllu sents fn))))

(defun main ()
  (mapc #'add-meta-and-save (directory "../udp/*.conllu")))


