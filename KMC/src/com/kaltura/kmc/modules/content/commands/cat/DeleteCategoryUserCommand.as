package com.borhan.bmc.modules.content.commands.cat
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.commands.MultiRequest;
	import com.borhan.commands.category.CategoryGet;
	import com.borhan.commands.categoryUser.CategoryUserDelete;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmc.modules.content.commands.BorhanCommand;
	import com.borhan.bmc.modules.content.events.CategoryEvent;
	import com.borhan.bmc.modules.content.events.CategoryUserEvent;
	import com.borhan.vo.BorhanCategory;
	import com.borhan.vo.BorhanCategoryUser;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
	public class DeleteCategoryUserCommand extends BorhanCommand {
		
		private var _usrs:Array;
		private var _eventType:String;
		
		override public function execute(event:CairngormEvent):void {
		
			// event.data is [BorhanCategoryUser]
			_usrs = event.data;
			
			if (!_model.categoriesModel.categoryUserFirstAction) {
				var rm:IResourceManager = ResourceManager.getInstance();
				Alert.show(rm.getString('cms', 'catUserFirstAction'), rm.getString('cms', 'catUserFirstActionTitle'), Alert.OK|Alert.CANCEL, null, afterConfirm);
				_model.categoriesModel.categoryUserFirstAction = true;
			}
			else {
				afterConfirm();
			}
		}
		
		private function afterConfirm(event:CloseEvent = null):void {
			if (event && event.detail == Alert.CANCEL) {
				return;
			}
			
			_model.increaseLoadCounter();
			
			var mr:MultiRequest = new MultiRequest();
			var cu:BorhanCategoryUser;
			for (var i:int = 0; i<_usrs.length; i++) {
				cu = _usrs[i] as BorhanCategoryUser;
				mr.addAction(new CategoryUserDelete(cu.categoryId, cu.userId));
			} 	
			var getCat:CategoryGet = new CategoryGet(cu.categoryId);
			mr.addAction(getCat);
			mr.addEventListener(BorhanEvent.COMPLETE, result);
			mr.addEventListener(BorhanEvent.FAILED, fault);
			_model.context.kc.post(mr);	   
		}
		
		override public function result(data:Object):void {
			super.result(data);
			if (!checkError(data)) {
				var cg:CategoryEvent = new CategoryEvent(CategoryEvent.LIST_CATEGORY_USERS);
				cg.dispatch();
				// set new numbers of members to the category object
				var updatedCat:BorhanCategory = data.data[data.data.length-1] as BorhanCategory;
				_model.categoriesModel.selectedCategory.membersCount = updatedCat.membersCount;
				_model.categoriesModel.selectedCategory.pendingMembersCount = updatedCat.pendingMembersCount;
			}
			_model.decreaseLoadCounter();
		}
	}
}