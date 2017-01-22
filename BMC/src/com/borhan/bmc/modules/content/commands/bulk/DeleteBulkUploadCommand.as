package com.borhan.bmc.modules.content.commands.bulk
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.commands.bulkUpload.BulkUploadAbort;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmc.modules.content.commands.BorhanCommand;
	import com.borhan.bmc.modules.content.events.BulkEvent;
	import com.borhan.vo.BorhanBulkUpload;
	
	public class DeleteBulkUploadCommand extends BorhanCommand {
		
		override public function execute(event:CairngormEvent):void
		{
			_model.increaseLoadCounter();
			var kbu:BulkUploadAbort = new BulkUploadAbort(event.data);
			kbu.addEventListener(BorhanEvent.COMPLETE, result);
			kbu.addEventListener(BorhanEvent.FAILED, fault);
			_model.context.kc.post(kbu);
		}
		
		override public function result( data : Object ) : void
		{
			super.result(data);
			var temp:BorhanBulkUpload;
//			var bulkEvent : BulkEvent = new BulkEvent( BulkEvent.LIST_BULK_UPLOAD );
//			bulkEvent.dispatch();
			_model.decreaseLoadCounter();
		}
	}
}