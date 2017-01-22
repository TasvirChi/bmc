package com.borhan.autocomplete.controllers
{
	import com.hillelcoren.components.AutoComplete;
	import com.hillelcoren.utils.StringUtils;
	import com.borhan.BorhanClient;
	import com.borhan.autocomplete.controllers.base.KACControllerBase;
	import com.borhan.autocomplete.itemRenderers.selection.CategorySelectedItem;
	import com.borhan.commands.category.CategoryList;
	import com.borhan.events.BorhanEvent;
	import com.borhan.net.BorhanCall;
	import com.borhan.vo.BorhanCategory;
	import com.borhan.vo.BorhanCategoryFilter;
	import com.borhan.vo.BorhanCategoryListResponse;
	
	import flash.events.Event;
	import flash.utils.setTimeout;
	
	import mx.collections.ArrayCollection;
	import mx.core.ClassFactory;
	import mx.utils.ArrayUtil;

	public class KACCategoryController extends KACControllerBase
	{
		public function KACCategoryController(autoComp:AutoComplete, client:BorhanClient)
		{
			super(autoComp, client);
			autoComp.dropDownLabelFunction = categoryLabelFunction;
			autoComp.selectionItemRendererClassFactory = new ClassFactory(CategorySelectedItem);
			autoComp.comparisonFunction = categoryComparison;
		}
		
		private function categoryComparison(itemA:Object, itemB:Object):Boolean{
			var categoryA:BorhanCategory = itemA as BorhanCategory;
			var categoryB:BorhanCategory = itemB as BorhanCategory;
			
			if (categoryA == null || categoryB == null){
				trace ("categoryComparison --> Trying to compare non-category object");
				return false;
			}
			
			return categoryA.id == categoryB.id;
		}
		
		override protected function createCallHook():BorhanCall{
			var filter:BorhanCategoryFilter = new BorhanCategoryFilter();
			filter.nameOrReferenceIdStartsWith = _autoComp.searchText;
			var listCategories:CategoryList = new CategoryList(filter);
			
			return listCategories;
		}
		
		override protected function fetchElements(data:Object):Array{
			var ret:Array = (data.data as BorhanCategoryListResponse).objects;
			if (ret != null){
				ret.sortOn("fullName", Array.CASEINSENSITIVE);
			}
			return ret;
		}
		
		private function categoryLabelFunction(item:Object):String{
			var category:BorhanCategory = item as BorhanCategory;
			
			var labelText:String = category.fullName;
			if (category.referenceId != null && category.referenceId != ""){
				labelText += " (" + category.referenceId + ")";
			}
			
			var searchStr:String = _autoComp.searchText;
			
			// there are problems using ">"s and "<"s in HTML
			labelText = labelText.replace( "<", "&lt;" ).replace( ">", "&gt;" );				
			
			var returnStr:String = StringUtils.highlightMatch( labelText, searchStr );
			
			var isDisabled:Boolean = false;
			var currCat:BorhanCategory = item as BorhanCategory;
			var kc:BorhanCategory;
			for each (kc in _autoComp.disabledItems.source){
				if (kc.id == currCat.id){
					isDisabled = true;
					break;
				}
			}
			
			var isSelected:Boolean = false;
			for each (kc in _autoComp.selectedItems.source){
				if (kc.id == currCat.id){
					isSelected = true;
					break;
				}
			}
			
			if (isSelected || isDisabled)
			{
				returnStr = "<font color='" + Consts.COLOR_TEXT_DISABLED + "'>" + returnStr + "</font>";
			}
			
			return returnStr;
		}
	}
}