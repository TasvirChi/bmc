package com.borhan.edw.vo
{
	import com.borhan.vo.BorhanAttachmentAsset;
	
	import flash.net.FileReference;
	import com.borhan.edw.vo.AssetVO;

	[Bindable]
	/**
	 * RelatedFileVO contains all relvant data for an entry's related file 
	 * @author Michal
	 * 
	 */	
	public class RelatedFileVO extends AssetVO
	{
		public static var serveURL:String = "/api_v3/index.php/service/attachment_attachmentasset/action/serve";		
		/**
		 * file asset
		 * */
		public var file:BorhanAttachmentAsset;
		
		public var fileReference:FileReference;
	
		public function RelatedFileVO()
		{
		}
	}
}