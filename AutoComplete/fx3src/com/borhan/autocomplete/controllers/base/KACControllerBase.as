package com.borhan.autocomplete.controllers.base
{
	import com.hillelcoren.components.AutoComplete;
	import com.borhan.BorhanClient;
	import com.borhan.core.KClassFactory;
	import com.borhan.events.BorhanEvent;
	import com.borhan.net.BorhanCall;
	
	import flash.events.Event;
	import flash.utils.setTimeout;
	
	import mx.collections.ArrayCollection;

	public class KACControllerBase
	{
		public var minPrefixLength:uint = 3;
		
		protected var _elementSelection:ArrayCollection;
		protected var _autoComp:AutoComplete;
		protected var _client:BorhanClient;
		
		private var _pendingCall:BorhanCall;
		
		public function KACControllerBase(autoComp:AutoComplete, client:BorhanClient)
		{
			_elementSelection = new ArrayCollection();
			_autoComp = autoComp;
			_autoComp.autoSelectEnabled = false;
			_autoComp.backspaceAction = AutoComplete.BACKSPACE_REMOVE;
			_autoComp.showRemoveIcon = true;
			_autoComp.setStyle("selectedItemStyleName", "selectionBox");
			_autoComp.setStyle("autoCompleteDropDownStyleName", "autoCompleteDropDown");
			_client = client;
			
			_autoComp.dataProvider = _elementSelection;
			_autoComp.addEventListener(AutoComplete.SEARCH_CHANGE, onSearchChange);
		}
		
		private function onSearchChange(event:Event):void{
			if (_autoComp.searchText != null){
				if (_pendingCall != null){
					_pendingCall.removeEventListener(BorhanEvent.COMPLETE, result);
					_pendingCall.removeEventListener(BorhanEvent.FAILED, fault);
				}
				
				_autoComp.clearSuggestions();
				
				if (_autoComp.searchText.length > (minPrefixLength - 1)){
					_elementSelection.removeAll();
					
					var call:BorhanCall = createCallHook();
					
					call.addEventListener(BorhanEvent.COMPLETE, result);
					call.addEventListener(BorhanEvent.FAILED, fault);
					call.queued = false;
					_autoComp.notifySearching();
					_pendingCall = call;
					_client.post(call);
				} 
			}
		}
		
		private function result(data:Object):void{
			_pendingCall = null;
			var elements:Array = fetchElements(data);
			if (elements != null && elements.length > 0){
				for each (var element:Object in elements){
					_elementSelection.addItem(element);
				}
			}
			_autoComp.search();
		}
		
		protected function fault(info:BorhanEvent):void{
			throw new Error(info.error.errorMsg);
		}
		
		protected function fetchElements(data:Object):Array{
			return null;
		}
		
		protected function createCallHook():BorhanCall{
			return null;
		}
	}
}