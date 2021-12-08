// contracts/GameItem.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
// import "./colors/IERC721.sol";
// import "hardhat/console.sol";

contract ConcaveNFT is ERC721Enumerable, Pausable, Ownable {
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    string public baseURI;
    string public notRevealedUri;
    uint256 public maxSupply = 4317;
    uint256 public maxMintAmount = 10;
    uint256 public price = 0.03 ether;
    bool public revealed = false;
    uint256 colors_quota = 200;
    mapping(uint256 => uint256) public hasMinted;

    address public constant THE_COLORS = 0x9fdb31F8CE3cB8400C7cCb2299492F2A498330a4;

    constructor(
        string memory _name,
        string memory _symbol,
        string memory _initBaseURI,
        string memory _initNotRevealedUri
    ) ERC721(_name, _symbol) {
        // setBaseURI(_initBaseURI);
        baseURI = _initBaseURI;
        notRevealedUri = _initNotRevealedUri;
        _pause();
         // = true;
        // setNotRevealedURI(_initNotRevealedUri);

    }

    function mint(uint256 _mintAmount)
        public
        payable
        whenNotPaused
        returns (uint256)
    {
        // require(!paused(),"contract is paused");
        require(_mintAmount > 0,"minting zero");
        require(_mintAmount <= maxMintAmount,"minting too many");
        require(totalSupply()+_mintAmount <= maxSupply,"no enough supply");
        if (totalSupply() >= colors_quota) { // supply > quota, have to pay
            require(msg.value >= price*_mintAmount, "insufficient funds"); 
        } else { //supply < quota
            uint256 colors_balance = IERC721(THE_COLORS).balanceOf(msg.sender);
            uint256 quota = colors_balance*2;
            require(colors_balance > 0,"Not Colors Owner");
            
            require(getUnmintedSpoonsByUser(msg.sender, _mintAmount)[0] != 0, "Cant claim this many!");

        }

        for (uint i = 0; i < _mintAmount; i++) {
            uint256 newItemId = _tokenIds.current();
            _mint(msg.sender, newItemId);
            _tokenIds.increment();
            hasMinted[msg.sender]++;
        }
        return _mintAmount;
    }

    function getUnmintedSpoonsByUser(address user, uint256 _mintAmount) public view returns (uint256[] memory tokenIdsList) {
        uint256[] memory tokenIds = new uint256[](4317);
        uint256 colors_balance = IERC721(THE_COLORS).balanceOf(msg.sender);
        uint256 quota = colors_balance*2;

        uint index = 0;
        for (uint i = 0; i < 4317; i++) {
            address tokenOwner = IERC721(THE_COLORS).ownerOf(i);

            if (user == tokenOwner && hasMinted[i] <= quota) {
                tokenIds[index] = i;
                index += 1;
            }
        }
        if(index < _mintAmount) {
            return uint256[](0, 1);
        }
        uint left = 4317 - index;
        for (uint i = 0; i < left; i++) {
            tokenIds[index] = 9999;
            index += 1;
        }
        

        return tokenIds;
    }


    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        if(!revealed) {
            return notRevealedUri;
        }
        // string memory baseURI = baseURI();
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(),".json")) : "";
    }

    function unpause() public onlyOwner {
        _unpause();
    }
    function pause() public onlyOwner {
        _pause();
    }

    function reveal() public onlyOwner {
        revealed = true;
    }
    function withdraw() public payable onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }
    function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
        notRevealedUri = _notRevealedURI;
    }
    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
    }
    function setMaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
        maxMintAmount = _newmaxMintAmount;
    }
    function setPrice(uint256 _price) public onlyOwner {
        price = _price;
    }
}
