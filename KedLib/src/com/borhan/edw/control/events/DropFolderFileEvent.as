package com.borhan.edw.control.events {
	import com.borhan.bmvc.control.BMvCEvent;
	import com.borhan.vo.BorhanAssetsParamsResourceContainers;
	import com.borhan.vo.BorhanBaseEntry;
	import com.borhan.vo.BorhanResource;

	public class DropFolderFileEvent extends BMvCEvent {

		/**
		 * reset the drop folder files list on the model
		 */		
		public static const RESET_DROP_FOLDERS_AND_FILES:String = "df_reset_files_list";
		
//		/**
//		 * list all files from all drop folders
//		 * */
//		public static const LIST_ALL:String = "list_all";
		
		/**
		 * list files in selected folder and create the array hierarchical
		 * */
		public static const LIST_BY_SELECTED_FOLDER_HIERCH:String = "df_list_by_selected_folder_hierch";
		
		/**
		 * list files in selected folder and create the array flat
		 */		
		public static const LIST_BY_SELECTED_FOLDER_FLAT:String = "df_list_by_selected_folder_flat";
		
//		/**
//		 * delete files from drop folder?
//		 * */
//		public static const DELETE_FILES:String = "delete_files";

		private var _entry:BorhanBaseEntry;
		private var _slug:String;
		private var _resources:BorhanResource;
		private var _selectedFiles:Array;


		public function DropFolderFileEvent(type:String, entry:BorhanBaseEntry=null, slug:String=null, resource:BorhanResource=null, selectedFiles:Array=null, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			_entry = entry;
			_slug = slug;
			_resources = resource;
			_selectedFiles = selectedFiles;
		}


		public function get entry():BorhanBaseEntry {
			return _entry;
		}


		public function get slug():String {
			return _slug;
		}


		public function get resource():BorhanResource {
			return _resources;
		}
		
		public function get selectedFiles():Array {
			return _selectedFiles;
		}

	}
}