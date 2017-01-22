package com.borhan.edw.control
{
	import com.borhan.edw.control.commands.*;
	import com.borhan.edw.control.events.KedEntryEvent;
	import com.borhan.bmvc.control.BMvCController;

	public class EDWController extends BMvCController {
		
		public function EDWController()
		{
			initializeCommands();
		}
		
		public function initializeCommands():void {
			addCommand(KedEntryEvent.DELETE_ENTRY, DeleteBaseEntryCommand);
			addCommand(KedEntryEvent.SET_SELECTED_ENTRY, SetSelectedEntryCommand);
			addCommand(KedEntryEvent.UPDATE_SINGLE_ENTRY, UpdateSingleEntry);
			addCommand(KedEntryEvent.LIST_ENTRIES_BY_REFID, ListEntriesByRefidCommand);
			
		}
	}
}