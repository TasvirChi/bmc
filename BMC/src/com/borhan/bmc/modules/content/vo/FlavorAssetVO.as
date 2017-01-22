package com.borhan.bmc.modules.content.vo
{
	import com.adobe.cairngorm.vo.IValueObject;
	import com.borhan.vo.BorhanFlavorAsset;
	
	import mx.utils.ObjectProxy;
	
	public class FlavorAssetVO extends ObjectProxy implements IValueObject
	{
		public var asset:BorhanFlavorAsset;
		public function FlavorAssetVO()
		{
			asset = new BorhanFlavorAsset();
		}

	}
}