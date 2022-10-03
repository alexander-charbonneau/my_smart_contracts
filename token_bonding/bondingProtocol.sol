// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

interface IERC20 {

    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return payable(msg.sender);
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

library Address {

    function isContract(address account) internal view returns (bool) {
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != accountHash && codehash != 0x0);
    }

    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }


    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }

    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
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

interface IERC20Metadata is IERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
}

contract ERC20 is Context, IERC20, IERC20Metadata {
    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;

    /**
     * @dev Sets the values for {name} and {symbol}.
     *
     * The defaut value of {decimals} is 18. To select a different value for
     * {decimals} you should overload it.
     *
     * All two of these values are immutable: they can only be set once during
     * construction.
     */
    constructor (string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5,05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the value {ERC20} uses, unless this function is
     * overridden;
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20}.
     *
     * Requirements:
     *
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for ``sender``'s tokens of at least
     * `amount`.
     */
    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);

        uint256 currentAllowance = _allowances[sender][_msgSender()];
        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
        _approve(sender, _msgSender(), currentAllowance - amount);

        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        uint256 currentAllowance = _allowances[_msgSender()][spender];
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        _approve(_msgSender(), spender, currentAllowance - subtractedValue);

        return true;
    }

    /**
     * @dev Moves tokens `amount` from `sender` to `recipient`.
     *
     * This is internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
    function _transfer(address sender, address recipient, uint256 amount) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        uint256 senderBalance = _balances[sender];
        require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
        _balances[sender] = senderBalance - amount;
        _balances[recipient] += amount;

        emit Transfer(sender, recipient, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        _balances[account] = accountBalance - amount;
        _totalSupply -= amount;

        emit Transfer(account, address(0), amount);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
     *
     * This internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Hook that is called before any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * will be to transferred to `to`.
     * - when `from` is zero, `amount` tokens will be minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
}

contract Ownable is Context {
    address private _owner;
 

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;
    }   
    
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }
    
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }

}


contract bondprot1 is ERC20, Ownable {
    using Address for address;
    
    address public  treasurey = address(this);
    address public  ewd = 0x16e13C4cCcC031a0D7BAa34bcB39Aaf65b3C1891;

    address public  cc1 = 0x62250F0B6a9923a19412469ad09F37A2aA367eda;
    address public  cc2 = 0x0000000000000000000000000000000000000000;
    address public  cc3 = 0x0000000000000000000000000000000000000000;
    address public  cc4 = 0x0000000000000000000000000000000000000000;
    address public  cc5 = 0x0000000000000000000000000000000000000000;

    uint256 public ewd1price = 1000;
    uint256 public ewd2price = 0;
    uint256 public ewd3price = 0;
    uint256 public ewd4price = 0;
    uint256 public ewd5price = 0;
    
    constructor(
        string memory _name,
        string memory _symbol
    ) ERC20(_name, _symbol) {

    }

  //
  //  Carbon credit #1
  //

  function bondcc1(uint256 _amount) public {
    uint256 amount = _amount * 10**18;
    uint256 ewdcost = amount * ewd1price;
    IERC20(ewd).transferFrom(msg.sender, treasurey, ewdcost);
    IERC20(cc1).transferFrom(msg.sender, treasurey, amount);
    _mint(msg.sender, amount);
  }

  function unbondcc1(uint256 _amount) public {
    uint256 amount = _amount * 10**18;
    _burn(msg.sender, amount);
    IERC20(cc1).approve(treasurey, amount);
    IERC20(cc1).transferFrom(treasurey, msg.sender, amount);
  }

  //
  //  Carbon credit #2
  //

  function bondcc2(uint256 _amount) public {
    uint256 amount = _amount * 10**18;
    uint256 ewdcost = amount * ewd1price;
    IERC20(ewd).transferFrom(msg.sender, treasurey, ewdcost);
    IERC20(cc2).transferFrom(msg.sender, treasurey, amount);
    _mint(msg.sender, amount);
  }

  function unbondcc2(uint256 _amount) public {
    uint256 amount = _amount * 10**18;
    _burn(msg.sender, amount);
    IERC20(cc2).approve(treasurey, amount);
    IERC20(cc2).transferFrom(treasurey, msg.sender, amount);
  }

  //
  //  Carbon credit #3
  //

  function bondcc3(uint256 _amount) public {
    uint256 amount = _amount * 10**18;
    uint256 ewdcost = amount * ewd1price;
    IERC20(ewd).transferFrom(msg.sender, treasurey, ewdcost);
    IERC20(cc3).transferFrom(msg.sender, treasurey, amount);
    _mint(msg.sender, amount);
  }

  function unbondcc3(uint256 _amount) public {
    uint256 amount = _amount * 10**18;
    _burn(msg.sender, amount);
    IERC20(cc3).approve(treasurey, amount);
    IERC20(cc3).transferFrom(treasurey, msg.sender, amount);
  }

  //
  //  Carbon credit #4
  //

  function bondcc4(uint256 _amount) public {
    uint256 amount = _amount * 10**18;
    uint256 ewdcost = amount * ewd1price;
    IERC20(ewd).transferFrom(msg.sender, treasurey, ewdcost);
    IERC20(cc4).transferFrom(msg.sender, treasurey, amount);
    _mint(msg.sender, amount);
  }

  function unbondcc4(uint256 _amount) public {
    uint256 amount = _amount * 10**18;
    _burn(msg.sender, amount);
    IERC20(cc4).approve(treasurey, amount);
    IERC20(cc4).transferFrom(treasurey, msg.sender, amount);
  }

  //
  //  Carbon credit #5
  //

  function bondcc5(uint256 _amount) public {
    uint256 amount = _amount * 10**18;
    uint256 ewdcost = amount * ewd1price;
    IERC20(ewd).transferFrom(msg.sender, treasurey, ewdcost);
    IERC20(cc5).transferFrom(msg.sender, treasurey, amount);
    _mint(msg.sender, amount);
  }

  function unbondcc5(uint256 _amount) public {
    uint256 amount = _amount * 10**18;
    _burn(msg.sender, amount);
    IERC20(cc5).approve(treasurey, amount);
    IERC20(cc5).transferFrom(treasurey, msg.sender, amount);
  }

  //
  //  Set the carbon credit contract addresses
  //

  function setcc1(address _setcc1) public onlyOwner() {
    cc1 = _setcc1;
  }
  function setcc2(address _setcc2) public onlyOwner() {
    cc2 = _setcc2;
  }
  function setcc3(address _setcc3) public onlyOwner() {
    cc3 = _setcc3;
  }
  function setcc4(address _setcc4) public onlyOwner() {
    cc4 = _setcc4;
  }
  function setcc5(address _setcc5) public onlyOwner() {
    cc5 = _setcc5;
  }

  //
  //  Set the EWD fee for bond
  //

  function setEwd1Price(uint256 _setEwd1Price) public onlyOwner() {
    ewd1price = _setEwd1Price;
  }
  function setEwd2Price(uint256 _setEwd2Price) public onlyOwner() {
    ewd2price = _setEwd2Price;
  }
  function setEwd3Price(uint256 _setEwd3Price) public onlyOwner() {
    ewd3price = _setEwd3Price;
  }
  function setEwd4Price(uint256 _setEwd4Price) public onlyOwner() {
    ewd4price = _setEwd4Price;
  }
  function setEwd5Price(uint256 _setEwd5Price) public onlyOwner() {
    ewd5price = _setEwd5Price;
  }
    
}