package com.borhan.edw.control.commands.thumb
{
	import com.borhan.commands.thumbAsset.ThumbAssetGenerate;
	import com.borhan.edw.control.commands.KedCommand;
	import com.borhan.edw.control.events.GenerateThumbAssetEvent;
	import com.borhan.edw.control.events.ThumbnailAssetEvent;
	import com.borhan.edw.model.datapacks.DistributionDataPack;
	import com.borhan.edw.model.datapacks.EntryDataPack;
	import com.borhan.edw.vo.ThumbnailWithDimensions;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmvc.control.BMvCEvent;
	import com.borhan.vo.BorhanThumbAsset;
	import com.borhan.vo.BorhanThumbParams;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.resources.ResourceManager;
	
	public class GenerateThumbAssetCommand extends KedCommand
	{
		private var _thumbsArray:Array;
		
		private var _ddp:DistributionDataPack;
		
		override public function execute(event:BMvCEvent):void
		{
			_model.increaseLoadCounter();
			var generateThumbEvent:GenerateThumbAssetEvent = event as GenerateThumbAssetEvent;
			var generateThumbAsset:ThumbAssetGenerate = new ThumbAssetGenerate((_model.getDataPack(EntryDataPack) as EntryDataPack).selectedEntry.id, generateThumbEvent.thumbParams, generateThumbEvent.thumbSourceId);
			generateThumbAsset.addEventListener(BorhanEvent.COMPLETE, result);
			generateThumbAsset.addEventListener(BorhanEvent.FAILED, fault);
			
			_client.post(generateThumbAsset);
		}
		
		override public function result(data:Object):void {
			_model.decreaseLoadCounter();
			super.result(data);
			_ddp = _model.getDataPack(DistributionDataPack) as DistributionDataPack;
			var newThumb:BorhanThumbAsset =  data.data as BorhanThumbAsset;
			_thumbsArray = _ddp.distributionInfo.thumbnailDimensions;
			var curUsedProfiles:Array = new Array();
			var thumbExist:Boolean = false;
			for each (var thumb:ThumbnailWithDimensions in _thumbsArray) {
				if ((newThumb.width == thumb.width) && (newThumb.height == thumb.height)) {
					if (!thumb.thumbAsset) {
						thumb.thumbAsset = newThumb;
						thumb.thumbUrl = thumb.buildThumbUrl(_client);
						thumbExist = true;
						break;
					}
					curUsedProfiles = thumb.usedDistributionProfilesArray;
				}
			}
			if (!thumbExist) {
				var thumbToAdd:ThumbnailWithDimensions = new ThumbnailWithDimensions(newThumb.width, newThumb.height, newThumb);
				thumbToAdd.thumbUrl = thumbToAdd.buildThumbUrl(_client);
				thumbToAdd.usedDistributionProfilesArray = curUsedProfiles;
				//add last
				_thumbsArray.splice(_thumbsArray.length,0,thumbToAdd);
			}
			
			Alert.show(ResourceManager.getInstance().getString('cms','savedMessage'),ResourceManager.getInstance().getString('cms','savedTitle'), Alert.OK, null, onUserOK);
			
		}
		
		/**
		 * only after user approval for the new thumbnail alert, the model will reload the thumbs
		 * */
		private function onUserOK(event:CloseEvent):void {
			_ddp.distributionInfo.thumbnailDimensions = _thumbsArray.concat();
		}
		
	}
}