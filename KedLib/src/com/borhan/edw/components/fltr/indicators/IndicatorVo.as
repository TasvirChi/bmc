package com.borhan.edw.components.fltr.indicators
{
	import com.borhan.edw.components.fltr.IFilterComponent;
	
	import mx.controls.Button;

	public class IndicatorVo {
		
		/**
		 * label to show on the box 
		 */
		public var label:String;
		
		/**
		 * box tooltip 
		 */
		public var tooltip:String;
		
		
		/**
		 * the field on the BorhanFilter this indicator refers to 
		 */
		public var attribute:String;
		
		
		/**
		 * a value that will allow the origin panel to identify
		 * the exact filter value, 
		 * i.e. for attribute mediaTypeIn, BorhanMediaType.VIDEO 
		 */		
		public var value:*;
		
		
	}
}