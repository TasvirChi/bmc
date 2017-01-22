package com.borhan.bmc.modules.create
{
	import com.borhan.BorhanClient;
	import com.borhan.commands.MultiRequest;
	import com.borhan.commands.bulkUpload.BulkUploadAdd;
	import com.borhan.commands.category.CategoryAddFromBulkUpload;
	import com.borhan.commands.categoryUser.CategoryUserAddFromBulkUpload;
	import com.borhan.commands.user.UserAddFromBulkUpload;
	import com.borhan.edw.model.types.APIErrorCode;
	import com.borhan.errors.BorhanError;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmc.business.JSGate;
	import com.borhan.bmc.modules.create.types.BulkTypes;
	import com.borhan.net.BorhanCall;
	import com.borhan.types.BorhanBulkUploadType;
	import com.borhan.vo.BorhanBulkUploadCategoryData;
	import com.borhan.vo.BorhanBulkUploadCategoryUserData;
	import com.borhan.vo.BorhanBulkUploadCsvJobData;
	import com.borhan.vo.BorhanBulkUploadUserData;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.FileReferenceList;
	
	import mx.controls.Alert;
	import mx.core.mx_internal;
	import mx.resources.ResourceBundle;
	import mx.resources.ResourceManager;
	import mx.validators.EmailValidator;

	/**
	 * this component handles the logic of selection and upload of bulk items 
	 * @author atar.shadmi
	 * 
	 */	
	public class BulkUploader extends EventDispatcher {
		
		
		private var _client:BorhanClient;
		
		/**
		 * type of object being uploaded in bulk
		 * 
		 * @see com.borhan.bmc.modules.create.types.BulkTypes 
		 */		
		private var _uploadType:String;
		
		/**
		 * file reference list object for bulk uploads
		 * */
		private var _bulkUpldFileRef:FileReferenceList;
		
		/**
		 * list of FileReference objects to upload
		 */		
		private var _files:Array;
		
		private var _processedFilesCounter:int = 0;
		
		public function BulkUploader(client:BorhanClient) {
			super(this);
			_client = client;
		}

		/**
		 * Opens a desktop file selection pop-up, allowing csv/xml files selection
		 * */
		public function doUpload(type:String):void {
			_uploadType = type;
			_bulkUpldFileRef = new FileReferenceList();
			_bulkUpldFileRef.addEventListener(Event.SELECT, addBulkUploads);
			_bulkUpldFileRef.browse(getBulkUploadFilter(type));
		}
		
		
		protected function addBulkUploads(event:Event):void {
			var defaultConversionProfileId:int = -1;
			var file:FileReference;
			var kbu:BorhanCall;
			var jobData:BorhanBulkUploadCsvJobData;
			_files = [];
			for (var i:int = 0; i<_bulkUpldFileRef.fileList.length; i++) {
				file = _bulkUpldFileRef.fileList[i] as FileReference;
				// save the file
				_files.push(file);
			
				jobData = new BorhanBulkUploadCsvJobData();
				jobData.fileName = file.name;
				switch (_uploadType) {
					case BulkTypes.MEDIA:
						// pass in xml or csv file type
						kbu = new BulkUploadAdd(defaultConversionProfileId, file, getUploadType(file.name));
						break;
					
					case BulkTypes.CATEGORY:
						kbu = new CategoryAddFromBulkUpload(file, jobData, new BorhanBulkUploadCategoryData());
						break;
					case BulkTypes.USER:
						kbu = new UserAddFromBulkUpload(file, jobData, new BorhanBulkUploadUserData());
						break;
					case BulkTypes.CATEGORY_USER:
						kbu = new CategoryUserAddFromBulkUpload(file, jobData, new BorhanBulkUploadCategoryUserData());
						break;
				}
				
				
				kbu.addEventListener(BorhanEvent.COMPLETE, bulkUploadCompleteHandler);
				kbu.addEventListener(BorhanEvent.FAILED, bulkUploadCompleteHandler);
				kbu.queued = false;
				_client.post(kbu);
			}
		}
		
		/**
		 * create the list of optional file types for bulk upload
		 * */
		protected function getBulkUploadFilter(type:String):Array {
			var filter:FileFilter;
			switch (type) {
				case BulkTypes.MEDIA:
					filter = new FileFilter(ResourceManager.getInstance().getString('create', 'media_file_types'), "*.csv;*.xml");
					break;
				case BulkTypes.CATEGORY:
				case BulkTypes.USER:
				case BulkTypes.CATEGORY_USER:
					filter = new FileFilter(ResourceManager.getInstance().getString('create', 'other_file_types'), "*.csv");
					break;
			}
			var types:Array = [filter];
			return types;
		}
		
		/**
		 * get upload type (csv / xml) by file extension
		 * */
		protected function getUploadType(url:String):String {
			var ext:String = url.substring(url.length - 3);
			ext = ext.toLowerCase();
			if (ext == "csv") {
				return BorhanBulkUploadType.CSV;
			}
			return BorhanBulkUploadType.XML;
		}
		
		
		/**
		 * notify user 
		 */		
		protected function onComplete():void {
			// dispatch complete event
			dispatchEvent(new Event(Event.COMPLETE));	
		}
		
		
		protected function bulkUploadCompleteHandler(e:BorhanEvent):void {
			if (!e.success)  {
				var er:BorhanError = e.error;
				if (er.errorCode == APIErrorCode.INVALID_KS) {
					JSGate.expired();
				}
				else if (er.errorCode == APIErrorCode.SERVICE_FORBIDDEN) {
					// added the support of non closable window
					Alert.show(ResourceManager.getInstance().getString('common','forbiddenError',[er.errorMsg]), 
						ResourceManager.getInstance().getString('create', 'forbiden_error_title'), Alert.OK, null, logout);
				}
				else if (er.errorMsg) {
					Alert.show(er.errorMsg, ResourceManager.getInstance().getString('common', 'error'));
				}
			}
			
			_processedFilesCounter ++;
			if (_processedFilesCounter == _files.length) {
				onComplete();
			}
		}
		
		/**
		 * logout from BMC
		 * */
		protected function logout(e:Object):void {
			JSGate.expired();
		}
	}
}