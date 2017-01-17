package com.borhan.autocomplete.controllers
{
	import com.hillelcoren.components.AutoComplete;
	import com.borhan.BorhanClient;
	import com.borhan.autocomplete.controllers.base.KACControllerBase;
	import com.borhan.autocomplete.itemRenderers.selection.TagsSelectedItem;
	import com.borhan.commands.tag.TagSearch;
	import com.borhan.net.BorhanCall;
	import com.borhan.types.BorhanTaggedObjectType;
	import com.borhan.vo.BorhanFilterPager;
	import com.borhan.vo.BorhanTag;
	import com.borhan.vo.BorhanTagFilter;
	import com.borhan.vo.BorhanTagListResponse;
	
	import mx.core.ClassFactory;
	
	public class KACTagsController extends KACControllerBase
	{
		private var _objType:String;
		
		public function KACTagsController(autoComp:AutoComplete, client:BorhanClient, objType:String)
		{
			super(autoComp, client);
//			autoComp.allowEditingSelectedValues = true;
			autoComp.selectionItemRendererClassFactory = new ClassFactory(TagsSelectedItem);
//			autoComp.allowEditingNewValues = true;
			_objType = objType;
		}
		
		override protected function createCallHook():BorhanCall{
			var filter:BorhanTagFilter = new BorhanTagFilter();
			filter.tagStartsWith = _autoComp.searchText;
			filter.objectTypeEqual = _objType;
			var pager:BorhanFilterPager = new BorhanFilterPager();
			
			// TODO: Check size limit?
			pager.pageSize = 30;
			pager.pageIndex = 0;
			
			var listTags:TagSearch = new TagSearch(filter, pager);
			return listTags;
		}
		
		override protected function fetchElements(data:Object):Array{
			if ((data.data as BorhanTagListResponse).objects != null) {
			var tags:Vector.<BorhanTag> = Vector.<BorhanTag>((data.data as BorhanTagListResponse).objects);
			var tagNames:Array = new Array();
			
			for each (var tag:BorhanTag in tags){
				tagNames.push(tag.tag);
			}
				
			return tagNames;
			
			} else {
				return new Array();
			}
		}
	}
}