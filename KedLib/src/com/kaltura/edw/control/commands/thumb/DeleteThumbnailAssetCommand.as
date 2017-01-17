package com.borhan.edw.control.commands.thumb
{
	import com.borhan.commands.thumbAsset.ThumbAssetDelete;
	import com.borhan.edw.control.commands.KedCommand;
	import com.borhan.edw.control.events.ThumbnailAssetEvent;
	import com.borhan.edw.model.datapacks.DistributionDataPack;
	import com.borhan.edw.vo.ThumbnailWithDimensions;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmvc.control.BMvCEvent;
	
	import mx.collections.ArrayCollection;

	public class DeleteThumbnailAssetCommand extends KedCommand
	{
		private var _thumbToRemove:ThumbnailWithDimensions;
		
		override public function execute(event:BMvCEvent):void
		{
			_model.increaseLoadCounter();
			_thumbToRemove = (event as ThumbnailAssetEvent).thumbnailAsset;
			var deleteThumb:ThumbAssetDelete = new ThumbAssetDelete(_thumbToRemove.thumbAsset.id);
			deleteThumb.addEventListener(BorhanEvent.COMPLETE, result);
			deleteThumb.addEventListener(BorhanEvent.FAILED, fault);
			_client.post(deleteThumb);
		}
		
		override public function result(data:Object):void {
			_model.decreaseLoadCounter();
			super.result(data);
			var ddp:DistributionDataPack = _model.getDataPack(DistributionDataPack) as DistributionDataPack;
			var thumbsArray:Array = ddp.distributionInfo.thumbnailDimensions;
			for (var i:int = 0; i<thumbsArray.length; i++) {
				var currentThumb:ThumbnailWithDimensions = thumbsArray[i] as ThumbnailWithDimensions;
				if (currentThumb==_thumbToRemove) {
					if (currentThumb.usedDistributionProfilesArray.length > 0) {
						currentThumb.thumbAsset = null;
						currentThumb.thumbUrl = "";
					}
					else 
						thumbsArray.splice(i, 1);
					
					ddp.distributionInfo.thumbnailDimensions = thumbsArray.concat();
					return;
				}
			}			
		}
	}
}