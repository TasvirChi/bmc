package com.borhan.bmc.events
{
	import flash.events.Event;
	
	/**
	 * The ErrorEvent class represents errors that BMCModules encounter 
	 * and need to inform the main BMC application. 
	 * @author Atar
	 */	
	public class BmcErrorEvent extends Event {
		
		
		public static const ERROR:String = "bmcError";
		
		
		private var _error:String;
		
		
		public function BmcErrorEvent(type:String, text:String, bubbles:Boolean = true, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			_error = text;
		}

		
		/**
		 * description of the error associated with this event 
		 */		
		public function get error():String {
			return _error;
		}

	}
}