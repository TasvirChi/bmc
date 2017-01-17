package com.borhan.bmc.business.module
{
	import org.flexunit.Assert;
	

	public class TestBmc extends BMC
	{	
		
		[Test]
		public function testRemoveExistingModule():void {
			var bmcuiconf:XML = <root>
					<!-- path to skin file -->
					<skinPath>http://localhost/bmc/BMC/bin-debug/workspaces/bmc/BMC/assets/bmc_skin.swf</skinPath>
					<!-- path to help page -->
					<helpPage>index.php/bmc/bmc2help</helpPage>
					<modules>
				        <module id="content" uiconf="1002420" path="Content.swf" />
				 		<module id="studio" uiconf="1002416" path="Studio.swf"/>
						<module id="dashboard" uiconf="1002412" path="Dashboard.swf"/>
						<module id="analytics" uiconf="1002413" path="Analytics.swf"/>
				        <module id="account" uiconf="1002414" path="Account.swf"/>
					</modules>					
				</root>;
			removeModule(bmcuiconf, "content");
			if (bmcuiconf.modules.module.(@id == "content").length() > 0) {
				Assert.fail("module not removed");
			}
		}
		
		[Test]
		public function testRemoveNonExistingModule():void {
			var bmcuiconf:XML = <root>
					<!-- path to skin file -->
					<skinPath>http://localhost/bmc/BMC/bin-debug/workspaces/bmc/BMC/assets/bmc_skin.swf</skinPath>
					<!-- path to help page -->
					<helpPage>index.php/bmc/bmc2help</helpPage>
					<modules>
				        <module id="content" uiconf="1002420" path="Content.swf" />
				 		<module id="studio" uiconf="1002416" path="Studio.swf"/>
						<module id="dashboard" uiconf="1002412" path="Dashboard.swf"/>
						<module id="analytics" uiconf="1002413" path="Analytics.swf"/>
				        <module id="account" uiconf="1002414" path="Account.swf"/>
					</modules>					
				</root>;
			try {
				removeModule(bmcuiconf, "atar");
			} catch (e:Error) {
				Assert.fail("method crashed");
			}
			
		}
		
		
		
		
//		[Before]
//		public function setUp():void
//		{
//		}
//		
//		[After]
//		public function tearDown():void
//		{
//		}
//		
//		[BeforeClass]
//		public static function setUpBeforeClass():void
//		{
//		}
//		
//		[AfterClass]
//		public static function tearDownAfterClass():void
//		{
//		}
		
		
	}
}