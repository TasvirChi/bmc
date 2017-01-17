package com.borhan.edw.control.commands.flavor
{
	import com.borhan.commands.media.MediaUpdateContent;
	import com.borhan.edw.control.events.KedEntryEvent;
	import com.borhan.edw.control.events.MediaEvent;
	import com.borhan.edw.model.datapacks.EntryDataPack;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmvc.control.BMvCEvent;
	import com.borhan.vo.BorhanBaseEntry;
	import com.borhan.edw.control.commands.KedCommand;

	public class UpdateMediaCommand extends KedCommand {
		
		override public function execute(event:BMvCEvent):void {
			_model.increaseLoadCounter();
			_dispatcher = event.dispatcher;
			var e:MediaEvent = event as MediaEvent;
			// e.data here is {conversionProfileId, resource}
			var mu:MediaUpdateContent = new MediaUpdateContent(e.entry.id, e.data.resource, e.data.conversionProfileId);
			mu.addEventListener(BorhanEvent.COMPLETE, result);
			mu.addEventListener(BorhanEvent.FAILED, fault);
			_client.post(mu);
		}
		
		override public function result(data:Object):void {
			super.result(data);
			_model.decreaseLoadCounter();
			// to update the flavors tab, we re-load flavors data
			var selectedEntry:BorhanBaseEntry = (_model.getDataPack(EntryDataPack) as EntryDataPack).selectedEntry;
			if(selectedEntry != null) {
				var cgEvent : KedEntryEvent = new KedEntryEvent(KedEntryEvent.GET_FLAVOR_ASSETS, selectedEntry);
				_dispatcher.dispatch(cgEvent);
				cgEvent = new KedEntryEvent(KedEntryEvent.UPDATE_SELECTED_ENTRY_REPLACEMENT_STATUS, null,selectedEntry.id);
				_dispatcher.dispatch(cgEvent);
			}
		}
	}
}