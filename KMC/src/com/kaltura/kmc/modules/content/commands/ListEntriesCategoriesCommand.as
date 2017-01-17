package com.borhan.bmc.modules.content.commands
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.commands.category.CategoryList;
	import com.borhan.commands.categoryEntry.CategoryEntryList;
	import com.borhan.errors.BorhanError;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmc.modules.content.events.EntriesEvent;
	import com.borhan.bmc.modules.content.view.window.RemoveCategoriesWindow;
	import com.borhan.vo.BorhanBaseEntry;
	import com.borhan.vo.BorhanCategory;
	import com.borhan.vo.BorhanCategoryEntry;
	import com.borhan.vo.BorhanCategoryEntryFilter;
	import com.borhan.vo.BorhanCategoryEntryListResponse;
	import com.borhan.vo.BorhanCategoryFilter;
	import com.borhan.vo.BorhanCategoryListResponse;
	import com.borhan.vo.BorhanFilterPager;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;

	public class ListEntriesCategoriesCommand extends BorhanCommand {
		
		private const CHUNK_SIZE:int = 20;
		
		/**
		 * reference to the window that triggered the command
		 * */
		private var _origin:RemoveCategoriesWindow; 

		/**
		 * index of last processed entry / categoryEntry 
		 */
		private var _lastObjectIndex:int;
		
		/**
		 * accumulated categoryEntries 
		 */		
		private var _categoryEntries:Array = [];
		
				
		override public function execute(event:CairngormEvent):void {
			
			if (event.type == EntriesEvent.RESET_SELECTED_ENTRIES_CATEGORIES) {
				_model.selectedEntriesCategories = null;
				return;	
			}
			
			_model.increaseLoadCounter();
			_model.selectedEntriesCategories = null;
			
			if (event.data is RemoveCategoriesWindow) {
				_origin = event.data as RemoveCategoriesWindow;
			}
			
			_lastObjectIndex = 0;
			listCategoryEntriesChunk();
		}
		
		/**
		 * get the next chunk of CategoryEntry objects
		 * */
		private function listCategoryEntriesChunk():void {
			var ids:String = '';
			
			var final:int = _lastObjectIndex + CHUNK_SIZE;
			if (final > _model.selectedEntries.length) {
				final = _model.selectedEntries.length;
			}
			
			for (var i:uint = _lastObjectIndex; i < final; i++) {
				ids += (_model.selectedEntries[i] as BorhanBaseEntry).id + ",";
			}
			var f:BorhanCategoryEntryFilter = new BorhanCategoryEntryFilter();
			f.entryIdIn = ids;
			
			var p:BorhanFilterPager = new BorhanFilterPager();
			p.pageIndex = 1;
			p.pageSize = 1000;	// very big number, should get all
			
			var list:CategoryEntryList = new CategoryEntryList(f, p);
			list.addEventListener(BorhanEvent.COMPLETE, listCategoryEntriesChunkResult);
			list.addEventListener(BorhanEvent.FAILED, fault);
			_model.context.kc.post(list);
			_lastObjectIndex = final;
		}
		
		
		/**
		 * see if need to get another CategoryEntry chunk, or start processing
		 * @param data
		 */		
		private function listCategoryEntriesChunkResult(data:BorhanEvent):void {
			super.result(data);
			if (!checkError(data)) {
				// concat result to previous results
				var curResult:Array = (data.data as BorhanCategoryEntryListResponse).objects;
				if (curResult && curResult.length) {
					// if categories were deleted or something and are still listed on the entry
					// but don't come back on list, we might get an empty array
					_categoryEntries = _categoryEntries.concat(curResult);
				}
				if (_lastObjectIndex < _model.selectedEntries.length) {
					listCategoryEntriesChunk();
				}
				else {
					// no more categoryEntries to list
					if (_categoryEntries.length) {
						_uniqueCategories = processCategoryEntries();
						_lastObjectIndex = 0;
						listCategoriesChunk();
					}
					else {
						// none of the entries was in any categories
						if (_origin) {
							// close the window (oish, this is ugly)
							_origin.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
							Alert.show(ResourceManager.getInstance().getString('cms', 'removeCategoriesNone'));
							_model.decreaseLoadCounter();
						}
					}
				}
			}
		}
		
		
		/**
		 * list of CategoryEntry objects so that every category id appears once 
		 */
		private var _uniqueCategories:Array;
		
		
		/**
		 * get a list of unique category ids from the accumulated CategoryEntries
		 */		
		private function processCategoryEntries():Array {
			var uniques:Array = [];
			var found:Boolean;
			for (var i:int = 0; i<_categoryEntries.length; i++) {
				found = false;
				for each (var kce:BorhanCategoryEntry in uniques) {
					if (kce.categoryId == _categoryEntries[i].categoryId) {
						found = true;
						break;
					}
				}
				if (!found) {
					uniques.push(_categoryEntries[i]);
				}
			}
			
			return uniques;
		}
		
		
		private function listCategoriesChunk():void {
			var ids:String = '';
			
			var final:int = _lastObjectIndex + CHUNK_SIZE;
			if (final > _uniqueCategories.length) {
				final = _uniqueCategories.length;
			}
			
			for (var i:uint = _lastObjectIndex; i < final; i++) {
				ids += (_uniqueCategories[i] as BorhanCategoryEntry).categoryId + ",";
			}
			
			var f:BorhanCategoryFilter = new BorhanCategoryFilter();
			f.idIn = ids;
			
			var p:BorhanFilterPager = new BorhanFilterPager();
			p.pageIndex = 1;
			p.pageSize = CHUNK_SIZE;	// very big number, should get all
			
			var list:CategoryList = new CategoryList(f, p);
			list.addEventListener(BorhanEvent.COMPLETE, listCategoriesChunkResult);
			list.addEventListener(BorhanEvent.FAILED, fault);
			_model.context.kc.post(list);
			_lastObjectIndex = final;
		}
		
		private var _categories:Array = [];
		
		
		private function listCategoriesChunkResult(data:BorhanEvent):void {
			super.result(data);
			_model.decreaseLoadCounter();
			if (!checkError(data)) {
				_categories = _categories.concat((data.data as BorhanCategoryListResponse).objects);
				
				if (_lastObjectIndex < _uniqueCategories.length) {
					listCategoriesChunk();
				}
				else {
					_model.selectedEntriesCategories = new ArrayCollection(_categories);
				}
			}
		}
		
	}
}