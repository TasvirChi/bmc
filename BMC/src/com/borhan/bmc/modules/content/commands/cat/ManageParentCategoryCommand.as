package com.borhan.bmc.modules.content.commands.cat
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.commands.MultiRequest;
	import com.borhan.commands.category.CategoryGet;
	import com.borhan.commands.user.UserGet;
	import com.borhan.errors.BorhanError;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmc.modules.content.commands.BorhanCommand;
	import com.borhan.bmc.modules.content.events.CategoryEvent;
	import com.borhan.types.BorhanInheritanceType;
	import com.borhan.vo.BorhanCategory;
	import com.borhan.vo.BorhanUser;
	
	import mx.controls.Alert;
	import mx.resources.ResourceManager;
	
	public class ManageParentCategoryCommand extends BorhanCommand{
		
		private var _eventType:String;
		
		override public function execute(event:CairngormEvent):void{
			_eventType = event.type;
			
			switch (event.type){
				case CategoryEvent.CLEAR_PARENT_CATEGORY:
					_model.categoriesModel.inheritedParentCategory = null;
					break;
				
				case CategoryEvent.GET_PARENT_CATEGORY:
				case CategoryEvent.GET_INHERITED_PARENT_CATEGORY:
					_model.increaseLoadCounter();
					var mr:MultiRequest = new MultiRequest();
					
					var selectedCat:BorhanCategory = event.data as BorhanCategory;
					var req:CategoryGet;
					if (event.type == CategoryEvent.GET_PARENT_CATEGORY) {
						req = new CategoryGet(selectedCat.parentId);
					}
					else if (event.type == CategoryEvent.GET_INHERITED_PARENT_CATEGORY) {
						req = new CategoryGet(selectedCat.inheritedParentId);
					}
					
					mr.addAction(req);
					
					// inheritedOwner
					var getOwner:UserGet = new UserGet("1"); // dummy value, overriden in 2 lines
					mr.addAction(getOwner);
					mr.mapMultiRequestParam(1, "owner", 2, "userId");
					
					mr.addEventListener(BorhanEvent.COMPLETE, result);
					mr.addEventListener(BorhanEvent.FAILED, fault);
		
					_model.context.kc.post(mr);
					
					break;
					
			}
		}
		
		override public function result(data:Object):void{
			super.result(data);
			_model.decreaseLoadCounter();
			
			if (!checkError(data)) {
				//inheritedOwner
				if (data.data[1] is BorhanUser) {
					_model.categoriesModel.inheritedOwner = data.data[1] as BorhanUser;
				}
				
				// category
				if (data.data[0] is BorhanCategory){
					_model.categoriesModel.inheritedParentCategory = data.data[0] as BorhanCategory;
				}
				else {
					Alert.show(ResourceManager.getInstance().getString('cms', 'error') + ": " +
						ResourceManager.getInstance().getString('cms', 'noMatchingParentError'));
				}
				
			}
		}
	}
}