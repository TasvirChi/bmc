package com.borhan.bmc.modules.content.model
{
	import com.borhan.vo.BorhanDropFolder;
	import com.borhan.vo.BorhanDropFolderFileFilter;
	import com.borhan.vo.BorhanFilterPager;
	
	import mx.collections.ArrayCollection;

	[Bindable]
	public class DropFolderModel {
		
//		/**
//		 * currently selected drop folder 
//		 */		
//		public var selectedDropFolder:BorhanDropFolder;	
		
		/**
		 * list of DropFolders 
		 */
		public var dropFolders:ArrayCollection;
		
		
		/**
		 * list of files from all drop folders
		 */
		public var files:ArrayCollection;
		
		/**
		 * drop folders files filter
		 * */
		public var filter:BorhanDropFolderFileFilter;

		/**
		 * drop folders files pager
		 * */
		public var pager:BorhanFilterPager;
		
		/**
		 * total amount of drop folder files
		 * */
		public var filesTotalCount:int;
	
	}
}