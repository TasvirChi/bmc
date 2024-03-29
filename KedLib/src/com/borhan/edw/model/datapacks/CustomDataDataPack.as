package com.borhan.edw.model.datapacks
{
	import com.borhan.bmvc.model.IDataPack;
	
	import mx.collections.ArrayCollection;
	
	[Bindable]
	public class CustomDataDataPack implements IDataPack {
		
		public var shared:Boolean = false;
		
		/**
		 * array of EntryMetadataDataVO;
		 * */
		public var metadataInfoArray:ArrayCollection;
		
		/**
		 * uiconf id used with metadata,
		 * shared between all models
		 * */
		public static var metadataDefaultUiconf:int;
		
		/**
		 * default metadata view uiconf xml,
		 * shared between all models
		 * */
		public static var metadataDefaultUiconfXML:XML;
	}
}