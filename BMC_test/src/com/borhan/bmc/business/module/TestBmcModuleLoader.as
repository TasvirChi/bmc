package com.borhan.bmc.business.module {
	import com.borhan.bmc.business.BmcModuleLoader;
	import com.borhan.bmc.events.BmcModuleEvent;
	import com.borhan.bmc.modules.BmcModule;
	
	import flash.system.ApplicationDomain;
	
	import mx.containers.HBox;
	import mx.controls.ComboBox;
	import mx.events.ModuleEvent;
	import mx.modules.ModuleLoader;
	
	import org.flexunit.Assert;
	import org.flexunit.async.Async;

	public class TestBmcModuleLoader {
		private var _bmcModuleLoader:BmcModuleLoader;


		[Before]
		public function setUp():void {
			_bmcModuleLoader = new BmcModuleLoader();
		}


		[After]
		public function tearDown():void {
			_bmcModuleLoader = null;
		}


		[Test(async, description="if module loaded, say so")]
		public function testOnModuleReady():void {
			BmcModule;HBox;ComboBox;
			var asyncHandler:Function = Async.asyncHandler(this, handleSuccess, 5000, null, handleTimeout);
			_bmcModuleLoader.addEventListener(BmcModuleEvent.MODULE_LOADED, asyncHandler, false, 0, true);
			var ml:ModuleLoader = _bmcModuleLoader.loadBmcModule("bin-debug/modules/Dashboard.swf", "dashboard");
			ml.loadModule();
		}


		[Test(async, description="if error loading module, catch the error")]
		public function testOnModuleError():void {
			BmcModule; 
			var asyncHandler:Function = Async.asyncHandler(this, handleSuccess, 10000, null, handleTimeout);
			_bmcModuleLoader.addEventListener(BmcModuleEvent.MODULE_LOAD_ERROR, asyncHandler, false, 0, true);
			var ml:ModuleLoader = _bmcModuleLoader.loadBmcModule("bin-debug/modules/Dashboard1.swf", "dashboard");
			ml.loadModule();
		}


		protected function handleSuccess(event:BmcModuleEvent, passThroughData:Object = null):void {
			trace(event.type, event.errorText);
		}


		



		protected function handleTimeout(passThroughData:Object):void {
			Assert.fail("Timeout reached before event");
		}
	}
}