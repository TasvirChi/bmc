package com.borhan.bmc.events
{
	import flash.events.Event;
	
	public class BmcEvent extends Event {
		
		private var _data:Object;
		
		public function BmcEvent(type:String, data:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_data = data;
			super(type, bubbles, cancelable);
		}

		public function get data():Object
		{
			return _data;
		}

	}
}