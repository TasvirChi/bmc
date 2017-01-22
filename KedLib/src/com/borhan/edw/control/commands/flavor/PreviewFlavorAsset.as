package com.borhan.edw.control.commands.flavor
{
	import com.borhan.edw.control.commands.KedCommand;
	import com.borhan.edw.model.datapacks.EntryDataPack;
	import com.borhan.bmvc.control.BMvCEvent;
	import com.borhan.vo.BorhanFlavorAssetWithParams;
	
	import flash.external.ExternalInterface;
	
	import mx.resources.ResourceManager;
	
	public class PreviewFlavorAsset extends KedCommand
	{
		override public function execute(event:BMvCEvent):void
		{		
			// { asset_id : "00_uyjv3dkxot", flavor_name : "Normal - big", format : "flv", codec : "vp6", bitrate : "768", dimensions : { height : 360 , width : 640 }, sizeKB : 1226, status : "OK" } 
			
			var obj:BorhanFlavorAssetWithParams = event.data as BorhanFlavorAssetWithParams;
			var flavorDetails:Object = new Object();
			flavorDetails.asset_id = obj.flavorAsset.id;
			flavorDetails.flavor_name = obj.flavorParams.name;
			flavorDetails.format = obj.flavorParams.format;
			flavorDetails.codec = obj.flavorAsset.videoCodecId;	// this is right
//			flavorDetails.codec = obj.flavorParams.videoCodec;  // this is wrong!!
			flavorDetails.bitrate = obj.flavorAsset.bitrate;
			
			var dimensions:Object = new Object();
			dimensions.height = obj.flavorAsset.height;
			dimensions.width = obj.flavorAsset.width;
			
			flavorDetails.dimensions = dimensions;
			flavorDetails.sizeKB = obj.flavorAsset.size;
			flavorDetails.status = ResourceManager.getInstance().getString('cms','readyStatus');
			
			ExternalInterface.call("bmc.preview_embed.doFlavorPreview", obj.entryId, (_model.getDataPack(EntryDataPack)as EntryDataPack).selectedEntry.name , flavorDetails);
		}
	}
}