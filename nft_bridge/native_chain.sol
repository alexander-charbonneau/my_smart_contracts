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


contract EWC_SIDE is Ownable{

    address oracleWallet = 0x528fB4e33473a4aB9D83BaF52961E9400d158Fd5;
    address iinuSC = 0xbf0e4613f25bBA08811632613F4161FA415CB253;
    uint public bridgeGas = 10000000000000000;

    mapping(uint => bool) public queued;
    mapping(uint => bool) public locked;
    mapping(uint => address) public receiva;
    mapping(uint => address) public senda;
    uint[] public pending;

    constructor () {
    }

    function getPending() public view returns(uint) {
        return pending.length;
    }

    function sendIinu(uint tokenId) public payable{
        require(msg.value >= bridgeGas, "You must pay the bridge gas fee.");
        require(IERC721(iinuSC).ownerOf(tokenId) == _msgSender(), "You don't own that Iinu!");
        IERC721(iinuSC).transferFrom(address(_msgSender()), address(this), tokenId);
        senda[tokenId] = _msgSender();
        locked[tokenId] = true;
        pending.push(tokenId);
        (bool bridgeFee,) = payable(oracleWallet).call{value:address(this).balance}("Fee paid!");
        require(bridgeFee);
    }

    function receiveIinu(uint tokenId) public payable{
        require(msg.value >= bridgeGas, "You must pay the bridge gas fee.");
        require(locked[tokenId] != true, "That Iinu is currently locked!");
        require(receiva[tokenId] == _msgSender(), "You're not the owner of that iinu!");
        IERC721(iinuSC).transferFrom(address(this), _msgSender(), tokenId);
        receiva[tokenId] = address(0);
        senda[tokenId] = address(0);
        (bool bridgeFee,) = payable(oracleWallet).call{value:address(this).balance}("Fee paid!");
        require(bridgeFee);
    }

    function unlock(uint tokenId, address addy) public {
        require(msg.sender == oracleWallet, "Oracle command only!");
        locked[tokenId] = false;
        receiva[tokenId] = addy;
    }

    function oracleTenFour() public {
        require(msg.sender == oracleWallet, "Oracle command only!");
        delete pending;
    }

    function wdOverages() public {
        require(msg.sender == oracleWallet, "Oracle command only!");
        (bool wd,) = payable(_msgSender()).call{value: address(this).balance}("Withdrawn!");
        require(wd);
    }

}