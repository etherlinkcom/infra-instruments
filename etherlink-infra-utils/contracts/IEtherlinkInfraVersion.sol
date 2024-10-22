// SPDX-License-Identifier: GPL-3.0
// Etherlink Infra Contracts (last updated v0.0.1)

pragma solidity >=0.7.0 <0.9.0;
/** 
 * @dev this enables tracking of Etherlink Infra Contracts deployed on Etherlink through automation
 */
interface IEtherlinkInfraVersion { 
    
    /** 
     * @dev returns name of the infra contract
     */
    function getName() view external returns (string memory _name);

    /**
     * @dev returns the version of the infra contract 
     */
    function getVersion() view external returns (uint256 _version);
}