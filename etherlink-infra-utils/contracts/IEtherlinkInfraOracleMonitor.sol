// SPDX-License-Identifier: GPL-3.0
// Etherlink Infra Contracts (last updated v0.0.1)

pragma solidity >=0.7.0 <0.9.0;

/** 
 * @dev this is the struct that returns on chain oracle monitoring data
 */
struct EtherlinkOraclePrice { 
    string provider;   // data providing organisation
    address source;    // address of the on chain oracle
    address monitor;   // address of the monitor
    Network network;     // Mainnet / Ghostnet 
    string symbol;     // symbol of the asset provided by the oracle
    uint256 price;     // price of the asset provided by the oracle
    uint256 priceDate; // date of the price provided 
    uint256 date;      // date of the price check 
}
/**
 * @dev network to which the monitor is deployed
 */ 
enum Network {MAINNET, TESTNET}

/** 
 * @dev this is the standard interface for infra monitoring of oracles on the Etherlink network. 
 */
interface IEtherlinkInfraOracleMonitor { 

    /**
     * @dev Returns the price of the configured asset in the Oracle implemenation. 
     */
    function getPrice() view external returns (EtherlinkOraclePrice memory _price);
}