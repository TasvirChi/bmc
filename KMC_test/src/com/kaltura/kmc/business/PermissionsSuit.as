package com.borhan.bmc.business
{
	import com.borhan.bmc.business.permissions.ExtendPermissionManager;
	import com.borhan.bmc.business.permissions.TestPermissionManager;
	import com.borhan.bmc.business.permissions.TestPermissionParser;

	
	[Suite(order="1")]
	[RunWith("org.flexunit.runners.Suite")]
	public class PermissionsSuit
	{
		public var test1:com.borhan.bmc.business.permissions.TestPermissionManager;
		public var test2:com.borhan.bmc.business.permissions.TestPermissionParser;
		public var test4:com.borhan.bmc.business.permissions.ExtendPermissionManager;
		
	}
}