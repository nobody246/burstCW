(use sndfile srfi-14 loops)
(define *pi_2  (* 2 (acos -1.0)))
(define alpha (string->list "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 "))
(define alpha-codes '(".-"
                      "-..."
                      "-.-."
                      "-.."
                      " . "
                      "..-."
                      "--."
                      "...."
                      " .. "
                      ".---"
                      "-.-"
                      ".-.."
                      "--"
                      "-."
                      "---"
                      ".--."
                      "--.-"
                      ".-."
                      "..."
                      "-"
                      "..-"
                      "...-"
                      ".--"
                      "-..-"
                      "-.--"
                      "--.."
                      "-----"
                      ".----"
                      "..---"
                      "...--"
                      "....-"
                      "....."
                      "-...."
                      "--..."
                      "---.."
                      "----."
                      " "))
(define file-copy "burstCW.wav")
(define s-per-sec 11025)
(define chans 1)
(define freq 2600)
(define volume 1.0)
(define millisecond (/ s-per-sec 1000))
(define sp-count 26) 
(define dot-count 6)
(define dash-count 20)
(define inter-char 15)
(define msg (string->list (cadr (command-line-arguments))))
(print "msg:" msg)
(define fr-cnt 0)
(define (ch l k #!optional (i 0))
  (if (eq? (car l) k)
      i
      (if (null? l)
          #f
          (ch (cdr l) k (add1 i)))))
(define (get-char-wav-seq wr h x)
  (let ((y '()))
    (when (not (null? x))
      (set! y (car x)))
    (cond
     ((eq? y #\space)
      (do-times i sp-count
        (begin
          (set! fr-cnt (add1 fr-cnt))
          (wr h (list->f32vector '(0.0))))))
     ((or (eq? y #\.) (eq? y #\-))
      (let ((d (if (eq? y #\.) dot-count dash-count)))
        (do-times i d
          (begin
            (set! fr-cnt (add1 fr-cnt))
            (wr h (list->f32vector
                   `(,(* volume (sin (/ (* *pi_2
                                           freq
                                           fr-cnt)
                                        s-per-sec)))))))))
      (do-times i inter-char
            (wr h (list->f32vector '(0.0)))))))
  (when (>= (length x) 1)
      (get-char-wav-seq wr h (cdr x))))
(define (make-wav wr h m)
  (let ((x (if (null? m) (ch alpha #\space) (ch alpha (car m)))))
      (get-char-wav-seq
       wr
       h
       (string->list (list-ref alpha-codes
                               x))))
  (do-times i sp-count
            (wr h (list->f32vector '(0.0))))
  (when (not (null? m))
    (make-wav wr h (if (null? m) m (cdr m)))))
(with-sound-to-file
 file-copy
 '(wav pcm-16 file)
 s-per-sec
 chans
 (lambda (h)
   (make-wav write-items/f32
             h
             msg)))
(exit)
