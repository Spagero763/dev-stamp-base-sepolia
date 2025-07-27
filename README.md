# 🧷 DevStamp

An onchain protocol for minting **soulbound "proof of contribution" NFTs** for developers.

## 📜 Contract Addresses

### 🧪 Base Sepolia Testnet
[`0x5a5a6f648CAA222BAB8506Eb2531138bCA1c8d7f`](https://sepolia.basescan.org/address/0x5a5a6f648CAA222BAB8506Eb2531138bCA1c8d7f)

### 🌐 Base Mainnet
[`0xea8bc2262c9813f2b1e595466475b29c72a54ba2`](https://basescan.org/address/0xea8bc2262c9813f2b1e595466475b29c72a54ba2)

## 🚀 What It Does

- Mints **soulbound ERC721 NFTs** as proof of developer contributions
- Each developer can **mint exactly once** per address
- Tokens are **permanently non-transferable** (soulbound)
- **Fully onchain metadata** with auto-generated SVG badges
- Self-minting system where developers create their own stamps

## ✨ Features

### 🔒 Soulbound Mechanics
- No transfers, approvals, or sales possible
- Permanently bound to the minting address
- True proof of personal achievement

### 🎨 Visual NFTs
- Auto-generated SVG badges with gradient backgrounds
- Displays contribution reason, timestamp, and token ID
- Embedded trophy emoji and "Soulbound NFT" branding

### 📊 Rich Metadata
- Fully onchain JSON metadata
- Structured attributes for indexing and display
- No IPFS or external dependencies

### 🔍 Query Functions
- `getStamp(tokenId)` - Get stamp data by token ID
- `getBuilderStamp(address)` - Get stamp data by builder address
- `hasMinted(address)` - Check if address has already minted
- `totalSupply()` - Total number of stamps minted

## 🛠️ Usage

### ⚡ Mint Your Stamp
```solidity
// Mint your contribution stamp (once per address)
devStamp.stampBuilder("Built decentralized social platform");
```

### 📝 Query Stamps
```solidity
// Check if someone has minted
bool minted = devStamp.hasMinted(builderAddress);

// Get stamp by builder address
Stamp memory stamp = devStamp.getBuilderStamp(builderAddress);

// Get stamp by token ID
Stamp memory stamp = devStamp.getStamp(tokenId);
```

### 📋 Stamp Data Structure
```solidity
struct Stamp {
    uint256 timestamp;  // Block timestamp when minted
    string reason;      // Contribution description
    address builder;    // Builder's address
}
```

## 🧪 Networks

### Base Sepolia Testnet ✅
- **Contract**: `0x5a5a6f648CAA222BAB8506Eb2531138bCA1c8d7f`
- **Status**: Live and verified

### Base Mainnet 🎉
- **Contract**: `0xea8bc2262c9813f2b1e595466475b29c72a54ba2`
- **Status**: Live and ready for production use!

## 🔗 Verification

### Base Sepolia Testnet
Verified on BaseScan:  
[🔎 View on BaseScan](https://sepolia.basescan.org/address/0x5a5a6f648CAA222BAB8506Eb2531138bCA1c8d7f)

### Base Mainnet
Verified on BaseScan:  
[🔎 View on BaseScan](https://basescan.org/address/0xea8bc2262c9813f2b1e595466475b29c72a54ba2)

## 🎯 Use Cases

- **📁 Portfolio Building**: Permanent onchain record of contributions
- **⭐ Reputation Systems**: Immutable proof of developer achievements  
- **👥 Community Recognition**: Self-sovereign achievement badges
- **🤝 Hiring Verification**: Cryptographic proof of past work
- **🆔 Developer Identity**: Soulbound professional credentials

## 🔐 Security Features

- **1️⃣ One mint per address**: Prevents spam and ensures uniqueness
- **✅ Input validation**: Non-empty contribution reasons required
- **🔒 Soulbound enforcement**: Multiple layers preventing transfers
- **♾️ Immutable records**: Stamps cannot be modified after minting

## 📢 Events

```solidity
event Stamped(address indexed builder, uint256 indexed tokenId, string reason);
```

## 🎨 Metadata Example

```json
{
  "name": "DevStamp #42",
  "description": "A soulbound proof of contribution stamp for developers",
  "attributes": [
    {"trait_type": "Builder", "value": "0x742d35Cc6861C4C687b78D8b5c6C2E2b2C2D2D2D"},
    {"trait_type": "Contribution", "value": "Built awesome DeFi protocol"},
    {"trait_type": "Timestamp", "value": 1735257600},
    {"trait_type": "Date", "value": "Block: 1735257600"},
    {"trait_type": "Soulbound", "value": "true"}
  ],
  "image": "data:image/svg+xml;base64,..."
}
```

## 📄 License

MIT

---

**🏗️ Build once. 🏆 Prove forever.**

> 💡 **Contributing to DevStamp?** Don't forget to mint your own soulbound token (SBT) as proof of your contribution! Use `stampBuilder("Your contribution description")` to create your permanent onchain record. 🎯