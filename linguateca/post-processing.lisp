
(ql:quickload '(:cxml :xpath :alexandria :cl-ppcre))


(defun main (file-in file-out)
  (let* ((data-1 (format nil "<doc>~a</doc>" (alexandria:read-file-into-string file-in)))
	 (data-2 (cl-ppcre:regex-replace-all "&" data-1 "&amp;")))
    (with-open-file (out file-out :direction :output :if-exists :supersede)
      (let ((doc (cxml:parse data-2 (cxml-dom:make-dom-builder))))
	(xpath:do-node-set (node (xpath:evaluate "//s/text()" doc))
	  (format out "~a~%" (string-trim '(#\Space #\Tab #\Newline) (xpath:string-value node))))))))


(mapc (lambda (file)
	(main file (format nil "~a.new" (pathname-name file))))
      (directory "*.sent"))


