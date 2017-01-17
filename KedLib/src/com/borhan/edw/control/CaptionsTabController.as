package com.borhan.edw.control
{
	import com.borhan.edw.control.commands.UploadTokenCommand;
	import com.borhan.edw.control.commands.captions.*;
	import com.borhan.edw.control.events.CaptionsEvent;
	import com.borhan.edw.control.events.UploadTokenEvent;
	import com.borhan.bmvc.control.BMvCController;
	
	public class CaptionsTabController extends BMvCController {
		
		public function CaptionsTabController()
		{
			initializeCommands();
		}
		
		public function initializeCommands():void {
			addCommand(CaptionsEvent.LIST_CAPTIONS, ListCaptionsCommand);
			addCommand(CaptionsEvent.SAVE_ALL, SaveCaptionsCommand);
			addCommand(CaptionsEvent.UPDATE_CAPTION, GetCaptionDownloadUrl);
			addCommand(UploadTokenEvent.UPLOAD_TOKEN, UploadTokenCommand);
		}
	}
}