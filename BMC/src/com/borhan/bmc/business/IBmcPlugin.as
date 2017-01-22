package com.borhan.bmc.business
{
	import com.borhan.BorhanClient;

	public interface IBmcPlugin {
		
		function set client(value:BorhanClient):void;
		function get client():BorhanClient;
		
		function set flashvars(value:Object):void;
		function get flashvars():Object;
		
	}
}