package com.borhan.edw.control.events
{
	import com.borhan.bmvc.control.BMvCEvent;
	
	public class CuePointEvent extends BMvCEvent {
		
		/**
		 * reset cuepoints count on model.
		 */		
		public static const RESET_CUEPOINTS_COUNT:String = "reset_cuepoints_count";
		
		/**
		 * count the cuepoints for a given entry.
		 * event.data should be entryid. 
		 */		
		public static const COUNT_CUEPOINTS:String = "count_cuepoints";
		
		/**
		 * download cuepoints to file.
		 * event.data should be entryid. 
		 * */
		public static const DOWNLOAD_CUEPOINTS:String = "download_cuepoints";
		
		/**
		 * upload cuepoints from file.
		 * event.data should be entryid. 
		 * */ 
		public static const UPLOAD_CUEPOINTS:String = "upload_cuepoints";
		
		
		public function CuePointEvent( type : String, bubbles : Boolean = false, cancelable : Boolean = false )
		{
			super( type, bubbles, cancelable );
		}
	}
}