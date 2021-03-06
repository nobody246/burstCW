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
(define out-file "burstCW.wav")
(define s-per-sec 11025)
(define chans 1)
(define volume 1.0)
(define sp-count 26) 
(define dot-count 6)
(define dash-count 20)
(define interchar-count 15)
(define cli (command-line-arguments))
(define msg (map char-upcase (string->list (cadr cli))))
(define freq (if (>= (length cli) 3) (string->number (caddr cli)) #f))
(when (not freq)
  (set! freq 3600))
(print "msg:" msg)
(define fr-count 0)
(define (ch l k #!optional (i 0))
  (if (null? l)
      #f
      (if (eq? (car l) k)
          i
          (ch (cdr l) k (add1 i)))))
(define (get-char-wav-seq wr h x)
  (let ((y '()))
    (when (not (null? x))
      (set! y (car x)))
    (cond
     ((eq? y #\space)
      (do-times i sp-count
                (set! fr-count (add1 fr-count))
                (wr h (list->f32vector '(0.0)))))
     ((or (eq? y #\.) (eq? y #\-))
      (let ((d (if (eq? y #\.) dot-count dash-count)))
        (do-times i d
                  (set! fr-count (add1 fr-count))
                  (wr h (list->f32vector
                         `(,(* volume (sin (/ (* *pi_2
                                                 freq
                                                 fr-count)
                                              s-per-sec))))))))
      (do-times i interchar-count
            (wr h (list->f32vector '(0.0)))))))
  (when (>= (length x) 1)
      (get-char-wav-seq wr h (cdr x))))
(define (make-wav wr h m)
  (and-let* ((x (if (null? m) (ch alpha #\space) (ch alpha (car m)))))
      (get-char-wav-seq
       wr
       h
       (string->list (list-ref alpha-codes x)))
      (do-times i sp-count
                (wr h (list->f32vector '(0.0))))
      (when (not (null? m))
        (make-wav wr h (if (null? m) m (cdr m))))))
(with-sound-to-file
 out-file
 '(wav pcm-16 file)
 s-per-sec
 chans
 (lambda (h)
   (when (not (make-wav write-items/f32
                        h
                        msg))
     (print "undefined character found, valid characters are a-z,A-Z,0-9"))))
(exit)
