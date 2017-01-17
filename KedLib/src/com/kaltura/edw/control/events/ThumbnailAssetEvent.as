package com.borhan.edw.control.events
{
	import com.borhan.edw.vo.ThumbnailWithDimensions;
	import com.borhan.bmvc.control.BMvCEvent;

	public class ThumbnailAssetEvent extends BMvCEvent
	{
		public static const LIST:String = "content_listThumbnailAsset";
		public static const SET_AS_DEFAULT:String = "content_setAsDefaultThumbAsset";
		public static const DELETE:String = "content_deleteThumbnailAsset";
		public static const GET:String = "content_getThumbnailAsset";
		
		public var thumbnailAsset:ThumbnailWithDimensions;
		
		public function ThumbnailAssetEvent(type:String, thumbAsset:ThumbnailWithDimensions = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.thumbnailAsset = thumbAsset;
			super(type, bubbles, cancelable);
		}
	}
}