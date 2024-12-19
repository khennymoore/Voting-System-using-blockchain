# Voting System Smart Contract

This smart contract implements a decentralized voting system with the following features:

- **Proposal Management**: Add proposals for voting with a title and description.
- **Voting**: Cast votes securely using hashed votes to maintain voter anonymity.
- **Vote Verification**: Verify if a vote matches a submitted secret.
- **Voting Control**: Open and close voting sessions.

## Features

1. **Proposal Management**  
   - Admin (contract owner) can add proposals with a title and description.
   - Each proposal is assigned a unique ID.

2. **Voting**  
   - Voters can cast a vote for a specific proposal using a hashed value of their vote.
   - Ensures that each voter can vote only once.

3. **Vote Verification**  
   - Voters can verify their vote by providing the secret used to generate their hashed vote.

4. **Voting Control**  
   - Admin can open or close the voting session.
   - Votes can only be cast while voting is open.

---

## Data Structures

### Constants
- **`contract-owner`**: The principal address of the contract owner.
- **Error Codes**:
  - `err-unauthorized (u100)`: Unauthorized action.
  - `err-already-voted (u101)`: Voter has already cast a vote.
  - `err-invalid-proposal (u102)`: Proposal ID does not exist.
  - `err-voting-closed (u103)`: Voting is closed.

### Data Variables
- **`voting-open`**: Boolean flag indicating whether voting is open.
- **`proposal-count`**: Total number of proposals.
- **`proposals`**: Map of proposal IDs to proposal details (title, description, and vote count).
- **`voters`**: Map of voter addresses to their voting details (`has-voted` and `vote-hash`).

---

## Functions

### Read-Only Functions
- **`get-proposal(proposal-id)`**  
  Retrieves the details of a specific proposal.
  
- **`has-voted(voter)`**  
  Checks if a voter has already voted.
  
- **`get-vote-hash(voter)`**  
  Retrieves the hash of the voter's cast vote.

- **`verify-vote(voter, proposal-id, secret)`**  
  Verifies if the voter's vote matches the provided secret.

### Public Functions
- **`add-proposal(title, description)`**  
  Adds a new proposal. Only the contract owner can call this function.
  
- **`cast-vote(proposal-id, vote-hash)`**  
  Allows a voter to cast a vote for a proposal using a hashed vote.  
  Ensures:
  - The proposal exists.
  - Voting is open.
  - The voter has not already voted.
  
- **`close-voting()`**  
  Closes the voting session. Only the contract owner can call this function.

---

## Usage Instructions

### 1. Deploying the Contract
The contract owner (deployer) automatically becomes the `contract-owner`.

### 2. Adding Proposals
Call the `add-proposal` function with the desired `title` and `description`.  
Example:  
```clojure
(add-proposal "Proposal 1" "Description of proposal 1")
```

### 3. Casting Votes
Voters must generate a `hash` of their vote using the `hash160` function and cast it with the `cast-vote` function.  
Example:  
```clojure
(cast-vote 0 0x123456789abcdef)
```

### 4. Verifying Votes
Voters can verify their vote by providing the secret used to generate the vote hash.  
Example:  
```clojure
(verify-vote tx-sender 0 0xabcdef123456789)
```

### 5. Closing Voting
The contract owner can close the voting session by calling `close-voting`.  
Example:  
```clojure
(close-voting)
```

---

## Error Handling
- **Unauthorized Actions**: Returns `err u100` if the caller is not the contract owner for restricted actions.
- **Duplicate Votes**: Returns `err u101` if a voter attempts to vote more than once.
- **Invalid Proposal**: Returns `err u102` if the provided proposal ID does not exist.
- **Voting Closed**: Returns `err u103` if voting is closed and a voter attempts to vote.

---

## Security Features
- **Admin Control**: Only the contract owner can add proposals and close voting.
- **Anonymity**: Votes are stored as hashes, ensuring voter anonymity.
- **Vote Verification**: Voters can verify the integrity of their vote using a secret.

---

## Example Scenarios

### Admin Adds Proposals
```clojure
(add-proposal "Proposal A" "Increase funding for project A")
(add-proposal "Proposal B" "Reduce costs for project B")
```

### Voter Casts a Vote
```clojure
(cast-vote 0 0xhash_of_vote_secret)
```

### Verify the Vote
```clojure
(verify-vote tx-sender 0 0xvote_secret)
```

### Admin Closes Voting
```clojure
(close-voting)
```

---

## Future Enhancements
- Support for re-opening voting sessions.
- Integration with decentralized identity systems for voter authentication.
- Expanding proposal details with additional metadata.

---

## License
This project is open-source and available for public use. Contributions are welcome.