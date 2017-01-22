package com.borhan.edw.model.util
{
	import com.borhan.vo.BorhanBaseEntry;
	
	import flash.events.Event;
	
	import mx.binding.utils.BindingUtils;
	import mx.events.PropertyChangeEvent;
	
	public class CompositeKBaseEntry extends BorhanBaseEntry
	{
		
		private var _entries:Vector.<BorhanBaseEntry>;
		
		public function CompositeKBaseEntry(entries:Vector.<BorhanBaseEntry>)
		{
			super();
			_entries = entries;
			
			addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onPropertyChanged);
		}
		
		protected function onPropertyChanged(event:PropertyChangeEvent):void
		{
			var propName:String = event.property as String;
			setBoundValue(propName, event.newValue);
		}
		
		private function setBoundValue(prop:String, value:Object):void{
			for each(var entry:BorhanBaseEntry in _entries){
				entry[prop] = value;
			}
		}
	}
}