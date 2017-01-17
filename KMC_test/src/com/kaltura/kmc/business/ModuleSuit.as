package com.borhan.bmc.business
{
	import com.borhan.bmc.business.module.TestBmc;
	import com.borhan.bmc.business.module.TestBmcModuleLoader;
	import com.borhan.bmc.business.module.TestModuleLoaded;
	import com.borhan.bmc.business.module.TestBmc;
	import com.borhan.bmc.business.module.TestBmcModuleLoader;
	import com.borhan.bmc.business.module.TestModuleLoaded;
	
	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class ModuleSuit
	{
		public var test1:com.borhan.bmc.business.module.TestBmc;
		public var test2:com.borhan.bmc.business.module.TestBmcModuleLoader;
		public var test3:com.borhan.bmc.business.module.TestModuleLoaded;
		
	}
}