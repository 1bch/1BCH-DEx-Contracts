pragma solidity >=0.5.0;

interface IPancakeFactory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function feeTo() external view returns (address);
    function getExchangeFee(address) external view returns (uint);
    function feeShare() external view returns (uint);
    function feeAdmin() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;
    function setExchangeFee(address, uint) external;
    function setFeeShare(uint) external;
    function setFeeAdmin(address) external;
    
    function INIT_CODE_PAIR_HASH() external pure returns (bytes32);
}
