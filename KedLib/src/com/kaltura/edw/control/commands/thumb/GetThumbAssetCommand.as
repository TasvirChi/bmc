package com.borhan.edw.control.commands.thumb
{
	import com.borhan.bmvc.control.BMvCEvent;
	import com.borhan.commands.thumbAsset.ThumbAssetGet;
	import com.borhan.events.BorhanEvent;
	import com.borhan.edw.control.events.ThumbnailAssetEvent;
	import com.borhan.edw.vo.ThumbnailWithDimensions;
	import com.borhan.vo.BorhanThumbAsset;
	import com.borhan.edw.control.commands.KedCommand;

	public class GetThumbAssetCommand extends KedCommand
	{
		private var _thumbnailAsset:ThumbnailWithDimensions;
		
		override public function execute(event:BMvCEvent):void
		{
			_thumbnailAsset = (event as ThumbnailAssetEvent).thumbnailAsset;
			var getThumbAsset:ThumbAssetGet = new ThumbAssetGet(_thumbnailAsset.thumbAsset.id);
			getThumbAsset.addEventListener(BorhanEvent.COMPLETE, result);
			getThumbAsset.addEventListener(BorhanEvent.FAILED, fault);
			
			_client.post(getThumbAsset);
		}
		
		override public function result(data:Object):void {
			_thumbnailAsset.thumbAsset = data.data as BorhanThumbAsset;
		}
	}
}