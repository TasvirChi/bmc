package com.borhan.edw.model.datapacks
{
	import com.borhan.edw.model.FilterModel;
	import com.borhan.bmvc.model.IDataPack;
	
	[Bindable]
	/**
	 * gateway to access the filter model of BMC
	 * */
	public class FilterDataPack implements IDataPack {
		
		public var shared:Boolean = true;
		
		public var filterModel:FilterModel;
	}
}