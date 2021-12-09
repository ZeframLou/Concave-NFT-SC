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
    mapping(address => uint256) public hasMinted;

    address public constant THE_COLORS = 0x9fdb31F8CE3cB8400C7cCb2299492F2A498330a4;
    address public constant TREASURY = 0x48aE900E9Df45441B2001dB4dA92CE0E7C08c6d2;
    
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

    function mintOnce()
        public
        payable
        whenNotPaused
        returns (uint256)
    {
        // require(!paused(),"contract is paused");
        require(totalSupply()+1 <= maxSupply,"no enough supply");
        uint256 colors_balance = IERC721(THE_COLORS).balanceOf(msg.sender);
        uint256 quota = colors_balance*2;

        if (totalSupply() >= colors_quota) {
            require(msg.value >= price, "insufficient funds");
        } else {
            require(colors_balance > 0,"Not Colors Owner");
            require(hasMinted[msg.sender] <= quota,"Already minted your quota");
            require(hasMinted[msg.sender] + 1 <= quota,"Mint amount surpasses quota");
        }
        uint256 newItemId = _tokenIds.current();
        _tokenIds.increment();
        hasMinted[msg.sender]++;
        _safeMint(msg.sender, newItemId);

        return 1;
    }

    function mint(uint256 _mintAmount) public payable whenNotPaused returns (uint256) {
        if (totalSupply() >= colors_quota) {
            require(msg.value >= price * _mintAmount, "insufficient funds");
        }  
        for (uint i = 0; i < _mintAmount; i++) {
            mintOnce();
        }
        return _mintAmount;
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
        //flat treasury payout
    (bool tr, ) = payable(TREASURY).call{value: address(this).balance * 60 / 100}("");
    require(tr);
    (bool md, ) = payable(0x2F66d5D7561e1bE587968cd336FA3623E5792dc2).call{value: address(this).balance * 9 / 100}("");  
    require(md);
    (bool rd, ) = payable(0xeb9ADe429FBA6c51a1B352a869417Bd410bC1421).call{value: address(this).balance * 5 / 100}("");  
    require(rd);
    (bool br, ) = payable(0xf1A1e46463362C0751Af4Ff46037D1815d66bB4D).call{value: address(this).balance * 5 / 100}("");  
    require(br);
    (bool wt, ) = payable(0x1E3005BD8281148f1b00bdcC94E8d0cD9DA242C2).call{value: address(this).balance * 5 / 100}("");  
    require(wt);
    (bool mt, ) = payable(0x21761978a6F93D0bF5bAb5F75762880E8dc813e8).call{value: address(this).balance * 4 / 100}("");  
    require(mt);
    (bool sh, ) = payable(0x5b3DBf9004E01509777329B762EC2332565F12fA).call{value: address(this).balance * 4 / 100}("");  
    require(sh);
    (bool a1, ) = payable(0xB2b9FF858Bf74436685DaaF76d6901C2A24ef0C3).call{value: address(this).balance * 2 / 100}("");  
    require(a1);
    (bool nu, ) = payable(0xe873Fa8436097Bcdfa593EEd60c10eFAd4244dC0).call{value: address(this).balance * 4 / 100}("");  
    require(nu);
     (bool y1, ) = payable(0x182e0C610c4A855b81169385821C4c8690Af5f3b).call{value: address(this).balance * 2 / 100}("");  
    require(y1);
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
