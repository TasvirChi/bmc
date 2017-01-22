package com.borhan.edw.model.datapacks
{
	import com.borhan.bmvc.model.IDataPack;
	
	[Bindable]
	/**
	 * information about clips created from the current entry
	 * */
	public class ClipsDataPack implements IDataPack {
		
		public var shared:Boolean = false;
		
		/**
		 * clips derived from the current entry, 
		 * <code>BorhanBaseEntry</code> objects
		 */		
		public var clips:Array;
	}
}