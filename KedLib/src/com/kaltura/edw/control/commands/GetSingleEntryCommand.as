package com.borhan.edw.control.commands {
	import com.borhan.commands.baseEntry.BaseEntryGet;
	import com.borhan.edw.business.EntryUtil;
	import com.borhan.edw.control.events.KedEntryEvent;
	import com.borhan.edw.events.KedDataEvent;
	import com.borhan.edw.model.datapacks.ContextDataPack;
	import com.borhan.edw.model.datapacks.EntryDataPack;
	import com.borhan.edw.model.types.APIErrorCode;
	import com.borhan.errors.BorhanError;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmvc.control.BMvCEvent;
	import com.borhan.vo.BorhanBaseEntry;
	import com.borhan.vo.BorhanClipAttributes;
	
	import flash.events.IEventDispatcher;
	
	import mx.events.PropertyChangeEvent;

	public class GetSingleEntryCommand extends KedCommand {

		private var _eventType:String;
		
		override public function execute(event:BMvCEvent):void {
			_model.increaseLoadCounter();
			var e:KedEntryEvent = event as KedEntryEvent;
			_eventType = e.type;
			if (_eventType == KedEntryEvent.UPDATE_SELECTED_ENTRY_REPLACEMENT_STATUS) {
				(_model.getDataPack(EntryDataPack) as EntryDataPack).selectedEntryReloaded = false;
			}
			
			var getEntry:BaseEntryGet = new BaseEntryGet(e.entryId);

			getEntry.addEventListener(BorhanEvent.COMPLETE, result);
			getEntry.addEventListener(BorhanEvent.FAILED, fault);

			_client.post(getEntry);
		}


		override public function result(data:Object):void {
			var clipAttributes:BorhanClipAttributes; // compile this type into BMC
			super.result(data);
			
			if (data.data && data.data is BorhanBaseEntry) {
				var resultEntry:BorhanBaseEntry = data.data as BorhanBaseEntry;
				var edp:EntryDataPack = _model.getDataPack(EntryDataPack) as EntryDataPack;
				var dsp:IEventDispatcher = (_model.getDataPack(ContextDataPack) as ContextDataPack).dispatcher;
				if (_eventType == KedEntryEvent.GET_REPLACEMENT_ENTRY) {
					edp.selectedReplacementEntry = resultEntry;
				}
				else if (_eventType == KedEntryEvent.UPDATE_SELECTED_ENTRY_REPLACEMENT_STATUS) {
					var selectedEntry:BorhanBaseEntry = edp.selectedEntry;
					EntryUtil.updateChangebleFieldsOnly(resultEntry, selectedEntry);
					var e:KedDataEvent = new KedDataEvent(KedDataEvent.ENTRY_RELOADED);
					e.data = selectedEntry; 
					dsp.dispatchEvent(e);
					
					edp.selectedEntryReloaded = true;
				}
				else {
					// let the env.app know the entry is loaded so it can open another drilldown window
					var ee:KedDataEvent = new KedDataEvent(KedDataEvent.OPEN_ENTRY);
					ee.data = resultEntry; 
					dsp.dispatchEvent(ee);
				}
			}
			else {
				trace(_eventType, ": Error getting entry");
			}
			_model.decreaseLoadCounter();
		}

		
		override public function fault(info:Object):void {
			//if entry replacement doesn't exist it means that the replacement is ready
			if (_eventType == KedEntryEvent.GET_REPLACEMENT_ENTRY || _eventType == KedEntryEvent.UPDATE_SELECTED_ENTRY_REPLACEMENT_STATUS) {
				var er:BorhanError = (info as BorhanEvent).error;
				if (er.errorCode == APIErrorCode.ENTRY_ID_NOT_FOUND) {
					trace("GetSingleEntryCommand 703");
					_model.decreaseLoadCounter();
					return;
				}
			}

			super.fault(info);
		}
	}
}