package com.borhan.edw.control.commands
{
	import com.borhan.commands.MultiRequest;
	import com.borhan.commands.categoryEntry.CategoryEntryAdd;
	import com.borhan.commands.categoryEntry.CategoryEntryDelete;
	import com.borhan.edw.control.events.KedEntryEvent;
	import com.borhan.errors.BorhanError;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmvc.control.BMvCEvent;
	import com.borhan.vo.BorhanCategory;
	import com.borhan.vo.BorhanCategoryEntry;
	
	import mx.controls.Alert;
	import mx.resources.ResourceManager;

	public class UpdateEntryCategoriesCommand extends KedCommand {
		
		override public function execute(event:BMvCEvent):void {
			_model.increaseLoadCounter();
			var e:KedEntryEvent = event as KedEntryEvent;
			var mr:MultiRequest = new MultiRequest();
			var toAdd:Array = e.data[0];	// categories to add to the entry
			var toRemove:Array = e.data[1];	// categories to remove from the entry
			
			var kCat:BorhanCategory;
			var ce:BorhanCategoryEntry;
			// add
			for each (kCat in toAdd) {
				ce = new BorhanCategoryEntry();
				ce.categoryId = kCat.id;
				ce.entryId = e.entryVo.id;
				mr.addAction(new CategoryEntryAdd(ce));
			} 
			// remove
			for each (kCat in toRemove) {
				ce = new BorhanCategoryEntry();
				mr.addAction(new CategoryEntryDelete(e.entryVo.id, kCat.id));
			} 
			
			
			mr.addEventListener(BorhanEvent.COMPLETE, result);
			mr.addEventListener(BorhanEvent.FAILED, fault);

			_client.post(mr);
		}
		
		
		override public function result(data:Object):void {
			super.result(data);
			var er:BorhanError = (data as BorhanEvent).error;
			for each (var o:Object in data.data) {
				er = o.error as BorhanError;
				if (er) {
					Alert.show(er.errorMsg, ResourceManager.getInstance().getString('drilldown', 'error'));
				}
			}
		
			_model.decreaseLoadCounter();
		}
	}
}