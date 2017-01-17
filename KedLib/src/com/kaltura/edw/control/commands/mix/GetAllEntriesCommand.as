package com.borhan.edw.control.commands.mix {
	import com.borhan.commands.mixing.MixingGetReadyMediaEntries;
	import com.borhan.edw.control.events.KedEntryEvent;
	import com.borhan.edw.model.datapacks.ContentDataPack;
	import com.borhan.edw.model.datapacks.EntryDataPack;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmvc.control.BMvCEvent;
	import com.borhan.vo.BorhanBaseEntry;
	
	import mx.collections.ArrayCollection;
	import com.borhan.edw.control.commands.KedCommand;

	public class GetAllEntriesCommand extends KedCommand {
		override public function execute(event:BMvCEvent):void {
			_model.increaseLoadCounter();
			var cdp:ContentDataPack = _model.getDataPack(ContentDataPack) as ContentDataPack;
			cdp.contentParts = null;
			
			var e:KedEntryEvent = event as KedEntryEvent;
			var getMediaReadyMix:MixingGetReadyMediaEntries = new MixingGetReadyMediaEntries(e.entryVo.id);

			getMediaReadyMix.addEventListener(BorhanEvent.COMPLETE, result);
			getMediaReadyMix.addEventListener(BorhanEvent.FAILED, fault);

			_client.post(getMediaReadyMix);
		}


		override public function result(data:Object):void {
			super.result(data);
			_model.decreaseLoadCounter();
			if (data.data && data.data is Array) {
				var cdp:ContentDataPack = _model.getDataPack(ContentDataPack) as ContentDataPack;
				cdp.contentParts = data.data;
			}
			else
				trace("Error getting the list of roughcut entries");
		}
	}
}