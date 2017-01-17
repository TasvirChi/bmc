package com.borhan.bmc.modules.content.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.vo.BorhanFilterPager;
	
	public class SetSyndicationPagerEvent extends CairngormEvent {
		
		public static const SET_PAGER:String = "content_setPager";
		
		private var _pager:BorhanFilterPager;
		
		public function SetSyndicationPagerEvent(type:String, pager:BorhanFilterPager = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_pager = pager;
			super(type, bubbles, cancelable);
		}

		public function get pager():BorhanFilterPager
		{
			return _pager;
		}

	}
}