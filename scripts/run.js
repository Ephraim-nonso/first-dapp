const main = async () => {
  // const [owner, randomPerson] = await hre.ethers.getSigners(); //Hardhat helps in getting addresses before a contract is carried. The owner is us, randomPerson.
  const waveContractFactory = await hre.ethers.getContractFactory("WavePortal");
  const waveContract = await waveContractFactory.deploy({
    value: hre.ethers.utils.parseEther("0.1"),
  });
  await waveContract.deployed();
  console.log("contract addy:", waveContract.address);

  // let waveCount;
  // waveCount = await waveContract.getTotalWaves();
  // console.log(waveCount.toNumber());

  // console.log("Contract deployed to:", waveContract.address);
  // console.log("Contract deployed by:", owner.address); //The log here shows the users' address derived with the assistance of hardhat.

  // Get the contract account balance
  let contractBalance = await hre.ethers.provider.getBalance(
    waveContract.address
  );
  console.log(
    "Contract balance:",
    hre.ethers.utils.formatEther(contractBalance)
  );

  // A trial of two waves
  const waveTxn = await waveContract.wave("This is wave #1");
  await waveTxn.wait();

  const waveTxn2 = await waveContract.wave("This is wave #2");
  await waveTxn2.wait();

  // This is to send some waves.
  // let waveTxn = await waveContract.wave("A message has been sent by the user!");
  // await waveTxn.wait(); //This is to ait for the transaction to be mined.

  // Get the contract account balance to see the changes.
  contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
  console.log(
    "Contract balance:",
    hre.ethers.utils.formatEther(contractBalance)
  );

  // const [_, randomPerson] = await hre.ethers.getSigners();
  // waveTxn = await waveContract.connect(randomPerson).wave("Another message!");
  // await waveTxn.wait(); //Wait for the transaction to be mined.

  let allWaves = await waveContract.getAllWaves();
  console.log(allWaves);

  // let getNumberOfWaves;
  // getNumberOfWaves = await waveContract.getTotalWaves();

  // let waveFromUsers = await waveContract.wave();
  // await waveFromUsers.wait();

  // waveFromUsers = await waveContract.connect(randomPerson).wave();
  // await waveTxn.wait();

  // getNumberOfWaves = await waveContract.getTotalWaves();
};

// const getAllWaves = () => {};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();
