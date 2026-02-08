import { ethers } from "hardhat";

async function main() {
  const FishShooter = await ethers.getContractFactory("FishShooter");
  const game = await FishShooter.deploy();

  await game.waitForDeployment();

  console.log("FishShooter deployed at:", await game.getAddress());
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
