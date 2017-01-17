package com.borhan.bmc.modules.content.commands.dropfolder {
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.commands.dropFolderFile.DropFolderFileList;
	import com.borhan.errors.BorhanError;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmc.modules.content.commands.BorhanCommand;
	import com.borhan.bmc.modules.content.events.BMCDropFolderEvent;
	import com.borhan.vo.BorhanDropFolderFile;
	import com.borhan.vo.BorhanDropFolderFileListResponse;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;

	public class ListDropFoldersFilesCommand extends BorhanCommand {
		// list_all / df_list_by_selected_folder_hierch / df_list_by_selected_folder_flat
		protected var _eventType:String;


		override public function execute(event:CairngormEvent):void {
			_model.increaseLoadCounter();
			var listEvent:BMCDropFolderEvent = event as BMCDropFolderEvent;
			_eventType = listEvent.type;
			var listFiles:DropFolderFileList;
			
			// drop folders panel
			listFiles = new DropFolderFileList(_model.dropFolderModel.filter, _model.dropFolderModel.pager);

			listFiles.addEventListener(BorhanEvent.COMPLETE, result);
			listFiles.addEventListener(BorhanEvent.FAILED, fault);

			_model.context.kc.post(listFiles);
		}


		override public function result(data:Object):void {
			if (data.error) {
				var er:BorhanError = data.error as BorhanError;
				if (er) {
					Alert.show(er.errorMsg, "Error");
				}
			}
			else {
				var ar:Array = handleDropFolderFileList(data.data as BorhanDropFolderFileListResponse);
				_model.dropFolderModel.files = new ArrayCollection(ar);
				_model.dropFolderModel.filesTotalCount = data.data.totalCount;
			}
			_model.decreaseLoadCounter();
		}


		/**
		 * list hierarchical:
		 * 	group items by slug
		 *
		 * list all or list flat:
		 *  just push the items to the model
		 *  */
		protected function handleDropFolderFileList(lr:BorhanDropFolderFileListResponse):Array {
			var ar:Array; // results array
			ar = new Array();
			for each (var o:Object in lr.objects) {
				if (o is BorhanDropFolderFile) {
					ar.push(o);
				}
			}
			return ar;
		}


	}
}