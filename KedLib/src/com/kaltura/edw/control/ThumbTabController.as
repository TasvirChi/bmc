package com.borhan.edw.control
{
	import com.borhan.edw.control.commands.thumb.*;
	import com.borhan.edw.control.events.GenerateThumbAssetEvent;
	import com.borhan.edw.control.events.ThumbnailAssetEvent;
	import com.borhan.edw.control.events.UploadFromImageThumbAssetEvent;
	import com.borhan.bmvc.control.BMvCController;
	
	public class ThumbTabController extends BMvCController {
		
		public function ThumbTabController()
		{
			initializeCommands();
		}
		
		public function initializeCommands():void {
			addCommand(ThumbnailAssetEvent.LIST, ListThumbnailAssetCommand);
			addCommand(UploadFromImageThumbAssetEvent.ADD_FROM_IMAGE, AddFromImageThumbnailAssetCommand);
			addCommand(ThumbnailAssetEvent.DELETE, DeleteThumbnailAssetCommand);
			addCommand(ThumbnailAssetEvent.SET_AS_DEFAULT, SetAsDefaultThumbnailAsset);
			addCommand(GenerateThumbAssetEvent.GENERATE, GenerateThumbAssetCommand);
			
		}
	}
}