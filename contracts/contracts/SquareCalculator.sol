// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {CallbackConsumer} from "infernet/consumer/Callback.sol";

/// @title SquareCalculator - Simple example using the Ritual Infernet SDK
/// @notice Sends a number to Infernet for off-chain computation, then receives the squared result.
contract SquareCalculator is CallbackConsumer {
    uint256 public lastResult;
    address public owner;

    event ComputationRequested(uint256 input);
    event ComputationReceived(uint256 result);

    constructor(address _coordinator) CallbackConsumer(_coordinator) {
        owner = msg.sender;
    }

    /// @notice Requests Infernet to compute the square of a number
    /// @param input The number to be squared
    function requestSquare(uint256 input) external {
        emit ComputationRequested(input);
        bytes memory payload = abi.encode(input);

        // In the official SDK, the correct function is _requestCompute (not _sendCompute)
        _requestCompute(payload);
    }

    /// @notice Automatically called when Infernet returns the computed result
    /// @param output Encoded output returned from Infernet
    function _receiveCompute(bytes memory output) internal override {
        uint256 value = abi.decode(output, (uint256));
        lastResult = value;
        emit ComputationReceived(value);
    }

    /// @notice Returns the last computed square result
    /// @return The last result value stored
    function getLastResult() external view returns (uint256) {
        return lastResult;
    }
}
