// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

//
//
//

interface IERC165 {
    
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

//
//
//

interface IERC721 is IERC165 {
    
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
    
    function balanceOf(address owner) external view returns (uint256 balance);
    
    function ownerOf(uint256 tokenId) external view returns (address owner);
    
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;
    
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;
    
    function approve(address to, uint256 tokenId) external;
    
    function getApproved(uint256 tokenId) external view returns (address operator);
    
    function setApprovalForAll(address operator, bool _approved) external;
    
    function isApprovedForAll(address owner, address operator) external view returns (bool);
    
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;
}

//
//
//

interface IERC721Receiver {
    
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);
}

//
//
//

interface IERC721Metadata is IERC721 {
    
    function name() external view returns (string memory);
    
    function symbol() external view returns (string memory);
    
    function tokenURI(uint256 tokenId) external view returns (string memory);
}

//
//
//

library Address {
    
    function isContract(address account) internal view returns (bool) {
        
        
        
        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }
    
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");
        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
    
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCall(target, data, "Address: low-level call failed");
    }
    
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }
    
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }
    
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");
        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResult(success, returndata, errorMessage);
    }
    
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }
    
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");
        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }
    
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }
    
    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }
    
    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            
            if (returndata.length > 0) {
                
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

//
//
//

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }
    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

//
//
//

library Strings {
    bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
    
    function toString(uint256 value) internal pure returns (string memory) {
        
        
        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
    
    function toHexString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0x00";
        }
        uint256 temp = value;
        uint256 length = 0;
        while (temp != 0) {
            length++;
            temp >>= 8;
        }
        return toHexString(value, length);
    }
    
    function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
        bytes memory buffer = new bytes(2 * length + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint256 i = 2 * length + 1; i > 1; --i) {
            buffer[i] = _HEX_SYMBOLS[value & 0xf];
            value >>= 4;
        }
        require(value == 0, "Strings: hex length insufficient");
        return string(buffer);
    }
}

//
//
//

abstract contract ERC165 is IERC165 {
    
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC165).interfaceId;
    }
}

//
//
//

interface IERC721Enumerable is IERC721 {
    
    function totalSupply() external view returns (uint256);
    
    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
    
    function tokenByIndex(uint256 index) external view returns (uint256);
}

//
//
//

abstract contract Ownable is Context {
    address private _owner;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    
    constructor() {
        _setOwner(_msgSender());
    }
    
    function owner() public view virtual returns (address) {
        return _owner;
    }
    
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }
    
    function renounceOwnership() public virtual onlyOwner {
        _setOwner(address(0));
    }
    
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _setOwner(newOwner);
    }
    function _setOwner(address newOwner) private {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

//
//
//

interface IERC20 {

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address to, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}

//
//
//

contract Birch is Ownable {

    mapping(uint => uint) blocktimestamps;
    mapping(uint => bool) public rare;
    mapping(uint => bool) public epic;
    mapping(uint => bool) public legendary;

    uint startBlock;
    uint commonClaim = 158548959918;
    uint rareClaim = 317097919837;
    uint epicClaim = 634195839675;
    uint legendClaim = 1902587519025;

    uint[] rares = [10,23,27,29,36,37,39,42,56,59,71,89,102,108,112,116,123,125,126,148,163,173,174,195,213,217,242,246,255,257,258,263,276,278,297,298];
    uint[] epics = [2,3,4,5,6,7,20,34,50,52,69,72,73,107,131,156,199,200,229,245,249,285];
    uint[] legends = [54,109,120,236,248];

    address dogos = 0xbf0e4613f25bBA08811632613F4161FA415CB253;
    address carboncredit = 0x16e13C4cCcC031a0D7BAa34bcB39Aaf65b3C1891;

    event Claim(uint256 iinuID);

    constructor() {
        startBlock = (block.number + 10);
        for (uint i = 0; i < rares.length; i++) {
            rare[rares[i]] = true;
        }
        for (uint i = 0; i < epics.length; i++) {
            epic[epics[i]] = true;
        }
        for (uint i = 0; i < legends.length; i++) {
            legendary[legends[i]] = true;
        }
    }

    function claim(uint256 _iinuID) public {
        require(msg.sender == IERC721(dogos).ownerOf(_iinuID), "You don't own that dog!");
        uint iinuBalance = dogoBalance(_iinuID);
        blocktimestamps[_iinuID] = block.number;
        IERC20(carboncredit).transfer(address(msg.sender), iinuBalance);
    }

    function dogoBalance(uint256 _iinuID) public view returns (uint256) {
        uint iinu = blocktimestamps[_iinuID];
        uint iinuBalance;
        uint rarityClaim;
        if (rare[_iinuID] == true){    
            rarityClaim = rareClaim;
        } else if (epic[_iinuID] == true) {
            rarityClaim = epicClaim;
        }  else if (legendary[_iinuID] == true) {
            rarityClaim = legendClaim;
        } else {
            rarityClaim = commonClaim;
        }
        if (iinu == 0){
            iinuBalance = (block.number - startBlock) * rarityClaim;
        } else {
            iinuBalance = (block.number - iinu) * rarityClaim;
        }
        return iinuBalance;
    }

    function setCarbonCredit(address _setCarbonCredit) public onlyOwner() {
        carboncredit = _setCarbonCredit;
    }

    function withdrawCarbonCredits() public onlyOwner() {
        uint CCBAL = IERC20(carboncredit).balanceOf(address(this));
        IERC20(carboncredit).transfer(address(msg.sender), CCBAL);
    }

    function setCommonClaim(uint256 _setCommonClaim) public onlyOwner() {
        commonClaim = _setCommonClaim;
    }

    function setRareClaim(uint256 _setRareClaim) public onlyOwner() {
        rareClaim = _setRareClaim;
    }

    function setEpicClaim(uint256 _setEpicClaim) public onlyOwner() {
        epicClaim = _setEpicClaim;
    }

    function setLegendClaim(uint256 _setLegendClaim) public onlyOwner() {
        legendClaim = _setLegendClaim;
    }
}