#lang racket/base

(require "xxhash-helper.rkt")

(define test (lambda (msg expected found)
   (display "TEST: ")
   (display msg)
   (display " ")
   (if (equal? expected found)
      (displayln "OK")
      (begin
         (displayln "FAILED")
         (displayln (string-append "  expected: " expected))
         (displayln (string-append "  found:    " found))))))

(test "XXH32_filehash" (XXH32_filehash "test") "280d7c51")
(test "XXH64_filehash" (XXH64_filehash "test") "9489b3c544d32a95")
(test "XXH3_64bits_filehash" (XXH3_64bits_filehash "test") "0c5d514a2d12c86d")
(test "XXH3_128bits_filehash" (XXH3_128bits_filehash "test") "53fd92379a57ec33d4882c0833cc3cef")
