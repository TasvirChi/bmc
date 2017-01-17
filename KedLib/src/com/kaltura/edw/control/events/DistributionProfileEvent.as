package com.borhan.edw.control.events
{
	import com.borhan.bmvc.control.BMvCEvent;

	public class DistributionProfileEvent extends BMvCEvent
	{
		public static const LIST:String = "content_listDistributionProfile";
		public static const UPDATE:String = "content_updateDistributionProfiles";
		
		public var distributionProfiles:Array;
		
		public function DistributionProfileEvent( type:String,
												  distributionProfiles:Array = null,
												  bubbles:Boolean=false, 
												  cancelable:Boolean=false)
		{
			this.distributionProfiles = distributionProfiles;
			super(type, bubbles, cancelable);
		}
	}
}