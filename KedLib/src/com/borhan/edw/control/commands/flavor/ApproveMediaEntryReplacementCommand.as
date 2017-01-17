package com.borhan.edw.control.commands.flavor
{
	import com.borhan.commands.media.MediaApproveReplace;
	import com.borhan.edw.business.EntryUtil;
	import com.borhan.edw.control.events.MediaEvent;
	import com.borhan.edw.events.KedDataEvent;
	import com.borhan.edw.model.datapacks.ContextDataPack;
	import com.borhan.edw.model.datapacks.EntryDataPack;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmvc.control.BMvCEvent;
	import com.borhan.vo.BorhanBaseEntry;
	import com.borhan.vo.BorhanMediaEntry;
	
	import flash.events.IEventDispatcher;
	import com.borhan.edw.control.commands.KedCommand;

	public class ApproveMediaEntryReplacementCommand extends KedCommand
	{
		override public function execute(event:BMvCEvent):void {
			_model.increaseLoadCounter();
			var approveReplacement:MediaApproveReplace = new MediaApproveReplace((event as MediaEvent).entry.id);
			approveReplacement.addEventListener(BorhanEvent.COMPLETE, result);
			approveReplacement.addEventListener(BorhanEvent.FAILED, fault);
			
			_client.post(approveReplacement);
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
			}
			else {
				trace ("error in approve replacement");
			}
			
			_model.decreaseLoadCounter();
		}
	}
}