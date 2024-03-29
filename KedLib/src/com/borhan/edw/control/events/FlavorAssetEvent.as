package com.borhan.edw.control.events
{
	import com.borhan.bmvc.control.BMvCEvent;
	import com.borhan.vo.BorhanFlavorAssetWithParams;
	
	public class FlavorAssetEvent extends BMvCEvent
	{
		public static const CREATE_FLAVOR_ASSET : String = "content_createFlavorAsset";
		public static const DELETE_FLAVOR_ASSET : String = "content_deleteFlavorAsset";
		public static const DOWNLOAD_FLAVOR_ASSET : String = "content_downloadFlavorAsset";
		public static const PREVIEW_FLAVOR_ASSET : String = "content_previewFlavorAsset";
		public static const VIEW_WV_ASSET_DETAILS : String = "content_viewWVAssetDetails";
		
		public function FlavorAssetEvent(type:String, dataVo:BorhanFlavorAssetWithParams, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.data = dataVo;
		}

	}
}