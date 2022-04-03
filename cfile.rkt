#lang racket/base

(require
   ffi/unsafe
   ffi/unsafe/define)

(define stdio-lib (ffi-lib #f))

(define-ffi-definer define-stdio stdio-lib)
(define-cpointer-type _FILE-pointer)

(define-stdio fopen (_fun _string/utf-8 _string/utf-8 -> _FILE-pointer))
(define-stdio fclose (_fun _FILE-pointer -> _void))
(define-stdio fread (_fun _pointer _size _size _FILE-pointer -> _size))

(define with-cfile
   (lambda (file-name body)
      (define f (fopen file-name "r"))
      (if (eq? f #f)
         (error "Could not open file: %s" file-name)
         (let [(result (body f))]
            (fclose f)
            result))))

(define with-buffer
   (lambda (fp buffer-size body [&init #f])
      (letrec [
         (buffer-size 4096)
         (buffer_t (_array _uint8 buffer-size))
         (buffer (array-ptr (ptr-ref (malloc buffer_t) buffer_t)))
         (count (fread buffer 1 buffer-size fp))
         (loop (lambda (acc)
            (define res (body acc buffer count))
            (define count2 (fread buffer 1 buffer-size fp))
               (if (eq? count2 0)
                  res
                  (loop res))))
         ]
         (loop &init))))

(provide
   _FILE-pointer
   with-cfile
   with-buffer
   fopen
   fclose
   fread)
