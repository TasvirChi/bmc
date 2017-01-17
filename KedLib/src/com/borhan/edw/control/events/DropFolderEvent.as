package com.borhan.edw.control.events {
	import com.borhan.bmvc.control.BMvCEvent;
	import com.borhan.vo.BorhanDropFolder;
	
	import mx.controls.Alert;

	public class DropFolderEvent extends BMvCEvent {


		/**
		 * list drop folders that are configured for slug matching 
		 */
		public static const LIST_MATCH_FOLDERS:String = "df_list_match_folders";
		
		/**
		 * list all enabled drop folders 
		 */
		public static const LIST_FOLDERS:String = "df_list_folders";
		
		
//		/**
//		 * list all enabled drop folders, then list files for the folders in the list 
//		 */
//		public static const LIST_FOLDERS_AND_FILES:String = "df_list_folders_and_files";
		
		
		
		/**
		 * set selected drop folder to the supplied drop folder 
		 */
		public static const SET_SELECTED_FOLDER:String = "df_set_selected_folder";
		
		
		private var _folder:BorhanDropFolder;
		
		private var _flags:uint;
		

		public function DropFolderEvent(type:String, folder:BorhanDropFolder = null, folderFlags:uint = 0x0, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			_folder = folder;
			_flags = folderFlags;
		}


		/**
		 * the drop folder this event referes to
		 */
		public function get folder():BorhanDropFolder {
			return _folder;
		}

		
		/**
		 * list flags 
		 * */
		public function get flags():uint {
			return _flags;
		}


	}
}