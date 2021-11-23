pragma solidity =0.5.16;

import './interfaces/IPancakeFactory.sol';
import './PancakePair.sol';

contract PancakeFactory is IPancakeFactory {
    bytes32 public constant INIT_CODE_PAIR_HASH = keccak256(abi.encodePacked(type(PancakePair).creationCode));

    address public feeTo;
    mapping(address => uint) public exchangeFee;
    uint public feeShare;
    address public feeAdmin;

    mapping(address => mapping(address => address)) public getPair; // map[token1][token2]->pair_Address
    address[] public allPairs;

    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    constructor(address _feeAdmin) public {
        feeAdmin = _feeAdmin;
        feeShare = 334; // 33.4%
        exchangeFee[address(0)] = 2; // 0.2%
    }

    function allPairsLength() external view returns (uint) {
        return allPairs.length;
    }

    function createPair(address tokenA, address tokenB) external returns (address pair) {
        require(tokenA != tokenB, 'Pancake: IDENTICAL_ADDRESSES');
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        require(token0 != address(0), 'Pancake: ZERO_ADDRESS');
        require(getPair[token0][token1] == address(0), 'Pancake: PAIR_EXISTS'); // single check is sufficient
        bytes memory bytecode = type(PancakePair).creationCode;
        bytes32 salt = keccak256(abi.encodePacked(token0, token1));
        assembly {
            pair := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }
        IPancakePair(pair).initialize(token0, token1);
        getPair[token0][token1] = pair;
        getPair[token1][token0] = pair; // populate mapping in the reverse direction
        allPairs.push(pair);
        emit PairCreated(token0, token1, pair, allPairs.length);
    }

    function setFeeTo(address _feeTo) external {
        require(msg.sender == feeAdmin, 'Pancake: FORBIDDEN');
        feeTo = _feeTo;
    }

    function setExchangeFee(address _pair, uint _fee) external {
        require(msg.sender == feeAdmin, 'Pancake: FORBIDDEN');
        require(_fee >= 0 && _fee <= 1000, 'Pancake: INVALID_FEE');	
        exchangeFee[_pair] = _fee;
    }
    
    function getExchangeFee(address _pair) external view returns (uint fee){
        fee = exchangeFee[_pair];
        if (fee == 0){ // if not set use default value
          fee = exchangeFee[address(0)];
        }
    }

    function setFeeShare(uint _feeShare) external {
        require(msg.sender == feeAdmin, 'Pancake: FORBIDDEN');
        require(_feeShare >= 0 && _feeShare <= 1000, 'Pancake: INVALID_SHARE');	
        feeShare = _feeShare;
    }

    function setFeeAdmin(address _feeAdmin) external {
        require(msg.sender == feeAdmin, 'Pancake: FORBIDDEN');
        feeAdmin = _feeAdmin;
    }

}
