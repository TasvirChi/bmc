package com.borhan.edw.control.events
{
	import com.borhan.bmvc.control.BMvCEvent;
	
	public class ModelEvent extends BMvCEvent {
		
		/**
		 * create a new entryDetailsModel, copy general attributes
		 * and push it to the entryDetailsModels array 
		 */
		public static const DUPLICATE_ENTRY_DETAILS_MODEL:String = "duplicate_entry_details_model"; 
		
		
		public function ModelEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}