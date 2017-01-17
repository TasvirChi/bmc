package com.borhan.edw.control
{
	import com.borhan.edw.control.commands.clips.*;
	import com.borhan.edw.control.events.ClipEvent;
	import com.borhan.bmvc.control.BMvCController;
	
	public class ClipsTabController extends BMvCController {
		
		public function ClipsTabController()
		{
			initializeCommands();
		}
		
		public function initializeCommands():void {
			
			addCommand(ClipEvent.GET_ENTRY_CLIPS, GetEntryClipsCommand);
			addCommand(ClipEvent.RESET_MODEL_ENTRY_CLIPS, ResetEntryClipsCommand);
		}
	}
}