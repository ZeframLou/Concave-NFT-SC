// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
pragma abicoder v2;

import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/utils/Strings.sol';
import '@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol';
// import 'base64-sol/base64.sol';
import './base64.sol';
import './TheColors.sol';
import './INFTOwner.sol';


contract TheSpirals is ERC721Enumerable, Ownable {
    using Strings for uint256;
    using Strings for uint32;
    using Strings for uint8;

    struct SpoonTraits {
        uint8 material;
        uint8 role;
    }

    address constant public THE_COLORS = address(0x9fdb31F8CE3cB8400C7cCb2299492F2A498330a4);

    mapping(uint256 => bool) public hasClaimed;
    mapping(uint256 => bool) public isUpsideDown;

    constructor() ERC721("The Spoons (CONCAVE)", "CONCAVE") {}

    function tokenURI(uint256 tokenId) public view virtual override(ERC721) returns (string memory) {
        require(hasClaimed[tokenId], "ERC721Metadata: URI query for nonexistent token");

        string memory svgData = generateSVGImage(tokenId);
        string memory image = Base64.encode(bytes(svgData));

        return string(
            abi.encodePacked(
                'data:application/json;base64,',
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{',
                            '"image":"',
                            'data:image/svg+xml;base64,',
                            image,
                            '",',
                            generateNameDescription(tokenId),
                            generateAttributes(tokenId),
                            '}'
                        )
                    )
                )
            )
        );
    }

    function getTokenMetadata(uint256 tokenId) public view returns (string memory) {
        string memory image = Base64.encode(bytes(generateSVGImage(tokenId)));

        return string(
            abi.encodePacked(
                'data:application/json',
                '{',
                '"image":"',
                'data:image/svg+xml;base64,',
                image,
                '",',
                generateNameDescription(tokenId),
                generateAttributes(tokenId),
                '}'
            )
        );
    }

    function getTokenSVG(uint256 tokenId) public view returns (string memory) {
        return generateSVGImage(tokenId);
    }

    function getBase64TokenSVG(uint256 tokenId) public view returns (string memory) {
        string memory image = Base64.encode(bytes(generateSVGImage(tokenId)));
        return string(
            abi.encodePacked(
                'data:application/json;base64',
                image
            )
        );
    }

    function getColorsOwnedByUser(address user) public view returns (uint256[] memory tokenIds) {
      uint256[] memory tokenIds = new uint256[](4317);

      uint index = 0;
      for (uint i = 0; i < 4317; i++) {
        address tokenOwner = INFTOwner(THE_COLORS).ownerOf(i);

        if (user == tokenOwner) {
          tokenIds[index] = i;
          index += 1;
        }
      }

      uint left = 4317 - index;
      for (uint i = 0; i < left; i++) {
        tokenIds[index] = 9999;
        index += 1;
      }

      return tokenIds;
    }

    function getUnmintedSpoonsByUser(address user) public view returns (uint256[] memory tokenIds) {
      uint256[] memory tokenIds = new uint256[](4317);

      uint index = 0;
      for (uint i = 0; i < 4317; i++) {
        address tokenOwner = INFTOwner(THE_COLORS).ownerOf(i);

        if (user == tokenOwner && !hasClaimed[i]) {
          tokenIds[index] = i;
          index += 1;
        }
      }

      uint left = 4317 - index;
      for (uint i = 0; i < left; i++) {
        tokenIds[index] = 9999;
        index += 1;
      }

      return tokenIds;
    }

    function withdraw() public onlyOwner {
        uint balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }

    function mintSpoon(uint256 tokenId) public {
        address tokenOwner = INFTOwner(THE_COLORS).ownerOf(tokenId);

        require(!hasClaimed[tokenId], "Color has already claimed their Spiral.");
        require(msg.sender == tokenOwner, "Only token owner can mint their Spiral.");

        uint32 r = TheColors(THE_COLORS).getRed(tokenId);
        uint32 g = TheColors(THE_COLORS).getGreen(tokenId);
        uint32 b = TheColors(THE_COLORS).getBlue(tokenId);

        _safeMint(msg.sender, tokenId);
        generateColorSpectrum(tokenId, r, g, b);

        hasClaimed[tokenId] = true;
    }

    function mintBatch(uint256[] memory tokenIds) public {
      for (uint256 i = 0; i < tokenIds.length; i++) {
        mintSpoon(tokenIds[i]);
      }
    }

    function generateNameDescription(uint256 tokenId) internal view returns (string memory) {
        string memory hexCode = TheColors(THE_COLORS).getHexColor(tokenId);
        return string(
            abi.encodePacked(
                '"external_url":"https://thecolors.art",',
                unicode'"description":"The Spoons. A homage to TheColors, TheSpirals, by the Concave community.',
                '\\nToken id: #',
                tokenId.toString(),
                '",',
                '"name":"The ',
                hexCode,
                ' Spoon",'
            )
        );
    }

    function generateAttributes(uint256 tokenId) internal view returns (string memory) {
        string memory hexCode = TheColorsSpoons(THE_COLORS).getHexColor(tokenId);
        uint32 r = TheColorsSpoons(THE_COLORS).getRed(tokenId);
        uint32 g = TheColorsSpoons(THE_COLORS).getGreen(tokenId);
        uint32 b = TheColorsSpoons(THE_COLORS).getBlue(tokenId);

        SpoonTraits memory traits = generateTraits(tokenId, r, g, b);

        return string(
          abi.encodePacked(
                  '"attributes":[',
                  '{"trait_type":"Background color","value":"',
                  hexCode,
                  '"},',
                  '{"trait_type":"Upside Down","value":"',
                  isUpsideDown[tokenId],
                  '"},',
                  '{"trait_type":"Material","value":"',
                  getMaterial(traits.material),
                  '"},',
                  '{"trait_type":"Role","value":"',
                  getRole(traits.role),
                  '"}',
                  ']'
          )
        );
    }

    function getMaterial(uint8 direction) internal view returns (string memory) {

        if (direction < 10) {
            return "Diamond";
        } else if (direction < 25) {
            return "Platinum";
        } else if (direction < 45) {
            return "Gold";
        } else if (direction < 76) {
            return "Silver";
        } else {
            return "Wood";
        }
    }

    function getRole(uint8 strokeWidth) internal view returns (string memory) {
        if (strokeWidth < 51) {
            return "Miner";
        } else if (strokeWidth < 86) {
            return "Seismologist";
        } else if (strokeWidth < 117) {
            return "Foreman";
        } else if (strokeWidth < 142) {
            return "Genesis";
        } else if (strokeWidth < 163) {
            return "Hentai";
        } else if (strokeWidth < 181) {
            return "Spelunker";
        } else if (strokeWidth < 196) {
            return "Explorer";
        } else if (strokeWidth < 209) {
            return "Documentator";
        } else if (strokeWidth < 219) {
            return "Witness";
        } else if (strokeWidth < 228) {
            return "Engineer";
        } else if (strokeWidth < 235) {
            return "Cave Troll";
        } else if (strokeWidth < 242) {
            return "Operator";
        } else if (strokeWidth < 247) {
            return "Inspector";
        } else if (strokeWidth < 251) {
            return "MOTW";
        } else if (strokeWidth < 253) {
            return "Super Mod";
        } else {
            return "Core";
        }
    }

    function generateSVGImage(uint256 tokenId) internal view returns (string memory) {
        return ""
    }

    function generateTraits(uint256 tokenId, uint32 r, uint32 g, uint32 b) internal view returns (SpoonTraits memory) {

        SpoonTraits memory traits;
        traits.material = uint8((_rng(tokenId, r + g + b)));
        traits.role = uint8((_rng(tokenId, r + g + b)));

        return traits;
    }

    function generateOppositeColor(uint32 r, uint32 g, uint32 b) internal view returns (string memory) {
        return string(abi.encodePacked('rgb(', (255 - r).toString(), ',', (255 - g).toString(), ',', (255 - b).toString(), ')'));
    }

    function generateColorSpectrum(uint256 tokenId, uint32 r, uint32 g, uint32 b) internal view returns (string memory, string memory, string memory) {
        return (
          string(
            abi.encodePacked(
              '#',
              uintToHexString(uint256(_rng(tokenId, r) % 16777215))
            )
          ),
          string(
            abi.encodePacked(
              '#',
              uintToHexString(uint256(_rng(tokenId, g) % 16777215))
            )
          ),
          string(
            abi.encodePacked(
              '#',
              uintToHexString(uint256(_rng(tokenId, b) % 16777215))
            )
          )
        );
    }

    function uintToHexString(uint256 number) public pure returns(string memory) {
        bytes32 value = bytes32(number);
        bytes memory alphabet = "0123456789abcdef";

        bytes memory str = new bytes(6);
        for (uint i = 0; i < 3; i++) {
            str[i*2] = alphabet[uint(uint8(value[i + 29] >> 4))];
            str[1+i*2] = alphabet[uint(uint8(value[i + 29] & 0x0f))];
        }

        return string(str);
    }

    function _rng(uint256 tokenId, uint256 seed) internal view returns(uint256) {
        uint256 _tokenId = tokenId + 1;
        return uint256(keccak256(abi.encodePacked(_tokenId.toString(), seed.toString()))) +
                uint256(_tokenId * seed);
    }
}
