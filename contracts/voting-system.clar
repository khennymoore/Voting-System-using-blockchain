;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-unauthorized (err u100))
(define-constant err-already-voted (err u101))
(define-constant err-invalid-proposal (err u102))
(define-constant err-voting-closed (err u103))

;; Data Variables
(define-data-var voting-open bool true)
(define-data-var proposal-count uint u0)

(define-map proposals
    uint 
    {
        title: (string-ascii 256),
        description: (string-ascii 1024),
        vote-count: uint
    }
)

(define-map voters 
    principal 
    {
        has-voted: bool,
        vote-hash: (optional (buff 20))
    }
)

(define-read-only (get-proposal (proposal-id uint))
    (map-get? proposals proposal-id)
)

(define-read-only (has-voted (voter principal))
    (default-to false
        (get has-voted (map-get? voters voter))
    )
)

(define-read-only (get-vote-hash (voter principal))
    (get vote-hash (map-get? voters voter))
)

(define-public (add-proposal (title (string-ascii 256)) (description (string-ascii 1024)))
    (let
        (
            (new-proposal-id (var-get proposal-count))
        )
        (asserts! (is-eq tx-sender contract-owner) err-unauthorized)
        (map-set proposals new-proposal-id
            {
                title: title,
                description: description,
                vote-count: u0
            }
        )
        (var-set proposal-count (+ new-proposal-id u1))
        (ok new-proposal-id)
    )
)

(define-public (cast-vote (proposal-id uint) (vote-hash (buff 20)))
    (let
        (
            (proposal (unwrap! (map-get? proposals proposal-id) err-invalid-proposal))
        )
        (asserts! (var-get voting-open) err-voting-closed)
        (asserts! (not (has-voted tx-sender)) err-already-voted)
        
        (map-set voters tx-sender
            {
                has-voted: true,
                vote-hash: (some vote-hash)
            }
        )
        
        (map-set proposals proposal-id
            (merge proposal { vote-count: (+ (get vote-count proposal) u1) })
        )
        
        (ok true)
    )
)

(define-public (close-voting)
    (begin
        (asserts! (is-eq tx-sender contract-owner) err-unauthorized)
        (var-set voting-open false)
        (ok true)
    )
)

(define-read-only (verify-vote (voter principal) (proposal-id uint) (secret (buff 32)))
    (let
        (
            (stored-hash (unwrap! (get-vote-hash voter) (err false)))
            (computed-hash (hash160 secret))
        )
        (ok (is-eq (unwrap! stored-hash (err false)) computed-hash))
    )
)