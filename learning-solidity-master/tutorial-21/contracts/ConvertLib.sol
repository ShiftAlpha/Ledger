pragma solidity ^0.4.4;

library ConvertLib{
	function convert(uint amount,uint conversionRate) internal returns (uint convertedAmount)
	{
		return amount * conversionRate;
	}
}
