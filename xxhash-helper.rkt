#lang racket/base

(require "xxhash.rkt")
(require "cfile.rkt")

; helper

(define (int->base/str n [base 16] [digit-case 'lower])
   (let* ([letter-base
            (case digit-case
               [(upper) 64] ; ascii 65 = "A"
               [(lower) 96] ; ascii 97 = "a"
               [else    (error "oops - bad DIGIT-CASE")])])
      (define (int->base-digit v)
         (cond
            [(< v 10) (integer->char (+ 48 v))]  ; ascii 48 = "0"
            [else     (integer->char (+ letter-base (- v 9)))]))
      (let loop ([n  n]  [∑ '()])
         (if (= 0 n)
            (list->string ∑)
            (let*-values([(quo rem)  (quotient/remainder n base)])
               (loop  quo  (cons (int->base-digit rem) ∑)))))))

(define left-padding (lambda (str len char)
   (if (<= len (string-length str))
      str
      (left-padding (string-append char str) len char))))

(define XXH32_filehash (lambda (filename [seed 0])
   (let [(state (XXH32_createState))]
      (XXH32_reset state seed)
      (with-cfile filename
         (lambda (fp)
            (with-buffer fp 4096
               (lambda (_ buffer count)
                  (XXH32_update state buffer count)))))
      (let [(digest (XXH32_digest state))]
         (XXH32_freeState state)
         (left-padding (int->base/str digest) 8 "0")))))

(define XXH64_filehash (lambda (filename [seed 0])
   (let [(state (XXH64_createState))]
      (XXH64_reset state seed)
      (with-cfile filename
         (lambda (fp)
            (with-buffer fp 4096
               (lambda (_ buffer count)
                  (XXH64_update state buffer count)))))
      (let [(digest (XXH64_digest state))]
         (XXH64_freeState state)
         (left-padding (int->base/str digest) 16 "0")))))

(define XXH3_64bits_filehash (lambda (filename)
   (let [(state (XXH3_createState))]
      (XXH3_64bits_reset state)
      (with-cfile filename
         (lambda (fp)
            (with-buffer fp 4096
               (lambda (_ buffer count)
                  (XXH3_64bits_update state buffer count)))))
      (let [(digest (XXH3_64bits_digest state))]
         (XXH3_freeState state)
         (left-padding (int->base/str digest) 16 "0")))))

(define XXH3_128bits_filehash (lambda (filename)
   (let [(state (XXH3_createState))]
      (XXH3_128bits_reset state)
      (with-cfile filename
         (lambda (fp)
            (with-buffer fp 4096
               (lambda (_ buffer count)
                  (XXH3_128bits_update state buffer count)))))
      (let* [(digest (XXH3_128bits_digest state))
            (low (car digest))
            (high (car (cdr digest)))]
         (XXH3_freeState state)
         (left-padding (string-append (int->base/str high) (int->base/str low)) 32 "0")))))

(provide
   XXH32_filehash
   XXH64_filehash
   XXH3_64bits_filehash
   XXH3_128bits_filehash)
