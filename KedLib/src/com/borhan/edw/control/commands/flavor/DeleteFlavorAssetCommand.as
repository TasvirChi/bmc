package com.borhan.edw.control.commands.flavor
{
	import com.borhan.commands.flavorAsset.FlavorAssetDelete;
	import com.borhan.edw.control.commands.KedCommand;
	import com.borhan.edw.control.events.KedEntryEvent;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmvc.control.BMvCEvent;
	import com.borhan.vo.BorhanBaseEntry;
	import com.borhan.vo.BorhanFlavorAssetWithParams;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.resources.ResourceManager;
	
	public class DeleteFlavorAssetCommand extends KedCommand
	{
		private var fap:BorhanFlavorAssetWithParams;
		override public function execute(event:BMvCEvent):void
		{		
			_dispatcher = event.dispatcher;
			fap = event.data as BorhanFlavorAssetWithParams;
			Alert.show(ResourceManager.getInstance().getString('cms', 'deleteAssetMsg') + fap.flavorAsset.id + " ?", 
					   ResourceManager.getInstance().getString('cms', 'deleteAssetTitle'), Alert.YES | Alert.NO, null, handleUserResponse);
		
		}
		
		private function handleUserResponse(event:CloseEvent):void
		{
			if(event.detail == Alert.YES)
			{
				_model.increaseLoadCounter();
				var deleteCommand:FlavorAssetDelete = new FlavorAssetDelete(fap.flavorAsset.id);
	            deleteCommand.addEventListener(BorhanEvent.COMPLETE, result);
		        deleteCommand.addEventListener(BorhanEvent.FAILED, fault);
	    	    _client.post(deleteCommand); 
			}
		}
		
		override public function result(event:Object):void
		{
			super.result(event);
 			_model.decreaseLoadCounter();
 			Alert.show(ResourceManager.getInstance().getString('cms', 'assetDeletedMsg'), '', Alert.OK);
 			var entry:BorhanBaseEntry = new BorhanBaseEntry();
 			entry.id = fap.entryId;
 			var cgEvent : KedEntryEvent = new KedEntryEvent(KedEntryEvent.GET_FLAVOR_ASSETS, entry);
			_dispatcher.dispatch(cgEvent);
		}
	}
}