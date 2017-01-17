package com.borhan.bmc.business.module
{
	import com.borhan.bmc.business.BmcModuleLoader;
	import com.borhan.bmc.events.BmcModuleEvent;
	import com.borhan.bmc.modules.BmcModule;BmcModule;
	
	
	import mx.modules.ModuleLoader;
	
	import org.flexunit.Assert;
	import org.flexunit.async.Async;
	import org.fluint.uiImpersonation.UIImpersonator;
	import mx.controls.ComboBox;ComboBox;

	public class TestModuleLoaded
	{		
		
		private var _bmcModuleLoader:BmcModuleLoader;
		private var _ml:ModuleLoader;
		
		[Before( async, ui )]
		public function setUp():void
		{
			_bmcModuleLoader = new BmcModuleLoader();
			_ml = _bmcModuleLoader.loadBmcModule("bin-debug/modules/Dashboard.swf", "dashboard");
			Async.proceedOnEvent( this, _bmcModuleLoader, BmcModuleEvent.MODULE_LOADED, 2000 );
			UIImpersonator.addChild( _ml );
		}
		
		[After(ui)]
		public function tearDown():void
		{
			UIImpersonator.removeChild( _ml );
			_ml = null;
			_bmcModuleLoader = null;
			
		}
		
		[Test(async, description="return the id a module was loaded with")]
		public function testGetModuleId():void
		{
			Assert.assertEquals(_bmcModuleLoader.getModuleLoadId(_ml), "dashboard");
		}
		
		
	}
}