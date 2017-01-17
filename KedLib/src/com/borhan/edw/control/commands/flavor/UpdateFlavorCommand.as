package com.borhan.edw.control.commands.flavor
{
	import com.borhan.commands.flavorAsset.FlavorAssetSetContent;
	import com.borhan.edw.control.events.KedEntryEvent;
	import com.borhan.edw.control.events.MediaEvent;
	import com.borhan.edw.model.datapacks.EntryDataPack;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmvc.control.BMvCEvent;
	import com.borhan.vo.BorhanContentResource;
	import com.borhan.edw.control.commands.KedCommand;
	
	public class UpdateFlavorCommand extends KedCommand {
		
		override public function execute(event:BMvCEvent):void
		{
			_dispatcher = event.dispatcher;
			_model.increaseLoadCounter();
			var e:MediaEvent = event as MediaEvent;
			var fau:FlavorAssetSetContent = new FlavorAssetSetContent(e.data.flavorAssetId, e.data.resource as BorhanContentResource);
			fau.addEventListener(BorhanEvent.COMPLETE, result);
			fau.addEventListener(BorhanEvent.FAILED, fault);
			_client.post(fau);
		}
		
		override public function result(data:Object):void
		{
			super.result(data);
			_model.decreaseLoadCounter();
			
			// to update the flavors tab, we re-load flavors data
			var edp:EntryDataPack = _model.getDataPack(EntryDataPack) as EntryDataPack;
			if(edp.selectedEntry != null) {
				var cgEvent : KedEntryEvent = new KedEntryEvent(KedEntryEvent.GET_FLAVOR_ASSETS, edp.selectedEntry);
				_dispatcher.dispatch(cgEvent);
			}
		}
	}
}