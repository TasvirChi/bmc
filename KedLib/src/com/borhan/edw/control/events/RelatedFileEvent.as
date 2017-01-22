package com.borhan.edw.control.events
{
	import com.borhan.bmvc.control.BMvCEvent;
	import com.borhan.vo.BorhanAttachmentAsset;
	
	public class RelatedFileEvent extends BMvCEvent
	{
		public static const LIST_RELATED_FILES:String = "listRelatedFiles";
		public static const SAVE_ALL_RELATED:String = "saveAllRelated";
		public static const UPDATE_RELATED_FILE:String = "updateRelatedFile";

		public var attachmentAsset:BorhanAttachmentAsset;
		/**
		 * array of related files to add 
		 */		
		public var relatedToAdd:Array;
		/**
		 * array of related files to update 
		 */		
		public var relatedToUpdate:Array;
		/**
		 * array of related files to delete 
		 */		
		public var relatedToDelete:Array;
		
		public function RelatedFileEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}