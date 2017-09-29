;; authors: bruno cuconato (@odanoburu)
;; placed in the public domain.

;; this code assumes a trie of entities built by
;; trie.lisp. (recognize-ents-in-sentences ) will take this trie and a
;; list of sentences (list of list of characters) and recognize the
;; entities found in each sentence, outputting the results in the
;; following format (called 'entrec' in the code):

;; ((sentence-id . (entity-id start-index)))

;; using (visualize-entities-and-sentences ) one can transform this
;; output into ((entities found) sentence) for better visualization.

;; one can also count the entities found in the sentences provided,
;; using (count-entities (get-entids-from-entrecs entrecs), which will
;; give:

;; ((entity-id . entity-count))

;; again, for better visualization, one can use:

;; (viz-count raw-entities (count-entities (get-entids-from-entrecs
;; entrecs))))

;; where raw-entities is a list of the entities' names, in order of
;; id.

;;
;; to-do's:
;; encontrar submatches tb
;; transformar em função geradora (mas cl não é lazy...)


(ql:quickload :cl-conllu)
(load (compile-file #p"~/git/ed-2017-2/src/projeto/trie.lisp"))

;;
;; recognize entities
(defun unwind-entity (entity start &optional entities)
  (unless entity
    (return-from unwind-entity entities))
  (let ((ent-id (trie-is-leaf? (first entity))))
    (if (numberp ent-id)
        (unwind-entity (rest entity) start (acons ent-id start
                                                  entities))
        (unwind-entity (rest entity) start entities))))

;;
;; recognize entities
(defun token-in-trie? (trie token)
  "return trie-leaf if token is leaf in trie."
  (partially-in-trie? trie token))

(defun aux-recognize-ents-in-sentence (trie token-list
                                       &key entity (iter 0))
  (when (endp token-list)
    (return-from aux-recognize-ents-in-sentence
      (values nil entity iter)))
  (let ((trie-node (token-in-trie? trie (first token-list))))
    (cond ((and (null entity)
		(null trie-node))
	   (values (rest token-list) nil (1+ iter)))
	  ((and (null trie-node) entity)
	   (values token-list entity iter))
          ;; not (rest token-list) to give tk a fresh chance, but will
          ;; only give this chance to the last tk. (think of searching
          ;; for joão almeida de castro when only joão almeida and
          ;; joão almeida de silva are ents: only castro will be
          ;; reconsidered, not 'de'). is that a problem?
	  (trie-node
	   (aux-recognize-ents-in-sentence trie-node
					 (rest token-list)
					 :entity (cons trie-node
                                                       entity)
                                         :iter (1+ iter))))))

(defun recognize-ents-in-sentence (trie token-list
                                   &key entities (start 0))
  "return entities found (list (cons ent-id (start end)))"
  (if (endp token-list)
      entities
      (multiple-value-bind (rest-token-list entity iter)
          (aux-recognize-ents-in-sentence trie token-list)
        (recognize-ents-in-sentence trie
                                    rest-token-list
                                    :entities
                                    (append (unwind-entity
                                             entity start)
                                            entities)
                                    :start (+ start iter)))))

;;
;; entry point
(defun recognize-ents-in-sentences (trie sentences
                                    &key entities (sentid 0))
  "take trie and list of sentences (list of tokens), return sentid
with entities recognized in index ix (entity . ix)"
  (if (endp sentences)
      entities
      (let ((entities-in-sent (recognize-ents-in-sentence
                               trie (first sentences))))
        (recognize-ents-in-sentences trie (rest sentences)
                                     :entities (acons sentid
                                                      entities-in-sent
                                                      entities)
                                     :sentid (1+ sentid)))))

;;
;; visualization
(defun get-entity (entities entid)
  (nth entid entities))

(defun get-entities (entities entids &optional entities-found)
  "get entities' names from entity ids."
  (if (endp entids)
      entities-found
      (get-entities entities (rest entids)
                    (cons (get-entity entities (caar entids))
                          entities-found))))

(defun visualize-entities-and-sentences (sentences rec-entities
                                         entities &optional viz)
  "useful for debugging. assumes sentences and rec-entities are
paired."
  (if (endp sentences)
      viz
      (let* ((entids-in-sent (cdar rec-entities))
             (ents-in-sent (get-entities entities entids-in-sent))
             (sent (first sentences)))
        (visualize-entities-and-sentences (rest sentences)
                                          (rest rec-entities)
                                          entities
                                          (acons ents-in-sent
                                                 sent
                                                 viz)))))

;;
;; get enclosing entities
(defun aux-add-size-to-entrec (entid-start semi-entities)
  (destructuring-bind (entid . start) entid-start
    (list* entid start (length (get-entity semi-entities entid)))))
  
  
(defun add-size-to-entrec (entrec semi-entities)
  (destructuring-bind (sentid . entrecs) entrec
    (cons sentid (mapcar (lambda (entid-start)
                           (aux-add-size-to-entrec entid-start
                                                   semi-entities))
                         entrecs))))

(defun aux-enclosing-entities (entid start end other-ents &optional
                                                            filtered)
  (if (endp other-ents)
      (values (cons entid start) (reverse filtered))
      (destructuring-bind ((o-entid o-start . o-end) &rest
                           rest-other-ents)
          other-ents
        (if (and (<= start o-start)
                 (>= (+ start end) (+ o-start o-end)))
            (aux-enclosing-entities entid start end
                                    rest-other-ents
                                    filtered)
            (aux-enclosing-entities entid start end
                                    rest-other-ents
                                    (cons (cons o-entid (cons o-start
                                                              o-end))
                                          filtered))))))

(defun enclosing-entities (ents &optional enclosing)
  (if (endp ents)
      enclosing
      (destructuring-bind ((entid start . size) &rest other-ents) ents
          (multiple-value-bind (enc-ent filtered-ents)
              (aux-enclosing-entities entid start size other-ents)
            (enclosing-entities filtered-ents
                                (cons enc-ent enclosing))))))
      

(defun get-enclosing-entities (entrecs semi-entities &optional
                                                  enclosing-ents)
  (if (endp entrecs)
      enclosing-ents
      (let ((entrec-w/size (add-size-to-entrec (first entrecs)
                                               semi-entities)))
        (destructuring-bind (sentid . ents) entrec-w/size
          (get-enclosing-entities (rest entrecs)
                                  semi-entities
                                  (cons (cons sentid
                                              (enclosing-entities
                                               (reverse ents)))
                                      enclosing-ents))))))

;;
;; count entities (remove is for better performance)
(defun get-entids-from-entrec (rec-entity &optional entities-found)
  "entrec '(sentid (entid start size) (entid2 start2 size2))"
  (if (endp rec-entity)
      entities-found
      (get-entids-from-entrec (rest rec-entity) (cons (caar rec-entity)
                                          entities-found))))

(defun get-entids-from-entrecs (rec-entities &optional entities-found)
  "equiv to (mapcan (lambda (entrec)
            (get-entids-from-entrec (rest entrec)))
          rec-entities))"
  (if (endp rec-entities)
      entities-found
      (get-entids-from-entrecs (rest rec-entities)
                                 (append (get-entids-from-entrec
                                        (cdar rec-entities))
                                       entities-found))))

