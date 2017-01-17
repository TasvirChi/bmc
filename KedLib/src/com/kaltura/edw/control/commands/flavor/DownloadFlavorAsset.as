package com.borhan.edw.control.commands.flavor
{
	import com.borhan.commands.flavorAsset.FlavorAssetGetUrl;
	import com.borhan.edw.control.commands.KedCommand;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmvc.control.BMvCEvent;
	import com.borhan.vo.BorhanFlavorAssetWithParams;
	
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	public class DownloadFlavorAsset extends KedCommand
	{
		override public function execute(event:BMvCEvent):void
		{		
		 	_model.increaseLoadCounter();
		 	var obj:BorhanFlavorAssetWithParams = event.data as BorhanFlavorAssetWithParams;
			var downloadCommand:FlavorAssetGetUrl = new FlavorAssetGetUrl(obj.flavorAsset.id);
            downloadCommand.addEventListener(BorhanEvent.COMPLETE, result);
	        downloadCommand.addEventListener(BorhanEvent.FAILED, fault);
    	    _client.post(downloadCommand);  
		}
		
		override public function result(event:Object):void
		{
			super.result(event);
 			_model.decreaseLoadCounter();
 			var downloadUrl:String = event.data;
			var urlRequest:URLRequest = new URLRequest(downloadUrl);
            navigateToURL(urlRequest, "downloadURL");
		}
	}
}
