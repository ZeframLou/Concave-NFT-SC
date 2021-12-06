// contracts/GameItem.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

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

    constructor(
        string memory _name,
        string memory _symbol,
        string memory _initBaseURI,
        string memory _initNotRevealedUri
    ) ERC721(_name, _symbol) {
        // setBaseURI(_initBaseURI);
        baseURI = _initBaseURI;
        notRevealedUri = _initNotRevealedUri;
        // setNotRevealedURI(_initNotRevealedUri);

    }

    function mint(uint256 _mintAmount)
        public
        payable
        returns (uint256)
    {
        require(!paused(),"contract is paused");
        require(_mintAmount <= maxMintAmount,"minting too many");
        require(totalSupply()+_mintAmount <= maxSupply,"no enough supply");
        if (totalSupply() > 200) {
            require(msg.value >= price, "insufficient funds");
        }
        uint256 newItemId = _tokenIds.current();
        _mint(msg.sender, newItemId);
        _tokenIds.increment();
        return newItemId;
    }


    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        if(!revealed) {
            return notRevealedUri;
        }
        // string memory baseURI = baseURI();
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(),".json")) : "";
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
