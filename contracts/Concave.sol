// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ConcaveNFT is ERC721Enumerable, Pausable, Ownable {
    using Strings for uint256;
    using Counters for Counters.Counter;

    // private variables
    Counters.Counter private _tokenIds;
    bool internal _publicMintActive;

    // public variables
    // NFT base URI
    string public baseURI;
    // URI used for all NFTs before reveal
    string public notRevealedURI;
    // max number of mints per transaction
    uint256 public maxMintAmount = 10;
    // price of public minting
    uint256 public price = 0.04 ether;
    // NFT URI has been revealed
    bool public revealed;
    // colorsTokenId => hasMinted
    mapping(uint256 => bool) public colorsHasMinted;

    // public constants
    address public constant THE_COLORS =
        0x9fdb31F8CE3cB8400C7cCb2299492F2A498330a4;
    address public constant TREASURY =
        0x48aE900E9Df45441B2001dB4dA92CE0E7C08c6d2;
    uint256 public constant MAX_SUPPLY = 4317;
    // Note: TOTAL_COLORS_QUOTA should be divisible by QUOTA_FOR_EACH_COLORS_NFT
    // to ensure the public mint is automatically activated once the quota
    // has been depleted
    uint256 public constant QUOTA_FOR_EACH_COLORS_NFT = 2;
    uint256 public constant TOTAL_COLORS_QUOTA = 200;

    constructor(
        string memory _name,
        string memory _symbol,
        string memory _initBaseURI,
        string memory _initNotRevealedURI
    ) ERC721(_name, _symbol) {
        baseURI = _initBaseURI;
        notRevealedURI = _initNotRevealedURI;
        _pause();
    }

    /**
        External functions
     */

    function publicMintOnce() external payable whenNotPaused {
        uint256 _totalSupply = totalSupply();

        // check conditions
        require(_totalSupply + 1 <= MAX_SUPPLY, "no enough supply");
        require(_publicMintActiveInternal(_totalSupply), "not public mint");
        require(msg.value >= price, "insufficient funds");

        // mint
        uint256 newItemId = _tokenIds.current();
        _tokenIds.increment();
        _safeMint(msg.sender, newItemId);
    }

    function publicMintMultiple(uint256 numMints)
        external
        payable
        whenNotPaused
    {
        uint256 _totalSupply = totalSupply();

        // check conditions
        require(_totalSupply + numMints <= MAX_SUPPLY, "no enough supply");
        require(_publicMintActiveInternal(_totalSupply), "not public mint");
        require(msg.value >= price * numMints, "insufficient funds");
        require(numMints <= maxMintAmount, "over max mint amount per tx");

        // mint
        uint256 newItemId;
        for (uint256 i = 0; i < numMints; i++) {
            newItemId = _tokenIds.current();
            _tokenIds.increment();
            _safeMint(msg.sender, newItemId);
        }
    }

    function colorsMintOnce(uint256 tokenId) external whenNotPaused {
        uint256 _totalSupply = totalSupply();

        // check conditions
        require(
            _totalSupply + QUOTA_FOR_EACH_COLORS_NFT <= TOTAL_COLORS_QUOTA,
            "not enough quota"
        );
        require(!_publicMintActiveInternal(_totalSupply), "not colors mint");

        // verify colors NFT ownership
        require(
            IERC721(THE_COLORS).ownerOf(tokenId) == msg.sender,
            "not colors owner"
        );
        require(!colorsHasMinted[tokenId], "already used this colors NFT");

        // update colors NFT mint status
        colorsHasMinted[tokenId] = true;

        // mint quota
        uint256 newItemId;
        for (uint256 i = 0; i < QUOTA_FOR_EACH_COLORS_NFT; i++) {
            newItemId = _tokenIds.current();
            _tokenIds.increment();
            _safeMint(msg.sender, newItemId);
        }
    }

    function colorsMintMultiple(uint256[] calldata tokenIdList)
        external
        whenNotPaused
    {
        uint256 _totalSupply = totalSupply();

        // check conditions
        require(
            _totalSupply + QUOTA_FOR_EACH_COLORS_NFT * tokenIdList.length <=
                TOTAL_COLORS_QUOTA,
            "not enough quota"
        );
        require(!_publicMintActiveInternal(_totalSupply), "not colors mint");

        uint256 i;
        for (i = 0; i < tokenIdList.length; i++) {
            // verify colors NFT ownership
            require(
                IERC721(THE_COLORS).ownerOf(tokenIdList[i]) == msg.sender,
                "not colors owner"
            );
            require(
                !colorsHasMinted[tokenIdList[i]],
                "already used this colors NFT"
            );

            // update colors NFT mint status
            colorsHasMinted[tokenIdList[i]] = true;
        }

        // mint quota
        uint256 newItemId;
        for (i = 0; i < QUOTA_FOR_EACH_COLORS_NFT * tokenIdList.length; i++) {
            newItemId = _tokenIds.current();
            _tokenIds.increment();
            _safeMint(msg.sender, newItemId);
        }
    }

    /**
        View functions
     */

    /**
        @notice The public mint is activated when the quota for the colors NFT holders
        has been depleted, or when _publicMintActive has been set to true by the contract owner.
        Once the public mint is active, the colors NFT holders can no longer mint for free.
     */
    function publicMintActive() external view returns (bool) {
        return _publicMintActiveInternal(totalSupply());
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        if (!revealed) {
            return notRevealedURI;
        }
        return
            bytes(baseURI).length > 0
                ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json"))
                : "";
    }

    /**
        Owner functions
     */

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
        uint256 balance = address(this).balance;
        uint256 for_treasury = (balance * 60) / 100;
        uint256 for_r1 = (balance * 9) / 100;
        uint256 for_r2 = (balance * 5) / 100;
        uint256 for_r3 = (balance * 5) / 100;
        uint256 for_r4 = (balance * 5) / 100;
        uint256 for_r5 = (balance * 4) / 100;
        uint256 for_r6 = (balance * 4) / 100;
        uint256 for_r7 = (balance * 2) / 100;
        uint256 for_r8 = (balance * 4) / 100;
        uint256 for_r9 = (balance * 2) / 100;
        payable(TREASURY).transfer(for_treasury);
        payable(0x2F66d5D7561e1bE587968cd336FA3623E5792dc2).transfer(for_r1);
        payable(0xeb9ADe429FBA6c51a1B352a869417Bd410bC1421).transfer(for_r2);
        payable(0xf1A1e46463362C0751Af4Ff46037D1815d66bB4D).transfer(for_r3);
        payable(0x1E3005BD8281148f1b00bdcC94E8d0cD9DA242C2).transfer(for_r4);
        payable(0x21761978a6F93D0bF5bAb5F75762880E8dc813e8).transfer(for_r5);
        payable(0x5b3DBf9004E01509777329B762EC2332565F12fA).transfer(for_r6);
        payable(0xB2b9FF858Bf74436685DaaF76d6901C2A24ef0C3).transfer(for_r7);
        payable(0xe873Fa8436097Bcdfa593EEd60c10eFAd4244dC0).transfer(for_r8);
        payable(0x182e0C610c4A855b81169385821C4c8690Af5f3b).transfer(for_r9);
    }

    function setPublicMintActive(bool active) external onlyOwner {
        _publicMintActive = active;
    }

    function setNotRevealedURI(string calldata _notRevealedURI)
        external
        onlyOwner
    {
        notRevealedURI = _notRevealedURI;
    }

    function setBaseURI(string calldata _newBaseURI) external onlyOwner {
        baseURI = _newBaseURI;
    }

    function setMaxMintAmount(uint256 _newMaxMintAmount) external onlyOwner {
        maxMintAmount = _newMaxMintAmount;
    }

    function setPrice(uint256 _price) external onlyOwner {
        price = _price;
    }

    /**
        Internal functions
     */

    function _publicMintActiveInternal(uint256 _totalSupply)
        internal
        view
        returns (bool)
    {
        return _totalSupply >= TOTAL_COLORS_QUOTA || _publicMintActive;
    }
}
