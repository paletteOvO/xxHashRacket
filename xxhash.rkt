#lang racket/base

(require ffi/unsafe ffi/unsafe/define)

(define xxhash-lib (ffi-lib "lib/libxxhash"))
(define-ffi-definer define-xxhash xxhash-lib)

(define _XXH_errorcode
   (_enum '(XXH_OK = 0 XXH_ERROR)))

; XXH32
(define _XXH32_hash_t _uint32)
(define-cpointer-type _XXH32_state_s-pointer)
(define-xxhash XXH32 (_fun _pointer _size _XXH32_hash_t -> _XXH32_hash_t))
(define-xxhash XXH32_createState (_fun -> _XXH32_state_s-pointer))
(define-xxhash XXH32_freeState (_fun _XXH32_state_s-pointer -> _XXH_errorcode))
(define-xxhash XXH32_reset (_fun _XXH32_state_s-pointer _XXH32_hash_t -> _XXH_errorcode))
(define-xxhash XXH32_update (_fun _XXH32_state_s-pointer _pointer _size -> _XXH_errorcode))
(define-xxhash XXH32_digest (_fun _XXH32_state_s-pointer -> _XXH32_hash_t))

; XXH64
(define _XXH64_hash_t _uint64)
(define-cpointer-type _XXH64_state_s-pointer)
(define-xxhash XXH64 (_fun _pointer _size _XXH64_hash_t -> _XXH64_hash_t))
(define-xxhash XXH64_createState (_fun -> _XXH64_state_s-pointer))
(define-xxhash XXH64_freeState (_fun _XXH64_state_s-pointer -> _XXH_errorcode))
(define-xxhash XXH64_reset (_fun _XXH64_state_s-pointer _XXH64_hash_t -> _XXH_errorcode))
(define-xxhash XXH64_update (_fun _XXH64_state_s-pointer _pointer _size -> _XXH_errorcode))
(define-xxhash XXH64_digest (_fun _XXH64_state_s-pointer -> _XXH64_hash_t))

; XXH3
(define-cpointer-type _XXH3_state_s-pointer)
(define-xxhash XXH3_createState (_fun -> _XXH3_state_s-pointer))
(define-xxhash XXH3_freeState (_fun _XXH3_state_s-pointer -> _XXH_errorcode))

; XXH3_64
(define-xxhash XXH3_64bits (_fun _pointer _size -> _XXH64_hash_t))
(define-xxhash XXH3_64bits_withSecret (_fun _pointer _size _pointer _size -> _XXH64_hash_t))
(define-xxhash XXH3_64bits_withSeed (_fun _pointer _size _XXH64_hash_t -> _XXH64_hash_t))
(define-xxhash XXH3_64bits_withSecretandSeed (_fun _pointer _size _pointer _size _XXH64_hash_t -> _XXH64_hash_t))

(define-xxhash XXH3_64bits_reset (_fun _XXH3_state_s-pointer -> _XXH_errorcode))
(define-xxhash XXH3_64bits_reset_withSecret (_fun _XXH3_state_s-pointer _pointer _size -> _XXH_errorcode))
(define-xxhash XXH3_64bits_reset_withSeed (_fun _XXH3_state_s-pointer _XXH64_hash_t -> _XXH_errorcode))
(define-xxhash XXH3_64bits_reset_withSecretandSeed (_fun _XXH3_state_s-pointer _pointer _size _XXH64_hash_t -> _XXH_errorcode))
(define-xxhash XXH3_64bits_update (_fun _XXH3_state_s-pointer _pointer _size -> _XXH_errorcode))
(define-xxhash XXH3_64bits_digest (_fun _XXH3_state_s-pointer -> _uint64))

; XXH3_128
(define _XXH128_hash_t (_list-struct _XXH64_hash_t _XXH64_hash_t))

(define-xxhash XXH3_128bits (_fun _pointer _size -> _XXH128_hash_t))
(define-xxhash XXH3_128bits_withSecret (_fun _pointer _size _pointer _size -> _XXH128_hash_t))
(define-xxhash XXH3_128bits_withSeed (_fun _pointer _size _XXH64_hash_t -> _XXH128_hash_t))
(define-xxhash XXH3_128bits_withSecretandSeed (_fun _pointer _size _pointer _size _XXH64_hash_t -> _XXH128_hash_t))

(define-xxhash XXH3_128bits_reset (_fun _XXH3_state_s-pointer -> _XXH_errorcode))
(define-xxhash XXH3_128bits_reset_withSecret (_fun _XXH3_state_s-pointer _pointer _size -> _XXH_errorcode))
(define-xxhash XXH3_128bits_reset_withSeed (_fun _XXH3_state_s-pointer _XXH64_hash_t -> _XXH_errorcode))
(define-xxhash XXH3_128bits_reset_withSecretandSeed (_fun _XXH3_state_s-pointer _pointer _size _XXH64_hash_t -> _XXH_errorcode))

(define-xxhash XXH3_128bits_update (_fun _XXH3_state_s-pointer _pointer _size -> _XXH_errorcode))
(define-xxhash XXH3_128bits_digest (_fun _XXH3_state_s-pointer -> _XXH128_hash_t))

(provide (all-defined-out))
