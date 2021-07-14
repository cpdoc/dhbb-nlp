
(ql:quickload '(:cl-ppcre :alexandria :cl-conllu))

(in-package :conllu.user)

(defstruct entry form lemma pos lpat)

(defmethod print-object ((obj entry) out)
  (print-unreadable-object (obj out :type t)
    (format out "~a:~a ~a/~a" (entry-form obj) (entry-lemma obj) (entry-pos obj) (entry-lpat obj))))

(defmethod print-object ((obj token) out)
  (print-unreadable-object (obj out :type t)
    (format out "~a:~a ~a/~a #~a-~a-~a"
	    (slot-value obj 'form) (slot-value obj 'lemma) (slot-value obj 'upostag) (slot-value obj 'feats)
	    (slot-value obj 'id) (slot-value obj 'deprel) (slot-value obj 'head))))

(defun line-to-entry (line)
  (destructuring-bind (form rest)
      (cl-ppcre:split "\\t" (string-trim '(#\Space #\Tab) line))
    (let ((as (cl-ppcre:split "\\+" rest)))
      (make-entry :form form :lemma (car as) :pos (cadr as)
		  :lpat (format nil "~{~a~^+~}" (subseq as 1))))))


(defun read-dict (file dict)
  (with-open-file (in file)
    (loop for line = (read-line in nil nil)
	  while line
	  do (let ((e (line-to-entry line)))
	       (push e (gethash (entry-form e) dict)))
	  finally (return dict))))

(defun read-morphobr ()
  (let ((dicts (append (directory "/Users/ar/work/morpho-br/nouns/*.dict")
		       (directory "/Users/ar/work/morpho-br/adjectives/*.dict")
		       (directory "/Users/ar/work/morpho-br/verbs/*.dict")
		       (directory "/Users/ar/work/morpho-br/adverbs/*.dict"))))
    (reduce (lambda (tb file) (read-dict file tb)) dicts 
	    :initial-value (make-hash-table :test #'equal))))

(defun read-mapping (fn)
  (with-open-file (in fn)
    (loop for line = (read-line in nil nil)
	  while line
	  for reg = (cl-ppcre:split "[ ]+" (string-trim '(#\Space #\Tab) line))
	  when (> (length reg) 3) collect (subseq reg 1))))



(defun unique? (lst)
  (equal 1(length lst)))


(defun filter-map (tk mapping)
  (remove-if-not (lambda (e)
		   (and (equal (token-feats tk) (cadr e))
			(equal (token-upostag tk) (car e))))
		 mapping))

(defun filter-dic (entries mapping)
  (remove-if-not (lambda (e)
		   (member (entry-lpat e) mapping :test #'equal :key #'caddr))
		 entries))


(defun equal-pos (pdict pud)
  (let ((map '(("NOUN" . "N") ("VERB" . "V") ("AUX" . "V") ("ADJ" . "A") ("ADV" . "ADV"))))
    (equal pdict (cdr (assoc pud map :test #'equal)))))

(defun compatible (tk entry)
  (and (equal     (entry-lemma entry) (token-lemma tk))
       (equal-pos (entry-pos entry)   (token-upostag tk))
       (equal     (entry-form entry)  (string-downcase (token-form tk)))))

(defun remove1 (alist)
  (remove-if (lambda (e) (and (equal "A" (entry-pos e))
			      (equal (entry-lemma e) (entry-form e))))
	     alist))

(defun remove2 (alist)
  (remove-if (lambda (e) (and (member (entry-pos e) (list "N" "A") :test #'equal)
			      (equal (entry-lemma e) (entry-form e))))
	     alist))

(defun check (tk dict mapping stream)
  (if (member (token-upostag tk) (list "VERB" "ADV" "NOUN" "ADJ" "AUX") :test #'equal)
      (let* ((lform   (string-downcase (token-form tk)))
	     (entries0 (remove2 (remove1 (gethash lform dict))))
	     (entries1 (remove-if-not (lambda (e) (compatible tk e)) entries0)))
	(cond
	  ((equal 1 (length entries1))
	   ;; (format stream "~a ok~%" tk)
	   )
	  ((> (length entries1) 1)
	   (format stream "~a ambiguos, found ~%~{ ~a~^~%~}~%~%" tk entries1))
	  ((not entries1)
	   (format stream "~a not found in dict~%" tk))))))


(defparameter mapping (read-mapping "mapping.txt"))
(defparameter dic (read-morphobr))

(defun main (dict map &key (path "../udp-mini/*.conllu") (out *standard-output*))
  (mapc (lambda (fn)
	  (loop for s in (cl-conllu:read-conllu fn)
		do (progn
		     (format out "~%Sentence: ~a ~a ~%" (sentence-id s) (sentence-text s))
		     (loop for tk in (sentence-tokens s)
			   do (check tk dict map out)))))
	(directory path)))
