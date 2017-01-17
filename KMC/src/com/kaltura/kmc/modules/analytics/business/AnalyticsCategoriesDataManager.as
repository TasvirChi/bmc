package com.borhan.bmc.modules.analytics.business
{
	import com.borhan.edw.components.fltr.cat.data.ICategoriesDataManger;
	import com.borhan.edw.control.CategoriesTreeController;
	import com.borhan.edw.vo.CategoryVO;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * CategoriesDataManger to be used in analytics filter categories selection popup.
	 * Disable all data manipulation, use the given data provider as is.
	 * @author atar.shadmi
	 */
	public class AnalyticsCategoriesDataManager extends EventDispatcher implements ICategoriesDataManger
	{
		public function AnalyticsCategoriesDataManager()
		{
		}
		
		public function loadInitialData():void
		{
			// do nothing, data is provided externally
		}
		
		public function branchClicked(cat:CategoryVO):void
		{
			// do nothing, data is provided externally
		}
		
		public function resetData():void
		{
			// do nothing, data is provided externally
		}
		
		public function destroy():void
		{
		}
		
		public function get controller():CategoriesTreeController
		{
			return null;
		}
		
		public function set controller(value:CategoriesTreeController):void
		{
		}
		
		
	}
}