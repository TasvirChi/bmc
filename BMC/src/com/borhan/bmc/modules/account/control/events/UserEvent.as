package com.borhan.bmc.modules.account.control.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.vo.BorhanUserFilter;
	
	public class UserEvent extends CairngormEvent {
		
		public static const LIST_USERS:String = "account_listUsers";
		
		public function UserEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}

	}
}