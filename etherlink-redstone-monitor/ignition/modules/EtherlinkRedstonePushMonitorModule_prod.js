// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

const assets = ["0xF0F22f4b9e49a0d6ade134A9d71D37cc0117951F","0x7e5a7D5d603d53d6681BdDBd1B743796956cdF17","0xe92c00BC72dD12e26E61212c04E8D93aa09624F2"];
const symbols = ["ETH USD", "BTC USD", "XTZ USD"];
const admin = "0x146F2D294aAE7996Bd95bae526472f751D32258c";
const network = 0; // mainnet

module.exports = buildModule("RedstonePushMonitorModule_prod", (m) => {

  const admin_ = m.getParameter("admin", admin);
  const assets_ = m.getParameter("assets", assets);
  const symbols_ = m.getParameter("symbols", symbols);
  const network_ = m.getParameter("network", network);


  const redstonePush = m.contract("EtherlinkRedstonePushMonitor", [admin_, assets_, symbols_, network_], {});

  return { redstonePush };
});
