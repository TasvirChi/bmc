package com.borhan.bmc.modules.admin.control.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.vo.BorhanFilter;
	import com.borhan.vo.BorhanFilterPager;
	
	public class ListItemsEvent extends CairngormEvent {
		
		public static const LIST_ROLES:String = "admin_listRoles";
		public static const LIST_USERS:String = "admin_listUsers";
		public static const LIST_PARTNER_PERMISSIONS:String = "admin_listPartnerPermissions";
		
		private var _filter:BorhanFilter;
		private var _pager:BorhanFilterPager;
		
		
		public function ListItemsEvent(type:String, filter:BorhanFilter = null, pager:BorhanFilterPager = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_filter = filter;
			_pager = pager;
		}

		public function get filter():BorhanFilter
		{
			return _filter;
		}

		public function get pager():BorhanFilterPager
		{
			return _pager;
		}


	}
}