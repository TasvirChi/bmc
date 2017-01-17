package com.borhan.bmc.modules.content.commands {
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.analytics.GoogleAnalyticsConsts;
	import com.borhan.analytics.GoogleAnalyticsTracker;
	import com.borhan.analytics.KAnalyticsTracker;
	import com.borhan.analytics.KAnalyticsTrackerConsts;
	import com.borhan.commands.MultiRequest;
	import com.borhan.commands.baseEntry.BaseEntryDelete;
	import com.borhan.commands.mixing.MixingDelete;
	import com.borhan.commands.playlist.PlaylistDelete;
	import com.borhan.edw.control.events.SearchEvent;
	import com.borhan.errors.BorhanError;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmc.modules.content.events.CategoryEvent;
	import com.borhan.bmc.modules.content.events.BMCSearchEvent;
	import com.borhan.net.BorhanCall;
	import com.borhan.types.BorhanStatsBmcEventType;
	import com.borhan.vo.BorhanBaseEntry;
	import com.borhan.vo.BorhanMediaEntryFilterForPlaylist;
	import com.borhan.vo.BorhanMixEntry;
	import com.borhan.vo.BorhanPlaylist;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.messaging.messages.ErrorMessage;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;

	public class DeleteEntriesCommand extends BorhanCommand implements ICommand, IResponder {
		private var _isPlaylist:Boolean = false;
		
		private var _entries:Array;


		override public function execute(event:CairngormEvent):void {
			if (event.data is BorhanBaseEntry) {
				// if an entry was given, use it
				_entries = [event.data];
			}
			else {
				// otherwise use selected entries from the model (bulk action)
				_entries = _model.selectedEntries;
			}
			
			if (_entries.length == 0) {
//				if (_isPlaylist) {
//					Alert.show(ResourceManager.getInstance().getString('cms', 'pleaseSelectPlaylistsFirst'),
//						ResourceManager.getInstance().getString('cms',
//						'pleaseSelectPlaylistsFirstTitle'));
//				} 
//				else {
					Alert.show(ResourceManager.getInstance().getString('entrytable', 'pleaseSelectEntriesFirst'),
						ResourceManager.getInstance().getString('cms',
						'pleaseSelectEntriesFirstTitle'));
//				}
				return;
			} 
			_isPlaylist = (_entries[0] is BorhanPlaylist);
			if (_entries.length < 13) {
				var entryNames:String = "\n";
				for (var i:int = 0; i < _entries.length; i++)
					entryNames += (i + 1) + ". " + _entries[i].name + "\n";


				if (_isPlaylist) {
					Alert.show(ResourceManager.getInstance().getString('cms', 'deletePlaylistQ', [entryNames]),
						ResourceManager.getInstance().getString('cms',
						'deletePlaylistQTitle'),
						Alert.YES |
						Alert.NO, null, deleteEntries);
				} 
				else {
					Alert.show(ResourceManager.getInstance().getString('cms', 'deleteEntryQ', [entryNames]),
						ResourceManager.getInstance().getString('cms',
						'deleteEntryQTitle'),
						Alert.YES |
						Alert.NO, null, deleteEntries);
				}
			} 
			else {
				if (_isPlaylist) {
					Alert.show(ResourceManager.getInstance().getString('cms', 'deleteSelectedPlaylists'),
						ResourceManager.getInstance().getString('cms',
						'deletePlaylistQTitle'),
						Alert.YES | Alert.NO, null,
						deleteEntries);
				} 
				else {
					Alert.show(ResourceManager.getInstance().getString('cms', 'deleteSelectedEntries'),
						ResourceManager.getInstance().getString('cms', 'deleteEntryQTitle'),
						Alert.YES | Alert.NO, null, deleteEntries);
				}
			}
		}


		/**
		 * Delete _entries entries with a multi request
		 */
		private function deleteEntries(event:CloseEvent):void {
			if (event.detail == Alert.YES) {
				_model.increaseLoadCounter();
				var mr:MultiRequest = new MultiRequest();
				for (var i:uint = 0; i < _entries.length; i++) {
					var deleteEntry:BorhanCall;
					// create the correct delete action by entry type, and track deletion.
					if (_entries[i] is BorhanPlaylist) {
						deleteEntry = new PlaylistDelete((_entries[i] as BorhanBaseEntry).id);
						KAnalyticsTracker.getInstance().sendEvent(KAnalyticsTrackerConsts.CONTENT, BorhanStatsBmcEventType.CONTENT_DELETE_PLAYLIST,
							"Playlists>DeletePlaylist", _entries[i].id);
						GoogleAnalyticsTracker.getInstance().sendToGA(GoogleAnalyticsConsts.CONTENT_DELETE_PLAYLIST, GoogleAnalyticsConsts.CONTENT);
					} else if (_entries[i] is BorhanMixEntry) {
						deleteEntry = new MixingDelete((_entries[i] as BorhanBaseEntry).id);
						KAnalyticsTracker.getInstance().sendEvent(KAnalyticsTrackerConsts.CONTENT, BorhanStatsBmcEventType.CONTENT_DELETE_MIX,
							"Delete Mix", _entries[i].id);
						GoogleAnalyticsTracker.getInstance().sendToGA(GoogleAnalyticsConsts.CONTENT_DELETE_MIX, GoogleAnalyticsConsts.CONTENT);
					} else {
						deleteEntry = new BaseEntryDelete((_entries[i] as BorhanBaseEntry).id);
						KAnalyticsTracker.getInstance().sendEvent(KAnalyticsTrackerConsts.CONTENT, BorhanStatsBmcEventType.CONTENT_DELETE_ITEM,
							"Delete Entry", _entries[i].id);
						GoogleAnalyticsTracker.getInstance().sendToGA(GoogleAnalyticsConsts.CONTENT_DELETE_MEDIA_ENTRY, GoogleAnalyticsConsts.CONTENT);
					}

					mr.addAction(deleteEntry);
				}

				mr.addEventListener(BorhanEvent.COMPLETE, result);
				mr.addEventListener(BorhanEvent.FAILED, fault);
				_model.context.kc.post(mr);
			}
		}


		override public function result(data:Object):void {
			super.result(data);
			_model.decreaseLoadCounter();
			var rm:IResourceManager = ResourceManager.getInstance();
			var erHeader:String = _isPlaylist ?  rm.getString('cms', 'deletePlaylists') : rm.getString('cms', 'deleteEntries');
			if (!checkError(data, erHeader)) {
				if (_isPlaylist) {
					Alert.show(rm.getString('cms', 'playlistsDeleted'), erHeader, 4, null, refresh);
				} else {
					Alert.show(rm.getString('cms', 'entriesDeleted'), erHeader, 4, null, refresh);
				}
			}
		}


		/**
		 * after server result - refresh the current list
		 */
		private function refresh(event:CloseEvent):void {
			var searchEvent:BMCSearchEvent;
			if (_model.listableVo.filterVo is BorhanMediaEntryFilterForPlaylist) {
				searchEvent = new BMCSearchEvent(BMCSearchEvent.DO_SEARCH_ENTRIES, _model.listableVo);
				searchEvent.dispatch();
			} else if (_entries[0] && _entries[0] is BorhanPlaylist) {
				//refresh the playlist 
				searchEvent = new BMCSearchEvent(BMCSearchEvent.SEARCH_PLAYLIST, _model.listableVo);
				searchEvent.dispatch();
				return;
			} else {
				searchEvent = new BMCSearchEvent(BMCSearchEvent.DO_SEARCH_ENTRIES, _model.listableVo);
				searchEvent.dispatch();
			}

		}
	}
}