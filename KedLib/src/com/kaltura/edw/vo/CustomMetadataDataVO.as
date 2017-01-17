package com.borhan.edw.vo
{
	import com.borhan.edw.model.MetadataDataObject;
	import com.borhan.vo.BorhanMetadata;

	[Bindable]
	/**
	 * This value object holds any information relevant to metadata data 
	 * @author Michal
	 * 
	 */	
	public class CustomMetadataDataVO
	{
		/**
		 * dynamic object, represents metadata values
		 * */
		public var metadataDataObject:MetadataDataObject = new MetadataDataObject();
		
		public var finalViewMxml:XML;
		
		public var metadata:BorhanMetadata;
		
	}
}