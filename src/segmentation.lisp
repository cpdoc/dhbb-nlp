
(ql:quickload :serapeum)

(defun read-lines (fn)
  (with-open-file (in fn)
    (loop for line = (read-line in nil nil)
	  while line
	  collect line)))

(defun stat (fn)
  (list (length (read-lines fn))
	(length (read-lines (merge-pathnames #P"../nltk/" fn)))
	(length (read-lines (merge-pathnames #P"../fl/" fn)))))

(defun main ()
  (serapeum:assort (mapcar #'stat (directory "../opennlp/*.sent"))
		   :key (lambda (lst) (length (remove-duplicates lst)))))


(mapcar #'length (main))
;; all eq / two eq / no eq => (6054 1251 388)

(let* ((res (main))
       (teq (cadr res))
       (neq (caddr res)))
  (print (mapcar #'length (serapeum:assort teq :key (lambda (lst)
						      (cond ((equal (car lst) (cadr lst)) 12)
							    ((equal (car lst) (caddr lst)) 13)
							    ((equal (cadr lst) (caddr lst)) 23))))))
  (multiple-value-bind (a b)
      (serapeum:partition (lambda (lst) (apply #'> lst)) neq)
    (print (list (length a) (length b)))))

;; (265 333 653) 
;; (271 117)
