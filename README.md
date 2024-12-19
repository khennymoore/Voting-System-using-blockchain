# Voting-System-using-blockchain


## **Overview**

This project is a secure and transparent **Blockchain-Based Voting System** implemented using **Clarity**, the smart contract language for the Stacks blockchain. The system ensures anonymity and immutability for voters while providing transparent and verifiable election results.

---

## **Features**

- **Immutable Vote Records**: All votes are stored immutably on the blockchain.
- **End-to-End Encryption**: Voter identities are anonymized, ensuring privacy.
- **Role-Based Access**: Only the admin (contract owner) can manage elections.
- **Transparency**: Election results are accessible to the public, preserving anonymity.

---

## **Smart Contract Functions**

### **Admin Functions**
1. **`register-election`**  
   Registers a new election.  
   **Parameters**:
   - `id (uint)`: Unique ID of the election.
   - `name (string-ascii 50)`: Name of the election.
   - `candidates (list 10 (string-ascii 30))`: List of candidates.  
   **Access**: Admin only.  
   **Returns**: `true` if the election is registered successfully.

2. **`close-election`**  
   Closes an election, preventing further voting.  
   **Parameters**:
   - `id (uint)`: ID of the election to close.  
   **Access**: Admin only.  
   **Returns**: `true` if the election is closed successfully.

---

### **Voter Functions**
3. **`vote`**  
   Casts a vote in an election.  
   **Parameters**:
   - `election-id (uint)`: ID of the election.
   - `candidate-id (uint)`: ID of the candidate.  
   **Access**: All voters.  
   **Returns**: `true` if the vote is cast successfully.  
   **Restrictions**:
   - Voter must not have voted before in the same election.
   - Election must be open.
   - Candidate must exist in the election.

---

### **Read-Only Functions**
4. **`get-election`**  
   Retrieves details of an election.  
   **Parameters**:
   - `id (uint)`: ID of the election.  
   **Returns**: Election details including its name, status (open/closed), and candidates.

5. **`get-results`**  
   Fetches the voting results of an election.  
   **Parameters**:
   - `election-id (uint)`: ID of the election.  
   **Returns**: A map of candidate IDs to their respective vote counts.

6. **`has-voted?`**  
   Checks if a voter has already voted in an election.  
   **Parameters**:
   - `election-id (uint)`: ID of the election.
   - `voter (principal)`: Voter's address.  
   **Returns**: `true` if the voter has already voted, otherwise `false`.

---

## **Error Codes**

| Code | Description                       |
|------|-----------------------------------|
| `1`  | Unauthorized action (not admin). |
| `2`  | Voter has already voted.          |
| `3`  | Voter not registered.             |
| `4`  | Election not found.               |
| `5`  | Election is closed.               |
| `6`  | Invalid candidate ID.             |

---

## **Deployment**

### **Prerequisites**
- **Clarity Developer Tools**: Install via [Stacks CLI](https://docs.stacks.co/).
- **Stacks Blockchain Testnet**: Use the testnet for development and testing.

### **Steps**
1. Write the contract code in a file named `voting-system.clar`.
2. Deploy the contract:
   ```bash
   stacks-cli contract deploy voting-system.clar <deployer-principal>
   ```
3. Interact with the contract using `stacks.js` or the Clarity CLI.

---

## **Usage**

### **Frontend Integration**
Use a frontend framework like React or Angular to:
- Register elections (admin).
- Allow users to cast votes.
- Display real-time election results.

### **Example Transactions**
1. **Register an Election**:
   ```clarity
   (contract-call? .voting-system register-election 1 "Presidential Election" ["Alice" "Bob"])
   ```

2. **Vote for a Candidate**:
   ```clarity
   (contract-call? .voting-system vote 1 0) ;; Vote for "Alice" in election ID 1
   ```

3. **Fetch Results**:
   ```clarity
   (contract-call? .voting-system get-results 1)
   ```

---

## **Testing**

1. Write unit tests for the smart contract using Clarity's testing framework.
2. Test scenarios:
   - Admin registration and closing of elections.
   - Voting restrictions (already voted, invalid candidate).
   - Result computation and retrieval.

---

## **Future Enhancements**
- Implement voter registration with KYC (Know Your Customer).
- Add weighted voting (e.g., votes carry different weights based on roles).
- Enhance the frontend for a user-friendly voting experience.

---

## **License**
This project is licensed under the MIT License.

--- 

Feel free to tweak the README further based on your project's specifics! Let me know if you'd like help with any section.