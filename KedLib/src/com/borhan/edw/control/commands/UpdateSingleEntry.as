package com.borhan.edw.control.commands {
	import com.borhan.commands.baseEntry.BaseEntryUpdate;
	import com.borhan.edw.control.events.KedEntryEvent;
	import com.borhan.edw.events.KedDataEvent;
	import com.borhan.edw.model.datapacks.ContextDataPack;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmvc.control.BMvCEvent;
	import com.borhan.types.BorhanEntryStatus;
	import com.borhan.vo.BorhanBaseEntry;
	import com.borhan.vo.BorhanLiveStreamEntry;

	public class UpdateSingleEntry extends KedCommand {
		
		private var _event:KedEntryEvent;

		override public function execute(event:BMvCEvent):void {
			_model.increaseLoadCounter();
			
			_event = event as KedEntryEvent;
			var entry:BorhanBaseEntry = _event.entryVo;

			entry.setUpdatedFieldsOnly(true);
			if (entry.status != BorhanEntryStatus.NO_CONTENT && !(entry is BorhanLiveStreamEntry)) {
				entry.conversionProfileId = int.MIN_VALUE;
			}
			// don't send categories - we use categoryEntry service to update them in EntryData panel
			entry.categories = null;
			entry.categoriesIds = null;
			// don't send msDuration, we never have any reason to update it.
			if (entry.msDuration && entry.msDuration != int.MIN_VALUE) {
				entry.msDuration = int.MIN_VALUE;
			}

			var mu:BaseEntryUpdate = new BaseEntryUpdate(entry.id, entry);
			// add listeners and post call
			mu.addEventListener(BorhanEvent.COMPLETE, result);
			mu.addEventListener(BorhanEvent.FAILED, fault);

			_client.post(mu);
		}


		override public function result(data:Object):void {
			super.result(data);
			_model.decreaseLoadCounter();
			
			if (checkErrors(data)) {
				return;
			}
			
			var e:KedDataEvent = new KedDataEvent(KedDataEvent.ENTRY_UPDATED);
			e.data = data.data; // send the updated entry as event data
			(_model.getDataPack(ContextDataPack) as ContextDataPack).dispatcher.dispatchEvent(e);

			// this will handle window closing or entry switching after successful save
			if (_event.onComplete != null) {
				_event.onComplete.call(_event.source);
			}
		}
	}
}