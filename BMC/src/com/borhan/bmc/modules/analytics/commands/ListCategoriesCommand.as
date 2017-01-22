package com.borhan.bmc.modules.analytics.commands {
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.commands.category.CategoryList;
	import com.borhan.dataStructures.HashMap;
	import com.borhan.edw.vo.CategoryVO;
	import com.borhan.errors.BorhanError;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmc.business.CategoryUtils;
	import com.borhan.bmc.modules.analytics.model.AnalyticsModelLocator;
	import com.borhan.types.BorhanCategoryOrderBy;
	import com.borhan.vo.BorhanCategory;
	import com.borhan.vo.BorhanCategoryFilter;
	import com.borhan.vo.BorhanCategoryListResponse;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;

	public class ListCategoriesCommand implements ICommand, IResponder {
		private var _model:AnalyticsModelLocator = AnalyticsModelLocator.getInstance();


		public function execute(event:CairngormEvent):void {
			_model.loadingFlag = true;
			_model.loadingCategories = true;

			var f:BorhanCategoryFilter = new BorhanCategoryFilter();
			f.orderBy = BorhanCategoryOrderBy.NAME_ASC;
			var listCategories:CategoryList = new CategoryList(f);

			listCategories.addEventListener(BorhanEvent.COMPLETE, result);
			listCategories.addEventListener(BorhanEvent.FAILED, fault);
			_model.kc.post(listCategories);
		}


		public function fault(info:Object):void {
			_model.loadingCategories = true;
			_model.checkLoading();
			Alert.show(info.error.errorMsg, ResourceManager.getInstance().getString('analytics', 'error'));
		}


		public function result(event:Object):void {
			_model.loadingCategories = true;
			_model.checkLoading();

			var kclr:BorhanCategoryListResponse;
			var kc:BorhanCategory;

			if (event.data[0] is BorhanError) {
				Alert.show((event.data[0] as BorhanError).errorMsg, ResourceManager.getInstance().getString('analytics', 'error'));
			}
			else {
				_model.categories = buildCategoriesHyrarchy((event.data as BorhanCategoryListResponse).objects, _model.categoriesMap);
			}

		}
		
		private function buildCategoriesHyrarchy(kCats:Array, catMap:HashMap):ArrayCollection {
			var allCategories:ArrayCollection = new ArrayCollection();	// all categories, so we can scan them easily
			var rootLevel:ArrayCollection = new ArrayCollection();	// categories in the root level
			var category:CategoryVO;
			// create category VOs and add to hashmap
			for each (var kCat:BorhanCategory in kCats) {
				category = new CategoryVO(kCat.id, kCat.name, kCat);
				catMap.put(kCat.id + '', category);
				allCategories.addItem(category)
			}
			
			// create tree: list children on parent categories
			for each (category in allCategories) {
				var parentCategory:CategoryVO = catMap.getValue(category.category.parentId + '') as CategoryVO;
				if (parentCategory != null) {
					if (!parentCategory.children) {
						parentCategory.children = new ArrayCollection();
					}
					parentCategory.children.addItem(category);
				}
				else {
					// parent is root
					rootLevel.addItem(category);
				}
			}
			
			var temp:Array;
			// sort on partnerSortValue
			for each (category in allCategories) {
				if (category.children) {
					temp = category.children.source;
					temp.sort(CategoryUtils.compareValues);
				}
			}
			
			return rootLevel;
		}
		

	}
}
