// scripts/deploy.js
// SPDX-License-Identifier: MIT

const hre = require("hardhat");
require("dotenv").config();

/**
 * @notice Deployment script for the SquareCalculator contract.
 * Uses the Infernet coordinator address from environment variables.
 */
async function main() {
  // Load coordinator address from .env or fallback to zero address
  const coordinator =
    process.env.COORDINATOR_ADDRESS ||
    "0x0000000000000000000000000000000000000000";

  // Compile and prepare the contract factory
  const SquareCalculator = await hre.ethers.getContractFactory("SquareCalculator");

  console.log("🚀 Deploying SquareCalculator...");
  const square = await SquareCalculator.deploy(coordinator);

  // Wait until deployed
  await square.deployed();

  console.log("✅ SquareCalculator deployed to:", square.address);
}

// Run the main function and handle errors
main().catch((err) => {
  console.error("❌ Deployment failed:", err);
  process.exitCode = 1;
});
