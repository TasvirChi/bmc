package com.borhan.bmc.modules.content.commands {
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.commands.MultiRequest;
	import com.borhan.commands.baseEntry.BaseEntryUpdate;
	import com.borhan.commands.playlist.PlaylistUpdate;
	import com.borhan.edw.business.EntryUtil;
	import com.borhan.edw.control.events.SearchEvent;
	import com.borhan.errors.BorhanError;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmc.modules.content.commands.BorhanCommand;
	import com.borhan.bmc.modules.content.events.CategoryEvent;
	import com.borhan.bmc.modules.content.events.EntriesEvent;
	import com.borhan.bmc.modules.content.events.BMCSearchEvent;
	import com.borhan.bmc.modules.content.events.WindowEvent;
	import com.borhan.types.BorhanEntryStatus;
	import com.borhan.vo.BorhanBaseEntry;
	import com.borhan.vo.BorhanMixEntry;
	import com.borhan.vo.BorhanPlaylist;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.resources.ResourceManager;

	/**
	 * This class is the Cairngorm command for updating multiple entries, or playlist.
	 * */
	public class UpdateEntriesCommand extends BorhanCommand {

		/**
		 * the updated entries.
		 * */
		private var _entries:ArrayCollection;

		/**
		 * are the entries being updated playlist entries
		 * */
		private var _isPlaylist:Boolean;


		override public function execute(event:CairngormEvent):void {
			var e:EntriesEvent = event as EntriesEvent;
			_entries = e.entries;
			if (e.entries.length > 50) {
				Alert.show(ResourceManager.getInstance().getString('cms', 'updateLotsOfEntriesMsg', [_entries.length]),
					ResourceManager.getInstance().getString('cms', 'updateLotsOfEntriesTitle'),
					Alert.YES | Alert.NO, null, responesFnc);
			}
			// for small update
			else {
				_model.increaseLoadCounter();
				var mr:MultiRequest = new MultiRequest();
				for (var i:uint = 0; i < e.entries.length; i++) {
					var keepId:String = (e.entries[i] as BorhanBaseEntry).id;

					// only send conversionProfileId if the entry is in no_content status
					if (e.entries[i].status != BorhanEntryStatus.NO_CONTENT) {
						e.entries[i].conversionProfileId = int.MIN_VALUE;
					}
					
					//handle playlist items
					if (e.entries[i] is BorhanPlaylist) {
						_isPlaylist = true;
						var plE:BorhanPlaylist = e.entries[i] as BorhanPlaylist;
						plE.setUpdatedFieldsOnly(true);
						var updatePlEntry:PlaylistUpdate = new PlaylistUpdate(keepId, plE);
						mr.addAction(updatePlEntry);
					}
					else {
						var be:BorhanBaseEntry = e.entries[i] as BorhanBaseEntry;
						be.setUpdatedFieldsOnly(true);
						if (be is BorhanMixEntry)
							(be as BorhanMixEntry).dataContent = null;
						// don't send categories - we use categoryEntry service to update them in EntryData panel
						be.categories = null;
						be.categoriesIds = null;
						
						var updateEntry1:BaseEntryUpdate = new BaseEntryUpdate(keepId, be);
						mr.addAction(updateEntry1);
					}
				}

				mr.addEventListener(BorhanEvent.COMPLETE, result);
				mr.addEventListener(BorhanEvent.FAILED, fault);
				_model.context.kc.post(mr);
				
			}
		}


		/**
		 * alert window closed
		 * */
		private function responesFnc(event:CloseEvent):void {
			if (event.detail == Alert.YES) {
				// update:
				var numOfGroups:int = Math.floor(_entries.length / 50);
				var lastGroupSize:int = _entries.length % 50;
				if (lastGroupSize != 0) {
					numOfGroups++;
				}

				var groupSize:int;
				var mr:MultiRequest;
				for (var groupIndex:int = 0; groupIndex < numOfGroups; groupIndex++) {
					mr = new MultiRequest();
					mr.addEventListener(BorhanEvent.COMPLETE, result);
					mr.addEventListener(BorhanEvent.FAILED, fault);
					mr.queued = false;

					groupSize = (groupIndex < (numOfGroups - 1)) ? 50 : lastGroupSize;
					for (var entryIndexInGroup:int = 0; entryIndexInGroup < groupSize; entryIndexInGroup++) {
						var index:int = ((groupIndex * 50) + entryIndexInGroup);
						var keepId:String = (_entries[index] as BorhanBaseEntry).id;
						var be:BorhanBaseEntry = _entries[index] as BorhanBaseEntry;
						be.setUpdatedFieldsOnly(true);
						// only send conversionProfileId if the entry is in no_content status
						if (be.status != BorhanEntryStatus.NO_CONTENT) {
							be.conversionProfileId = int.MIN_VALUE;
						}
						// don't send categories - we use categoryEntry service to update them in EntryData panel
						be.categories = null;
						be.categoriesIds = null;
						
						var updateEntry:BaseEntryUpdate = new BaseEntryUpdate(keepId, be);
						mr.addAction(updateEntry);
					}
					_model.increaseLoadCounter();
					_model.context.kc.post(mr);
				}
			}
			else {
				// announce no update:
				Alert.show(ResourceManager.getInstance().getString('cms', 'noUpdateMadeMsg'),
					ResourceManager.getInstance().getString('cms', 'noUpdateMadeTitle'));
			}
		}


		/**
		 * load success handler
		 * */
		override public function result(data:Object):void {
			super.result(data);
			var searchEvent:BMCSearchEvent;
			if (!checkError(data)) {
				if (_isPlaylist) {
					// refresh playlists list
					searchEvent = new BMCSearchEvent(BMCSearchEvent.SEARCH_PLAYLIST, _model.listableVo);
					searchEvent.dispatch();
					var cgEvent:WindowEvent = new WindowEvent(WindowEvent.CLOSE);
					cgEvent.dispatch();
				}
				else {
					for each (var entry:BorhanBaseEntry in data.data) {
						EntryUtil.updateSelectedEntryInList(entry, _model.listableVo.arrayCollection); 
					}
				}
			}
			else {
				// reload data to reset changes that weren't made
				if (_isPlaylist) {
					searchEvent = new BMCSearchEvent(BMCSearchEvent.SEARCH_PLAYLIST, _model.listableVo);
					searchEvent.dispatch();
				}
				else {
					searchEvent = new BMCSearchEvent(BMCSearchEvent.DO_SEARCH_ENTRIES, _model.listableVo);
					searchEvent.dispatch();
				}
			}
			_model.decreaseLoadCounter();
		}

	}
}