// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;
import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mock/MockV3Aggrigator.sol";

contract HelperConfig is Script {
    struct NetworkConfig {
        address priceFeed;
    }
    NetworkConfig public activeNetworkConfig;
    MockV3Aggregator public priceFeedMockV3Aggregator;
    uint8 public constant DECIMAL = 8;
    int256 public constant INITIAL = 2000e8;

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else if (block.chainid == 1) {
            activeNetworkConfig = getMainEthConfig();
        } else {
            activeNetworkConfig = getAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public returns (NetworkConfig memory) {
        activeNetworkConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return activeNetworkConfig;
    }

    function getAnvilEthConfig() public returns (NetworkConfig memory) {
        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }

        vm.startBroadcast();
        priceFeedMockV3Aggregator = new MockV3Aggregator(DECIMAL, INITIAL);
        vm.stopBroadcast();

        activeNetworkConfig = NetworkConfig({
            priceFeed: address(priceFeedMockV3Aggregator)
        });
        return activeNetworkConfig;
    }

    function getMainEthConfig() public returns (NetworkConfig memory) {
        activeNetworkConfig = NetworkConfig({
            priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        });
        return activeNetworkConfig;
    }
}
