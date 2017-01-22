package com.borhan.bmc.modules.content.commands.dropfolder {
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.commands.dropFolder.DropFolderList;
	import com.borhan.commands.dropFolderFile.DropFolderFileList;
	import com.borhan.edw.control.commands.KedCommand;
	import com.borhan.edw.control.events.DropFolderEvent;
	import com.borhan.edw.model.types.DropFolderListType;
	import com.borhan.errors.BorhanError;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmc.modules.content.commands.BorhanCommand;
	import com.borhan.bmc.modules.content.events.BMCDropFolderEvent;
	import com.borhan.bmvc.control.BMvCEvent;
	import com.borhan.types.BorhanDropFolderContentFileHandlerMatchPolicy;
	import com.borhan.types.BorhanDropFolderFileHandlerType;
	import com.borhan.types.BorhanDropFolderFileOrderBy;
	import com.borhan.types.BorhanDropFolderFileStatus;
	import com.borhan.types.BorhanDropFolderOrderBy;
	import com.borhan.types.BorhanDropFolderStatus;
	import com.borhan.vo.BorhanDropFolder;
	import com.borhan.vo.BorhanDropFolderContentFileHandlerConfig;
	import com.borhan.vo.BorhanDropFolderFile;
	import com.borhan.vo.BorhanDropFolderFileFilter;
	import com.borhan.vo.BorhanDropFolderFileListResponse;
	import com.borhan.vo.BorhanDropFolderFilter;
	import com.borhan.vo.BorhanDropFolderListResponse;
	import com.borhan.vo.BorhanFtpDropFolder;
	import com.borhan.vo.BorhanScpDropFolder;
	import com.borhan.vo.BorhanSftpDropFolder;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.mx_internal;
	import mx.resources.IResourceBundle;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
//	use namespace mx.core.mx_internal;
	

	public class ListDropFoldersAndFiles extends BorhanCommand {

		
		private var _flags:uint;
		private var _fileFilter:BorhanDropFolderFileFilter;


		override public function execute(event:CairngormEvent):void {
			_flags = (event as BMCDropFolderEvent).flags;
			_model.increaseLoadCounter();
			if (event.data is BorhanDropFolderFileFilter) {
				_fileFilter = event.data;
			}
			var filter:BorhanDropFolderFilter = new BorhanDropFolderFilter();
			filter.orderBy = BorhanDropFolderOrderBy.CREATED_AT_DESC;
			filter.statusEqual = BorhanDropFolderStatus.ENABLED;
			var listFolders:DropFolderList = new DropFolderList(filter);
			listFolders.addEventListener(BorhanEvent.COMPLETE, result);
			listFolders.addEventListener(BorhanEvent.FAILED, fault);

			_model.context.kc.post(listFolders);
		}


		override public function result(data:Object):void {
			var rm:IResourceManager = ResourceManager.getInstance();
			if (data.error) {
				var er:BorhanError = data.error as BorhanError;
				if (er) {
					Alert.show(er.errorMsg, rm.getString('cms', 'error'));
				}
			}
			else {
				var ar:Array = handleDropFolderList(data.data as BorhanDropFolderListResponse);
				_model.dropFolderModel.dropFolders = new ArrayCollection(ar);
				
				if (ar.length == 0) {
					// show upsale alert
					var str:String = rm.getString('dropfolders', 'dfUpsale');
					var alert:Alert = Alert.show(str, rm.getString('cms', 'attention'));
					alert.mx_internal::alertForm.mx_internal::textField.htmlText = str; // because it includes links and stuff
					_model.decreaseLoadCounter();
				}
				else {
					// load files from the returned folders
					if (!_fileFilter) {
						var folderIds:String = '';
						for each (var kdf:BorhanDropFolder in ar) {
							folderIds += kdf.id + ",";
						}
						_fileFilter = new BorhanDropFolderFileFilter();
						_fileFilter.orderBy = BorhanDropFolderFileOrderBy.CREATED_AT_DESC;
						// use selected folder
						_fileFilter.dropFolderIdIn = folderIds;
						_fileFilter.statusIn = BorhanDropFolderFileStatus.DOWNLOADING + "," +
							BorhanDropFolderFileStatus.ERROR_DELETING + "," + 
							BorhanDropFolderFileStatus.ERROR_DOWNLOADING + "," + 
							BorhanDropFolderFileStatus.ERROR_HANDLING + "," + 
							BorhanDropFolderFileStatus.HANDLED + "," + 
							BorhanDropFolderFileStatus.NO_MATCH + "," + 
							BorhanDropFolderFileStatus.PENDING + "," + 
							BorhanDropFolderFileStatus.PROCESSING + "," + 
							BorhanDropFolderFileStatus.PARSED + "," + 
							BorhanDropFolderFileStatus.UPLOADING + "," + 
							BorhanDropFolderFileStatus.DETECTED + "," + 
							BorhanDropFolderFileStatus.WAITING; 
						_model.dropFolderModel.filter = _fileFilter;
					}
					var listFiles:DropFolderFileList = new DropFolderFileList(_fileFilter, _model.dropFolderModel.pager);
	
					listFiles.addEventListener(BorhanEvent.COMPLETE, filesResult);
					listFiles.addEventListener(BorhanEvent.FAILED, fault);
					_model.context.kc.post(listFiles);
				}
			}
//			_model.decreaseLoadCounter();
		}


		protected function filesResult(event:BorhanEvent):void {
			var ar:Array = new Array();
			var objs:Array = (event.data as BorhanDropFolderFileListResponse).objects;
			for each (var o:Object in objs) {
				if (o is BorhanDropFolderFile) {
					ar.push(o);
				}
			}
			_model.dropFolderModel.files = new ArrayCollection(ar);
			_model.dropFolderModel.filesTotalCount = event.data.totalCount;
			_model.decreaseLoadCounter();
		}


		/**
		 * put the folders in an array collection on the model
		 * */
		protected function handleDropFolderList(lr:BorhanDropFolderListResponse):Array {
			// so that the classes will be comiled in
			var dummy1:BorhanScpDropFolder;
			var dummy2:BorhanSftpDropFolder;
			var dummy3:BorhanFtpDropFolder;

			var df:BorhanDropFolder;
			var ar:Array = new Array();
			for each (var o:Object in lr.objects) {
				if (o is BorhanDropFolder) {
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
					else if (_flags & DropFolderListType.XML_FOLDER && df.fileHandlerType == BorhanDropFolderFileHandlerType.XML) {
						ar.push(df);
					}
				}
			}
			return ar;
		}
	}
}