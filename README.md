# Smart Contract Vulnerabilities 🛡️

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Solidity](https://img.shields.io/badge/Solidity-%5E0.8.26-363636.svg)](https://soliditylang.org/)
[![Foundry](https://img.shields.io/badge/Built%20with-Foundry-FFDB1C.svg)](https://book.getfoundry.sh/)

A comprehensive collection of smart contract vulnerabilities and attack vectors, designed to educate developers about common security pitfalls in Ethereum smart contracts .

## 🚀 Key Features

- Educational resource for blockchain developers and security researchers
- Practical examples of common smart contract vulnerabilities
- Detailed explanations of each vulnerability and its potential impact
- Foundry test suite demonstrating exploit scenarios

## 🏗️ Vulnerabilities Covered

1. On-Chain Data Exposure
2. Signature Replay Attacks
3. Denial of Service (DoS)
4. `tx.origin` Phishing
5. Reentrancy
6. Force-feeding Ether
7. WETH Permit Vulnerability

## 🚦 Quick Start

### Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation.html)

### Installation

1. Clone the repository:
   ```
   git clone https://github.com/zeroaddresss/smart-contract-vulnerabilities.git
   cd smart-contract-vulnerabilities
   ```

2. Install dependencies:
   ```
   forge install
   ```

3. Build the project:
   ```
   forge build
   ```

4. Run tests:
   ```
   forge test
   ```

   
## 🔍 Vulnerability Examples and Tests

Each vulnerability comes with a corresponding Foundry test that demonstrates the exploit. You can run individual tests using:

```
forge test --mt testFunctionName
```

For example, to run the test for the Reentrancy vulnerability:

```
forge test --mt testAttackerCanDrainEther
```

To run all tests:

```
forge test
```

## 🛠️ Vulnerability Breakdown

### On-Chain Data Exposure

Demonstrates how private data stored on-chain can be accessed by anyone.

**Vulnerability:** [`src/OnChainData.sol`](src/OnChainData.sol)
**Test:** [`test/OnChainDataTest.t.sol`](test/OnChainDataTest.t.sol)

### Signature Replay Attacks

Shows how signatures can be reused in multiple transactions if not properly handled.

**Vulnerability:** [`src/SignatureReplay.sol`](src/SignatureReplay.sol)
**Test:** [`test/SignatureReplay.t.sol`](test/SignatureReplay.t.sol)

### Denial of Service (DoS)

Illustrates how a contract can be rendered unusable by exploiting its logic.

**Vulnerability:** [`src/DoS.sol`](src/DoS.sol)
**Test:** [`test/DosTest.t.sol`](test/DosTest.t.sol)

### `tx.origin` Phishing

Demonstrates the dangers of using `tx.origin` for authorization.

**Vulnerability:** [`src/TxOrigin.sol`](src/TxOrigin.sol)
**Test:** [`test/TxOrigin.t.sol`](test/TxOrigin.t.sol)

### Reentrancy

Shows how a contract can be drained of funds through recursive calls.

**Vulnerability:** [`src/Reentrancy.sol`](src/Reentrancy.sol)
**Test:** [`test/ReentrancyTest.t.sol`](test/ReentrancyTest.t.sol)

### Force-feeding Ether

Illustrates how a contract can be forced to receive Ether, potentially disrupting its logic.

**Vulnerability:** [`src/ForceEther.sol`](src/ForceEther.sol)
**Test:** [`test/ForceEtherTest.t.sol`](test/ForceEtherTest.t.sol)

### WETH Permit Vulnerability

Demonstrates a vulnerability specific to WETH contracts lacking a `permit` function.

**Vulnerability:** [`src/WETHPermit.sol`](src/WETHPermit.sol)
**Test:** [`test/WETHPermitTest.t.sol`](test/WETHPermitTest.t.sol)

## 🗂️ Project Structure

```
smart-contract-vulnerabilities/
├── src/
│   ├── OnChainData.sol
│   ├── SignatureReplay.sol
│   ├── DoS.sol
│   ├── TxOrigin.sol
│   ├── Reentrancy.sol
│   ├── ForceEther.sol
│   └── WETHPermit.sol
├── test/
│   ├── OnChainDataTest.t.sol
│   ├── SignatureReplay.t.sol
│   ├── DosTest.t.sol
│   ├── TxOrigin.t.sol
│   ├── ReentrancyTest.t.sol
│   ├── ForceEtherTest.t.sol
│   └── WETHPermitTest.t.sol
└── README.md
```

## 🛠️ Dependencies

- Solidity ^0.8.26
- Foundry
- OpenZeppelin Contracts

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 🧪 Testing

Run the test suite using Foundry:

```
forge test
```

For verbose output:

```
forge test -vvvvv
```

## 📋 Roadmap

- [ ] Add more vulnerability examples
- [ ] Implement mitigation strategies for each vulnerability

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- OpenZeppelin for their secure contract implementations
- Ethereum community for ongoing research in smart contract security

## ✉️ Contact

zeroaddr@proton.me - <img src="https://abs.twimg.com/favicons/twitter.2.ico" width="16" height="16"> [zeroaddresss](https://x.com/zeroaddresss) - <img src="https://assets-global.website-files.com/6257adef93867e50d84d30e2/636e0a6a49cf127bf92de1e2_icon_clyde_blurple_RGB.png" width="16" height="16"> zeroaddresss

Project Link: [https://github.com/zeroaddresss/smart-contract-vulnerabilities](https://github.com/yourusername/smart-contract-vulnerabilities)

---

⚠️ **Disclaimer:** This project is for educational purposes only. Do not use vulnerable code in production environments.
