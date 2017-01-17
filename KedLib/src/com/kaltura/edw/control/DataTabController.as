package com.borhan.edw.control
{
	import com.borhan.edw.control.commands.DuplicateEntryDetailsModelCommand;
	import com.borhan.edw.control.commands.GetEntryCategoriesCommand;
	import com.borhan.edw.control.commands.GetLivestreamStatusCommand;
	import com.borhan.edw.control.commands.GetSingleEntryCommand;
	import com.borhan.edw.control.commands.ListEntriesCommand;
	import com.borhan.edw.control.commands.LoadFilterDataCommand;
	import com.borhan.edw.control.commands.UpdateEntryCategoriesCommand;
	import com.borhan.edw.control.commands.customData.*;
	import com.borhan.edw.control.events.KedEntryEvent;
	import com.borhan.edw.control.events.LoadEvent;
	import com.borhan.edw.control.events.MetadataDataEvent;
	import com.borhan.edw.control.events.MetadataProfileEvent;
	import com.borhan.edw.control.events.ModelEvent;
	import com.borhan.edw.control.events.SearchEvent;
	import com.borhan.bmvc.control.BMvCController;
	
	public class DataTabController extends BMvCController {
		
		private static var _instance:DataTabController;
		
		
		public static function getInstance():DataTabController {
			if (!_instance){
				_instance = new DataTabController();
			}
			return _instance;
		}
		
		public function DataTabController()
		{
			initializeCommands();
		}
		
		public function initializeCommands():void {
			addCommand(MetadataProfileEvent.GET_METADATA_UICONF, GetMetadataUIConfCommand);
			addCommand(MetadataProfileEvent.LIST, ListMetadataProfileCommand);
			addCommand(MetadataProfileEvent.GET, GetMetadataProfileCommand);
			addCommand(MetadataDataEvent.LIST, ListMetadataDataCommand);
			addCommand(MetadataDataEvent.UPDATE, UpdateMetadataDataCommand);
			addCommand(MetadataDataEvent.RESET, ListMetadataDataCommand);
			addCommand(SearchEvent.SEARCH_ENTRIES, ListEntriesCommand);
			addCommand(LoadEvent.LOAD_FILTER_DATA, LoadFilterDataCommand);
			
			addCommand(ModelEvent.DUPLICATE_ENTRY_DETAILS_MODEL, DuplicateEntryDetailsModelCommand);
			addCommand(KedEntryEvent.GET_ENTRY_AND_DRILLDOWN, GetSingleEntryCommand);	
			addCommand(KedEntryEvent.GET_ENTRY_CATEGORIES, GetEntryCategoriesCommand);	
			addCommand(KedEntryEvent.RESET_ENTRY_CATEGORIES, GetEntryCategoriesCommand);	
			addCommand(KedEntryEvent.UPDATE_ENTRY_CATEGORIES, UpdateEntryCategoriesCommand);	
			addCommand(KedEntryEvent.GET_LIVESTREAM_STATUS, GetLivestreamStatusCommand);	
			addCommand(KedEntryEvent.RESET_LIVESTREAM_STATUS, GetLivestreamStatusCommand);	
		}
	}
}