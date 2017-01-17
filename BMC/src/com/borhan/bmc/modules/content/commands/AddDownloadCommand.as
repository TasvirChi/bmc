package com.borhan.bmc.modules.content.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.bmc.modules.content.events.DownloadEvent;
	import com.borhan.bmc.modules.content.model.CmsModelLocator;
	import com.borhan.commands.*;
	import com.borhan.commands.xInternal.XInternalXAddBulkDownload;
	import com.borhan.events.BorhanEvent;
	
	import mx.controls.Alert;
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;

	public class AddDownloadCommand extends BorhanCommand
	{
		
		override public function execute(event:CairngormEvent):void
		{
			_model.increaseLoadCounter();
			var de:DownloadEvent = event as DownloadEvent;
			
		 	var addDownload:XInternalXAddBulkDownload = new XInternalXAddBulkDownload(de.entriesIds, de.flavorParamId);
		 	addDownload.addEventListener(BorhanEvent.COMPLETE, result);
			addDownload.addEventListener(BorhanEvent.FAILED, fault);
			_model.context.kc.post(addDownload);	   
		}
		
		override public function result(data:Object):void
		{
			super.result(data);
			_model.decreaseLoadCounter();												// partner's email
			Alert.show( ResourceManager.getInstance().getString('cms', 'entryDownloadAlert', [data.data]) );
		}
		
		override public function fault(event:Object):void
		{
			_model.decreaseLoadCounter();
			Alert.show( ResourceManager.getInstance().getString('cms', 'entryDownloadErrorAlert') );
		}
	}
}