package com.borhan.bmc.modules.content.commands.cat
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.bmc.modules.content.commands.BorhanCommand;
	
	public class SetSelectedCategoryUsersCommand extends BorhanCommand {
		
		override public function execute(event:CairngormEvent):void {
			// event.data is [BorhanCategoryUser]
			_model.categoriesModel.selectedCategoryUsers = event.data;
		}
	}
}