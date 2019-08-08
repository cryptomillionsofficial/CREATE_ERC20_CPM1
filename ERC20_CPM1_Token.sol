pragma solidity ^0.4.24;

import "./Ownable.sol";
import "./SafeMath.sol";
import "./ERC20.sol";
import "./Pausable.sol";
import "./Destructible.sol";

/**
 * @title ERC20_CPM1_Token
 * @dev Basic version of StandardToken, with no allowances.
 */
contract ERC20_CPM1_Token is Ownable, ERC20, Pausable, Destructible {

    using SafeMath for uint256;
    
    mapping(address => uint256) internal balances;

    // Internal variables
    uint256 internal totalSupply_;

    // Token variables
    string public name = "Cryptomillions Serie 1";
    uint8 public decimals = 8;                
    string public symbol = "CPM1";
    uint private TotalSupply = 60000000000000000;
    string public version = '1.0';

    // Constructor to create token
    constructor() public {
        totalSupply_ = TotalSupply;
        balances[owner] = TotalSupply;
        emit Transfer(address(0), owner, TotalSupply);
    }
    
    /**
     * @dev Total number of tokens in existence
     */
    function totalSupply() public view returns (uint256) {
        return totalSupply_;
    }

    /**
     * @dev Gets the balance of the specified address.
     * @param _owner The address to query the the balance of.
     * @return An uint256 representing the amount owned by the passed address.
     */
    function balanceOf(address _owner) public view returns (uint256) {
        return balances[_owner];
    }

    /**
     * @dev Transfer token for a specified address
     * @param _to The address to transfer to.
     * @param _value The amount to be transferred.
     * notice it is necessary that the paused variable be false
     */
    function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
        _transfer(msg.sender, _to, _value);
        return true;
    }

    function _transfer(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0));
        require(recipient != address(0));
        require(recipient != address(msg.sender));
        require(recipient != address(this));
        require(balances[msg.sender] >= amount );
        require(amount != 0);

        balances[sender] = balances[sender].sub(amount);
        balances[recipient] = balances[recipient].add(amount);

        emit Transfer(sender, recipient, amount);
        emit Transfer(sender, address(0), amount);
    }

    /**
     * @dev Burns a specific amount of tokens.
     * @param _value The amount of token to be burned.
     * notice it is necessary that the paused variable be false
     */
    function burnTokens(uint256 _value) public onlyOwner whenNotPaused {
        _burn(msg.sender, _value);
    }

    function _burn(address _who, uint256 _value) internal {
        require(_value != 0);
        require(balances[_who] >= _value);

        balances[_who] = balances[_who].sub(_value);
        totalSupply_ = totalSupply_.sub(_value);
        
        emit Burn(_who, _value);
        emit Transfer(_who, address(0), _value);
    }

    /**
     * @dev show the contract address
     */
    function contractAddress() public view returns(address){
        return address(this);
    }

}
