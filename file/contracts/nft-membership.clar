;; NFT Membership System
;; A smart contract for managing membership NFTs and access control

;; Import NFT trait from local traits contract
(use-trait nft-trait .traits.nft-trait)

;; Implement NFT trait
(impl-trait .traits.nft-trait)

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-token-owner (err u101))
(define-constant err-token-not-found (err u102))
(define-constant err-invalid-recipient (err u103))
(define-constant err-invalid-uri (err u104))
(define-constant err-invalid-level (err u105))
(define-constant err-self-transfer (err u106))

;; Data Variables
(define-non-fungible-token membership uint)
(define-data-var last-token-id uint u0)
(define-map membership-metadata uint {uri: (string-utf8 256), level: uint})

;; Private Functions
(define-private (is-token-owner (token-id uint) (user principal))
    (is-eq user (unwrap! (nft-get-owner? membership token-id) false)))

(define-private (is-valid-recipient (recipient principal))
    (and 
        (not (is-eq recipient contract-owner))
        (not (is-eq recipient tx-sender))
        (match (principal-destruct? recipient)
            success true
            error false)))

(define-private (is-valid-uri (uri (string-utf8 256)))
    (> (len uri) u0))

(define-private (is-valid-level (level uint))
    (and 
        (>= level u1)
        (<= level u5)))  ;; Assuming 5 levels max

;; Required NFT Trait Functions
(define-read-only (get-last-token-id)
    (ok (var-get last-token-id)))

(define-read-only (get-owner (token-id uint))
    (ok (nft-get-owner? membership token-id)))

;; Public Functions
(define-public (mint (recipient principal) (uri (string-utf8 256)) (level uint))
    (let
        ((token-id (+ (var-get last-token-id) u1)))
        ;; Input validation
        (asserts! (is-eq tx-sender contract-owner) err-owner-only)
        (asserts! (is-valid-recipient recipient) err-invalid-recipient)
        (asserts! (is-valid-uri uri) err-invalid-uri)
        (asserts! (is-valid-level level) err-invalid-level)
        
        ;; Mint token and store metadata
        (try! (nft-mint? membership token-id recipient))
        (map-set membership-metadata token-id {uri: uri, level: level})
        (var-set last-token-id token-id)
        (ok token-id)))

(define-public (transfer (token-id uint) (sender principal) (recipient principal))
    (begin
        ;; Input validation
        (asserts! (is-token-owner token-id sender) err-not-token-owner)
        (asserts! (is-valid-recipient recipient) err-invalid-recipient)
        (asserts! (not (is-eq sender recipient)) err-self-transfer)
        
        ;; Transfer token
        (nft-transfer? membership token-id sender recipient)))

;; Read-only Functions
(define-read-only (get-token-uri (token-id uint))
    (match (map-get? membership-metadata token-id)
        metadata (ok (some (get uri metadata)))
        (ok none)))

(define-read-only (get-membership-level (token-id uint))
    (ok (get level (unwrap! (map-get? membership-metadata token-id) err-token-not-found))))
