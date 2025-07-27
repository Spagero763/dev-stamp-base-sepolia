// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract DevStamp is ERC721 {
    using Strings for uint256;
    
    struct Stamp {
        uint256 timestamp;
        string reason;
        address builder;
    }
    
    // Token ID counter
    uint256 private _tokenIdCounter;
    
    // Mapping from token ID to stamp data
    mapping(uint256 => Stamp) public stamps;
    
    // Mapping to track if an address has already minted
    mapping(address => bool) public hasMinted;
    
    // Mapping from address to their token ID
    mapping(address => uint256) public builderToTokenId;
    
    event Stamped(address indexed builder, uint256 indexed tokenId, string reason);
    
    constructor() ERC721("DevStamp", "DEVS") {}
    
    /**
     * @dev Mint a soulbound stamp NFT - can only be called once per address
     * @param reason The contribution reason for this stamp
     */
    function stampBuilder(string memory reason) external {
        require(!hasMinted[msg.sender], "DevStamp: Address has already minted");
        require(bytes(reason).length > 0, "DevStamp: Reason cannot be empty");
        
        uint256 tokenId = _tokenIdCounter;
        _tokenIdCounter++;
        
        // Store stamp data
        stamps[tokenId] = Stamp({
            timestamp: block.timestamp,
            reason: reason,
            builder: msg.sender
        });
        
        // Mark as minted and store token ID
        hasMinted[msg.sender] = true;
        builderToTokenId[msg.sender] = tokenId;
        
        // Mint the NFT
        _safeMint(msg.sender, tokenId);
        
        emit Stamped(msg.sender, tokenId, reason);
    }
    
    /**
     * @dev Get stamp data for a token ID
     */
    function getStamp(uint256 tokenId) external view returns (Stamp memory) {
        require(_ownerOf(tokenId) != address(0), "DevStamp: Token does not exist");
        return stamps[tokenId];
    }
    
    /**
     * @dev Get stamp data for a builder address
     */
    function getBuilderStamp(address builder) external view returns (Stamp memory) {
        require(hasMinted[builder], "DevStamp: Builder has not minted");
        uint256 tokenId = builderToTokenId[builder];
        return stamps[tokenId];
    }
    
    /**
     * @dev Generate fully onchain metadata as base64-encoded JSON
     */
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_ownerOf(tokenId) != address(0), "DevStamp: URI query for nonexistent token");
        
        Stamp memory stamp = stamps[tokenId];
        
        // Format timestamp as readable date
        string memory dateStr = _formatTimestamp(stamp.timestamp);
        
        // Create JSON metadata
        string memory json = string(abi.encodePacked(
            '{"name": "DevStamp #', tokenId.toString(),
            '", "description": "A soulbound proof of contribution stamp for developers",',
            '"attributes": [',
                '{"trait_type": "Builder", "value": "', _addressToString(stamp.builder), '"},',
                '{"trait_type": "Contribution", "value": "', stamp.reason, '"},',
                '{"trait_type": "Timestamp", "value": ', stamp.timestamp.toString(), '},',
                '{"trait_type": "Date", "value": "', dateStr, '"},',
                '{"trait_type": "Soulbound", "value": "true"}',
            '],',
            '"image": "', _generateSVG(tokenId, stamp), '"}'
        ));
        
        return string(abi.encodePacked(
            "data:application/json;base64,",
            Base64.encode(bytes(json))
        ));
    }
    
    /**
     * @dev Generate an SVG image for the NFT
     */
    function _generateSVG(uint256 tokenId, Stamp memory stamp) internal pure returns (string memory) {
        string memory svg = string(abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" width="400" height="400" viewBox="0 0 400 400">',
            '<defs><linearGradient id="bg" x1="0%" y1="0%" x2="100%" y2="100%">',
            '<stop offset="0%" style="stop-color:#667eea"/><stop offset="100%" style="stop-color:#764ba2"/>',
            '</linearGradient></defs>',
            '<rect width="400" height="400" fill="url(#bg)"/>',
            '<circle cx="200" cy="120" r="50" fill="white" opacity="0.9"/>',
            '<text x="200" y="130" text-anchor="middle" font-family="Arial, sans-serif" font-size="24" fill="#333">🏆</text>',
            '<text x="200" y="200" text-anchor="middle" font-family="Arial, sans-serif" font-size="20" font-weight="bold" fill="white">DevStamp #', tokenId.toString(), '</text>',
            '<text x="200" y="240" text-anchor="middle" font-family="Arial, sans-serif" font-size="14" fill="white" opacity="0.9">Soulbound NFT</text>',
            '<text x="200" y="300" text-anchor="middle" font-family="Arial, sans-serif" font-size="12" fill="white" opacity="0.8">Contribution:</text>',
            '<text x="200" y="320" text-anchor="middle" font-family="Arial, sans-serif" font-size="10" fill="white">', 
            _truncateString(stamp.reason, 40), '</text>',
            '<text x="200" y="360" text-anchor="middle" font-family="Arial, sans-serif" font-size="10" fill="white" opacity="0.7">',
            _formatTimestamp(stamp.timestamp), '</text>',
            '</svg>'
        ));
        
        return string(abi.encodePacked(
            "data:image/svg+xml;base64,",
            Base64.encode(bytes(svg))
        ));
    }
    
    /**
     * @dev Override transfer functions to make tokens soulbound (non-transferable)
     */
    function _update(address to, uint256 tokenId, address auth) internal override returns (address) {
        address from = _ownerOf(tokenId);
        
        // Allow minting (from == address(0)) but block all transfers
        if (from != address(0) && to != address(0)) {
            revert("DevStamp: Soulbound tokens cannot be transferred");
        }
        
        return super._update(to, tokenId, auth);
    }
    
    /**
     * @dev Override approve to prevent approvals (since tokens can't be transferred)
     */
    function approve(address, uint256) public pure override {
        revert("DevStamp: Soulbound tokens cannot be approved");
    }
    
    /**
     * @dev Override setApprovalForAll to prevent approvals
     */
    function setApprovalForAll(address, bool) public pure override {
        revert("DevStamp: Soulbound tokens cannot be approved");
    }
    
    /**
     * @dev Utility function to convert address to string
     */
    function _addressToString(address addr) internal pure returns (string memory) {
        bytes32 value = bytes32(uint256(uint160(addr)));
        bytes memory alphabet = "0123456789abcdef";
        bytes memory str = new bytes(42);
        str[0] = '0';
        str[1] = 'x';
        for (uint256 i = 0; i < 20; i++) {
            str[2+i*2] = alphabet[uint8(value[i + 12] >> 4)];
            str[3+i*2] = alphabet[uint8(value[i + 12] & 0x0f)];
        }
        return string(str);
    }
    
    /**
     * @dev Format timestamp into readable date string
     */
    function _formatTimestamp(uint256 timestamp) internal pure returns (string memory) {
        // Simple date formatting - you could make this more sophisticated
        return string(abi.encodePacked("Block: ", timestamp.toString()));
    }
    
    /**
     * @dev Truncate string to specified length
     */
    function _truncateString(string memory str, uint256 maxLength) internal pure returns (string memory) {
        bytes memory strBytes = bytes(str);
        if (strBytes.length <= maxLength) {
            return str;
        }
        
        bytes memory truncated = new bytes(maxLength - 3);
        for (uint256 i = 0; i < maxLength - 3; i++) {
            truncated[i] = strBytes[i];
        }
        
        return string(abi.encodePacked(truncated, "..."));
    }
    
    /**
     * @dev Get total number of stamps minted
     */
    function totalSupply() external view returns (uint256) {
        return _tokenIdCounter;
    }
}