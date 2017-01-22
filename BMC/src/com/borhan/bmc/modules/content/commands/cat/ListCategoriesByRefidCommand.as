package com.borhan.bmc.modules.content.commands.cat {
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.commands.category.CategoryList;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmc.modules.content.commands.BorhanCommand;
	import com.borhan.vo.BorhanCategory;
	import com.borhan.vo.BorhanCategoryFilter;
	import com.borhan.vo.BorhanCategoryListResponse;

	public class ListCategoriesByRefidCommand extends BorhanCommand {
		
		override public function execute(event:CairngormEvent):void {
			_model.increaseLoadCounter();

			var f:BorhanCategoryFilter = new BorhanCategoryFilter();
			f.referenceIdEqual = (event.data as BorhanCategory).referenceId;
			
			var catList:CategoryList = new CategoryList(f);
			catList.addEventListener(BorhanEvent.COMPLETE, result);
			catList.addEventListener(BorhanEvent.FAILED, fault);
			_model.context.kc.post(catList);
		}


		override public function result(data:Object):void {
			super.result(data);
			if (!checkError(data)) {
				var recievedData:BorhanCategoryListResponse = BorhanCategoryListResponse(data.data);
				_model.categoriesModel.categoriesWSameRefidAsSelected = recievedData.objects;
			}
			_model.decreaseLoadCounter();
		}

	}
}
