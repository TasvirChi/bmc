package com.borhan.edw.vo
{
	import com.adobe.cairngorm.vo.IValueObject;
	import com.borhan.vo.BorhanFlavorAssetWithParams;
	
	public class FlavorAssetWithParamsVO implements IValueObject
	{
		public var hasOriginal:Boolean = false;
		public var borhanFlavorAssetWithParams:BorhanFlavorAssetWithParams;
		
		/**
		 * list of flavors (BorhanFlavorParams) that contribute to a multi bitrate flavor
		 */
		public var sources:Array;
		
		public function FlavorAssetWithParamsVO()
		{
		}

	}
}