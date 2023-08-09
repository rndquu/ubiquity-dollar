# SafeAddArray
[Git Source](https://github.com/rndquu/ubiquity-dollar/blob/a6cd404057114388fb832210ff4efe4a6cd31e8e/src/dollar/utils/SafeAddArray.sol)

Wrappers over Solidity's array push operations with added check


## Functions
### add

Adds `value` to `array`


```solidity
function add(uint256[] storage array, uint256 value) internal;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`array`|`uint256[]`|Array to modify|
|`value`|`uint256`|Value to add|


### add

Adds `values` to `array`


```solidity
function add(uint256[] storage array, uint256[] memory values) internal;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`array`|`uint256[]`|Array to modify|
|`values`|`uint256[]`|Array of values to add|


