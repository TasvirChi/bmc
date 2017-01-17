package com.borhan.edw.control.commands.clips
{
	import com.borhan.commands.baseEntry.BaseEntryList;
	import com.borhan.edw.control.commands.KedCommand;
	import com.borhan.edw.model.datapacks.ClipsDataPack;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmvc.control.BMvCEvent;
	import com.borhan.vo.BorhanBaseEntryFilter;
	import com.borhan.vo.BorhanBaseEntryListResponse;
	
	public class GetEntryClipsCommand extends KedCommand {
		
		
		
		override public function execute(event:BMvCEvent):void {
			_model.increaseLoadCounter();
			var f:BorhanBaseEntryFilter = new BorhanBaseEntryFilter();
			f.rootEntryIdEqual = event.data.id;
			f.orderBy = event.data.orderBy;
			
			var list:BaseEntryList = new BaseEntryList(f, event.data.pager);
			list.addEventListener(BorhanEvent.COMPLETE, result);
			list.addEventListener(BorhanEvent.FAILED, fault);
			_client.post(list);
		}
		
		override public function result(data:Object):void {
			super.result(data);
			var res:Array = (data.data as BorhanBaseEntryListResponse).objects;
			if (res) {
				(_model.getDataPack(ClipsDataPack) as ClipsDataPack).clips = res;
			}
			else {
				// if the server returned nothing, use an empty array for the tab to remove itself.
				(_model.getDataPack(ClipsDataPack) as ClipsDataPack).clips = new Array();
			}
			_model.decreaseLoadCounter();
		}
	}
}