package com.borhan.bmc.modules.content.commands.dropfolder
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.commands.MultiRequest;
	import com.borhan.commands.dropFolderFile.DropFolderFileDelete;
	import com.borhan.commands.dropFolderFile.DropFolderFileList;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmc.modules.content.commands.BorhanCommand;
	import com.borhan.bmc.modules.content.events.BMCDropFolderEvent;
	import com.borhan.vo.BorhanDropFolderFile;
	import com.borhan.vo.BorhanDropFolderFileListResponse;
	
	import mx.collections.ArrayCollection;

	public class DeleteDropFolderFilesCommand extends BorhanCommand
	{
		override public function execute(event:CairngormEvent):void {
			_model.increaseLoadCounter();
			var itemsToDelete:Array = (event as BMCDropFolderEvent).data;
			var mr:MultiRequest = new MultiRequest();
			for each (var file:BorhanDropFolderFile in itemsToDelete) {
				var deleteFile:DropFolderFileDelete = new DropFolderFileDelete(file.id);
				mr.addAction(deleteFile);
			}
			var listFiles:DropFolderFileList = new DropFolderFileList(_model.dropFolderModel.filter, _model.dropFolderModel.pager);
			mr.addAction(listFiles);
			
			mr.addEventListener(BorhanEvent.COMPLETE, result);
			mr.addEventListener(BorhanEvent.FAILED, fault);
			_model.context.kc.post(mr);
		}
		
		override public function result(data:Object):void {
			var resultArr:Array = data.data as Array;
			var listResponse:BorhanDropFolderFileListResponse = resultArr[resultArr.length - 1];
			var filteredArray:Array = new Array();
			for each (var o:Object in listResponse.objects) {
				if (o is BorhanDropFolderFile) {
					filteredArray.push(o);
				}
			}
			_model.dropFolderModel.files = new ArrayCollection(filteredArray);
			_model.dropFolderModel.filesTotalCount = listResponse.totalCount;
			
			_model.decreaseLoadCounter();
		}
	}
}