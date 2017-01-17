package com.borhan.bmc.modules.content.model
{
	import com.borhan.vo.BorhanBulkUploadFilter;
	import com.borhan.vo.BorhanFilterPager;
	
	import mx.collections.ArrayCollection;

	[Bindable]
	/**
	 * data used by <code>BulkUpload</code> panel
	 */
	public class BulkUploadModel {
		
		/**
		 * the last filter used in list action in bulk uploads log page 
		 */		
		public var lastFilterUsed:BorhanBulkUploadFilter;
		
		/**
		 * the last pager used in list action in bulk uploads log page 
		 */		
		public var lastPagerUsed:BorhanFilterPager;
		
		/**
		 * list of <code>BorhanBulkUpload</code>
		 * used as dataprovider in <code>BulkUpload</code>
		 * */
		public var bulkUploads:ArrayCollection = null;
		
		/**
		 * total count for pager in <code>BulkUpload</code>
		 * */
		public var bulkUploadTotalCount:int = 0;
		
		/**
		 * list of <code>ConversionProfileVO</code>
		 * data provider for conversion profiles cb in <code>BulkUpload</code> panel 
		 */
		public var conversionData:ArrayCollection;
		
		/**
		 * the default conversion profile for this partner 
		 */		
		public var defaultConversionProfileId:int;
		
		/**
		 * call this JS function to open CW
		 */
		public var openCw:String = "openCw";
	}
}