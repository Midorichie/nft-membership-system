;; access-control.clar
;; Access Control System

(use-trait access-control-trait .traits.access-control-trait)

(define-map roles principal {admin: bool})
(define-constant err-not-admin (err u200))
(define-constant err-invalid-user (err u201))
(define-constant err-cannot-remove-self (err u202))

(define-data-var initial-admin principal tx-sender)

;; Initialize the contract owner as the first admin
(map-set roles (var-get initial-admin) {admin: true})

(define-read-only (is-admin (user principal))
    (ok (get admin (default-to {admin: false} (map-get? roles user))))
)

(define-public (add-admin (user principal))
    (begin
        ;; Check if caller is admin
        (asserts! (unwrap! (is-admin tx-sender) err-not-admin) err-not-admin)
        ;; Validate user is not already admin
        (asserts! (not (unwrap! (is-admin user) err-invalid-user)) err-invalid-user)
        (map-set roles user {admin: true})
        (ok true)))

(define-public (remove-admin (user principal))
    (begin
        ;; Check if caller is admin
        (asserts! (unwrap! (is-admin tx-sender) err-not-admin) err-not-admin)
        ;; Prevent removing self as admin
        (asserts! (not (is-eq tx-sender user)) err-cannot-remove-self)
        ;; Validate user is actually an admin
        (asserts! (unwrap! (is-admin user) err-invalid-user) err-invalid-user)
        (map-delete roles user)
        (ok true)))
