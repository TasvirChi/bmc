package com.borhan.edw.control.commands
{
	import com.borhan.commands.category.CategoryList;
	import com.borhan.commands.categoryEntry.CategoryEntryList;
	import com.borhan.edw.control.events.KedEntryEvent;
	import com.borhan.edw.model.datapacks.EntryDataPack;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmvc.control.BMvCEvent;
	import com.borhan.vo.BorhanCategoryEntry;
	import com.borhan.vo.BorhanCategoryEntryFilter;
	import com.borhan.vo.BorhanCategoryEntryListResponse;
	import com.borhan.vo.BorhanCategoryFilter;
	import com.borhan.vo.BorhanCategoryListResponse;
	import com.borhan.vo.BorhanFilterPager;
	
	import mx.collections.ArrayCollection;

	public class GetEntryCategoriesCommand extends KedCommand {
		
		override public function execute(event:BMvCEvent):void {
			var edp:EntryDataPack = _model.getDataPack(EntryDataPack) as EntryDataPack;
			switch (event.type) {
				case KedEntryEvent.RESET_ENTRY_CATEGORIES:
					edp.entryCategories = new ArrayCollection();
					break;
				case KedEntryEvent.GET_ENTRY_CATEGORIES:
					_model.increaseLoadCounter();
					
					// get a list of BorhanCategoryEntries
					var e:KedEntryEvent = event as KedEntryEvent;
					
					var f:BorhanCategoryEntryFilter = new BorhanCategoryEntryFilter();
					f.entryIdEqual = e.entryVo.id;
					var p:BorhanFilterPager = new BorhanFilterPager();
					p.pageSize = edp.maxNumCategories;
					var getcats:CategoryEntryList = new CategoryEntryList(f, p);
					
					getcats.addEventListener(BorhanEvent.COMPLETE, result);
					getcats.addEventListener(BorhanEvent.FAILED, fault);
					
					_client.post(getcats);
					break;
			}
		}
		
		
		override public function result(data:Object):void {
			super.result(data);
			var edp:EntryDataPack = _model.getDataPack(EntryDataPack) as EntryDataPack;
			if (data.data is BorhanCategoryEntryListResponse) {
				// get a list of BorhanCategories
				var kce:BorhanCategoryEntry;
				var str:String = '';
				var kces:Array = data.data.objects;
				if (!kces || !kces.length) {
					_model.decreaseLoadCounter();
					return;
				}
				
				for each (kce in kces) {
					str += kce.categoryId + ",";
				}
				var f:BorhanCategoryFilter = new BorhanCategoryFilter();
				f.idIn = str;
				var p:BorhanFilterPager = new BorhanFilterPager();
				p.pageSize = edp.maxNumCategories;
				var getcats:CategoryList = new CategoryList(f, p);
				
				getcats.addEventListener(BorhanEvent.COMPLETE, result);
				getcats.addEventListener(BorhanEvent.FAILED, fault);
				
				_client.post(getcats);
			}
			else if (data.data is BorhanCategoryListResponse) {
				// put the BorhanCategories on the model
				edp.entryCategories = new ArrayCollection((data.data as BorhanCategoryListResponse).objects);
				_model.decreaseLoadCounter();
			}
		}
	}
}