package com.borhan.edw.control.commands.flavor
{
	import com.borhan.commands.media.MediaCancelReplace;
	import com.borhan.edw.business.Cloner;
	import com.borhan.edw.business.EntryUtil;
	import com.borhan.edw.control.commands.KedCommand;
	import com.borhan.edw.control.events.MediaEvent;
	import com.borhan.edw.events.KedDataEvent;
	import com.borhan.edw.model.datapacks.ContextDataPack;
	import com.borhan.edw.model.datapacks.EntryDataPack;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmvc.control.BMvCEvent;
	import com.borhan.vo.BorhanBaseEntry;
	import com.borhan.vo.BorhanMediaEntry;
	
	import flash.events.IEventDispatcher;


	public class CancelMediaEntryReplacementCommand extends KedCommand
	{
		override public function execute(event:BMvCEvent):void {
			_model.increaseLoadCounter();
			var cancelReplacement:MediaCancelReplace = new MediaCancelReplace((event as MediaEvent).entry.id);
			cancelReplacement.addEventListener(BorhanEvent.COMPLETE, result);
			cancelReplacement.addEventListener(BorhanEvent.FAILED, fault);
			
			_client.post(cancelReplacement);
		}
		
		override public function result(data:Object):void {
			super.result(data);
			
			if (data.data && (data.data is BorhanMediaEntry)) {
				var entry:BorhanBaseEntry = (_model.getDataPack(EntryDataPack) as EntryDataPack).selectedEntry;
				EntryUtil.updateChangebleFieldsOnly(data.data as BorhanMediaEntry, entry);
				
				var dsp:IEventDispatcher = (_model.getDataPack(ContextDataPack) as ContextDataPack).dispatcher;
				var e:KedDataEvent = new KedDataEvent(KedDataEvent.ENTRY_RELOADED);
				e.data = entry; 
				dsp.dispatchEvent(e);
//				EntryUtil.updateSelectedEntryInList(entry, _model.listableVo.arrayCollection);
			}
			else {
				trace ("error in cancel replacement");
			}
			
			_model.decreaseLoadCounter();
		}
	}
}