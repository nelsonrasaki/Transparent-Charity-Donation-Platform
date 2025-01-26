;; Milestone Tracking Contract

(define-map milestones
  { milestone-id: uint }
  { project-id: uint, description: (string-utf8 500), target-amount: uint, status: (string-ascii 20), completion-date: uint }
)

(define-data-var milestone-nonce uint u0)

(define-public (create-milestone (project-id uint) (description (string-utf8 500)) (target-amount uint))
  (let
    ((new-id (+ (var-get milestone-nonce) u1)))
    (asserts! (is-eq tx-sender (as-contract tx-sender)) (err u403))
    (map-set milestones
      { milestone-id: new-id }
      { project-id: project-id, description: description, target-amount: target-amount, status: "pending", completion-date: u0 }
    )
    (var-set milestone-nonce new-id)
    (ok new-id)
  )
)

(define-public (update-milestone-status (milestone-id uint) (new-status (string-ascii 20)))
  (let
    ((milestone (unwrap! (map-get? milestones { milestone-id: milestone-id }) (err u404))))
    (asserts! (is-eq tx-sender (as-contract tx-sender)) (err u403))
    (map-set milestones
      { milestone-id: milestone-id }
      (merge milestone { status: new-status, completion-date: (if (is-eq new-status "completed") block-height u0) })
    )
    (ok true)
  )
)

(define-read-only (get-milestone (milestone-id uint))
  (map-get? milestones { milestone-id: milestone-id })
)

