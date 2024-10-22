// SPDX-License-Identifier: GPL-3.0
// Etherlink Infra Contracts (last updated v0.0.1)

pragma solidity >=0.8.2 <0.9.0;

import "etherlink-infra-utils/contracts/EtherlinkAdministered.sol";
import "etherlink-infra-utils/contracts/IEtherlinkInfraOracleMonitor.sol"; 
import "etherlink-infra-external-deps/contracts/chainlink/AggregatorV3Interface.sol";

/**
 * @dev this is the implementation for Redstone of IEtherlinkInfraOracleMonitor.sol 
 * this implemenation enables the monitoring of a specific asset. This contract also provides functions for fault diagnosis on chain 
 */
contract EtherlinkRedstonePushMonitor is EtherlinkAdministered, IEtherlinkInfraOracleMonitor { 

    string constant name = "ETHERLINK_REDSTONE_PUSH_ORACLE_MONITOR";
    uint256 constant version = 1; 

    mapping(address=>bool) knownAsset; 
    mapping(address=>string) symbolByAsset;
    mapping(string=>address) assetBySymbol;  
    address [] assets; 

    address monitorAsset; 
    Network network;

    constructor(address _admin, address [] memory _assets, string [] memory _symbols, Network _network) EtherlinkAdministered(_admin) {
        monitorAsset = _assets[0];
        for(uint256 x_ = 0; x_ < _assets.length; x_++){
            loadAsset(_assets[x_], _symbols[x_]);
        }
        network = _network; 
    }
    /**
     * @inheritdoc IEtherlinkInfraVersion
     */
    function getName() pure override external returns (string memory _name) {
        return name; 
    }

    /**
     * @inheritdoc IEtherlinkInfraVersion
     */
    function getVersion() pure override external returns (uint256 _version) {
        return version; 
    }

    /**
     * @dev gets the asset that is currently configured for monitoring 
     * @return _asset the address of the asset
     * @return _symbol the symbol of the asset
     */
    function getMonitorAsset() view external returns (address _asset, string memory _symbol){
        return (monitorAsset, symbolByAsset[monitorAsset]); 
    }

    /**
     * @dev gets the assets that are configured for this monitor
     * @return _symbols for the assets configured for this monitor
     */
    function getConfiguredAssets() view external returns (string [] memory _symbols) {
        _symbols = new string[](assets.length);
        for(uint256 x_ = 0; x_ < assets.length; x_++){
            _symbols[x_] = symbolByAsset[assets[x_]];
        }
        return _symbols; 
    }

    /**
     * @dev checks whether a price can be retrieved for all assets configured for this monitor 
     * @return _prices as an array of standardised EtherlinkOraclePrice representations
     */
    function checkAllAssets() view external returns (EtherlinkOraclePrice [] memory _prices) {
        _prices = new EtherlinkOraclePrice[](assets.length);
        for(uint256 x_ = 0; x_ < assets.length; x_++){
            _prices[x_] = getPriceInternal(assets[x_]);
        }
        return _prices; 
    }

    /**
     * @inheritdoc IEtherlinkInfraOracleMonitor
     */
    function getPrice() view external returns (EtherlinkOraclePrice memory _price){
        return getPriceInternal(monitorAsset); 
    }

    /**
     * @dev adds a new asset to this oracle monitor (Admin Only)
     * @param _asset address of asset
     * @param _symbol of asset 
     */
    function addAsset(address _asset, string memory _symbol) external adminOnly returns (bool _added){
        require(!knownAsset[_asset], "known asset");
        loadAsset(_asset, _symbol);
        return true; 
    }

    /**
     * @dev sets the asset to be monitored (Admin Only)
     * @param _symbol of asset to monitor
     */
    function setMonitorAsset(string memory _symbol) external adminOnly returns (bool _set) {
         address asset_ = assetBySymbol[_symbol]; 
         require(knownAsset[asset_], "unknown asset"); 
         monitorAsset = asset_;
         return true; 
    }

    //==================================== INTERNAL ============================================================

    function getPriceInternal( address _asset ) view internal returns (EtherlinkOraclePrice memory _price) {
        AggregatorV3Interface oracle_ = AggregatorV3Interface(_asset);
        (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound) = oracle_.latestRoundData(); 
        _price = EtherlinkOraclePrice({     
                                        provider : "REDSTONE",
                                        source : _asset, 
                                        monitor : self,
                                        network : network, 
                                        symbol : symbolByAsset[_asset],
                                        price : uint256(answer),
                                        priceDate : updatedAt,
                                        date : block.timestamp
                                    });
        return _price; 
    }

    function loadAsset(address _asset, string memory _symbol)  internal returns (bool _loaded){
        knownAsset[_asset] = true; 
        assets.push(_asset);
        symbolByAsset[_asset] = _symbol;
        assetBySymbol[_symbol] = _asset; 
        return true; 
    }
}