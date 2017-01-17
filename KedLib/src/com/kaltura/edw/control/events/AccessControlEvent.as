package com.borhan.edw.control.events
{
	import com.borhan.bmvc.control.BMvCEvent;
	
	public class AccessControlEvent extends BMvCEvent {
		
		public static const LIST_ACCESS_CONTROLS_PROFILES:String = "listAllAccessControlProfiles";
		
		public static const ADD_NEW_ACCESS_CONTROL_PROFILE:String = "addNewAccessControlProfile";
		
		public static const UPDATE_ACCESS_CONTROL_PROFILE:String = "updateAccessControlProfile";
		
		public function AccessControlEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}