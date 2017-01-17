package com.borhan.bmc.modules.content.business
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.edw.components.et.EntryTable;
	import com.borhan.edw.components.et.events.EntryTableEvent;
	import com.borhan.edw.control.KedController;
	import com.borhan.edw.control.events.KedEntryEvent;
	import com.borhan.edw.model.types.WindowsStates;
	import com.borhan.bmc.modules.content.events.EntriesEvent;
	import com.borhan.bmc.modules.content.events.BMCEntryEvent;
	import com.borhan.bmc.modules.content.events.SelectionEvent;
	import com.borhan.bmc.modules.content.events.WindowEvent;
	import com.borhan.bmvc.control.BMvCEvent;
	import com.borhan.types.BorhanPlaylistType;
	import com.borhan.vo.BorhanBaseEntry;
	import com.borhan.vo.BorhanMediaEntry;
	import com.borhan.vo.BorhanMixEntry;
	import com.borhan.vo.BorhanPlaylist;
	
	import mx.collections.ArrayCollection;

	/**
	 * handles EntryTable actions in a single location,
	 * so we won't have to duplicate code in all the classes that hold the ET.  
	 * @author atar.shadmi
	 */
	public class EntryTableActionsManager {
		
		/**
		 * delete selected entries
		 */
		public function deleteEntries(event:EntryTableEvent):void {
			var cgEvent:EntriesEvent = new EntriesEvent(EntriesEvent.DELETE_ENTRIES);
			cgEvent.data = event.data;
			cgEvent.dispatch();
		}
		
		
		/**
		 * open PnE window 
		 * @param event
		 */
		public function preview(event:EntryTableEvent):void {
			var entry:BorhanBaseEntry = event.data as BorhanBaseEntry;
			var cgEvent:BMCEntryEvent;
			if (entry is BorhanPlaylist)
				cgEvent = new BMCEntryEvent(BMCEntryEvent.PREVIEW, entry as BorhanPlaylist);
			else if (entry is BorhanMediaEntry || entry is BorhanMixEntry)
				cgEvent = new BMCEntryEvent(BMCEntryEvent.PREVIEW, entry as BorhanBaseEntry);
			else {
				trace("Error: no PlaylistVO nor EntryVO");
				return;
			}
			
			cgEvent.dispatch();
		}
		
		
		public function showEntryDetailsHandler(event:EntryTableEvent):void {
			var entry:BorhanBaseEntry = event.data as BorhanBaseEntry;
			var et:EntryTable = event.target as EntryTable;
			var kEvent:BMvCEvent = new KedEntryEvent(KedEntryEvent.SET_SELECTED_ENTRY, entry, entry.id, (et.dataProvider as ArrayCollection).getItemIndex(entry));
			KedController.getInstance().dispatch(kEvent);
			var cgEvent:CairngormEvent = new WindowEvent(WindowEvent.OPEN, WindowsStates.ENTRY_DETAILS_WINDOW);
			cgEvent.dispatch();
		}
		
		
		public function showPlaylistDetailsHandler(event:EntryTableEvent):void {
			var entry:BorhanBaseEntry = event.data as BorhanBaseEntry;
			var et:EntryTable = event.target as EntryTable;
			var cgEvent:CairngormEvent;
			var kEvent:KedEntryEvent = new KedEntryEvent(KedEntryEvent.SET_SELECTED_ENTRY, entry as BorhanBaseEntry, (entry as BorhanBaseEntry).id, (et.dataProvider as ArrayCollection).getItemIndex(entry));
			KedController.getInstance().dispatchEvent(kEvent);
			//switch manual / rule base
			if ((entry as BorhanPlaylist).playlistType == BorhanPlaylistType.STATIC_LIST) {
				// manual list
				cgEvent = new WindowEvent(WindowEvent.OPEN, WindowsStates.PLAYLIST_MANUAL_WINDOW);
				cgEvent.dispatch();
			}
			if ((entry as BorhanPlaylist).playlistType == BorhanPlaylistType.DYNAMIC) {
				cgEvent = new WindowEvent(WindowEvent.OPEN, WindowsStates.PLAYLIST_RULE_BASED_WINDOW);
				cgEvent.dispatch();
			}
		}
		
		
		public function itemClickHandler(event:EntryTableEvent):void {
			var et:EntryTable = event.target as EntryTable;
			var cgEvent:SelectionEvent = new SelectionEvent(SelectionEvent.ENTRIES_SELECTION_CHANGED, et.selectedItems);
			cgEvent.dispatch();
			
		}
		
	}
}