package com.borhan.edw.control.commands.categories
{
	import com.borhan.commands.category.CategoryList;
	import com.borhan.dataStructures.HashMap;
	import com.borhan.edw.control.commands.KedCommand;
	import com.borhan.edw.model.FilterModel;
	import com.borhan.edw.model.datapacks.FilterDataPack;
	import com.borhan.edw.vo.CategoryVO;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmvc.control.BMvCEvent;
	import com.borhan.types.BorhanCategoryOrderBy;
	import com.borhan.vo.BorhanCategory;
	import com.borhan.vo.BorhanCategoryFilter;
	import com.borhan.vo.BorhanCategoryListResponse;
	
	import mx.collections.ArrayCollection;

	public class ListAllCategoriesCommand extends KedCommand {
		
		private var _source:*;
		
		private var _onComplete:Function;
		
		private var _filterModel:FilterModel;
		
		override public function execute(event:BMvCEvent):void {
			_model.increaseLoadCounter();
			
			_source = event.source;
			_onComplete = event.onComplete;
			
			var f:BorhanCategoryFilter = new BorhanCategoryFilter();
			f.orderBy = BorhanCategoryOrderBy.NAME_ASC;
			var listCategories:CategoryList = new CategoryList(f);
			// listeners
			listCategories.addEventListener(BorhanEvent.COMPLETE, result);
			listCategories.addEventListener(BorhanEvent.FAILED, fault);
			
			_client.post(listCategories);
		}
		
		override public function result(data:Object):void {
			super.result(data);
			_filterModel = (_model.getDataPack(FilterDataPack) as FilterDataPack).filterModel;
			// set root level categories to the model
			_filterModel.categoriesForEntries = buildCategoriesHyrarchy((data.data as BorhanCategoryListResponse).objects, _filterModel.categoriesMapForEntries);
			// set root level categories to the model
			_filterModel.categoriesForMod = buildCategoriesHyrarchy((data.data as BorhanCategoryListResponse).objects, _filterModel.categoriesMapForMod);
			// set root level categories to the model
			_filterModel.categoriesForCats = buildCategoriesHyrarchy((data.data as BorhanCategoryListResponse).objects, _filterModel.categoriesMapForCats);
			// set root level categories to the model
			_filterModel.categoriesGeneral = buildCategoriesHyrarchy((data.data as BorhanCategoryListResponse).objects, _filterModel.categoriesMapGeneral);
			_model.decreaseLoadCounter();
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
				if (category.children && category.children.length > 1) {
					temp = category.children.source;
					if (temp[0].category.partnerSortValue || temp[1].category.partnerSortValue) {
						// even if the first one has 0, if it is real order the second one will have a real value
						temp.sort(compareValues);
					}
					else {
						temp.sortOn("name");
					}
				}
			}
			
			return rootLevel;
		}
		
		
//		private function sortCategories(catArrCol:ArrayCollection):void {
//			// using this messes up "for each" loops!!!!
//			var dataSort:Sort = new Sort();
//			dataSort.compareFunction = compareValues;
//			catArrCol.sort = dataSort;
//			catArrCol.refresh();
//		}
		
		private function compareValues(a:CategoryVO, b:CategoryVO, fields:Array = null):int {
			if (a == null && b == null)
				return 0;
			
			if (a == null)
				return 1;
			
			if (b == null)
				return -1;
			
			if (a.category.partnerSortValue < b.category.partnerSortValue)
				return -1;
			
			if (a.category.partnerSortValue > b.category.partnerSortValue)
				return 1;
			
			return 0;
		}
		
	}
}