package com.borhan.edw.control.commands
{
	import com.borhan.commands.baseEntry.BaseEntryDelete;
	import com.borhan.edw.control.events.KedEntryEvent;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmvc.control.BMvCEvent;

	public class DeleteBaseEntryCommand extends KedCommand
	{
		override public function execute(event:BMvCEvent):void {
			_model.increaseLoadCounter();
			var deleteEntry:BaseEntryDelete = new BaseEntryDelete((event as KedEntryEvent).entryId);
			deleteEntry.addEventListener(BorhanEvent.COMPLETE, result);
			deleteEntry.addEventListener(BorhanEvent.FAILED, fault);
			
			_client.post(deleteEntry);
		}
		
		override public function result(data:Object):void {
			_model.decreaseLoadCounter();
		}
	}
}