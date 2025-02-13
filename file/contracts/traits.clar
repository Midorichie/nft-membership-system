;; NFT Trait Definition
(define-trait nft-trait
    (
        ;; Last token ID
        (get-last-token-id () (response uint uint))

        ;; URI for token metadata
        (get-token-uri (uint) (response (optional (string-utf8 256)) uint))

        ;; Owner of the token
        (get-owner (uint) (response (optional principal) uint))

        ;; Transfer token
        (transfer (uint principal principal) (response bool uint))
    )
)

;; Membership System Trait
(define-trait membership-trait
    (
        ;; Mint new membership NFT
        (mint (principal (string-utf8 256) uint) (response uint uint))
        
        ;; Transfer membership
        (transfer (uint principal principal) (response bool uint))
        
        ;; Get token URI
        (get-token-uri (uint) (response (string-utf8 256) uint))
        
        ;; Get membership level
        (get-membership-level (uint) (response uint uint))
    )
)
