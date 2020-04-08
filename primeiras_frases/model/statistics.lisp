(ql:quickload :cl-conllu)


(defparameter *test-list* (cl-conllu:read-conllu "/home/lucas/work/dhbb-nlp/primeiras_frases/model/teste.conllu"))
(defparameter *predicted-list* (cl-conllu:read-conllu "/home/lucas/work/dhbb-nlp/primeiras_frases/model/target_index.conllu"))




(format nil "Exact match score: ~a~%Microaverage UAS: ~a~%Macroaverage UAS: ~a~%Microaverage LAS: ~a~%Macroaverage UAS: ~a~%"
        (conllu.evaluate:exact-match-score *predicted-list* *test-list*)
        (conllu.evaluate:attachment-score-by-word *predicted-list* *test-list*
                                                  :labeled nil)
        (conllu.evaluate:attachment-score-by-sentence *predicted-list* *test-list*
                                                      :labeled nil)
        (conllu.evaluate:attachment-score-by-word *predicted-list* *test-list*
                                                  :labeled t)
        (conllu.evaluate:attachment-score-by-sentence *predicted-list* *test-list*
                                                      :labeled t))

                                                      

                                                      
                                                    
(defparameter *test-list* (cl-conllu:read-conllu "/home/lucas/work/dhbb-nlp/primeiras_frases/model/teste_bosque.conllu"))
                                                    
                                                    
                                                    
(format nil "Exact match score: ~a~%Microaverage UAS: ~a~%Macroaverage UAS: ~a~%Microaverage LAS: ~a~%Macroaverage UAS: ~a~%"
        (conllu.evaluate:exact-match-score *predicted-list* *test-list*)
        (conllu.evaluate:attachment-score-by-word *predicted-list* *test-list*
                                                  :labeled nil)
        (conllu.evaluate:attachment-score-by-sentence *predicted-list* *test-list*
                                                      :labeled nil)
        (conllu.evaluate:attachment-score-by-word *predicted-list* *test-list*
                                                  :labeled t)
        (conllu.evaluate:attachment-score-by-sentence *predicted-list* *test-list*
                                                      :labeled t))

