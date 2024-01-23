import { task, types } from "hardhat/config";
import { TASK_COMPILE } from "hardhat/builtin-tasks/task-names";
import chalk from "chalk";

task("deploy-omni", "Deploy Omni contracts").setAction(
  async ({}, { ethers, run, network }) => {
    await run(TASK_COMPILE);

    const factory = await (
      await ethers.getContractFactory("OmniFactory")
    ).deploy();

    if (network.name == "goerli") {
      await run("verify:verify", {
        address: await factory.getAddress(),
        constructorArguments: [],
      });

      console.log(chalk.blue(">>>>> Contracts verified."));
    }

    console.log(
      chalk.blue(
        ">>>>> Success deployed the OmniToken:",
        chalk.green(await factory.getAddress())
      )
    );
  }
);
