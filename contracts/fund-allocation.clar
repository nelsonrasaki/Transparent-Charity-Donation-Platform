;; Fund Allocation Contract

(define-map allocations
  { allocation-id: uint }
  { project-id: uint, amount: uint, timestamp: uint }
)

(define-data-var allocation-nonce uint u0)

(define-public (allocate-funds (project-id uint) (amount uint))
  (let
    ((new-id (+ (var-get allocation-nonce) u1)))
    (asserts! (is-eq tx-sender (as-contract tx-sender)) (err u403))
    (map-set allocations
      { allocation-id: new-id }
      { project-id: project-id, amount: amount, timestamp: block-height }
    )
    (var-set allocation-nonce new-id)
    (ok new-id)
  )
)

(define-read-only (get-allocation (allocation-id uint))
  (map-get? allocations { allocation-id: allocation-id })
)

