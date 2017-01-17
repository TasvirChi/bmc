package com.borhan.edw.control.commands.dropFolder {
	import com.borhan.commands.dropFolderFile.DropFolderFileList;
	import com.borhan.edw.control.commands.KedCommand;
	import com.borhan.edw.control.events.DropFolderFileEvent;
	import com.borhan.edw.model.datapacks.DropFolderDataPack;
	import com.borhan.errors.BorhanError;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmvc.control.BMvCEvent;
	import com.borhan.types.BorhanDropFolderFileOrderBy;
	import com.borhan.types.BorhanDropFolderFileStatus;
	import com.borhan.vo.BorhanBaseEntry;
	import com.borhan.vo.BorhanDropFolderFile;
	import com.borhan.vo.BorhanDropFolderFileFilter;
	import com.borhan.vo.BorhanDropFolderFileListResponse;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.resources.ResourceManager;

	public class ListDropFoldersFilesCommand extends KedCommand {
		// list_all / df_list_by_selected_folder_hierch / df_list_by_selected_folder_flat
		protected var _eventType:String;

		protected var _entry:BorhanBaseEntry;

		protected var _dropFolderData:DropFolderDataPack;
		
		override public function execute(event:BMvCEvent):void {
			_model.increaseLoadCounter();
			_dropFolderData = _model.getDataPack(DropFolderDataPack) as DropFolderDataPack;
			var listEvent:DropFolderFileEvent = event as DropFolderFileEvent;
			_eventType = listEvent.type;
			_entry = listEvent.entry;
			var listFiles:DropFolderFileList;
			
//			// drop folders panel
//			if (_eventType == DropFolderFileEvent.LIST_ALL) {
//				listFiles = new DropFolderFileList(_model.dropFolderModel.filter, _model.dropFolderModel.pager);
//			}
			// match from drop folder popup
//			else {
				var filter:BorhanDropFolderFileFilter = new BorhanDropFolderFileFilter();
				filter.orderBy = BorhanDropFolderFileOrderBy.CREATED_AT_DESC;
				// use selected folder
				filter.dropFolderIdEqual = _dropFolderData.selectedDropFolder.id;
				// if searching for slug
				if (listEvent.slug) {
					filter.parsedSlugLike = listEvent.slug;
				}
				// file status
				filter.statusIn = BorhanDropFolderFileStatus.NO_MATCH + "," + BorhanDropFolderFileStatus.WAITING + "," + BorhanDropFolderFileStatus.ERROR_HANDLING;
				listFiles = new DropFolderFileList(filter);
//			}

			listFiles.addEventListener(BorhanEvent.COMPLETE, result);
			listFiles.addEventListener(BorhanEvent.FAILED, fault);

			_client.post(listFiles);
		}


		override public function result(data:Object):void {
			if (data.error) {
				var er:BorhanError = data.error as BorhanError;
				if (er) {
					Alert.show(er.errorMsg, "Error");
				}
			}
			else {
				var ar:Array = handleDropFolderFileList(data.data as BorhanDropFolderFileListResponse);
//				if (_eventType == DropFolderFileEvent.LIST_ALL) {
//					_model.dropFolderModel.files = new ArrayCollection(ar);
//					_model.dropFolderModel.filesTotalCount = data.data.totalCount;
//				}
//				else {
					_dropFolderData.dropFolderFiles = new ArrayCollection(ar);
//				}
			}
			_model.decreaseLoadCounter();
		}


		/**
		 * list hierarchical:
		 * 	group items by slug
		 *
		 * list all or list flat:
		 *  just push the items to the model
		 *  */
		protected function handleDropFolderFileList(lr:BorhanDropFolderFileListResponse):Array {
			var ar:Array; // results array
			if (_eventType == DropFolderFileEvent.LIST_BY_SELECTED_FOLDER_HIERCH) {
				ar = createHierarchicData(lr);
			}
			else if (_eventType == DropFolderFileEvent.LIST_BY_SELECTED_FOLDER_FLAT) {
				ar = createFlatData(lr);
			}
			else {
				ar = new Array();
				for each (var o:Object in lr.objects) {
					if (o is BorhanDropFolderFile) {
						ar.push(o);
					}
				}
			}
			return ar;
		}


		protected function createFlatData(lr:BorhanDropFolderFileListResponse):Array {
			var dff:BorhanDropFolderFile;
			var ar:Array = new Array(); // results array
			var arWait:Array = new Array(); // waiting array

			for each (var o:Object in lr.objects) {
				if (o is BorhanDropFolderFile) {
					dff = o as BorhanDropFolderFile;
					// for files in status waiting, we only want files with a matching slug
					if (dff.status == BorhanDropFolderFileStatus.WAITING) {
						if (dff.parsedSlug != _entry.referenceId) {
							continue;
						}
						else {
							arWait.push(dff)
						}
					}
					// .. and all other fiels
					else {
						ar.push(dff);
					}
				}
			}

			// put the matched waiting files first
			while (arWait.length > 0) {
				ar.unshift(arWait.pop());
			}
			return ar;
		}


		/**
		 * Slug Based Folders:
		 * 	create a new dropfolderfile for each slug
		 * 	pouplate its createdAt property according to the file that created it.
		 * 	for each file:
		 * 	- if no matching slug object is found, create matching slug object.
		 * 	- update date on slug if needed
		 * 	- push the dff to the "files" attribute on the slug vo
		 */
		protected function createHierarchicData(lr:BorhanDropFolderFileListResponse):Array {
			var dff:BorhanDropFolderFile;
			var ar:Array = new Array(); // results array
			var dict:Object = new Object(); // slugs dictionary
			var group:BorhanDropFolderFile; // dffs group (by slug)

			var parseFailedStr:String = ResourceManager.getInstance().getString('dropfolders', 'parseFailed');
			for each (var o:Object in lr.objects) {
				if (o is BorhanDropFolderFile) {
					dff = o as BorhanDropFolderFile;
					// for files in status waiting, we only want files with a matching slug
					if (dff.status == BorhanDropFolderFileStatus.WAITING) {
						if (dff.parsedSlug != _entry.referenceId) {
							continue;
						}
					}
					// group all files where status == ERROR_HANDLING under same group
					if (dff.status == BorhanDropFolderFileStatus.ERROR_HANDLING) {
						dff.parsedSlug = parseFailedStr;
					}
					// get relevant group
					if (!dict[dff.parsedSlug]) {
						// create group
						group = new BorhanDropFolderFile();
						group.parsedSlug = dff.parsedSlug;
						group.createdAt = dff.createdAt;
						group.files = new Array();
						dict[group.parsedSlug] = group;
					}
					else {
						group = dict[dff.parsedSlug];
						// update date if needed
						if (group.createdAt > dff.createdAt) {
							group.createdAt = dff.createdAt;
						}
					}
					// add dff to files list
					group.files.push(dff);
					// if any file in the group is in waiting status, set the group to waiting:
					if (dff.status == BorhanDropFolderFileStatus.WAITING) {
						group.status = BorhanDropFolderFileStatus.WAITING;
					}
				}
			}
			var wait:BorhanDropFolderFile;
			for (var slug:String in dict) {
				if (slug != parseFailedStr) {
					if (dict[slug].status == BorhanDropFolderFileStatus.WAITING) {
						// we assume there's only one...
						wait = dict[slug] as BorhanDropFolderFile;
					}
					else {
						ar.push(dict[slug]);
					}
				}
			}
			// put the matched waiting file first
			if (wait) {
				ar.unshift(wait);
			}
			// put the parseFailed last
			if (dict[parseFailedStr]) {
				ar.push(dict[parseFailedStr]);
			}
			return ar;
		}
	}
}