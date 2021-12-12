pragma solidity >=0.5.0;

import '@pancakeswap/1bch-swap-core/contracts/interfaces/IPancakePair.sol';
import '@pancakeswap/1bch-swap-core/contracts/interfaces/IPancakeFactory.sol';

import "./SafeMath.sol";

library PancakeLibrary {
    using SafeMath for uint;

    // returns sorted token addresses, used to handle return values from pairs sorted in this order
    function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
        require(tokenA != tokenB, 'PancakeLibrary: IDENTICAL_ADDRESSES');
        (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        require(token0 != address(0), 'PancakeLibrary: ZERO_ADDRESS');
    }

    // calculates the CREATE2 address for a pair without making any external calls
    function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
        (address token0, address token1) = sortTokens(tokenA, tokenB);
        pair = address(uint(keccak256(abi.encodePacked(
                hex'ff',
                factory,
                keccak256(abi.encodePacked(token0, token1)),
                IPancakeFactory(factory).INIT_CODE_PAIR_HASH() // init code hash
                // /*>>>*/hex'd0d4c4cd0848c93cb4fd1f498d7013ee6bfb25783ea21593d5834f5d250ece66'/*<<<*/ // init code hash
            ))));
    }

    // fetches and sorts the reserves for a pair
    function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
        (address token0,) = sortTokens(tokenA, tokenB);
        pairFor(factory, tokenA, tokenB);
        (uint reserve0, uint reserve1,) = IPancakePair(pairFor(factory, tokenA, tokenB)).getReserves();
        (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
    }

    // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
    function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
        require(amountA > 0, 'PancakeLibrary: INSUFFICIENT_AMOUNT');
        require(reserveA > 0 && reserveB > 0, 'PancakeLibrary: INSUFFICIENT_LIQUIDITY');
        amountB = amountA.mul(reserveB) / reserveA;
    }

    // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
    function getAmountOut(address factory, address pair, uint amountIn, uint reserveIn, uint reserveOut) internal view returns (uint amountOut) {
        uint outModifyer = 1000 - IPancakeFactory(factory).getExchangeFee(pair);
        require(outModifyer <= 1000 && outModifyer >= 0, 'PancakeLibrary: INVALID_FEE'); // 1000 - 0%, 998 - 0.2%, 990 - 1%, 900 - 10%
        require(amountIn > 0, 'PancakeLibrary: INSUFFICIENT_INPUT_AMOUNT');
        require(reserveIn > 0 && reserveOut > 0, 'PancakeLibrary: INSUFFICIENT_LIQUIDITY');
        //uint amountInWithFee = amountIn.mul(998);
        uint amountInWithFee = amountIn.mul(outModifyer);
        uint numerator = amountInWithFee.mul(reserveOut);
        uint denominator = reserveIn.mul(1000).add(amountInWithFee);
        amountOut = numerator / denominator;
    }

    // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
    function getAmountIn(address factory, address pair, uint amountOut, uint reserveIn, uint reserveOut) internal view returns (uint amountIn) {
        uint inModifyer = 1000 - IPancakeFactory(factory).getExchangeFee(pair);
        require(inModifyer <= 1000 && inModifyer >= 0, 'PancakeLibrary: INVALID_FEE'); // 1000 - 0%, 998 - 0.2%, 990 - 1%, 900 - 10%
        require(amountOut > 0, 'PancakeLibrary: INSUFFICIENT_OUTPUT_AMOUNT');
        require(reserveIn > 0 && reserveOut > 0, 'PancakeLibrary: INSUFFICIENT_LIQUIDITY');
        uint numerator = reserveIn.mul(amountOut).mul(1000);
        //uint denominator = reserveOut.sub(amountOut).mul(998);
        uint denominator = reserveOut.sub(amountOut).mul(inModifyer);
        amountIn = (numerator / denominator).add(1);
    }

    // performs chained getAmountOut calculations on any number of pairs
    function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
        require(path.length >= 2, 'PancakeLibrary: INVALID_PATH');
        amounts = new uint[](path.length);
        amounts[0] = amountIn;
        for (uint i; i < path.length - 1; i++) {
            (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
            address pair = pairFor(factory, path[i], path[i + 1]);
            amounts[i + 1] = getAmountOut(factory, pair, amounts[i], reserveIn, reserveOut);
        }
    }

    // performs chained getAmountIn calculations on any number of pairs
    function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
        require(path.length >= 2, 'PancakeLibrary: INVALID_PATH');
        amounts = new uint[](path.length);
        amounts[amounts.length - 1] = amountOut;
        for (uint i = path.length - 1; i > 0; i--) {
            (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
            address pair = pairFor(factory, path[i], path[i - 1]);
            amounts[i - 1] = getAmountIn(factory, pair, amounts[i], reserveIn, reserveOut);
        }
    }
}
