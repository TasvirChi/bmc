package com.borhan.bmc.modules.content.business
{
	import com.borhan.vo.BorhanBaseEntryFilter;

	/**
	 * This interface declares methods that allow the Content module to comunicate with its subtabs.
	 * @author Atar
	 * 
	 */	
	public interface IContentPanel {
		
		/**
		 * initialize the panel, refresh data, etc.
		 * @param kbef	(optional) initial filtering data
		 */		
		function init(kbef:BorhanBaseEntryFilter = null):void;
		

	}
}