(defun count-and-remove (item sequence &key (predicate #'=)
                                          (count 0) filtered-items)
  (when (endp sequence) (return-from count-and-remove
				(values count filtered-items)))
  (let ((se1 (first sequence))
	(rest-sequence (rest sequence)))
    (if (funcall predicate item se1)
	(count-and-remove item rest-sequence
			  :predicate predicate
			  :count (1+ count)
			  :filtered-items filtered-items)
	(count-and-remove item rest-sequence
			  :predicate predicate
			  :count count
			  :filtered-items
                          (cons se1 filtered-items)))))

(defun count-and-remove-entity (entid entids-found
                                &optional entid-count (predicate #'=))
  (multiple-value-bind (count filtered-entids)
      (count-and-remove entid entids-found :predicate predicate)
    (values (acons entid count entid-count) filtered-entids)))

(defun count-entities (entids &key (predicate #'=)
                                           entid-count)
  (if (endp entids)
      entid-count
      (multiple-value-bind (new-entid-count filtered-entids)
	  (count-and-remove-entity (first entids) entids
				   entid-count predicate)
	(count-entities filtered-entids
				   :predicate predicate
				   :entid-count new-entid-count))))

(defun viz-count (entities entid-count &optional entity-count)
  (if (endp entid-count)
      entity-count
      (destructuring-bind (entid . count) (first entid-count)
        (viz-count entities (rest entid-count)
                   (acons (get-entity entities entid)
                          count
                          entity-count)))))

;;
;; entities not found
(defun aux-get-null-indices (list &key (ix 0) null-ixs)
  "return indices where element is null."
  (if (endp list)
      null-ixs
      (aux-get-null-indices (rest list)
                           :ix (1+ ix)
                           :null-ixs (if (null (first list))
                                         (cons ix null-ixs)
                                         null-ixs))))

(defun get-null-indices (vector)
  (aux-get-null-indices (coerce vector 'list)))

(defun get-number-of-entities (entities-path)
  "must have trailing newline."
  (with-open-file (stream entities-path)
    (loop for line = (read-line stream nil)
         for ix from 0
          while line
       finally (return ix))))

(defun update-remaining-ents (entid remaining-ents entity-vector)
  (if (svref entity-vector entid)
      (values remaining-ents entity-vector)
      (and (setf (svref entity-vector entid) t)
           (values (1- remaining-ents) entity-vector))))

(defun aux-ents-not-found (entities-found remaining ent-vec)
  (when (= remaining 0) (return-from aux-ents-not-found nil))
  (if (endp entities-found)
      (get-null-indices ent-vec)
      (multiple-value-bind (new-remaining new-ent-vec)
          (update-remaining-ents (first entities-found)
                                 remaining ent-vec)
        (aux-ents-not-found (rest entities-found)
                            new-remaining
                            new-ent-vec))))

(defun ents-not-found (entities-found nr-ents)
  (let ((entity-vector (make-array nr-ents :initial-element nil)))
    (aux-ents-not-found entities-found nr-ents entity-vector)))
  


;;
;; tests
#|
(get-entids-from-entrec '((20 11 1) (21 7 3))) ; (21 20)
(count-and-remove 1 (list 1 52 26 73 1 0)) ; 2 (0 73 26 52)
(count-and-remove -88 (list 1 52 26 73 1 0)) ; (0 1...)
(count-and-remove-entity 1 (list 1 284 1 393 0 -1))
                                        ; ((1 . 2)) (-1 0 393 284)
(count-entities (list 1 2 3 4 -1 1 8 -1 -1 3))
               ;; ((8 . 1) (4 . 1) (-1 . 3) (2 . 1) (3 . 2) (1 . 2))

(let* ((sents '(("amanda" "silvana" "de" "castro" "amava" "joão" "bosco" ".")
               ("joão" "bosco" "de" "santos" "gostava" "de" "reggae.")
               ("aqui" "não" "tem" "entidade.")))
       (char-sents (mapcar (lambda (sent)
                             (mapcar #'str-to-char sent))
                           sents))
       (raw-ents (list "amanda silvana" "amanda silvana de castro"
                   "joão bosco" "joão bosco de santos"))
       (semi-ents (mapcar (lambda (name)
                            (split-sequence:split-sequence #\space name))
                          raw-ents))
       (ents (conllu-process-entities raw-ents))
       (trie (start-trie ents))
       (rec-entities (recognize-ents-in-sentences trie char-sents)))
  (print rec-entities) ;;((2) (1 (2 . 0) (3 . 0)) (0 (2 . 5) (0 . 0) (1 . 0))) 
  (get-enclosing-entities rec-entities semi-ents)) ;; ((0 (2 . 5) (1 . 0)) (1 (3 . 0)) (2))

|#
