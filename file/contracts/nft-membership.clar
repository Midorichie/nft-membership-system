;; nft-membership.clar
;; NFT Membership System

;; Import traits with proper syntax
(use-trait nft .traits.nft-trait)
(use-trait access-control .traits.access-control-trait)

;; Define constants and data variables
(define-constant contract-owner tx-sender)
(define-constant err-not-authorized (err u100))
(define-constant err-invalid-token-id (err u101))
(define-constant err-invalid-sender (err u102))
(define-constant err-token-not-owned (err u103))
(define-constant err-expired (err u104))
(define-constant err-invalid-uri (err u105))
(define-constant err-invalid-level (err u106))
(define-constant err-invalid-expiry (err u107))
(define-constant err-invalid-recipient (err u108))
(define-constant err-recipient-is-sender (err u109))
(define-constant err-recipient-is-contract (err u110))

;; Define NFT Token
(define-non-fungible-token membership uint)

;; Data maps for storing membership info
(define-map token-uris uint (string-utf8 256))
(define-map membership-levels uint uint)
(define-map membership-expiry uint uint)
(define-data-var last-token-id uint u0)

;; Helper functions
(define-private (validate-token-owner (token-id uint) (supposed-owner principal))
    (match (nft-get-owner? membership token-id)
        owner (if (is-eq owner supposed-owner)
                true
                false)
        false))

(define-private (validate-recipient (recipient principal) (sender principal))
    (and 
        (not (is-eq recipient sender))
        (not (is-eq recipient (as-contract tx-sender)))
        (not (is-eq recipient 'SP000000000000000000002Q6VF78))))

;; Public functions
(define-public (mint (recipient principal) 
                    (token-uri (string-utf8 256)) 
                    (level uint) 
                    (expiry uint))
    (let ((token-id (+ (var-get last-token-id) u1)))
        (begin
            ;; Check authorization
            (asserts! (is-eq tx-sender contract-owner) err-not-authorized)
            ;; Validate recipient
            (asserts! (validate-recipient recipient tx-sender) err-invalid-recipient)
            ;; Validate inputs
            (asserts! (> (len token-uri) u0) err-invalid-uri)
            (asserts! (> level u0) err-invalid-level)
            (asserts! (> expiry block-height) err-invalid-expiry)
            ;; Mint token
            (try! (nft-mint? membership token-id recipient))
            ;; Store metadata
            (map-set token-uris token-id token-uri)
            (map-set membership-levels token-id level)
            (map-set membership-expiry token-id expiry)
            (var-set last-token-id token-id)
            (ok token-id))))

(define-read-only (get-last-token-id)
    (ok (var-get last-token-id)))

(define-read-only (get-token-uri (token-id uint))
    (ok (map-get? token-uris token-id)))

(define-read-only (get-owner (token-id uint))
    (ok (nft-get-owner? membership token-id)))

(define-public (transfer (token-id uint) 
                        (sender principal) 
                        (recipient principal))
    (begin
        ;; Check authorization
        (asserts! (is-eq tx-sender sender) err-not-authorized)
        ;; Validate recipient
        (asserts! (validate-recipient recipient sender) err-invalid-recipient)
        ;; Verify token ownership
        (asserts! (validate-token-owner token-id sender) err-token-not-owned)
        ;; Perform transfer
        (try! (nft-transfer? membership token-id sender recipient))
        (ok true)))

;; Additional helper functions for membership management
(define-read-only (get-membership-level (token-id uint))
    (ok (default-to u0 (map-get? membership-levels token-id))))

(define-read-only (is-membership-active (token-id uint))
    (match (map-get? membership-expiry token-id)
        expiry (ok (> expiry block-height))
        (ok false)))
