
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


;(defun main ()
;  (update-files (directory "~/work/cpdoc/dhbb-nlp/udp/*.conllu")
;		(index #P"frases.conllu")))


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

;;(defun collect-revised (pathspec)
;;  (loop for fn in (directory pathspec)
;;	for sents = (collect-from-file fn)
;;	do (format t "Looking ~a~%" fn)
;;	when sents
;;	  collect (cons fn sents)))


;; given sent list of sentences, write every revised sentence in a file called frases_rev.tmp
(defun write-from-revised (sent)
  (let (sents)
    (loop for obj in sent
      do (push  (cadr obj) sents)
         (push (cons "file" (file-namestring (car obj))) (sentence-meta (cadr obj))))
        (write-conllu (reverse sents) "frases_rev.tmp")))

;; given a file_path and a path, write every sentence in fild to its respective place in the folder with conllu sentences 

(defun to-udp (file udp)
  (let ((sent (read-conllu file)))
    (loop for obj in sent
         do (let ((sent_num (parse-integer (cdr (car (remove-if-not (lambda (s) (equal "sent_id" (car s))) (sentence-meta obj)))))))
         (let((fn (cdr (car (sentence-meta obj)))))
           (let ((udp_file (read-conllu (merge-pathnames udp (parse-namestring fn)))))
             (setf (sentence-meta obj) (cdr (sentence-meta obj)))
             (setf (nth (- sent_num 1) udp_file) obj)
             (write-conllu udp_file (merge-pathnames udp (parse-namestring fn)))
             (format t "Done file ~a~%" fn)))))))

;;given a path to the revised sentences, split and create three subsets.

(defun gen-dataset (path)
  (let ((sents (read-conllu path)))
    (let ((len (list-length sents)))
      (let ((train_len (round (* 0.65 len))))
        (let ((test_len (round (* 0.175 len))))
            (let ((train_set (subseq sents 0 train_len)))
              (let ((test_set (subseq sents train_len (+ train_len test_len))))
                (let ((dev_set (subseq sents (+ train_len test_len) len)))
                  (write-conllu train_set "gold_train.conllu")
                  (format t "~a~%" "train set saved in gold_train.conllu...")
                  (write-conllu test_set "gold_test.conllu")
                  (format t "~a~%" "test set saved in gold_test.conllu...")
                  (write-conllu dev_set "gold_dev.conllu")
                  (format t "~a~%" "dev set saved in gold_dev.conllu...")



))))))))

;;(defun main()
;;  (write-from-revised (collect-revised #P"/media/lucas/Lucas/work/dhbb-nlp/udpipe_2/"))
;;  (to-udp #P"/media/lucas/Lucas/work/dhbb-nlp/primeiras_frases/frases.texte" #P"/media/lucas/Lucas/work/dhbb-nlp/udpipe_2")
;;)

;(defun create-revised-file (fn)
;  (let ((sents (collect-revised #P"/media/lucas/Lucas/work/dhbb-nlp/udp/*.conllu")))
;       (write-conllu sents fn)))
  

;; dhbb-train.conllu dhbb-test.conllu dhbb-dev.conllu


;; second approach : more functional style 

;; (defun update-file (fn sents)
;;   (format t "update-file ~a ~a~%" fn (length sents))
;;   (labels ((update (osents rsents changed remain updated)
;; 	     (cond ((null osents)
;; 		    (values changed (append rsents remain) (reverse updated)))
		   
;; 		   ((null rsents)
;; 		    (values changed remain (append (reverse updated) osents)))

;; 		   ((string= (sentence-text (car osents))
;; 			     (sentence-text (car rsents)))
;; 		    (update (cdr osents) (cdr rsents) t
;; 			    remain (cons (merge-it (car osents) (car rsents)) updated)))

;; 		   ((string< (sentence-text (car osents))
;; 			     (sentence-text (car rsents)))
;; 		    (update (cdr osents) rsents changed
;; 			    remain (cons (car osents) updated)))

;; 		   ((string> (sentence-text (car osents))
;; 			     (sentence-text (car rsents)))
;; 		    (update osents (cdr rsents) changed
;; 			    (cons (car rsents) remain) updated)))))

;;     (multiple-value-bind (changed remain updated)
;; 	(update (sort (read-conllu fn) #'string<= :key #'sentence-text)
;; 		(sort sents #'string<= :key #'sentence-text) nil nil nil)
;;       (if changed
;; 	  (write-conllu (sort updated #'< :key (lambda (s) (parse-integer (sentence-id s)))) fn))
;;       remain)))


;; (defun update-files (files sents)
;;   (if (or (null sents) (null files))
;;       sents
;;       (update-files (cdr files) (update-file (car files) sents))))


;; (defun main ()
;;   (update-files (directory "~/work/cpdoc/dhbb-nlp/udp/*.conllu")
;; 		(remove-if-not (lambda (s)
;; 				 (equal "revisado" (sentence-meta-value s "status")))
;; 			       (read-conllu #P"frases.conllu"))))

