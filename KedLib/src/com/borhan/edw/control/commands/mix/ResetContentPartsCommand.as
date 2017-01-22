package com.borhan.edw.control.commands.mix
{
	import com.borhan.edw.control.commands.KedCommand;
	import com.borhan.edw.model.datapacks.ContentDataPack;
	import com.borhan.bmvc.control.BMvCEvent;
	
	public class ResetContentPartsCommand extends KedCommand {
		
		override public function execute(event:BMvCEvent):void
		{
//			_model.increaseLoadCounter();		
			var cdp:ContentDataPack = _model.getDataPack(ContentDataPack) as ContentDataPack;
			cdp.contentParts = null;
//			
//			var e : KedEntryEvent = event as KedEntryEvent;
//			var getMixUsingEntry:MixingGetMixesByMediaId = new MixingGetMixesByMediaId(e.entryVo.id);
//			
//			getMixUsingEntry.addEventListener(BorhanEvent.COMPLETE, result);
//			getMixUsingEntry.addEventListener(BorhanEvent.FAILED, fault);
//			
//			_client.post(getMixUsingEntry);
		}
	}
}