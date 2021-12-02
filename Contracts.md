
´´´
/1bch-farm/contracts/MasterChef.sol <- audit
  /1bch-farm/contracts/CakeToken.sol <- audit
  /1bch-swap-lib/contracts/token/BEP20/BEP20.sol  from pancakeswap, BSC version of openzeppelin ERC20.sol
    /1bch-swap-lib/contracts/token/BEP20/IBEP20.sol
    
    /1bch-swap-lib/contracts//access/Ownable.sol from openzeppelin
    /1bch-swap-lib/contracts//GSN/Context.sol from openzeppelin
    /1bch-swap-lib/contracts//math/SafeMath.sol from openzeppelin
    /1bch-swap-lib/contracts//utils/Address.sol from openzeppelin
  
  /1bch-swap-lib/contracts/token/BEP20/IBEP20.sol from pancakeswap, BSC version
  /1bch-swap-lib/contracts/token/BEP20/SafeBEP20.sol from pancakeswap, BSC version
  
  /1bch-swap-lib/contracts/math/SafeMath.sol from openzeppelin
  /1bch-swap-lib/contracts/access/Ownable.sol from openzeppelin

/1bch-vault/contracts/CakeVault.sol <- audit

  /1bch-vault/contracts/utils/Context.sol from openzepelin
  /1bch-vault/contracts/access/Ownable.sol from openzepelin
  /1bch-vault/contracts/math/SafeMath.sol from openzepelin
  /1bch-vault/contracts/token/ERC20/IERC20.sol from openzepelin
  /1bch-vault/contracts/utils/Address.sol from openzepelin
  /1bch-vault/contracts/utils/Pausable.sol from openzepelin
  /1bch-vault/contracts/token/ERC20/SafeERC20.sol from openzepelin

  /interfaces/IMasterChef.sol interface to our mactercheff contract

// swapping stuff
/1bch-swap-core/contracts/PancakeFactory.sol <- audit
  /1bch-swap-core/contracts/interfaces/IPancakeFactory.sol just an interface
  
  /1bch-swap-core/contracts/PancakePair.sol our liquidity/swap pool pait <- audit
    /1bch-swap-core/contracts/interfaces/IPancakePair.sol just an interface
    /1bch-swap-core/contracts/interfaces/IPancakeFactory.sol just an interface
    /1bch-swap-core/contracts/interfaces/IPancakeCallee.sol just an interface
    
    /1bch-swap-core/contracts/PancakeERC20.sol from pancake swap
    /1bch-swap-core/contracts/libraries/UQ112x112.sol from pancake swap
    
    /1bch-swap-core/contracts/libraries/Math.sol from openzeppelin
    /1bch-swap-core/contracts/interfaces/IERC20.sol from openzeppelin
    

/1bch-swap-periphery/contracts/PancakeRouter.sol <- audit
  /1bch-swap-core/contracts/interfaces/IPancakeFactory.sol just an interface
  /interfaces/IPancakeRouter02.sol just an interface
  
  /1bch-swap-lib/contracts/utils/TransferHelper.sol from pancakeswap
  /libraries/PancakeLibrary.sol <- audit
    /1bch-swap-core/contracts/interfaces/IPancakePair.sol just an interface
    /1bch-swap-core/contracts/interfaces/IPancakeFactory.sol just an interface

    /libraries/SafeMath.sol from openzepelin

  /libraries/SafeMath.sol from openzepelin
  /interfaces/IERC20.sol from openzepelin
  /interfaces/IWETH.sol from openzepelin


// sprinklers - no audit needed?
/1bch-pool/contracts/SmartChefFactory.sol <- audit
  /1bch-pool/contracts/SmartChefInitializable.sol the actual sprinkler <- audit

    /utils/Context.sol from openzeppelin
    /access/Ownable.sol from openzeppelin
    /math/SafeMath.sol from openzeppelin
    /utils/ReentrancyGuard.sol from openzeppelin
    /utils/Address.sol from openzeppelin

    /token/BEP20/SafeBEP20.sol from pancakeswap, BSC version
    
´´´