;; authors: bruno cuconato (@odanoburu)
;; placed in the public domain.


;; this code takes as input (see example in the end) a file with a
;; list of entities (one per line). it will strip the name's
;; separators (space by default) and build a trie from their
;; characters. the last character of each entity will be marked as a
;; leaf with the entity id (the line it appears on the file, starting
;; at 0). search functions are provided.

;; note: any node at any point of a trie is itself a trie (as a trie
;; is characterized by a root node and its children).

(defstruct (trie (:print-function
		   (lambda (node stream k)
		     (identity k)
		     (format stream "|~A|" (trie-value node)))))
  (value "ROOT")
  (children)
  (is-leaf?))

;;
;; input
(defun read-entities (filepath)
  (with-open-file (stream filepath)
    (loop for line = (read-line stream nil)
       while line
       collect line)))

(defun str-to-char (string)
  (coerce string 'list))

(defun remove-separator (chars separator)
  (remove-if (lambda(character)
               (char= character separator))
            chars))

(defun process-string (string &optional (separator #\space))
  (remove-separator (str-to-char (string-trim '(#\space #\tab) string))
                    separator))

(defun process-entities (entities &key (process-fn #'process-string)
                                    processed-entities
                                    (id 0))
  "return (ent-id . entity), where entity = list of characters minus
separator"
  (if (endp entities)
      processed-entities
      (process-entities
       (rest entities) :id (1+ id)
       :process-fn process-fn
       :processed-entities (acons id (funcall process-fn
                                              (first entities))
                                  processed-entities))))

;;
;; search
(defun aux-search-children (tries character)
  (when (endp tries)
    (return-from aux-search-children nil))
  (let ((trie (first tries)))
    (if (char= character (trie-value trie))
	trie
	(aux-search-children (rest tries) character))))

(defun search-children (trie character)
  "searches children of a trie node for a value of character"
  (let ((trie-children (trie-children trie)))
    (aux-search-children trie-children character)))

#|;; can use this simpler (but seemingly less efficient) form.
(defun search-children (trie character)
  (let ((trie-children (trie-children trie)))
    (find character trie-children :key #'trie-value :test #'char=)))
|#

(defun search-trie (trie chars &optional path (ix 0))
  (when (endp chars)
    (return-from search-trie (values trie path ix)))
  (let ((match (search-children trie (first chars))))
    (if (null match)
	(values trie path ix) ; returns reverse path
	(search-trie match (rest chars)
                     (cons match path) (1+ ix)))))

(defun str-search-trie (trie string &optional
                                      (str-process-fn #'process-string))
  (let ((chars (funcall str-process-fn string)))
    (search-trie trie chars)))

(defun partially-in-trie? (trie chars)
  (multiple-value-bind (trie-node * ix) (search-trie trie chars)
    (when (= (length chars) ix) trie-node)))

(defun leaf-in-trie? (trie chars)
  "return nil or trie-leaf."
  (let ((trie-node (partially-in-trie? trie chars)))
    (when (and trie-node (trie-is-leaf? trie-node))
        trie-node)))

(defun str-in-trie? (trie string &optional
                                   (str-process-fn #'process-string))
  (let ((chars (funcall str-process-fn string)))
    (leaf-in-trie? trie chars)))

;;
;; cons trie
(defun add-char-to-children (trie char)
  (push (make-trie :value char) (trie-children trie))
  (search-children trie char))

(defun mark-node (trie ent-id)
  (setf (trie-is-leaf? trie) ent-id)
  trie)

(defun insert-node (trie chars ent-id)
  "add value which is not present in trie."
  (if (endp chars)
      (mark-node trie ent-id)
      (insert-node (add-char-to-children trie (first chars))
		   (rest chars) ent-id)))

(defun aux-add-node (trie chars ent-id)
  (multiple-value-bind (trie-node * ix)
      (search-trie trie chars)
    (if (= (length chars) ix)
        (mark-node trie-node ent-id)
        (insert-node trie-node (subseq chars ix) ent-id))))

(defun add-node (trie value)
  (destructuring-bind (ent-id . entity-chars) value
    (aux-add-node trie entity-chars ent-id)))

(defun start-trie (ent-values)
  (let ((trie-root (make-trie)))
    (dolist (ent-value ent-values)
      (add-node trie-root ent-value))
    trie-root))

;;
;; tests
#|
(let* ((raw-ents (read-entities #p"entities.txt"))
       (ents (process-entities raw-ents))
       (test-trie (start-trie ents)))
  (trie-is-leaf? test-trie) ; nil
  (str-search-trie test-trie "amanda") ; |a| (|a| |d| |n| |a| |m| |a|) 6
  (str-search-trie test-trie "xesus") ; |ROOT| NIL 0
  (str-search-trie test-trie "amanda silva") ; |a| (|a| |v| |l| ... |a|) 11
  (str-in-trie? test-trie "amanda") ; nil
  (str-in-trie? test-trie "amanda silva") ; |a| leaf
  (str-in-trie? test-trie "amanda silvan") ; nil
  )
|#
