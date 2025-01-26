;; Donor Recognition NFT Contract

(define-non-fungible-token donor-badge uint)

(define-map badge-info
  { badge-id: uint }
  { donor: principal, level: (string-ascii 20), total-donations: uint }
)

(define-data-var badge-nonce uint u0)

(define-public (mint-donor-badge (donor principal) (level (string-ascii 20)) (total-donations uint))
  (let
    ((new-id (+ (var-get badge-nonce) u1)))
    (asserts! (is-eq tx-sender (as-contract tx-sender)) (err u403))
    (try! (nft-mint? donor-badge new-id donor))
    (map-set badge-info
      { badge-id: new-id }
      { donor: donor, level: level, total-donations: total-donations }
    )
    (var-set badge-nonce new-id)
    (ok new-id)
  )
)

(define-public (update-badge-level (badge-id uint) (new-level (string-ascii 20)) (new-total-donations uint))
  (let
    ((badge (unwrap! (map-get? badge-info { badge-id: badge-id }) (err u404))))
    (asserts! (is-eq tx-sender (as-contract tx-sender)) (err u403))
    (map-set badge-info
      { badge-id: badge-id }
      (merge badge { level: new-level, total-donations: new-total-donations })
    )
    (ok true)
  )
)

(define-read-only (get-badge-info (badge-id uint))
  (map-get? badge-info { badge-id: badge-id })
)

