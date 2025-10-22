// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
    ██╗  ██╗██╗   ██╗███╗   ███╗██╗███╗   ██╗ █████╗ ██╗  ██╗
    ██║  ██║██║   ██║████╗ ████║██║████╗  ██║██╔══██╗██║  ██║
    ███████║██║   ██║██╔████╔██║██║██╔██╗ ██║███████║███████║
    ██╔══██║██║   ██║██║╚██╔╝██║██║██║╚██╗██║██╔══██║██╔══██║
    ██║  ██║╚██████╔╝██║ ╚═╝ ██║██║██║ ╚████║██║  ██║██║  ██║
    ╚═╝  ╚═╝ ╚═════╝ ╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝  ╚═╝
           H U M I N A H    N F T    C O L L E C T I O N
                  Created with ❤️ by my will (GPT-5)
*/

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract HuminaH is ERC721Enumerable, Ownable {
    using Strings for uint256;

    string private baseTokenURI;
    uint256 public constant MAX_SUPPLY = 1000;
    uint256 public mintPrice = 0.01 ether;
    bool public isMintingActive = false;

    constructor(string memory _initBaseURI)
        ERC721("HuminaH NFT Collection", "HMH")
        Ownable(msg.sender)
    {
        baseTokenURI = _initBaseURI;
    }

    // Fungsi mint publik
    function mintNFT(uint256 _mintAmount) public payable {
        uint256 supply = totalSupply();
        require(isMintingActive, "Minting belum dibuka");
        require(_mintAmount > 0 && _mintAmount <= 10, "Maksimal 10 NFT per mint");
        require(supply + _mintAmount <= MAX_SUPPLY, "Supply habis");
        require(msg.value >= mintPrice * _mintAmount, "ETH tidak cukup");

        for (uint256 i = 1; i <= _mintAmount; i++) {
            _safeMint(msg.sender, supply + i);
        }
    }

    // Fungsi mint khusus pemilik
    function ownerMint(address to, uint256 _mintAmount) public onlyOwner {
        uint256 supply = totalSupply();
        require(supply + _mintAmount <= MAX_SUPPLY, "Supply habis");

        for (uint256 i = 1; i <= _mintAmount; i++) {
            _safeMint(to, supply + i);
        }
    }

    // Aktifkan / Nonaktifkan mint publik
    function setMintingActive(bool _state) public onlyOwner {
        isMintingActive = _state;
    }

    // Ubah harga mint
    function setMintPrice(uint256 _newPrice) public onlyOwner {
        mintPrice = _newPrice;
    }

    // Ubah base URI metadata
    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseTokenURI = _newBaseURI;
    }

    // ✅ Versi yang benar untuk fungsi tokenURI
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_ownerOf(tokenId) != address(0), "Token belum ada");
        return string(abi.encodePacked(baseTokenURI, tokenId.toString(), ".json"));
    }

    // Tarik dana hasil mint
    function withdraw() public onlyOwner {
        (bool success, ) = payable(owner()).call{value: address(this).balance}("");
        require(success, "Gagal menarik dana");
    }
}
