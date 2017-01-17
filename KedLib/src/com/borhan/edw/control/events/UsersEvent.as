package com.borhan.edw.control.events
{
	import com.borhan.bmvc.control.BMvCEvent;
	
	public class UsersEvent extends BMvCEvent {
		
		/**
		 * set the given BorhanUser object to be entry's owner localy (not saved to server)
		 * (data is BorhanUser)
		 */
		public static const SET_ENTRY_OWNER : String = "content_setEntryOwner";
		
		/**
		 * get the BorhanUser object that is this entry's owner
		 * (data is user id)
		 */
		public static const GET_ENTRY_OWNER : String = "content_getEntryOwner";
		
		/**
		 * get the BorhanUser object that is this entry's creator
		 * (data is user id)
		 */
		public static const GET_ENTRY_CREATOR : String = "content_getEntryCreator";
		
		/**
		 * get the BorhanUsers who are this entry's publishers
		 * (data is user ids)
		 */
		public static const GET_ENTRY_PUBLISHERS : String = "content_getEntryPublishers";
		
		/**
		 * get the BorhanUsers who are this entry's editors
		 * (data is user ids)
		 */
		public static const GET_ENTRY_EDITORS : String = "content_getEntryEditors";
		
		/**
		 * clear model data regarding entry owner / creator
		 */
		public static const RESET_ENTRY_USERS : String = "content_resetEntryUsers";
		
		
		public function UsersEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}