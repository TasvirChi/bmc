package com.borhan.bmc.business.module
{
	import com.borhan.bmc.modules.BmcModule;
	import com.borhan.bmc.utils.XMLUtils;
	
	import flexunit.framework.Assert;
	
	import org.flexunit.asserts.assertEquals;
	
	public class TestBMCModule extends BmcModule
	{		
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
		
		override public function getModuleName():String {
			return "a";
		}
		
		
		[Test]
		public function testOverrideDataByFlashvars():void
		{
			var xml:String = "<a><b><c>aaa</c></b><d>yyy</d></a>";
			var o:Object = {"a.b.c":"ttt", "a.d":"xx"};
			var expected:XML = <a><b><c>ttt</c></b><d>xx</d></a>;
			var res:String = overrideDataByFlashvars(xml, o);
			assertEquals(expected.toXMLString(), res);
		}
		
		[Test]
		public function testGetElement():void
		{
			var xml:XML = <a>
							<b>
								<c>aaa</c>
								<c>bbb</c>
							</b>
						</a>;
			
			var res:XML = XMLUtils.getElement(xml, ["a", "b", "c"]);
			Assert.assertEquals(<c>aaa</c>, res);
		}
	}
}