package com.borhan.edw.control
{
	import com.borhan.edw.control.commands.UploadTokenCommand;
	import com.borhan.edw.control.commands.relatedFiles.*;
	import com.borhan.edw.control.events.RelatedFileEvent;
	import com.borhan.edw.control.events.UploadTokenEvent;
	import com.borhan.bmvc.control.BMvCController;
	
	public class RelatedTabController extends BMvCController {
		
		public function RelatedTabController()
		{
			initializeCommands();
		}
		
		public function initializeCommands():void {
			addCommand(RelatedFileEvent.SAVE_ALL_RELATED, SaveRelatedFilesCommand);
			addCommand(RelatedFileEvent.LIST_RELATED_FILES, ListRelatedFilesCommand);
			addCommand(RelatedFileEvent.UPDATE_RELATED_FILE, UpdateRelatedFileCommand);
			
			addCommand(UploadTokenEvent.UPLOAD_TOKEN, UploadTokenCommand);
		}
	}
}