package com.borhan.bmc.modules.content.commands.cat {
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.commands.MultiRequest;
	import com.borhan.commands.baseEntry.BaseEntryCount;
	import com.borhan.commands.category.CategoryList;
	import com.borhan.dataStructures.HashMap;
	import com.borhan.edw.business.KedJSGate;
	import com.borhan.edw.model.FilterModel;
	import com.borhan.edw.model.datapacks.EntryDataPack;
	import com.borhan.edw.model.types.APIErrorCode;
	import com.borhan.edw.vo.CategoryVO;
	import com.borhan.errors.BorhanError;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmc.modules.content.commands.BorhanCommand;
	import com.borhan.types.BorhanEntryStatus;
	import com.borhan.types.BorhanMediaType;
	import com.borhan.vo.BorhanCategory;
	import com.borhan.vo.BorhanCategoryFilter;
	import com.borhan.vo.BorhanCategoryListResponse;
	import com.borhan.vo.BorhanFilterPager;
	import com.borhan.vo.BorhanMediaEntryFilter;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.controls.Alert;
	import mx.resources.ResourceManager;

	public class ListCategoriesCommand extends BorhanCommand {
		
		private var _filterModel:FilterModel;
		
		override public function execute(event:CairngormEvent):void {
			_model.increaseLoadCounter();
			// reset selected categories
			_model.categoriesModel.selectedCategories = [];
			
			if (event.data) {
				_model.categoriesModel.filter = event.data[0] as BorhanCategoryFilter;
				_model.categoriesModel.pager = event.data[1] as BorhanFilterPager;
				if (event.data.length > 2) {
					if (event.data[2]) {
						// reload categories for tree
						if (_model.filterModel.catTreeDataManager) {
							_model.filterModel.catTreeDataManager.resetData();
						}
					}
				}
			}
			
			var listCategories:CategoryList = new CategoryList(_model.categoriesModel.filter, _model.categoriesModel.pager);

			listCategories.addEventListener(BorhanEvent.COMPLETE, result);
			listCategories.addEventListener(BorhanEvent.FAILED, fault);
			_model.context.kc.post(listCategories);
		}


		override public function result(data:Object):void {
			_model.decreaseLoadCounter();
			super.result(data);
			if (!checkError(data)) {		
//			var er:BorhanError = (data as BorhanEvent).error;
//			if (er) { 
//				Alert.show(getErrorText(er), ResourceManager.getInstance().getString('cms', 'error'));
//				return;
//			}
				_model.categoriesModel.categoriesList = new ArrayCollection((data.data as BorhanCategoryListResponse).objects);
				_model.categoriesModel.totalCategories = (data.data as BorhanCategoryListResponse).totalCount;
			}
		}
		
		
		


	}
}