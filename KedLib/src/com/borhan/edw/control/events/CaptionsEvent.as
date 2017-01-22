package com.borhan.edw.control.events
{
	import com.borhan.edw.vo.EntryCaptionVO;
	import com.borhan.bmvc.control.BMvCEvent;
	
	public class CaptionsEvent extends BMvCEvent
	{
		public static const LIST_CAPTIONS:String = "listCaptions";
		public static const SAVE_ALL:String = "saveAllCaptions";
		
		/**
		 * get the captionAsset, if its status=ready ask for the updated donwload URL
		 * */
		public static const UPDATE_CAPTION:String = "updateCaption";
		
		
		public var captionsToSave:Array;
		public var captionsToRemove:Array;
		public var defaultCaption:EntryCaptionVO;
		
		public var captionVo:EntryCaptionVO;
		
		public function CaptionsEvent(type:String,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}