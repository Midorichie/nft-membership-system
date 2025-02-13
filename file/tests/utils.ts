// utils.ts
import { ClarityType, cvToString, uintCV } from "@stacks/transactions";
import { callReadOnlyFn, createAccount, mineBlock } from "./helpers";

export async function deployerAccount() {
  return await createAccount("deployer");
}

export async function mintToken(deployer, contractName) {
  const tokenId = await getNextTokenId(deployer, contractName);
  const tx = await mineBlock({
    sender: deployer,
    contract: contractName,
    functionName: "mint",
    functionArgs: [uintCV(tokenId)],
  });
  return tx;
}

export async function getNextTokenId(deployer, contractName) {
  const response = await callReadOnlyFn({
    contract: contractName,
    functionName: "get-last-token-id",
    sender: deployer,
  });
  return response.result ? parseInt(cvToString(response.result)) + 1 : 1;
}
