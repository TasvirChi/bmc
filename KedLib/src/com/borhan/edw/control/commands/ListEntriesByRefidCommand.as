package com.borhan.edw.control.commands
{
	import com.borhan.commands.baseEntry.BaseEntryList;
	import com.borhan.edw.control.events.KedEntryEvent;
	import com.borhan.edw.model.datapacks.EntryDataPack;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmvc.control.BMvCEvent;
	import com.borhan.vo.BorhanBaseEntryFilter;
	import com.borhan.vo.BorhanBaseEntryListResponse;

	public class ListEntriesByRefidCommand extends KedCommand {
		
		/**
		 * @inheritDoc
		 */		
		override public function execute(event:BMvCEvent):void
		{
			_model.increaseLoadCounter();
			var f:BorhanBaseEntryFilter = new BorhanBaseEntryFilter();
			f.referenceIdEqual = (event as KedEntryEvent).entryVo.referenceId;
			var getMediaList:BaseEntryList = new BaseEntryList(f);
			getMediaList.addEventListener(BorhanEvent.COMPLETE, result);
			getMediaList.addEventListener(BorhanEvent.FAILED, fault);
			_client.post(getMediaList);	  
		}
		
		/**
		 * @inheritDoc
		 */
		override public function result(data:Object):void
		{
			super.result(data);
			var recievedData:BorhanBaseEntryListResponse = BorhanBaseEntryListResponse(data.data);
			var edp:EntryDataPack = _model.getDataPack(EntryDataPack) as EntryDataPack;
			edp.entriesWSameRefidAsSelected = recievedData.objects;
			_model.decreaseLoadCounter();
		}
	}
}