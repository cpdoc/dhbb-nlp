
(ql:quickload :cl-conllu)
;; http://cl-cookbook.sourceforge.net/packages.html

(defpackage :working
  (:use :cl :cl-conllu))

(in-package :working)

;; util

(defun merge-it (old new)
  (setf (sentence-meta new)
	(sentence-meta old))
  (push (cons "status" "revisado")
	(sentence-meta new))
  new)


;; firt approach : more imperative style using hash-table

(defun index (fn)
  (let ((tb    (make-hash-table :test #'equal))
	(sents (remove-if-not (lambda (s)
				(equal "revisado" (sentence-meta-value s "status")))
			      (read-conllu fn))))
    (dolist (s sents tb)
      (setf (gethash (sentence-text s) tb)
	    s))))


(defun update-files (files tb)
  (dolist (fn files tb)
    (if (> (hash-table-count tb) 0)
	(let (changed updated)
	  (format t "update-file ~a ~a~%" fn (hash-table-count tb))
	  (dolist (s (read-conllu fn))
	    (let ((rs (gethash (sentence-text s) tb nil)))
	      (if rs
		  (progn (push (merge-it s rs) updated)
			 (remhash (sentence-text s) tb) ;; not necessary
			 (setf changed t))
		  (push s updated))))
	  (if changed
	      (write-conllu (reverse updated) fn)))
	(format t "update-file ~a no sentence remain.~%" fn))))


(defun main ()
  (update-files (directory "~/work/cpdoc/dhbb-nlp/udp/*.conllu")
		(index #P"frases.conllu")))




;; f : filename -> list of sentences
(defun collect-from-file (fn)
  (remove-if-not (lambda (s)
		   (equal "revisado" (sentence-meta-value s "status")))
		 (read-conllu fn)))

(defun collect-revised (pathspec)
  (reduce (lambda (res fn)
	    (format t "Looking ~a~%" fn)
	    (let ((r (collect-from-file fn)))
	      (if r (cons (cons fn r) res) res)))
	  (directory pathspec) :initial-value nil))

(defun collect-revised (pathspec)
  (loop for fn in (directory pathspec)
	for sents = (collect-from-file fn)
	do (format t "Looking ~a~%" fn)
	when sents
	  collect (cons fn sents)))

;; dhbb-train.conllu dhbb-test.conllu dhbb-dev.conllu


;; second approach : more functional style 

(defun update-file (fn sents)
  (format t "update-file ~a ~a~%" fn (length sents))
  (labels ((update (osents rsents changed remain updated)
	     (cond ((null osents)
		    (values changed (append rsents remain) updated))
		   
		   ((null rsents)
		    (values changed remain (append updated osents)))

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
	  (write-conllu (sort updated #'string<= :key #'sentence-id) fn))
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

