# Distributed-Digital-Transactions-CA1
CA1 project for Distributed Digital Transactions, focused on designing and implementing a blockchain-based solution using Solidity, Remix IDE, Ganache, Python, and supporting scripts.
flowchart LR

A[Farmer] --> B[DApp / User Interface]
B --> C[Solidity Smart Contract]
C --> D[Ethereum / Ganache Blockchain]

D --> E[Distributor]
E --> F[Retailer]
F --> G[Customer]

D --> H[Transaction History]

D --> I[Product Registration<br/>Transfer Records<br/>Sender / Receiver Addresses<br/>Timestamps<br/>Product Status]
