package com.borhan.bmc.modules.content.commands.cat
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.commands.category.CategoryList;
	import com.borhan.errors.BorhanError;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmc.modules.content.commands.BorhanCommand;
	import com.borhan.bmc.modules.content.events.CategoryEvent;
	import com.borhan.bmc.modules.content.model.CategoriesModel;
	import com.borhan.types.BorhanCategoryOrderBy;
	import com.borhan.vo.BorhanCategory;
	import com.borhan.vo.BorhanCategoryFilter;
	import com.borhan.vo.BorhanCategoryListResponse;
	import com.borhan.vo.BorhanFilterPager;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.resources.ResourceManager;

	public class GetSubCategoriesCommand extends BorhanCommand {
		
		override public function execute(event:CairngormEvent):void {
			switch (event.type) {
				case CategoryEvent.RESET_SUB_CATEGORIES:
					_model.categoriesModel.subCategories = null;
					break;
				
				case CategoryEvent.GET_SUB_CATEGORIES:
					_model.increaseLoadCounter();
					
					// filter
					var f:BorhanCategoryFilter = new BorhanCategoryFilter();
					f.parentIdEqual = _model.categoriesModel.selectedCategory.id;
					f.orderBy = BorhanCategoryOrderBy.NAME_DESC;
					// pager
					var p:BorhanFilterPager = new BorhanFilterPager();
					p.pageSize = CategoriesModel.SUB_CATEGORIES_LIMIT;
					p.pageIndex = 1;
					
					var listCategories:CategoryList = new CategoryList(f, p);
					listCategories.addEventListener(BorhanEvent.COMPLETE, result);
					listCategories.addEventListener(BorhanEvent.FAILED, fault);
					_model.context.kc.post(listCategories);
					break;
			}
		}
		
		
		override public function result(data:Object):void {
			_model.decreaseLoadCounter();
			super.result(data);
			
			var er:BorhanError = (data as BorhanEvent).error;
			if (er) { 
				Alert.show(getErrorText(er), ResourceManager.getInstance().getString('cms', 'error'));
				return;
			}
			if ((data.data as BorhanCategoryListResponse).totalCount <= CategoriesModel.SUB_CATEGORIES_LIMIT) {
				// only set to model if less than 50
				var ar:Array = (data.data as BorhanCategoryListResponse).objects;
				if (ar && ar.length > 1) {
					if (ar[0].partnerSortValue || ar[1].partnerSortValue) { 
						ar.sortOn("partnerSortValue", Array.NUMERIC);
					}
					else {
						ar.sortOn("name");
					}
				}
				_model.categoriesModel.subCategories = new ArrayCollection(ar);
			}
		}
		
	}
}