package com.borhan.edw.control.events
{
	import com.borhan.bmvc.control.BMvCEvent;
	
	public class ClipEvent extends BMvCEvent {
		
		/**
		 * get a list of clips derived from the given entry.
		 * event.data should be {id:id of the root entry, pager:borhanPager, orderBy: string, list order}
		 */		
		public static const GET_ENTRY_CLIPS:String = "GET_ENTRY_CLIPS";
		
		/**
		 * reset the list on the model of entry clips
		 * */
		public static const RESET_MODEL_ENTRY_CLIPS:String = "RESET_MODEL_ENTRY_CLIPS";
		
		
		public function ClipEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}