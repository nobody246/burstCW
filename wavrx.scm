(use bitstring posix)
(define file-in "burstCW.wav")
(define file-out "burstCWSlowed.wav")
(define slowdown-x (string->number (car (reverse (command-line-arguments)))))
(when (not slowdown-x)
  (set! slowdown-x 80))
(define f (file-open file-in
                     (+ open/read open/binary)))
(define fo (file-open file-out
                      (+ open/rdwr open/creat open/trunc open/binary)
                      (+ perm/irusr perm/iwusr)))
(bitmatch
 (car (file-read f 44))
 (((chunk-id 32 bitstring)
   (chunk-size 32 little unsigned)
   (riff-type 32 bitstring)
   (fmt-chunk-id 32 bitstring)
   (fmt-chunk-size 32 little unsigned)
   (fmt-chunk-compression-type 16 little unsigned)
   (fmt-chunk-channels 16 little unsigned)
   (fmt-chunk-slice-rate 32 little unsigned)
   (fmt-chunk-data-rate 32 little unsigned)
   (fmt-chunk-block-alignment 16 little unsigned)
   (fmt-chunk-sample-depth 16 little unsigned)
   (data-chunk-id 32 bitstring)
   (data-chunk-size 32 little unsigned))
   (file-write
    fo
    (bitstring->blob
     (bitconstruct
      (chunk-id 32  bitstring)
      (chunk-size 32 little unsigned)
      (riff-type  bitstring)
      (fmt-chunk-id  bitstring)
      (fmt-chunk-size 32 little unsigned)
      (fmt-chunk-compression-type 16 little unsigned)
      (fmt-chunk-channels 16 little unsigned)
      (fmt-chunk-slice-rate 32 little unsigned)
      (fmt-chunk-data-rate 32 little unsigned)
      (fmt-chunk-block-alignment 16 little unsigned)
      (fmt-chunk-sample-depth 16 little unsigned)
      (data-chunk-id  bitstring)
      ((* data-chunk-size slowdown-x)
       32 little unsigned))))))
(define z-cnt 0)
(define f-sz (file-size f))
(define (wr fo a #!optional (x 0))
  (when (< x slowdown-x)
    (file-write fo a)
    (wr fo a (add1 x))))
(define (r bt #!optional (cnt 1))
  (let ((a (car bt)))
    (wr fo a)
    (and-let* ((bt (file-read f 1))
               (iterate-again
                (and (> f-sz cnt)
                     (> (cadr bt) 0))))
      (r bt (add1 cnt)))))
(r (file-read f 1))
(file-close fo)
(file-close f)
(exit)
