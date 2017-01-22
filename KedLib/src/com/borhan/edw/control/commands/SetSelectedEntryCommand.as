package com.borhan.edw.control.commands
{
	import com.borhan.commands.baseEntry.BaseEntryGet;
	import com.borhan.edw.business.EntryUtil;
	import com.borhan.edw.control.events.KedEntryEvent;
	import com.borhan.edw.events.KedDataEvent;
	import com.borhan.edw.model.datapacks.ContextDataPack;
	import com.borhan.edw.model.datapacks.EntryDataPack;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmvc.control.BMvCEvent;
	import com.borhan.vo.BorhanBaseEntry;

	public class SetSelectedEntryCommand extends KedCommand
	{
		private var _edp:EntryDataPack;
		
		override public function execute(event:BMvCEvent):void
		{	
			_edp = _model.getDataPack(EntryDataPack) as EntryDataPack;
			_edp.selectedIndex = (event as KedEntryEvent).entryIndex;
			if ((event as KedEntryEvent).reloadEntry) {
				_model.increaseLoadCounter();
				var getEntry:BaseEntryGet = new BaseEntryGet((event as KedEntryEvent).entryVo.id);
				
				getEntry.addEventListener(BorhanEvent.COMPLETE, result);
				getEntry.addEventListener(BorhanEvent.FAILED, fault);
				
				_client.post(getEntry);
			}

			_edp.selectedEntry = (event as KedEntryEvent).entryVo;	
		}
		
		override public function result(data:Object):void {
			super.result(data);
			
			if (data.data && data.data is BorhanBaseEntry) {
				// update values on the existing entry in the list
				var e:KedDataEvent = new KedDataEvent(KedDataEvent.ENTRY_UPDATED);
				e.data = data.data as BorhanBaseEntry; // send the updated entry as event data
				(_model.getDataPack(ContextDataPack) as ContextDataPack).dispatcher.dispatchEvent(e);
			}
			_model.decreaseLoadCounter();
		}
	}
}