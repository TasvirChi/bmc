package com.borhan.bmc.modules.content.commands.cat
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.commands.user.UserGet;
	import com.borhan.errors.BorhanError;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmc.modules.content.commands.BorhanCommand;
	import com.borhan.bmc.modules.content.events.CategoryEvent;
	import com.borhan.vo.BorhanCategory;
	import com.borhan.vo.BorhanUser;
	
	public class GetCategoryOwnerCommand extends BorhanCommand {
		
		override public function execute(event:CairngormEvent):void{
			
			switch (event.type){
				case CategoryEvent.CLEAR_CATEGORY_OWNER:
					_model.categoriesModel.categoryOwner = null;
					_model.categoriesModel.inheritedOwner = null;
					break;
				
				case CategoryEvent.GET_CATEGORY_OWNER:
					
					var selectedCat:BorhanCategory = event.data as BorhanCategory;
					var req:UserGet = new UserGet(selectedCat.owner);
					
					req.addEventListener(BorhanEvent.COMPLETE, result);
					req.addEventListener(BorhanEvent.FAILED, fault);
					
					_model.increaseLoadCounter();
					_model.context.kc.post(req);
					break;
				
			}
		}
		
		override public function result(data:Object):void{
			super.result(data);
			_model.decreaseLoadCounter();
			
			if (!checkError(data)) {
				_model.categoriesModel.categoryOwner = data.data as BorhanUser;
			}
		}
	}
}