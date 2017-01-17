package com.borhan.edw.control.events
{
	import com.borhan.bmvc.control.BMvCEvent;

	public class LiveEvent extends BMvCEvent
	{
		/**
		 * regenerate live stream security token
		 */
		public static const REGENERATE_LIVE_TOKEN : String = "content_regenerateLiveToken";
		
		
		public function LiveEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}	
	}
}