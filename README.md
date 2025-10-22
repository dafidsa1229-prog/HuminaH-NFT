# 🌟 HuminaH NFT Collection

![HuminaH Banner](https://your-logo-link.com/logo.png)

**Creator:** Dafid Saeful Arifin  
**Repository:** [dafidsa1229-prog/HuminaH](https://github.com/dafidsa1229-prog/HuminaH)  
**Blockchain:** Ethereum / Polygon  
**Contract:** HuminaH.sol (ERC721Enumerable)

---

## 🚀 Overview

HuminaH NFT adalah koleksi **ERC721 NFT** eksklusif dengan **supply terbatas 1000 NFT**, memprioritaskan keamanan, transparansi, dan pengalaman minting yang lancar.  

Fitur utama:
- Mint publik hingga 10 NFT per transaksi
- Maksimal 20 NFT per wallet
- Owner minting untuk giveaway atau special allocation
- Aman dengan OpenZeppelin Contracts dan ReentrancyGuard
- Monitoring via OpenZeppelin Defender

---

## 📜 Smart Contract

| Function | Description | Access |
|----------|------------|--------|
| `mintNFT(uint256 _mintAmount)` | Mint publik hingga 10 NFT | Public |
| `ownerMint(address to, uint256 _mintAmount)` | Mint oleh pemilik | OnlyOwner |
| `setMintingActive(bool _state)` | Aktif/nonaktifkan mint publik | OnlyOwner |
| `setMintPrice(uint256 _newPrice)` | Ubah harga mint | OnlyOwner |
| `setBaseURI(string _newBaseURI)` | Ubah metadata base URI | OnlyOwner |
| `withdraw()` | Tarik hasil minting | OnlyOwner |

---

## 🔐 Security

- OpenZeppelin Contracts (ERC721Enumerable, Ownable, ReentrancyGuard)  
- Defender Issue Template siap pakai: [.github/ISSUE_TEMPLATE/DEFENDER_ISSUE_TEMPLATE.md](.github/ISSUE_TEMPLATE/DEFENDER_ISSUE_TEMPLATE.md)  
- Audit internal sebelum mainnet
- Event logging untuk setiap aksi penting
- Batasi minting per wallet
- Gunakan reentrancy guard pada fungsi kritis

---

## 🖼️ Metadata & Artwork

- Base URI: `https://<your-metadata-host>/`  
- JSON Metadata contoh:
```json
{
  "name": "HuminaH #001",
  "description": "HuminaH NFT Collection",
  "image": "ipfs://Qm...",
  "attributes": [
    { "trait_type": "Background", "value": "Blue" },
    { "trait_type": "Eyes", "value": "Star" }
  ]
}
