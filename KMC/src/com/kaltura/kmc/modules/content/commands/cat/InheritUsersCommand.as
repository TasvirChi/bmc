package com.borhan.bmc.modules.content.commands.cat
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.commands.MultiRequest;
	import com.borhan.commands.category.CategoryGet;
	import com.borhan.commands.categoryUser.CategoryUserCopyFromCategory;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmc.modules.content.commands.BorhanCommand;
	import com.borhan.bmc.modules.content.events.CategoryEvent;
	import com.borhan.net.BorhanCall;
	import com.borhan.vo.BorhanCategory;
	
	public class InheritUsersCommand extends BorhanCommand {
		
		
		override public function execute(event:CairngormEvent):void {
			_model.increaseLoadCounter();
			var catid:int = (event.data as BorhanCategory).id;
			var mr:MultiRequest = new MultiRequest();
			var call:BorhanCall = new CategoryUserCopyFromCategory(catid);
			mr.addAction(call);
			call = new CategoryGet(catid);
			mr.addAction(call);
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