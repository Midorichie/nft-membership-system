;; traits.clar
;; Contract containing trait definitions

(define-trait nft-trait
    (
        (get-last-token-id () (response uint uint))
        (get-token-uri (uint) (response (optional (string-utf8 256)) uint))
        (get-owner (uint) (response (optional principal) uint))
        (transfer (uint principal principal) (response bool uint))
    )
)

(define-trait membership-trait
    (
        (mint (principal (string-utf8 256) uint uint) (response uint uint))
        (transfer (uint principal principal) (response bool uint))
        (get-token-uri (uint) (response (string-utf8 256) uint))
        (get-membership-level (uint) (response uint uint))
        (is-membership-active (uint) (response bool uint))
        (renew-membership (uint uint) (response uint uint))
    )
)

(define-trait access-control-trait
    (
        (is-admin (principal) (response bool uint))
    )
)
