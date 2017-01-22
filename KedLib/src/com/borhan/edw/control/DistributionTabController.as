package com.borhan.edw.control
{
	import com.borhan.edw.control.commands.GetSingleEntryCommand;
	import com.borhan.edw.control.commands.ListFlavorAssetsByEntryIdCommand;
	import com.borhan.edw.control.commands.dist.*;
	import com.borhan.edw.control.commands.thumb.ListThumbnailAssetCommand;
	import com.borhan.edw.control.events.EntryDistributionEvent;
	import com.borhan.edw.control.events.KedEntryEvent;
	import com.borhan.edw.control.events.ThumbnailAssetEvent;
	import com.borhan.bmvc.control.BMvCController;
	
	public class DistributionTabController extends BMvCController {
		
		public function DistributionTabController()
		{
			initializeCommands();
		}
		
		public function initializeCommands():void {
			addCommand(ThumbnailAssetEvent.LIST, ListThumbnailAssetCommand);
			
			addCommand(KedEntryEvent.GET_FLAVOR_ASSETS, ListFlavorAssetsByEntryIdCommand);
			addCommand(KedEntryEvent.UPDATE_SELECTED_ENTRY_REPLACEMENT_STATUS, GetSingleEntryCommand);
			
			addCommand(EntryDistributionEvent.LIST, ListEntryDistributionCommand);
			addCommand(EntryDistributionEvent.UPDATE_LIST, UpdateEntryDistributionsCommand);
			addCommand(EntryDistributionEvent.SUBMIT, SubmitEntryDistributionCommand);
			addCommand(EntryDistributionEvent.SUBMIT_UPDATE, SubmitUpdateEntryDistributionCommand);
			addCommand(EntryDistributionEvent.UPDATE, UpdateEntryDistributionCommand);
			addCommand(EntryDistributionEvent.RETRY, RetryEntryDistributionCommand);
			addCommand(EntryDistributionEvent.GET_SENT_DATA, GetSentDataEntryDistributionCommand);
			addCommand(EntryDistributionEvent.GET_RETURNED_DATA, GetReturnedDataEntryDistributionCommand);
		}
	}
}