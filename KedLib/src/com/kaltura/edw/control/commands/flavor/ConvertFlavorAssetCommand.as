package com.borhan.edw.control.commands.flavor
{
	import com.borhan.commands.flavorAsset.FlavorAssetConvert;
	import com.borhan.edw.control.commands.KedCommand;
	import com.borhan.edw.control.events.KedEntryEvent;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmvc.control.BMvCEvent;
	import com.borhan.vo.BorhanBaseEntry;
	import com.borhan.vo.BorhanFlavorAssetWithParams;
	
	public class ConvertFlavorAssetCommand extends KedCommand
	{
		private var selectedEntryId:String;
		override public function execute(event:BMvCEvent):void
		{	
			_dispatcher = event.dispatcher;
			_model.increaseLoadCounter();
			var obj:BorhanFlavorAssetWithParams = event.data as BorhanFlavorAssetWithParams;
			selectedEntryId = obj.entryId;
			var convertCommand:FlavorAssetConvert = new FlavorAssetConvert(selectedEntryId, obj.flavorParams.id);
            convertCommand.addEventListener(BorhanEvent.COMPLETE, result);
	        convertCommand.addEventListener(BorhanEvent.FAILED, fault);
    	    _client.post(convertCommand);
		}
		
		override public function result(event:Object):void
		{
			super.result(event);
 			_model.decreaseLoadCounter();
 			var entry:BorhanBaseEntry = new BorhanBaseEntry();
 			entry.id = selectedEntryId;
 			var cgEvent : KedEntryEvent = new KedEntryEvent(KedEntryEvent.GET_FLAVOR_ASSETS, entry);
			_dispatcher.dispatch(cgEvent);
		}
	}
}