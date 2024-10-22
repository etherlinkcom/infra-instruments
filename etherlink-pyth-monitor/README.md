# Etherlink Pyth Monitor 

This workspace contains the contracts and instructions necessary to setup the monitoring of the Pyth Oracle on Etherlink. 

## Deployments 

**Etherlink Mainnet :** `0xE6161f114E6913BF2C6d109dc20eF0276AC05513`

**Etherlink Ghostnet:** `0xdEb51fEe6c0B932b50eB5451aa6AE3db3117964F`


## Instructions 

To setup the project, the following steps are required:
 - build the EtherlinkPythMonitor.sol contracct 
 - deploy the EtherlinkPythMonitor.sol contract 
 - verify the EtherlinkPythMonitor.sol contract 
 - set up the monitoring RPC

 ## Build EtherlinkPythMonitor.sol
To only build the **EtherlinkPythMonitor.sol** execute the command below:: 

>npx hardhat compile 

 ## Deploy EtherlinkPythMonitor.sol
 The following need to be configured in the **EtherlinkPythMonitorModule.js** prior to deployment:
```
   `const _admin = m.getParameter("admin", "${your admin address}");`

   `const _pyth = m.getParameter("pyth", "${the address of the Pyth deployment}" );`

   `const _priceId = m.getParameter("priceId", "${id of the Pyth Asset}");`

   `const _symbol = m.getParameter("symbol", "${symbol of the pyth asset}");`

   `const _network = m.getParameter("network", ${0 for Mainnent, 1 for Ghostnet});`
```
  Then run the following command 

  >npx hardhat ignition deploy ./ignition/modules/EtherlinkPythMonitorModule.js --network ${etherlink_mainnet / etherlink_ghostnet}

 ## Verify EtherlinkPythMonitor.sol
To verify the deployed contract you will have to execute the following command: 
> npx hardhat verify --network `${etherlink_mainnet / etherlink_ghostnet}` `${address of your deployment}` `"${your admin address}"` `"${the address of the Pyth deployment}"` `"${id of the Pyth Asset}"` `"${symbol of the pyth asset}"` `"${0 for Mainnent, 1 for Ghostnet}"`

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
curl -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0", "method":"eth_call", "params":[{ "to": "0xE6161f114E6913BF2C6d109dc20eF0276AC05513", "data": "98d5fdca" }, "latest" ], "id":1 }' https://node.mainnet.etherlink.com
```

Below is an example Ghostnet call:
```
curl -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0", "method":"eth_call", "params":[{ "to": "0xdEb51fEe6c0B932b50eB5451aa6AE3db3117964F", "data": "98d5fdca" }, "latest" ], "id":1 }' https://node.ghostnet.etherlink.com
```