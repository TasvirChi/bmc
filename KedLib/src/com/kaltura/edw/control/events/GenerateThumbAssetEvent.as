package com.borhan.edw.control.events
{
	import com.borhan.bmvc.control.BMvCEvent;
	import com.borhan.vo.BorhanThumbParams;

	public class GenerateThumbAssetEvent extends BMvCEvent
	{
		public static const GENERATE:String = "content_generateThumbAsset";
		public var thumbParams:BorhanThumbParams;
		public var thumbSourceId:String;
		
		public function GenerateThumbAssetEvent(type:String, thumbParams:BorhanThumbParams, thumbSourceId:String , bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.thumbParams = thumbParams;
			this.thumbSourceId = thumbSourceId;
			super(type, bubbles, cancelable);
		}
	}
}