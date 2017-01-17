package com.borhan.edw.control.commands.categories
{
	import com.borhan.edw.control.commands.KedCommand;
	import com.borhan.edw.model.FilterModel;
	import com.borhan.edw.model.datapacks.FilterDataPack;
	import com.borhan.bmvc.control.BMvCEvent;
	
	public class FlushCategoriesDataCommand extends KedCommand {
		
		override public function execute(event:BMvCEvent):void {
			var filterModel:FilterModel = (_model.getDataPack(FilterDataPack) as FilterDataPack).filterModel;
			filterModel.categoriesMapForEntries.clear();
			filterModel.categoriesForEntries = null;
			
			filterModel.categoriesMapForMod.clear();
			filterModel.categoriesForMod = null;
			
			filterModel.categoriesMapForCats.clear();
			filterModel.categoriesForCats = null;
			
			filterModel.categoriesMapGeneral.clear();
			filterModel.categoriesGeneral = null;
		}
	}
}