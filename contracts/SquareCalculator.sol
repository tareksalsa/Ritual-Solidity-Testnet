// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {CallbackConsumer} from "infernet/consumer/Callback.sol";

contract SquareCalculator is CallbackConsumer {
    uint256 public lastResult;
    address public owner;

    event ComputationRequested(uint256 input);
    event ComputationReceived(uint256 result);

    constructor(address _coordinator) CallbackConsumer(_coordinator) {
        owner = msg.sender;
    }

    // Caller requests square of `input`.
    // _sendCompute is a helper from the SDK (check SDK for exact API).
    function requestSquare(uint256 input) external {
        emit ComputationRequested(input);

        // Example: pack the input into bytes and send compute request.
        // NOTE: adjust according to the infernet-sdk API for sending compute.
        bytes memory payload = abi.encode(input);
        _sendCompute(payload);
    }

    // This function is called by the SDK/coordinator when compute result is ready.
    // The SDK expects this internal override to accept the result bytes.
    function _receiveCompute(bytes memory output) internal override {
        // Here we expect the output to be abi.encode(uint256)
        uint256 value = abi.decode(output, (uint256));
        lastResult = value;
        emit ComputationReceived(value);
    }

    // utility to read both values
    function getLastResult() external view returns (uint256) {
        return lastResult;
    }
}
