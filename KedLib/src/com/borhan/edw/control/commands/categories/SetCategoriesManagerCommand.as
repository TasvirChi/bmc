package com.borhan.edw.control.commands.categories
{
	import com.borhan.edw.components.fltr.cat.data.ICategoriesDataManger;
	import com.borhan.edw.control.commands.KedCommand;
	import com.borhan.edw.model.FilterModel;
	import com.borhan.edw.model.datapacks.FilterDataPack;
	import com.borhan.bmvc.control.BMvCEvent;

	public class SetCategoriesManagerCommand extends KedCommand {
		
		override public function execute(event:BMvCEvent):void
		{
			var filterModel:FilterModel = (_model.getDataPack(FilterDataPack) as FilterDataPack).filterModel;
			filterModel.catTreeDataManager = event.data as ICategoriesDataManger;
		}
	}
}