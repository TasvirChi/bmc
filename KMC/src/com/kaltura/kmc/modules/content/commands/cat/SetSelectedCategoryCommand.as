package com.borhan.bmc.modules.content.commands.cat
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.bmc.modules.content.commands.BorhanCommand;
	import com.borhan.vo.BorhanCategory;
	
	public class SetSelectedCategoryCommand extends BorhanCommand
	{
		override public function execute(event:CairngormEvent):void{
			var catToSet:BorhanCategory = event.data as BorhanCategory;
			_model.categoriesModel.selectedCategory = catToSet;
		}

	}
}