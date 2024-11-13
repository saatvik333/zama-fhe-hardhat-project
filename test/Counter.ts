const { ethers } = require("hardhat");
const { expect } = require("chai");

describe("Counter", function () {
  it("Should add the value to the counter", async function () {
    const Counter = await ethers.getContractFactory("Counter");
    const counter = await Counter.deploy();
    await counter.deployed();
    const value = 1;
    // Encrypt the value
    const { encryptedValue, inputProof } = await counter.encrypt(value);
    const valueInput = ethers.BigNumber.from(encryptedValue);
    await counter.add(valueInput, inputProof);
    const counterValue = await counter.counter();
    // Decrypt the counter value
    const decryptedValue = await counter.decrypt(counterValue);
    expect(decryptedValue).to.equal(value);
  });
});
