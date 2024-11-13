// SPDX-License-Identifier: BSD-3-Clause-Clear

pragma solidity ^0.8.24;

// Importing the TFHE library from fhevm
import "fhevm/lib/TFHE.sol";

// Defining the Counter contract
contract Counter {
  // Declaring a state variable 'counter' of type euint32
  euint32 counter;

  // Function to add a value to the counter
  // Takes an encrypted input 'valueInput' and a proof 'inputProof' as parameters
  function add(einput valueInput, bytes calldata inputProof) public {
    // Convert the encrypted input to an euint32 value using the provided proof
    euint32 value = TFHE.asEuint32(valueInput, inputProof);

    // Add the value to the counter
    counter = TFHE.add(counter, value);

    // Allow the contract to access the updated counter value
    TFHE.allow(counter, address(this));
  }
}
