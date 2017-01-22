package com.borhan.edw.control.commands.thumb
{
	import com.borhan.commands.thumbAsset.ThumbAssetAddFromImage;
	import com.borhan.edw.control.commands.KedCommand;
	import com.borhan.edw.control.events.UploadFromImageThumbAssetEvent;
	import com.borhan.edw.model.datapacks.DistributionDataPack;
	import com.borhan.edw.vo.ThumbnailWithDimensions;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmvc.control.BMvCEvent;
	import com.borhan.vo.BorhanThumbAsset;

	public class AddFromImageThumbnailAssetCommand extends KedCommand
	{
		override public function execute(event:BMvCEvent):void
		{
			_model.increaseLoadCounter();
			var uploadEvent:UploadFromImageThumbAssetEvent = event as UploadFromImageThumbAssetEvent;
			var uploadFromImage:ThumbAssetAddFromImage = new ThumbAssetAddFromImage(uploadEvent.entryId, uploadEvent.thumbnailFileReference);
			uploadFromImage.addEventListener(BorhanEvent.COMPLETE, result);
			uploadFromImage.addEventListener(BorhanEvent.FAILED, fault);
			uploadFromImage.queued = false;
			_client.post(uploadFromImage);
		}
		
		override public function result(data:Object):void {
			_model.decreaseLoadCounter();
			super.result(data);
			insertToThumbsArray(data.data as BorhanThumbAsset);
		}
		
		
		private function insertToThumbsArray(thumbAsset:BorhanThumbAsset):void {
			var distDp:DistributionDataPack = _model.getDataPack(DistributionDataPack) as DistributionDataPack;
			var thumbsArray:Array = distDp.distributionInfo.thumbnailDimensions;
			var newThumb:ThumbnailWithDimensions = new ThumbnailWithDimensions(thumbAsset.width, thumbAsset.height, thumbAsset);
			newThumb.thumbUrl = newThumb.buildThumbUrl(_client);
			for each (var thumb:ThumbnailWithDimensions in thumbsArray) {
				if ((thumb.width==thumbAsset.width) && (thumb.height==thumbAsset.height)) {
					if (!thumb.thumbAsset) {
						thumb.thumbAsset = thumbAsset;
						thumb.thumbUrl = thumb.buildThumbUrl(_client)
						//no need to add a new thumbnailWithDimensions object in this case
						return;
					}
					else {
						//since they have the same dimensions: same distribution profiles use them
						newThumb.usedDistributionProfilesArray = thumb.usedDistributionProfilesArray.concat();
					}
					
					break;
				}
			}
			//add last
			thumbsArray.splice(thumbsArray.length, 0, newThumb); 
			//for data binding
			distDp.distributionInfo.thumbnailDimensions = thumbsArray.concat();	
		}
		
	}
}