package com.borhan.edw.control.commands.flavor
{
	import com.borhan.commands.flavorAsset.FlavorAssetAdd;
	import com.borhan.commands.flavorAsset.FlavorAssetSetContent;
	import com.borhan.edw.control.events.KedEntryEvent;
	import com.borhan.edw.control.events.MediaEvent;
	import com.borhan.edw.model.datapacks.EntryDataPack;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmvc.control.BMvCEvent;
	import com.borhan.vo.BorhanContentResource;
	import com.borhan.vo.BorhanFlavorAsset;
	import com.borhan.edw.control.commands.KedCommand;
	
	public class AddFlavorCommand extends KedCommand {
		
		private var _resource:BorhanContentResource;
		
		override public function execute(event:BMvCEvent):void
		{
			_dispatcher = event.dispatcher;
			_model.increaseLoadCounter();
			var e:MediaEvent = event as MediaEvent;
			_resource = e.data.resource as BorhanContentResource;
			var flavorAsset:BorhanFlavorAsset = new BorhanFlavorAsset()
			flavorAsset.flavorParamsId = e.data.flavorParamsId;
			flavorAsset.setUpdatedFieldsOnly(true);
			flavorAsset.setInsertedFields(true);
			var fau:FlavorAssetAdd = new FlavorAssetAdd(e.entry.id, flavorAsset);
			fau.addEventListener(BorhanEvent.COMPLETE, setResourceContent);
			fau.addEventListener(BorhanEvent.FAILED, fault);
			_client.post(fau);
		}
		
		protected function setResourceContent(e:BorhanEvent):void {
			super.result(e);
			var fasc:FlavorAssetSetContent = new FlavorAssetSetContent(e.data.id, _resource);
			fasc.addEventListener(BorhanEvent.COMPLETE, result);
			fasc.addEventListener(BorhanEvent.FAILED, fault);
			_client.post(fasc);
		} 
		
		override public function result(data:Object):void {
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