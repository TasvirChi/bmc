package com.borhan.bmc.modules.content.commands.cat
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.bmc.modules.content.commands.BorhanCommand;
	
	public class SetRefreshCatsRequiredCommand extends BorhanCommand
	{
		override public function execute(event:CairngormEvent):void {
			_model.categoriesModel.refreshCategoriesRequired = event.data;
		}
	}
}