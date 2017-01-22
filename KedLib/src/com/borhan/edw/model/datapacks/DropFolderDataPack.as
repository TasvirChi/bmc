package com.borhan.edw.model.datapacks
{
	import com.borhan.bmvc.model.IDataPack;
	import com.borhan.vo.BorhanDropFolder;
	
	import mx.collections.ArrayCollection;
	
	[Bindable]
	public class DropFolderDataPack implements IDataPack {
		
		public var shared:Boolean = false;
		
		/**
		 * currently selected drop folder 
		 */		
		public var selectedDropFolder:BorhanDropFolder;
		
		/**
		 * list of DropFolders 
		 */
		public var dropFolders:ArrayCollection;
		
		/**
		 * list of files in the selected DropFolder
		 */
		public var dropFolderFiles:ArrayCollection;
	}
}