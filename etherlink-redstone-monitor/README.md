# Etherlink Redstone Monitor 

This workspace contains the contracts and instructions necessary to setup the monitoring of the Redstone Push Oracle on Etherlink. 

## Deployments 

**Etherlink Mainnet :** `0x497B59069b592308fe610005b22EA4073FF5833D`

**Etherlink Ghostnet:** `${replace}`


## Instructions 

To setup the project, the following steps are required:
 - build the EtherlinkRedstonePushMonitor.sol contracct 
 - deploy the EtherlinkRedstonePushMonitor.sol contract 
 - verify the EtherlinkRedstonePushMonitor.sol contract 
 - set up the monitoring RPC

 ## Build EtherlinkRedstonePushMonitor.sol
To only build the **EtherlinkRedstonePushMonitor.sol** execute the command below:: 

>npx hardhat compile 

 ## Deploy EtherlinkRedstonePushMonitor.sol
 The following need to be configured in the **EtherlinkRedstonePushMonitorModule_prod.js** prior to deployment:
```

`const assets = [${asset addresses}];`

`const symbols = [${asset symbols}];`

`const admin = "${admin address}";`

`const network = ${0 - mainnet / 1 ghostnet};`

```
  Then run the following command 

  >npx hardhat ignition deploy ./ignition/modules/EtherlinkRedstonePushMonitorModule_prod.js --network etherlink_mainnet

 ## Verify EtherlinkRedstonePushMonitor.sol
To verify the deployed contract you will have to execute the following command: 
> npx hardhat verify --constructor-args ignition/modules/EtherlinkRedstonePushMonitorConstructorArgumentsModule.js --network `${etherlink_mainnet / etherlink_ghostnet}` `${address of your deployment}` 


This will verify your deployed contract on the etherlink ghostnet explorer.

 ## Configure RPC Monitoring
To configure RPC monitoring the following curl command will need to be decomposed and integrated into the relevant monitoring framework. 
```
curl -X POST -H "Content-Type: application/json" --data 
 '{
    "jsonrpc":"2.0",
    "method":"eth_call",
    "params":[
      {
        "to": "${Etherlink Mainnet / Etherlink Testnet Address}",
        "data": "98d5fdca"
      },
      "latest"
    ],
    "id":1
  }'
  ${evm node rpc}
```

### Example curl call 
Below is an example Mainnet call:
```
curl -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0", "method":"eth_call", "params":[{ "to": "0x497B59069b592308fe610005b22EA4073FF5833D", "data": "98d5fdca" }, "latest" ], "id":1 }' https://node.mainnet.etherlink.com
```

