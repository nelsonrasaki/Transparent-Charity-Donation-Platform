;; Project Management Contract

(define-map projects
  { project-id: uint }
  { name: (string-ascii 50), description: (string-utf8 500), goal-amount: uint, current-amount: uint, status: (string-ascii 20) }
)

(define-data-var project-nonce uint u0)

(define-public (create-project (name (string-ascii 50)) (description (string-utf8 500)) (goal-amount uint))
  (let
    ((new-id (+ (var-get project-nonce) u1)))
    (map-set projects
      { project-id: new-id }
      { name: name, description: description, goal-amount: goal-amount, current-amount: u0, status: "active" }
    )
    (var-set project-nonce new-id)
    (ok new-id)
  )
)

(define-public (update-project-amount (project-id uint) (amount uint))
  (let
    ((project (unwrap! (map-get? projects { project-id: project-id }) (err u404))))
    (map-set projects
      { project-id: project-id }
      (merge project { current-amount: (+ (get current-amount project) amount) })
    )
    (ok true)
  )
)

(define-public (update-project-status (project-id uint) (new-status (string-ascii 20)))
  (let
    ((project (unwrap! (map-get? projects { project-id: project-id }) (err u404))))
    (asserts! (is-eq tx-sender (as-contract tx-sender)) (err u403))
    (map-set projects
      { project-id: project-id }
      (merge project { status: new-status })
    )
    (ok true)
  )
)

(define-read-only (get-project (project-id uint))
  (map-get? projects { project-id: project-id })
)

