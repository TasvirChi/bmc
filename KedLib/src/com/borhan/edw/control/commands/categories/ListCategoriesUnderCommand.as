package com.borhan.edw.control.commands.categories
{
	import com.borhan.commands.category.CategoryList;
	import com.borhan.dataStructures.HashMap;
	import com.borhan.edw.control.commands.KedCommand;
	import com.borhan.edw.model.FilterModel;
	import com.borhan.edw.model.datapacks.ContentDataPack;
	import com.borhan.edw.model.datapacks.ContextDataPack;
	import com.borhan.edw.model.datapacks.FilterDataPack;
	import com.borhan.edw.vo.CategoryVO;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmvc.control.BMvCEvent;
	import com.borhan.types.BorhanCategoryOrderBy;
	import com.borhan.vo.BorhanCategory;
	import com.borhan.vo.BorhanCategoryFilter;
	import com.borhan.vo.BorhanCategoryListResponse;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.resources.ResourceManager;
	
	public class ListCategoriesUnderCommand extends KedCommand {
		
		
		private var _branchCat:CategoryVO;
		
		private var _filterModel:FilterModel;
		
		private var _source:*;
		
		private var _onComplete:Function;
		
		override public function execute(event:BMvCEvent):void {
			_model.increaseLoadCounter();
			_filterModel = (_model.getDataPack(FilterDataPack) as FilterDataPack).filterModel;
			_branchCat = event.data as CategoryVO;
			_source = event.source;
			_onComplete = event.onComplete;
			
			var kcf:BorhanCategoryFilter = new BorhanCategoryFilter();
			kcf.orderBy = BorhanCategoryOrderBy.NAME_ASC;
			if (_branchCat) {
				kcf.parentIdEqual = _branchCat.id;
			}
			else {
				kcf.parentIdEqual = 0;
			}
//			kcf.orderBy = BorhanCategoryOrderBy.PARTNER_SORT_VALUE_DESC;
			var listCategories:CategoryList = new CategoryList(kcf);
			
			listCategories.addEventListener(BorhanEvent.COMPLETE, result);
			listCategories.addEventListener(BorhanEvent.FAILED, fault);
			
			_client.post(listCategories);
		}
		
		override public function result(data:Object):void {
			super.result(data);
			var limit:int = (_model.getDataPack(ContextDataPack) as ContextDataPack).singleLevelMaxCategories;
			if ((data.data as BorhanCategoryListResponse).totalCount > limit - 1) {
				Alert.show(ResourceManager.getInstance().getString('filter', 'catsSingleLevelExceeded', [limit - 1]));
			}
			else {
				if (_branchCat) {
					// set result in the existing tree 
					addCategoriesToTree((data.data as BorhanCategoryListResponse).objects, _filterModel.categoriesMapForEntries);
					addCategoriesToTree((data.data as BorhanCategoryListResponse).objects, _filterModel.categoriesMapForMod);
					addCategoriesToTree((data.data as BorhanCategoryListResponse).objects, _filterModel.categoriesMapForCats);
					addCategoriesToTree((data.data as BorhanCategoryListResponse).objects, _filterModel.categoriesMapGeneral);
				}
				else {
					// use result as tree base
					_filterModel.categoriesForEntries = addCategoriesToTree((data.data as BorhanCategoryListResponse).objects, _filterModel.categoriesMapForEntries);
					_filterModel.categoriesForMod = addCategoriesToTree((data.data as BorhanCategoryListResponse).objects, _filterModel.categoriesMapForMod);
					_filterModel.categoriesForCats = addCategoriesToTree((data.data as BorhanCategoryListResponse).objects, _filterModel.categoriesMapForCats);
					_filterModel.categoriesGeneral = addCategoriesToTree((data.data as BorhanCategoryListResponse).objects, _filterModel.categoriesMapGeneral);
				}
			}
			if (_source && _onComplete != null) {
				_onComplete.apply(_source, [_branchCat]);
			}
			_model.decreaseLoadCounter();
		}
		
		private function addCategoriesToTree(kCats:Array, catMap:HashMap):ArrayCollection {
			// create category VOs
			var categories:ArrayCollection = new ArrayCollection();
			var category:CategoryVO;
			
			// add to hashmap
			for each (var kCat:BorhanCategory in kCats) {
				category = new CategoryVO(kCat.id, kCat.name, kCat);
				catMap.put(kCat.id + '', category);
				categories.addItem(category)
			}
			
			// add to tree: list children on parent category
			if (_branchCat) {
				// get the matching catVo from the given hashmap so we add to all relevant catVos
				var catvo:CategoryVO = catMap.getValue(_branchCat.id.toString());
				if (!catvo.children) {
					catvo.children = new ArrayCollection();
				}
				for each (var cat:CategoryVO in categories) {
					catvo.children.addItem(cat);
				}
				// sort on partnerSortValue
				var temp:Array = catvo.children.source;
				if (temp.length > 1) {
					if (temp[0].category.partnerSortValue || temp[1].category.partnerSortValue) {
						// even if the first one has 0, if it is real order the second one will have a real value
						temp.sort(compareValues);
					}
					else {
						temp.sortOn("name");
					}
				}
			}
//			else {
//				// first level
//				_filterModel.categories = categories;
//			}
			return categories;
		}
		
		private function compareValues(a:CategoryVO, b:CategoryVO, fields:Array = null):int {
			if (a == null && b == null)
				return 0;
			
			if (a == null)
				return 1;
			
			if (b == null)
				return -1;
			
			if (a.category.partnerSortValue < b.category.partnerSortValue)
				return -1;
			
			else if (a.category.partnerSortValue > b.category.partnerSortValue)
				return 1;
			
			return 0;
		}
	}
}