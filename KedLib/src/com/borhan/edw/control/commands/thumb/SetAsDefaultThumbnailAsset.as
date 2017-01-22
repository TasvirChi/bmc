package com.borhan.edw.control.commands.thumb
{
	import com.borhan.commands.MultiRequest;
	import com.borhan.commands.thumbAsset.ThumbAssetGetByEntryId;
	import com.borhan.commands.thumbAsset.ThumbAssetSetAsDefault;
	import com.borhan.edw.control.commands.KedCommand;
	import com.borhan.edw.control.events.ThumbnailAssetEvent;
	import com.borhan.edw.model.datapacks.DistributionDataPack;
	import com.borhan.edw.model.datapacks.EntryDataPack;
	import com.borhan.edw.vo.ThumbnailWithDimensions;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmvc.control.BMvCEvent;
	import com.borhan.vo.BorhanThumbAsset;

	public class SetAsDefaultThumbnailAsset extends KedCommand
	{
		private var _defaultThumb:ThumbnailWithDimensions;
		
		override public function execute(event:BMvCEvent):void
		{
			_model.increaseLoadCounter();
			_defaultThumb = (event as ThumbnailAssetEvent).thumbnailAsset;
			var multiRequest:MultiRequest = new MultiRequest();
			var setDefault:ThumbAssetSetAsDefault = new ThumbAssetSetAsDefault(_defaultThumb.thumbAsset.id);
			multiRequest.addAction(setDefault);
			var listThumbs:ThumbAssetGetByEntryId = new ThumbAssetGetByEntryId((_model.getDataPack(EntryDataPack) as EntryDataPack).selectedEntry.id);
			multiRequest.addAction(listThumbs);
			
			multiRequest.addEventListener(BorhanEvent.COMPLETE, result);
			multiRequest.addEventListener(BorhanEvent.FAILED, fault);
			
			_client.post(multiRequest);
		}
		
		override public function result(data:Object):void {
			_model.decreaseLoadCounter();
			var resultArray:Array = data.data as Array;
			updateThumbnailsState(resultArray[1] as Array);
		}
		
		/**
		 * update our saved array with the updated array arrived from the server 
		 * @param thumbsArray the updated array
		 * 
		 */		
		private function updateThumbnailsState(thumbsArray:Array):void {
			var ddp:DistributionDataPack = _model.getDataPack(DistributionDataPack) as DistributionDataPack;
			var currentThumbsArray:Array = ddp.distributionInfo.thumbnailDimensions;
			for (var i:int=0; i<thumbsArray.length; i++) {
				var thumbAsset:BorhanThumbAsset = thumbsArray[i] as BorhanThumbAsset;
				for (var j:int=0; j<currentThumbsArray.length; j++) {
					var thumbWithDimensions:ThumbnailWithDimensions = currentThumbsArray[j] as ThumbnailWithDimensions;
					if (thumbWithDimensions.thumbAsset && (thumbWithDimensions.thumbAsset.id == thumbAsset.id)) {
						thumbWithDimensions.thumbAsset = thumbAsset;
						break;
					}
				}
			}
			
			//for data binding
			ddp.distributionInfo.thumbnailDimensions = currentThumbsArray.concat();
		}
	}
}