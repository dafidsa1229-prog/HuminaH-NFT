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
                  Created with Dafid Saeful Arifin
*/

// Import OpenZeppelin lokal
import "./openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "./openzeppelin/contracts/access/Ownable.sol";
import "./openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./openzeppelin/contracts/utils/Strings.sol";

contract HuminaH is ERC721Enumerable, Ownable, ReentrancyGuard {
    using Strings for uint256;

    string private baseTokenURI;
    uint256 public constant MAX_SUPPLY = 1000;
    uint256 public mintPrice = 0.01 ether;
    bool public isMintingActive = false;

    uint256 public constant MAX_PER_WALLET = 20;
    mapping(address => uint256) public walletMintCount;

    // Events
    event Mint(address indexed minter, uint256 tokenId);
    event Withdraw(address indexed owner, uint256 amount);
    event BaseURIChanged(string newBaseURI);
    event MintPriceChanged(uint256 newPrice);
    event MintingStateChanged(bool newState);

    constructor(string memory _initBaseURI)
        ERC721("HuminaH NFT Collection", "HMH")
        Ownable()
    {
        require(bytes(_initBaseURI).length > 0, "Base URI tidak boleh kosong");
        baseTokenURI = _initBaseURI;
    }

    // Mint publik
    function mintNFT(uint256 _mintAmount) public payable {
        uint256 supply = totalSupply();
        require(isMintingActive, "Minting belum dibuka");
        require(_mintAmount > 0 && _mintAmount <= 10, "Maksimal 10 NFT per mint");
        require(walletMintCount[msg.sender] + _mintAmount <= MAX_PER_WALLET, "Maksimal 20 NFT per wallet");
        require(supply + _mintAmount <= MAX_SUPPLY, "Supply habis");
        require(msg.value >= mintPrice * _mintAmount, "ETH tidak cukup");

        walletMintCount[msg.sender] += _mintAmount;

        for (uint256 i = 1; i <= _mintAmount; i++) {
            uint256 tokenId = supply + i;
            _safeMint(msg.sender, tokenId);
            emit Mint(msg.sender, tokenId);
        }
    }

    // Mint oleh owner
    function ownerMint(address to, uint256 _mintAmount) public onlyOwner {
        uint256 supply = totalSupply();
        require(supply + _mintAmount <= MAX_SUPPLY, "Supply habis");

        for (uint256 i = 1; i <= _mintAmount; i++) {
            uint256 tokenId = supply + i;
            _safeMint(to, tokenId);
            emit Mint(to, tokenId);
        }
    }

    // Aktifkan / nonaktifkan mint publik
    function setMintingActive(bool _state) public onlyOwner {
        isMintingActive = _state;
        emit MintingStateChanged(_state);
    }

    // Ubah harga mint
    function setMintPrice(uint256 _newPrice) public onlyOwner {
        mintPrice = _newPrice;
        emit MintPriceChanged(_newPrice);
    }

    // Ubah base URI metadata
    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        require(bytes(_newBaseURI).length > 0, "Base URI tidak boleh kosong");
        baseTokenURI = _newBaseURI;
        emit BaseURIChanged(_newBaseURI);
    }

    // Fungsi tokenURI aman
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        // Gunakan ownerOf sebagai pengganti _exists
        require(ownerOf(tokenId) != address(0), "Token belum ada");
        return string(abi.encodePacked(baseTokenURI, tokenId.toString(), ".json"));
    }

    // Tarik dana hasil mint
    function withdraw() public onlyOwner nonReentrant {
        uint256 balance = address(this).balance;
        require(balance > 0, "Saldo kosong");

        // Emit event sebelum transfer
        emit Withdraw(owner(), balance);

        (bool success, ) = payable(owner()).call{value: balance}("");
        require(success, "Gagal menarik dana");
    }
}

