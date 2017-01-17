package com.borhan.bmc.modules.content.utils
{
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	import com.borhan.vo.BorhanDropFolderFile;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.formatters.DateFormatter;
	import com.borhan.types.BorhanDropFolderFileStatus;
	import com.borhan.types.BorhanDropFolderFileErrorCode;

	public class DropFolderTableStringUtil {
		
		/**
		 * used to convert to MegaByetes
		 * */
		private static const MB_MULTIPLIER:int = 1024*1024;
		
		/**
		 * in files size: number of digits to show after the decimal point
		 * */
		private static const DIGITS_AFTER_DEC_POINT:int = 2;
		
		
		/**
		 * date formatter for "created at" column 
		 */
		private static var dateDisplay:DateFormatter; 
		
		private static function initDateFormatter():void {
			dateDisplay = new DateFormatter();
			dateDisplay.formatString = "MM/DD/YYYY JJ:NN";
		}
			
		private static function formatDate(timestamp:int):String {
			if (timestamp == int.MIN_VALUE)
				return ResourceManager.getInstance().getString('dropfolders', 'n_a');
			var date:Date = new Date(timestamp * 1000);
			if (!dateDisplay) initDateFormatter();
			return dateDisplay.format(date);
		}
		
		
		/**
		 * creates the string to show as tooltip for "created at" column
		 * */
		public static function getDatesInfo(item:Object):String {
			var rm:IResourceManager = ResourceManager.getInstance();
			var file:BorhanDropFolderFile = item as BorhanDropFolderFile;
			var str:String = rm.getString('dropfolders', 'dfUploadStart' , [formatDate(file.uploadStartDetectedAt)] );
			str += '\n' + rm.getString('dropfolders', 'dfUploadEnd',  [formatDate(file.uploadEndDetectedAt)] );
			str += '\n' + rm.getString('dropfolders', 'dfTranserStart',  [formatDate(file.importStartedAt)] );
			str += '\n' + rm.getString('dropfolders', 'dfTransferEnd',  [formatDate(file.importEndedAt)] );
			return str;
		}
		
		/**
		 * Create suitable string to display in the "Created at" column
		 * */
		public static function dateCreatedLabelFunc(item:Object, column:DataGridColumn): String {
			var curFile:BorhanDropFolderFile = item as BorhanDropFolderFile;
			return formatDate(curFile.createdAt);
		}
		
		
		/**
		 * Create suitable string to display in the "File Size" column
		 * */
		public static function fileSizeLabelFunc(item:Object, column:DataGridColumn): String {
			var curFile:BorhanDropFolderFile = item as BorhanDropFolderFile;
			if (curFile.fileSize==int.MIN_VALUE)
				return '';
			return ((curFile.fileSize/MB_MULTIPLIER).toFixed(DIGITS_AFTER_DEC_POINT)) + ' ' + ResourceManager.getInstance().getString('dropfolders','megaBytes');
			
		}
		
		
		/**
		 * creates the string to show as tooltip for "status" column
		 * */
		public static function getStatusInfo(item:Object):String {
			var resourceManager:IResourceManager = ResourceManager.getInstance();
			var file:BorhanDropFolderFile = item as BorhanDropFolderFile;
			var str:String = file.status.toString();	// original value as default
			switch (file.status) {
				case BorhanDropFolderFileStatus.UPLOADING:
					str = resourceManager.getString('dropfolders','transferringDesc');
					break;
				case BorhanDropFolderFileStatus.DOWNLOADING:
					str = resourceManager.getString('dropfolders','downloadingDesc');
					break;
				case BorhanDropFolderFileStatus.PENDING:
					str = resourceManager.getString('dropfolders','pendingDesc');
					break;
				case BorhanDropFolderFileStatus.PROCESSING:
					str = resourceManager.getString('dropfolders','processingDesc');
					break;
				case BorhanDropFolderFileStatus.PARSED:
					str = resourceManager.getString('dropfolders','parsedDesc');
					break;
				case BorhanDropFolderFileStatus.WAITING:
					str = resourceManager.getString('dropfolders','waitingDesc');
					break;
				case BorhanDropFolderFileStatus.NO_MATCH:
					str = resourceManager.getString('dropfolders','noMatchDesc');
					break;
				case BorhanDropFolderFileStatus.ERROR_HANDLING:
					str = resourceManager.getString('dropfolders','errHandlingDesc');
					break;
				case BorhanDropFolderFileStatus.ERROR_DELETING:
					str = resourceManager.getString('dropfolders','errDeletingDesc');
					break;
				case BorhanDropFolderFileStatus.HANDLED:
					str = resourceManager.getString('dropfolders','handledDesc');
					break;
				case BorhanDropFolderFileStatus.ERROR_DOWNLOADING:
					str = resourceManager.getString('dropfolders','errDnldDesc');
					break;
			}
			return str;
		}
		
		
		/**
		 * Create suitable string to display in the "Status" column
		 * */
		public static function statusLabelFunc(item:Object, column:DataGridColumn): String {
			var resourceManager:IResourceManager = ResourceManager.getInstance();
			var curFile:BorhanDropFolderFile = item as BorhanDropFolderFile;
			switch (curFile.status) {
				case BorhanDropFolderFileStatus.UPLOADING:
					return resourceManager.getString('dropfolders','transferringBtn');
				case BorhanDropFolderFileStatus.DOWNLOADING:
					return resourceManager.getString('dropfolders','downloadingBtn');
				case BorhanDropFolderFileStatus.PENDING:
					return resourceManager.getString('dropfolders','pendingBtn');
				case BorhanDropFolderFileStatus.PROCESSING:
					return resourceManager.getString('dropfolders','processingBtn');
				case BorhanDropFolderFileStatus.PARSED:
					return resourceManager.getString('dropfolders','parsedBtn');
				case BorhanDropFolderFileStatus.WAITING:
					return resourceManager.getString('dropfolders','waitingBtn');
				case BorhanDropFolderFileStatus.NO_MATCH:
					return resourceManager.getString('dropfolders','noMatchBtn');
				case BorhanDropFolderFileStatus.ERROR_HANDLING:
					return resourceManager.getString('dropfolders','errHandlingBtn');
				case BorhanDropFolderFileStatus.ERROR_DELETING:
					return resourceManager.getString('dropfolders','errDeletingBtn');
				case BorhanDropFolderFileStatus.HANDLED:
					return resourceManager.getString('dropfolders','handledBtn');
				case BorhanDropFolderFileStatus.ERROR_DOWNLOADING:
					return resourceManager.getString('dropfolders','errDnldBtn');
			}
			return '';
		}
		
		
		/**
		 * Create suitable string to display in the "error desctiption" column
		 * */
		public static function getErrorDescription(item:Object) : String {
			var resourceManager:IResourceManager = ResourceManager.getInstance();
			var file:BorhanDropFolderFile = item as BorhanDropFolderFile;
			var err:String = file.errorDescription;	// keep server string as default description
			
			switch (file.errorCode) {
				case BorhanDropFolderFileErrorCode.ERROR_ADDING_BULK_UPLOAD :
					err = resourceManager.getString('dropfolders','dfErrAddBulk');
					break;
				case BorhanDropFolderFileErrorCode.ERROR_IN_BULK_UPLOAD :
					err = resourceManager.getString('dropfolders','dfErrBulkUpload');
					break;
//				case BorhanDropFolderFileErrorCode.ERROR_WRITING_TEMP_FILE :
//				case BorhanDropFolderFileErrorCode.LOCAL_FILE_WRONG_CHECKSUM :
//				case BorhanDropFolderFileErrorCode.LOCAL_FILE_WRONG_SIZE :
//					// not supposed to happen
//					break;
				case BorhanDropFolderFileErrorCode.ERROR_UPDATE_ENTRY : 
					err = resourceManager.getString('dropfolders','dfErrUpdateEntry');
					break;
				case BorhanDropFolderFileErrorCode.ERROR_ADD_ENTRY : 
					err = resourceManager.getString('dropfolders','dfErrAddEntry');
					break;
				case BorhanDropFolderFileErrorCode.FLAVOR_NOT_FOUND : 
					err = resourceManager.getString('dropfolders','dfErrFlavorNotFound', [file.parsedFlavor]);
					break;
				case BorhanDropFolderFileErrorCode.FLAVOR_MISSING_IN_FILE_NAME : 
					err = resourceManager.getString('dropfolders','dfErrFlavorMissingInFile');
					break;
				case BorhanDropFolderFileErrorCode.SLUG_REGEX_NO_MATCH : 
					err = resourceManager.getString('dropfolders','dfErrSlugRegex');
					break;
				case BorhanDropFolderFileErrorCode.ERROR_READING_FILE :
					err = resourceManager.getString('dropfolders','dfErrReadFile');
					break;
				case BorhanDropFolderFileErrorCode.ERROR_DOWNLOADING_FILE :
					err = resourceManager.getString('dropfolders','dfErrDnldFile');
					break;
				case BorhanDropFolderFileErrorCode.ERROR_UPDATE_FILE :
					err = resourceManager.getString('dropfolders','dfErrUpdateFile');
					break;
				case BorhanDropFolderFileErrorCode.ERROR_ADD_CONTENT_RESOURCE :
					err = resourceManager.getString('dropfolders','dfErrAddResource');
					break;
				case BorhanDropFolderFileErrorCode.ERROR_ADDING_CONTENT_PROCESSOR :
					err = resourceManager.getString('dropfolders','dfErrAddProc');
					break;
				case BorhanDropFolderFileErrorCode.ERROR_IN_CONTENT_PROCESSOR :
					err = resourceManager.getString('dropfolders','dfErrProc');
					break;
				case BorhanDropFolderFileErrorCode.ERROR_DELETING_FILE :
					err = resourceManager.getString('dropfolders','dfErrDelFile');
					break;
				case BorhanDropFolderFileErrorCode.MALFORMED_XML_FILE :
					err = resourceManager.getString('dropfolders','dfErrMalformXml');
					break;
				case BorhanDropFolderFileErrorCode.XML_FILE_SIZE_EXCEED_LIMIT :
					err = resourceManager.getString('dropfolders','dfErrXmlSize');
					break;
					
			}
			
			return err;
		}
	}
}