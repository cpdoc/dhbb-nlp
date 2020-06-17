
(ql:quickload '(:alexandria :cl-conllu))

(in-package :conllu.user)

(defun add-meta-and-save (fn)
  (let ((sents (read-conllu fn)))
    (dolist (s sents)
      (let ((tb (alexandria:alist-hash-table (sentence-meta s) :test #'equal)))
	(if (equal "revisado" (gethash "status" tb))
	    (setf (gethash "status" tb)
		  "syntax"))
	(remhash "golden_syntactic" tb)
	(remhash "golden_split" tb)
	(setf (sentence-meta s)
	      (alexandria:hash-table-alist tb))))
    (write-conllu sents fn)))

(defun main ()
  (mapc #'add-meta-and-save (directory "../udp/*.conllu")))


