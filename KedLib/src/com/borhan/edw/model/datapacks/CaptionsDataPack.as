package com.borhan.edw.model.datapacks
{
	import com.borhan.bmvc.model.IDataPack;
	
	[Bindable]
	/**
	 * information regarding captions of the current entry
	 * */
	public class CaptionsDataPack implements IDataPack {
		
		public var shared:Boolean = false;
		
		/**
		 * Array of captionEntryVO
		 * */
		public var captionsArray:Array;
	}
}