;; Donation Management Contract

(define-map donations
  { donation-id: uint }
  { donor: principal, amount: uint, project-id: uint, timestamp: uint }
)

(define-map donor-total-donations principal uint)

(define-data-var donation-nonce uint u0)

(define-public (make-donation (amount uint) (project-id uint))
  (let
    ((new-id (+ (var-get donation-nonce) u1))
     (donor tx-sender)
     (current-total (default-to u0 (map-get? donor-total-donations donor))))
    (try! (stx-transfer? amount donor (as-contract tx-sender)))
    (map-set donations
      { donation-id: new-id }
      { donor: donor, amount: amount, project-id: project-id, timestamp: block-height }
    )
    (map-set donor-total-donations donor (+ current-total amount))
    (var-set donation-nonce new-id)
    (ok new-id)
  )
)

(define-read-only (get-donation (donation-id uint))
  (map-get? donations { donation-id: donation-id })
)

(define-read-only (get-donor-total-donations (donor principal))
  (ok (default-to u0 (map-get? donor-total-donations donor)))
)

