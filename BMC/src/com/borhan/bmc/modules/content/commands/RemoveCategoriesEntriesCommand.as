package com.borhan.bmc.modules.content.commands
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.commands.MultiRequest;
	import com.borhan.commands.categoryEntry.CategoryEntryDelete;
	import com.borhan.errors.BorhanError;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmc.modules.content.events.EntriesEvent;
	import com.borhan.bmc.modules.content.events.BMCSearchEvent;
	import com.borhan.vo.BorhanBaseEntry;
	import com.borhan.vo.BorhanCategory;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;

	public class RemoveCategoriesEntriesCommand extends BorhanCommand {
		
		override public function execute(event:CairngormEvent):void {
			_model.increaseLoadCounter();
			
			var e:EntriesEvent = event as EntriesEvent;
			var categories:Array = e.data as Array; // elements are BorhanCategories
			// for each entry, if it has the category remove it.
			var entries:Array = _model.selectedEntries;
			
			var ced:CategoryEntryDelete;
			var mr:MultiRequest = new MultiRequest();
			for each (var kbe:BorhanBaseEntry in entries) {
				for each (var kc:BorhanCategory in categories) {
					ced = new CategoryEntryDelete(kbe.id, kc.id);
					mr.addAction(ced);
				}
			}
			
			
			mr.addEventListener(BorhanEvent.COMPLETE, result);
			mr.addEventListener(BorhanEvent.FAILED, fault);
			_model.context.kc.post(mr);
			
		}
		
		override public function result(data:Object):void {
			super.result(data);
			_model.decreaseLoadCounter();
			
			// look for error
			var str:String = '';
			var er:BorhanError = (data as BorhanEvent).error;
			var rm:IResourceManager = ResourceManager.getInstance();
			if (er) {
				str = rm.getString('cms', er.errorCode);
				if (!str) {
					str = er.errorMsg;
				} 
				Alert.show(str, rm.getString('cms', 'error'));
				
			}
			else {
				// look inside MR, ignore irrelevant
				for each (var o:Object in data.data) {
					er = o as BorhanError;
					if (er) {
						if (er.errorCode != "ENTRY_IS_NOT_ASSIGNED_TO_CATEGORY") {
							str = rm.getString('cms', er.errorCode);
							if (!str) {
								str = er.errorMsg;
							} 
							Alert.show(str, rm.getString('cms', 'error'));
						}
					}
					else if (o.error) {
						// in MR errors aren't created
						if (o.error.code != "ENTRY_IS_NOT_ASSIGNED_TO_CATEGORY") {
							str = rm.getString('cms', o.error.code);
							if (!str) {
								str = o.error.message;
							} 
							Alert.show(str, rm.getString('cms', 'error'));
						}
					}
				}	
			}
			var searchEvent:BMCSearchEvent = new BMCSearchEvent(BMCSearchEvent.DO_SEARCH_ENTRIES , _model.listableVo  );
			searchEvent.dispatch();
		}
	}
}