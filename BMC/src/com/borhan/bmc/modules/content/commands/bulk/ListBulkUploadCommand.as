package com.borhan.bmc.modules.content.commands.bulk {
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.commands.bulk.BulkList;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmc.modules.content.commands.BorhanCommand;
	import com.borhan.vo.BorhanBulkUploadFilter;
	import com.borhan.vo.BorhanBulkUploadListResponse;
	import com.borhan.vo.BorhanBulkUploadResult;
	import com.borhan.vo.BorhanFilterPager;
	
	import mx.collections.ArrayCollection;

	public class ListBulkUploadCommand extends BorhanCommand {
		override public function execute(event:CairngormEvent):void {
			_model.increaseLoadCounter();
			
			var f:BorhanBulkUploadFilter;
			var p:BorhanFilterPager;
			
			if (event.data) {
				// use given and save
				_model.bulkUploadModel.lastFilterUsed = f = event.data[0] as BorhanBulkUploadFilter;
				_model.bulkUploadModel.lastPagerUsed = p = event.data[1] as BorhanFilterPager;
			}
			else {
				// use saved
				f = _model.bulkUploadModel.lastFilterUsed;
				p = _model.bulkUploadModel.lastPagerUsed;
			}
			
			
			var listBulks:BulkList = new BulkList(f, p);
			listBulks.addEventListener(BorhanEvent.COMPLETE, result);
			listBulks.addEventListener(BorhanEvent.FAILED, fault);
			_model.context.kc.post(listBulks);

		}


		override public function result(data:Object):void {
			super.result(data);
			var kbr:BorhanBulkUploadResult;
			_model.bulkUploadModel.bulkUploadTotalCount = data.data.totalCount;

			_model.bulkUploadModel.bulkUploads = new ArrayCollection((data.data as BorhanBulkUploadListResponse).objects);
			_model.decreaseLoadCounter();
		}

	}
}