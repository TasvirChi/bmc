package com.borhan.edw.control.events
{
	import com.borhan.edw.vo.AssetVO;
	import com.borhan.bmvc.control.BMvCEvent;
	
	import flash.net.FileReference;
	
	public class UploadTokenEvent extends BMvCEvent
	{
		public static const UPLOAD_TOKEN:String = "uploadToken";
		
		public var fileReference:FileReference;
		public var assetVo:AssetVO;
		
		public function UploadTokenEvent(type:String, file_reference:FileReference, asset_vo:AssetVO, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			fileReference = file_reference;
			assetVo = asset_vo;
			super(type, bubbles, cancelable);
		}
	}
}