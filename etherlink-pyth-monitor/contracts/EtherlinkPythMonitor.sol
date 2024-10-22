// SPDX-License-Identifier: GPL-3.0
// Etherlink Infra Contracts (last updated v0.0.1)

pragma solidity >=0.7.0 <0.9.0;

import "@pythnetwork/pyth-sdk-solidity/IPyth.sol";
import "@pythnetwork/pyth-sdk-solidity/PythStructs.sol";

import "etherlink-infra-utils/contracts/IEtherlinkInfraOracleMonitor.sol";
import "etherlink-infra-utils/contracts/EtherlinkAdministered.sol";
/**
 * @dev this is the implementation for Pyth of IEtherlinkInfraOracleMonitor.sol 
 * this implemenation enables the monitoring of a specific asset. This contract also provides functions for fault diagnosis on chain 
 */
contract EtherlinkPythMonitor is EtherlinkAdministered, IEtherlinkInfraOracleMonitor { 

    string name = "ETHERLINK_PYTH_MONITOR";
    uint256 constant version = 5; 

    bytes32 priceId;
    string symbol;
    Network network; 
    IPyth pyth; 
    uint256 age = 60; 

    constructor(address _admin, address _pyth, bytes32 _priceId, string memory _symbol, Network _network) EtherlinkAdministered(_admin) {
        pyth = IPyth(_pyth);
        priceId = _priceId; 
        symbol = _symbol; 
        network = _network; 
    }

    /**
     * @inheritdoc IEtherlinkVersion
     */
    function getName() view override external returns (string memory _name) {
        return name;
    }
   /**
     * @inheritdoc IEtherlinkVersion
     */
    function getVersion() pure override external returns (uint256 _version) {
        return version; 
    }

    /**
     * @dev gets the age from which the price will be retrieved by this monitor
     * @return _age in seconds 
     */
    function getAge() view external returns (uint256 _age) {
        return age; 
    }

    /**
     * @dev this gets the price id currently configured for monitoring
     * @return _priceId the price id
     * @return _symbol associated symbol that are currently set on this monitor
     */
    function getPriceId() view external returns (bytes32 _priceId, string memory _symbol) {
        return (priceId, symbol); 
    }

    /**
     * @dev sets the Pyth priceId and symbol for a given asset 
     * @param _priceId Pyth price Id for asset as specified at https://www.pyth.network/developers/price-feed-ids#pyth-evm-stable
     * @param _symbol symbol for asset
     */
    function setPriceId(bytes32 _priceId, string memory _symbol)  external adminOnly returns (bool _set){
        priceId = _priceId;
        symbol = _symbol; 
        return true;  
    }
    
    /**
     * @dev sets the age in seconds from which the price should be retrieved  
     * @param _age in seconds from which to get the price 
     */
    function setAge(uint256 _age) external adminOnly returns (bool _set){
        age = _age; 
        return true; 
    }

    /**
     * @dev this gets the current price served for the Pyth asset
     * @return _price raw Pyth price representation 
     */
    function getCurrentPrice() view external returns (PythStructs.Price memory _price) {
        _price = pyth.getPriceNoOlderThan(priceId, age);
        return _price; 
    }
    
    /**
     * @dev the gets the price from the Pyth oracle at a specific age
     * @return _price the standardised EtherlinkOraclePrice representation
     */
    function getPriceAtAge() view external returns (EtherlinkOraclePrice memory _price){
        PythStructs.Price memory price_ =  pyth.getPriceNoOlderThan(priceId, age);
        _price = EtherlinkOraclePrice({     
                                        provider : "PYTH",
                                        source : address(pyth), 
                                        monitor : self,
                                        network : network, 
                                        symbol : symbol,
                                        price : uint256(int256(price_.price)),
                                        priceDate : price_.publishTime,
                                        date : block.timestamp
                                    });
        return _price; 
    }

    /**
     * @inheritdoc IEtherlinkInfraOracleMonitor
     */
    function getPrice() view external returns (EtherlinkOraclePrice memory _price){
        PythStructs.Price memory price_ =  pyth.getPriceUnsafe(priceId);
        _price = EtherlinkOraclePrice({     
                                        provider : "PYTH",
                                        source : address(pyth), 
                                        monitor : self,
                                        network : network, 
                                        symbol : symbol, 
                                        price : uint256(int256(price_.price)),
                                        priceDate : price_.publishTime,
                                        date : block.timestamp
                                    });
        return _price; 

    }

}

