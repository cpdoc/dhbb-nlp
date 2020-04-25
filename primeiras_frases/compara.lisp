(ql:quickload :cl-conllu)

(defparameter path_to_frases #P"/home/lucas/work/dhbb-nlp/primeiras_frases/frases.conllu")

(defparameter *sent* (cl-conllu:read-conllu *path_to_frases*))

(defparameter path_to_udp #P"/home/lucas/work/dhbb-nlp/udp/")

(defparameter *correct_sents* 
  (cl-conllu:read-conllu path_to_frases))

(defun get-path (sent) 
  (let ((out 
      (cdr 
       (nth 3 
            (cl-conllu:sentence-meta sent)))))

   (merge-pathnames path_to_udp (parse-namestring out)))

)
