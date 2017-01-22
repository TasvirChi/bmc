package com.borhan.edw.control.commands
{
	import com.borhan.edw.control.commands.KedCommand;
	import com.borhan.edw.model.EntryDetailsModel;
	import com.borhan.edw.model.datapacks.EntryDataPack;
	import com.borhan.bmvc.control.BMvCEvent;
	import com.borhan.bmvc.model.BMvCModel;

	public class DuplicateEntryDetailsModelCommand extends KedCommand {
		
		override public function execute(event:BMvCEvent):void
		{
			// need to copy maxCats because entry data pack is not shared.
			var maxCats:int = (BMvCModel.getInstance().getDataPack(EntryDataPack) as EntryDataPack).maxNumCategories;
			BMvCModel.addModel();
			(BMvCModel.getInstance().getDataPack(EntryDataPack) as EntryDataPack).maxNumCategories = maxCats;
		}
	}
}