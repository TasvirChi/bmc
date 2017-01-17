package com.borhan.edw.control.commands.dropFolder
{
	import com.borhan.commands.dropFolder.DropFolderList;
	import com.borhan.edw.control.commands.KedCommand;
	import com.borhan.edw.control.events.DropFolderEvent;
	import com.borhan.edw.model.datapacks.DropFolderDataPack;
	import com.borhan.edw.model.types.DropFolderListType;
	import com.borhan.errors.BorhanError;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmvc.control.BMvCEvent;
	import com.borhan.types.BorhanDropFolderContentFileHandlerMatchPolicy;
	import com.borhan.types.BorhanDropFolderFileHandlerType;
	import com.borhan.types.BorhanDropFolderOrderBy;
	import com.borhan.types.BorhanDropFolderStatus;
	import com.borhan.vo.BorhanDropFolder;
	import com.borhan.vo.BorhanDropFolderContentFileHandlerConfig;
	import com.borhan.vo.BorhanDropFolderFilter;
	import com.borhan.vo.BorhanDropFolderListResponse;
	import com.borhan.vo.BorhanFtpDropFolder;
	import com.borhan.vo.BorhanScpDropFolder;
	import com.borhan.vo.BorhanSftpDropFolder;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	
	public class ListDropFolders extends KedCommand {
		
		private var _flags:uint;
		
		override public function execute(event:BMvCEvent):void {
			_flags = (event as DropFolderEvent).flags;
			_model.increaseLoadCounter();
			var filter:BorhanDropFolderFilter = new BorhanDropFolderFilter();
//			filter.fileHandlerTypeEqual = BorhanDropFolderFileHandlerType.CONTENT;
			filter.orderBy = BorhanDropFolderOrderBy.NAME_DESC;
			filter.statusEqual = BorhanDropFolderStatus.ENABLED;
			var listFolders:DropFolderList = new DropFolderList(filter);
			listFolders.addEventListener(BorhanEvent.COMPLETE, result);
			listFolders.addEventListener(BorhanEvent.FAILED, fault);
			
			_client.post(listFolders); 	
		}
		
		
		override public function result(data:Object):void {
			if (data.error) {
				var er:BorhanError = data.error as BorhanError;
				if (er) {
					Alert.show(er.errorMsg, "Error");
				}
			}
			else {
				handleDropFolderList(data.data as BorhanDropFolderListResponse);
			}
			_model.decreaseLoadCounter();
		}
		
		
		/**
		 * put the folders in an array collection on the model 
		 * */
		protected function handleDropFolderList(lr:BorhanDropFolderListResponse):void {
			// so that the classes will be compiled in
			var dummy1:BorhanScpDropFolder;
			var dummy2:BorhanSftpDropFolder;
			var dummy3:BorhanFtpDropFolder;
			
			var df:BorhanDropFolder;
			var ar:Array = new Array();
			for each (var o:Object in lr.objects) {
				if (o is BorhanDropFolder ) {
					df = o as BorhanDropFolder;
					if (df.fileHandlerType == BorhanDropFolderFileHandlerType.CONTENT) {
						var cfg:BorhanDropFolderContentFileHandlerConfig = df.fileHandlerConfig as BorhanDropFolderContentFileHandlerConfig;
						if (_flags & DropFolderListType.ADD_NEW && cfg.contentMatchPolicy == BorhanDropFolderContentFileHandlerMatchPolicy.ADD_AS_NEW) {
							ar.push(df);
						}
						else if (_flags & DropFolderListType.MATCH_OR_KEEP && cfg.contentMatchPolicy == BorhanDropFolderContentFileHandlerMatchPolicy.MATCH_EXISTING_OR_KEEP_IN_FOLDER) {
							ar.push(df);
						} 
						else if (_flags & DropFolderListType.MATCH_OR_NEW && cfg.contentMatchPolicy == BorhanDropFolderContentFileHandlerMatchPolicy.MATCH_EXISTING_OR_ADD_AS_NEW) {
							ar.push(df);
						} 
					}
					else if (_flags & DropFolderListType.XML_FOLDER && df.fileHandlerType == BorhanDropFolderFileHandlerType.XML){
						ar.push(df);
					}
				}
			}
			
			(_model.getDataPack(DropFolderDataPack) as DropFolderDataPack).dropFolders = new ArrayCollection(ar);
		}
		
	}
}