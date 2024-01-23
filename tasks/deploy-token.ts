import { task, types } from "hardhat/config";
import { TASK_COMPILE } from "hardhat/builtin-tasks/task-names";
import chalk from "chalk";

task("deploy-token", "Deploy Token contracts")
  .addParam("owner", "Owner address", "0x", types.string)
  .addParam("factoryaddr", "Factory address", "0x", types.string)
  .setAction(async ({ owner, factoryaddr }, { ethers, run, network }) => {
    await run(TASK_COMPILE);
    let endpoint = "";
    if (network.name == "goerli") {
      endpoint = "0x464570adA09869d8741132183721B4f0769a0287";
    }
    const OmniFactory = await ethers.getContractFactory("OmniFactory");

    await OmniFactory.attach(factoryaddr).deployToken(
      "OmniToken",
      "OMNI",
      8,
      endpoint,
      owner
    );
  });
