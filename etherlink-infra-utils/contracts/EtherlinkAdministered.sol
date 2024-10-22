// SPDX-License-Identifier: GPL-3.0
// Etherlink Infra Contracts (last updated v0.0.1)

pragma solidity >=0.7.0 <0.9.0;


import "./IEtherlinkInfraVersion.sol";

abstract contract EtherlinkAdministered is IEtherlinkInfraVersion {

    modifier adminOnly () { 
        require(isAdmin[msg.sender], "admin only");
        _;
    }
    address immutable self; 

    address [] admins; 
    mapping(address=>bool) isAdmin; 


    constructor(address _firstAdmin) { 
        addAdminInternal(_firstAdmin); 
        self = address(this);
    }


    function getName() view virtual  external returns (string memory _name);

    function getVersion() view virtual  external returns (uint256 _version);

    function addAdmin(address _admin) external adminOnly returns (bool _added){
        require(!isAdmin[_admin], "is already admin");
        return addAdminInternal(_admin);
    }

    function removeAdmin(address _admin) external adminOnly returns (bool _removed) {
        require(isAdmin[_admin], "is not admin");
        return removeAdminInternal(_admin);
    }

    //================================ INTERNAL ======================================

    function removeAdminInternal(address _admin)  internal returns (bool _removed){
        require(admins.length > 1, "insufficient admins");
        delete isAdmin[_admin];
        admins = remove(admins, _admin); 
        return true; 
    }

    function addAdminInternal(address _admin) internal returns (bool _added){
        isAdmin[_admin] = true; 
        admins.push(_admin);
        return true; 
    }

    function remove(address [] memory _a, address _b) internal pure returns (address [] memory _c) {
        _c = new address[](_a.length -1); 
        uint256 y_ = 0; 
        for(uint256 x = 0; x < _a.length; x++) {
            if(_a[x] != _b) {
                _c[y_] = _a[x];
                y_++;
            }
        }
        return _c; 
    }
}