// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("EtherlinkPythMonitorModule_prod", (m) => {

  const _admin = m.getParameter("admin", "0x146F2D294aAE7996Bd95bae526472f751D32258c");
  const _pyth = m.getParameter("pyth", "0x2880aB155794e7179c9eE2e38200202908C17B43" ); // mainnet
  const _priceId = m.getParameter("priceId", "0x0affd4b8ad136a21d79bc82450a325ee12ff55a235abc242666e423b8bcffd03");
  const _symbol = m.getParameter("symbol", "XTZ");
  const _network = m.getParameter("network", 0);

  const pyth = m.contract("EtherlinkPythMonitor", [_admin, _pyth, _priceId, _symbol, _network], {});

  return { pyth };
});