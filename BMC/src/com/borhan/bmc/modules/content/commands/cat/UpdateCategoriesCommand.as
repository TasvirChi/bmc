package com.borhan.bmc.modules.content.commands.cat
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.commands.MultiRequest;
	import com.borhan.commands.category.CategoryUpdate;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmc.business.CategoryUtils;
	import com.borhan.bmc.modules.content.commands.BorhanCommand;
	import com.borhan.bmc.modules.content.events.CategoryEvent;
	import com.borhan.vo.BorhanCategory;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.resources.ResourceManager;
	
	public class UpdateCategoriesCommand extends BorhanCommand {
		
		private var _categories:Array;
		
		private var _numOfGroups:int = 1;
		private var _callsCompleted:int = 0;
		private var _callFailed:Boolean = false;
		
		override public function execute(event:CairngormEvent):void
		{
			_categories = event.data as Array;
			if (_categories.length > 50) {
				Alert.show(ResourceManager.getInstance().getString('cms', 'updateLotsOfCategoriesMsg', [_categories.length]),
					ResourceManager.getInstance().getString('cms', 'updateLotsOfEntriesTitle'),
					Alert.YES | Alert.NO, null, responesFnc);
			}
			// for small update
			else {
				_model.increaseLoadCounter();
				var mr:MultiRequest = new MultiRequest();
				for each (var kCat:BorhanCategory in _categories) {
					kCat.setUpdatedFieldsOnly(true);
					CategoryUtils.resetUnupdateableFields(kCat);
					var update:CategoryUpdate = new CategoryUpdate(kCat.id, kCat);
					mr.addAction(update);
				}
				
				mr.addEventListener(BorhanEvent.COMPLETE, result);
				mr.addEventListener(BorhanEvent.FAILED, fault);
				_model.context.kc.post(mr); 
			}
		}
		
		
		
		/**
		 * handle large update
		 * */
		private function responesFnc(event:CloseEvent):void {
			if (event.detail == Alert.YES) {
				
				// update:
				_numOfGroups = Math.floor(_categories.length / 50);
				var lastGroupSize:int = _categories.length % 50;
				if (lastGroupSize != 0) {
					_numOfGroups++;
				}
				
				var groupSize:int;
				var mr:MultiRequest;
				for (var groupIndex:int = 0; groupIndex < _numOfGroups; groupIndex++) {
					mr = new MultiRequest();
					mr.addEventListener(BorhanEvent.COMPLETE, result);
					mr.addEventListener(BorhanEvent.FAILED, fault);
					mr.queued = false;
					
					groupSize = (groupIndex < (_numOfGroups - 1)) ? 50 : lastGroupSize;
					for (var entryIndexInGroup:int = 0; entryIndexInGroup < groupSize; entryIndexInGroup++) {
						var index:int = ((groupIndex * 50) + entryIndexInGroup);
						var keepId:int = (_categories[index] as BorhanCategory).id;
						var kCat:BorhanCategory = _categories[index] as BorhanCategory;
						kCat.setUpdatedFieldsOnly(true);
						CategoryUtils.resetUnupdateableFields(kCat);
						
						var update:CategoryUpdate = new CategoryUpdate(keepId, kCat);
						mr.addAction(update);
					}
					_model.increaseLoadCounter();
					_model.context.kc.post(mr);
				}
			}
			else {
				// announce no update:
				Alert.show(ResourceManager.getInstance().getString('cms', 'noUpdateMadeMsg'),
					ResourceManager.getInstance().getString('cms', 'noUpdateMadeTitle'));
			}
		}
		
		override public function result(data:Object):void {
			super.result(data);
			_model.decreaseLoadCounter();
			
			_callsCompleted ++;
			_callFailed ||= checkError(data);
			if (_callsCompleted == _numOfGroups) {
				if (!_callFailed) {
					Alert.show(ResourceManager.getInstance().getString('cms', 'catUpdtSuccess'));
				}
				
				// reload categories for table (also if no update, so values will be reset)
				var getCategoriesList:CategoryEvent = new CategoryEvent(CategoryEvent.LIST_CATEGORIES);
				getCategoriesList.dispatch();
			}
		}
	}
}