package com.borhan.bmc.modules.content.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.vo.BorhanUiConfFilter;
	
	public class UIConfEvent extends CairngormEvent
	{
		public static const LIST_UI_CONFS : String = "content_listUIConfs";
		
		public var uiConfFilter:BorhanUiConfFilter;
		
		public function UIConfEvent(type:String, filterVo:BorhanUiConfFilter, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.uiConfFilter = filterVo;
		}

	}
}