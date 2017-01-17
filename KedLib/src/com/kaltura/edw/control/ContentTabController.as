package com.borhan.edw.control
{
	import com.borhan.edw.control.commands.mix.GetAllEntriesCommand;
	import com.borhan.edw.control.commands.mix.GetEntryRoughcutsCommand;
	import com.borhan.edw.control.commands.mix.ResetContentPartsCommand;
	import com.borhan.edw.control.events.KedEntryEvent;
	import com.borhan.bmvc.control.BMvCController;
	
	public class ContentTabController extends BMvCController {
		
		public function ContentTabController()
		{
			initializeCommands();
		}
		
		public function initializeCommands():void {
			addCommand(KedEntryEvent.GET_ENTRY_ROUGHCUTS, GetEntryRoughcutsCommand);
			addCommand(KedEntryEvent.GET_ALL_ENTRIES, GetAllEntriesCommand);
			addCommand(KedEntryEvent.RESET_PARTS, ResetContentPartsCommand);
		}
	}
}