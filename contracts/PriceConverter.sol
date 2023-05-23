// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// imports the contract from npm, which is created from the chainlink github
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    function getPrice(
        AggregatorV3Interface priceFeed
    ) internal view returns (uint256) {
        // ABI
        // Address 0x694AA1769357215DE4FAC081bf1f309aDC325306
        // from https://docs.chain.link/data-feeds/price-feeds/addresses#Sepolia%20Testnet

        (, int256 price, , , ) = priceFeed.latestRoundData();
        // ETH in terms of USD
        // ETH feed contains 8 decimals
        return uint256(price * 1e10); // 1**10 == 10000000000
        // required to match msg.value which has 18 decimals,
        // has to be cast because msg.value is uint256
    }

    function getConversionRate(
        uint256 ethAmount,
        AggregatorV3Interface priceFeed
    ) internal view returns (uint256) {
        uint256 ethPrice = getPrice(priceFeed);
        // 3000_000000000000000000 price in usd with 18 decimals
        // 1_000000000000000000 ETH which means one eth in wei
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }
}
