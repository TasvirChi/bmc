package com.borhan.bmc.modules.content.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.edw.business.IDataOwner;
	import com.borhan.vo.BorhanMediaEntryFilterForPlaylist;

	public class BMCFilterEvent extends CairngormEvent
	{
		public static const SET_FILTER_TO_MODEL : String = "content_setFilterToModel";
		
		
		private var _filterVo : BorhanMediaEntryFilterForPlaylist;
		
		
		
		public function BMCFilterEvent(type:String, filterVo : BorhanMediaEntryFilterForPlaylist, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_filterVo = filterVo;
		}

		public function get filterVo():BorhanMediaEntryFilterForPlaylist
		{
			return _filterVo;
		}
		
		

	}
}