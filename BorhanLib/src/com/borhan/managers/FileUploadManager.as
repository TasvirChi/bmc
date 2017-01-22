package com.borhan.managers {
	import com.borhan.BorhanClient;
	import com.borhan.commands.MultiRequest;
	import com.borhan.commands.flavorAsset.FlavorAssetAdd;
	import com.borhan.commands.flavorAsset.FlavorAssetSetContent;
	import com.borhan.commands.media.MediaUpdateContent;
	import com.borhan.commands.uploadToken.UploadTokenAdd;
	import com.borhan.commands.uploadToken.UploadTokenDelete;
	import com.borhan.commands.uploadToken.UploadTokenUpload;
	import com.borhan.errors.BorhanError;
	import com.borhan.events.FileUploadEvent;
	import com.borhan.events.BorhanEvent;
	import com.borhan.types.BorhanMediaType;
	import com.borhan.utils.KStringUtil;
	import com.borhan.vo.FileUploadVO;
	import com.borhan.vo.BorhanAssetParamsResourceContainer;
	import com.borhan.vo.BorhanAssetsParamsResourceContainers;
	import com.borhan.vo.BorhanFlavorAsset;
	import com.borhan.vo.BorhanResource;
	import com.borhan.vo.BorhanUploadToken;
	import com.borhan.vo.BorhanUploadedFileTokenResource;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileReference;
	
	import mx.collections.ArrayCollection;
	import mx.resources.ResourceManager;

	/**
	 * This class will handle all file uploads for the current BMC session, and the 
	 * association of uploaded files with relevant entries / flavors.
	 * 
	 * file statuses:
	 * --------------
	 * a FileUploadVo starts its life with status PREPROCESS, it becomes QUEUED after 
	 * upload tokens are associated with entry / flavor. when the file starts uploading
	 * the vo status changes to STATUS_UPLOADING, and when upload is complete it the 
	 * status is changed to COMPLETE. if an error occures while uploading the vo status
	 * becomes FAILED. 
	 * 
	 * @author Atar
	 */
	public class FileUploadManager extends EventDispatcher {

		
		/**
		 * if debugMode is on, failure traces are presented.
		 * */
		public var debugMode:Boolean = false;

		/**
		 * Singleton instance
		 */
		private static var _instance:FileUploadManager;
		
		/**
		 * number of uploads actually happening at the moment,
		 * may not exceed  <code>_concurrentUploads</code>.
		 */
		private var _ongoingUploads:int = 0;

		/**
		 * @copy concurrentUploads
		 */
		private var _concurrentUploads:int = 3;
		
		/**
		 * files that are not ready for upload yet 
		 * (tokens not created or not added to entry) 
		 * <code>FileUploadVO</code> elements
		 */		
		private var _preprocessedFiles:Array;
		

		/**
		 * list of files schedueled for upload
		 * <code>FileUploadVO</code> elements
		 */
		private var _files:Array; //Vector.<FileUploadVO>;

		[Bindable]
		public var filesCollection:ArrayCollection;

		/**
		 * @copy #kc 
		 */
		private var _kc:BorhanClient;

		
		/**
		 * Singleton constructor.
		 * @param enforcer
		 */
		public function FileUploadManager(enforcer:Enforcer) {
			_preprocessedFiles = new Array();
			_files = new Array();//Vector.<FileUploadVO>();
			filesCollection = new ArrayCollection(_files)
		}
		
		
		/**
		 * Retrieves the singleton instance
		 */
		public static function getInstance():FileUploadManager {
			if (_instance == null) {
				_instance = new FileUploadManager(new Enforcer());
			}
			return _instance;
		}


		
		/**
		 * create an upload vo based on given data
		 * @param entryid
		 * @param entrytype
		 * @param file
		 * @param flavorparamsid
		 * @param flavorassetid
		 * @param convprofid
		 * @return 
		 * 
		 */
		public function createFuv(entryid:String, entrytype:int, file:FileReference, flavorparamsid:String = null, flavorassetid:String = null, convprofid:String = null):FileUploadVO {
			// create the VO
			var vo:FileUploadVO = new FileUploadVO();
			vo.file = file;
			vo.name = file.name;
			vo.uploadTime = new Date();
			vo.entryId = entryid; 
			vo.entryType = entrytype;
			vo.flavorParamsId = parseInt(flavorparamsid);
			vo.flavorAssetId = flavorassetid;
			vo.conversionProfile = convprofid;
			vo.fileSize = file.size;
			vo.status = FileUploadVO.STATUS_PREPROCESS;
			return vo;
		}
		
		
		
		/**
		 * add or update a single flavor to an entry
		 * @param entryid	the id of the entry to be updated
		 * @param file		upload info
		 * @param isNew		is this a new flavor or update of existing one
		 */
		public function updateEntryFlavor(entryid:String, file:FileUploadVO, isNew:Boolean):void {
			/* Flow:
			- create token
			- associate the token resource with the entry
			- upload the file
			*/
			_preprocessedFiles.push(file);
			// create upload token
			var ut:BorhanUploadToken = new BorhanUploadToken();
			ut.fileName = file.name;
			ut.fileSize = file.fileSize;
			var uta:UploadTokenAdd = new UploadTokenAdd(ut);
			// add listeners for complete / failed
			// pass events via fuv so we can retrieve a relevant vo after the call returns.
			if (isNew) {
				file.addEventListener(BorhanEvent.COMPLETE, addFlavorAsset/*, false, 0, true*/);
				file.addEventListener(BorhanEvent.FAILED, addFlavorAsset/*, false, 0, true*/);
			}
			else {
				file.addEventListener(BorhanEvent.COMPLETE, updateFlavorAsset/*, false, 0, true*/);
				file.addEventListener(BorhanEvent.FAILED, updateFlavorAsset/*, false, 0, true*/);
			}
			
			uta.addEventListener(BorhanEvent.COMPLETE, file.bubbleEvent);
			uta.addEventListener(BorhanEvent.FAILED, file.bubbleEvent);
			_kc.post(uta);
		}
		
		
		
		/**
		 * add media files to a no_content entry 
		 * @param entryid	the id of the entry to be updated
		 * @param filesData array of FileUploadVo
		 */
		public function updateEntryContent(entryid:String, filesData:Array):void {
			/* Flow:
			- create all required tokens
			- add them to the media
			- start uploading the files
			*/
			var mr:MultiRequest = new MultiRequest();
			var uta:UploadTokenAdd;
			var ut:BorhanUploadToken;
			var vo:FileUploadVO;
			for (var i:int = 0; i<filesData.length; i++) {
				vo = filesData[i];
				_preprocessedFiles.push(vo);
				// create upload token
				ut = new BorhanUploadToken();
				ut.fileName = vo.name;
				ut.fileSize = vo.fileSize;
				uta = new UploadTokenAdd(ut);
				mr.addAction(uta);
			}
			// add listeners for complete / failed
			// pass events via fuv so we can retrieve a relevant vo after the call returns.
			vo.addEventListener(BorhanEvent.COMPLETE, addContent/*, false, 0, true*/);
			vo.addEventListener(BorhanEvent.FAILED, addContent/*, false, 0, true*/);
			
			mr.addEventListener(BorhanEvent.COMPLETE, vo.bubbleEvent);
			mr.addEventListener(BorhanEvent.FAILED, vo.bubbleEvent);
			_kc.post(mr);
		}
		
		
		/**
		 * retry uploading a file that had failed previously
		 * @param uploadid	id of the upload vo we wish to retry
		 * */
		public function retryUpload(uploadid:String):void {
			var file:FileUploadVO = getFile(uploadid);
			if (file && file.status == FileUploadVO.STATUS_FAILED) {
				file.status = FileUploadVO.STATUS_QUEUED;
				// start uploading files
				if (_ongoingUploads < _concurrentUploads) {
					uploadNextFile();
				}
			}
		}
		
		
		/**
		 * add the received tokens to the specified media entry
		 * @param e
		 */		
		protected function addContent(e:BorhanEvent):void {
			e.target.removeEventListener(BorhanEvent.COMPLETE, addContent);
			e.target.removeEventListener(BorhanEvent.FAILED, addContent);
			var er:FileUploadEvent;
			if (e.type == BorhanEvent.COMPLETE) {
				// e.target is a good vo. e.data is the multirequest response
				// add the uploadTokens to the VOs
				var ut:BorhanUploadToken;
				var file:FileUploadVO;
				for each (var o:Object in e.data) {
					if (o is BorhanUploadToken) {
						ut = o as BorhanUploadToken;
						file = getVoByFileName(ut.fileName, true);
						file.uploadToken = ut.id;
						if (!file.uploadToken) {
							trace('no upload token id');
						}
					}
					else if (o is BorhanError) {
						// dispatch error event with relevant data
						er = new FileUploadEvent(FileUploadEvent.UPLOAD_ERROR, e.target.entryId);
						er.error = "Error #209: " + (o as BorhanError).errorMsg;
						if (debugMode) {
							trace("UploadTokenAdd failed: ");
							KStringUtil.traceObject(e.target);
							KStringUtil.traceObject(e.error.requestArgs);
						}
						dispatchEvent(er);
						return;
					}
				}
				
				// create uploadTokenResources, add them to the media.
				var entryid:String = (e.target as FileUploadVO).entryId;  
				
				
				// the actual resource we send is a list of the containers for the resources we want to replace.                
				var mediaResource:BorhanResource = new BorhanAssetsParamsResourceContainers();
				mediaResource.resources = new Array();
				
				for each (file in _preprocessedFiles) {
					if (file.entryId == entryid) {
						// the resource of the flavor we want to replace
						var subSubResource:BorhanUploadedFileTokenResource = new BorhanUploadedFileTokenResource();
						subSubResource.token = file.uploadToken;	// the token used to upload the file
						if (!subSubResource.token) {
							throw new Error("Token cannot be null");
						}
						if (file.entryType == BorhanMediaType.IMAGE) {
							/* image entries have a single resource and it should 
							 * not be sent in a container.
							 * only one asset might fit this entry, so after finding the 
							 * matching file we can break the loop. 							 */ 
							mediaResource = subSubResource;
							break;
						}
						// container for the resource we want to replace
						var subResource:BorhanAssetParamsResourceContainer = new BorhanAssetParamsResourceContainer();
						subResource.resource = subSubResource;
						subResource.assetParamsId = file.flavorParamsId;
						
						// add to list
						mediaResource.resources.push(subResource);
					}
				}
				
				// set media
				var mac:MediaUpdateContent = new MediaUpdateContent(entryid, mediaResource, parseInt(file.conversionProfile));
				
				// listeners
				mac.addEventListener(BorhanEvent.COMPLETE, startUploadMulti);
				mac.addEventListener(BorhanEvent.FAILED, startUploadMulti);
				_kc.post(mac);
			}
			else {
				// dispatch error event with relevant data
				er = new FileUploadEvent(FileUploadEvent.UPLOAD_ERROR, e.target.entryId);
				if (debugMode) {
					trace("UploadTokenAdd failed: ");
					KStringUtil.traceObject(e.target);
					KStringUtil.traceObject(e.error.requestArgs);
				}
				er.error = "Error #201: " + e.error.errorMsg;
				dispatchEvent(er);
			}
		}
		
		
		/**
		 * handle errors if any, or start uploading files. 
		 * @param e
		 */
		protected function startUploadMulti(e:BorhanEvent):void {
			e.target.removeEventListener(BorhanEvent.COMPLETE, startUploadMulti);
			e.target.removeEventListener(BorhanEvent.FAILED, startUploadMulti);
			if (e.type == BorhanEvent.COMPLETE) {
				// pass files to files list
				var entryid:String = e.data.id; // e.data is the updated entry
				var fuv:FileUploadVO;
				var updated:int = 0;
				for (var i:int = _preprocessedFiles.length - 1; i >= 0; i--) { // scan from last to first because of splice
					if ((_preprocessedFiles[i] as FileUploadVO).entryId == entryid) {
						updated ++;
						(_preprocessedFiles[i] as FileUploadVO).status = FileUploadVO.STATUS_QUEUED;
						_files.push(_preprocessedFiles[i]);
						filesCollection.refresh();
						_preprocessedFiles.splice(i, 1);
					}
				}
				dispatchEvent(new FileUploadEvent(FileUploadEvent.GROUP_UPLOAD_STARTED, entryid));
				// start uploading files
				while (_ongoingUploads < _concurrentUploads && updated > 0) {
					/* "updated" is used to start uploading all flavours of a single entry, while   
						not getting an infinite loop when only adding a single file to the entry */ 
					uploadNextFile();
					updated --;
				}
			}
			else {
				// dispatch error event with relevant data
				var er:FileUploadEvent = new FileUploadEvent(FileUploadEvent.UPLOAD_ERROR, 'multi_uploads');
				er.error = 'Error 202: ' + e.error.errorMsg;
				if (debugMode) {
					trace("MediaUpdateContent failed, multi_uploads");
					KStringUtil.traceObject(e.target);
					KStringUtil.traceObject(e.error.requestArgs);
				}
				dispatchEvent(er);
			}
		}
		
		
		/**
		 * handle errors if any, or adds the file to upload queue. 
		 * @param e
		 */
		protected function startUploadSingle(e:BorhanEvent):void {
			e.target.removeEventListener(BorhanEvent.COMPLETE, startUploadSingle);
			e.target.removeEventListener(BorhanEvent.FAILED, startUploadSingle);
			if (e.type == BorhanEvent.COMPLETE) {
				// pass files to files list (upload queue)
				var fuv:FileUploadVO;
				for (var i:int =_preprocessedFiles.length-1; i>=0; i--) {
					if ((_preprocessedFiles[i] as FileUploadVO) == e.target) {
						e.target.status = FileUploadVO.STATUS_QUEUED;
						_files.push(e.target);
						filesCollection.refresh();
						_preprocessedFiles.splice(i, 1);
					}
				}
				// start uploading files
				if (_ongoingUploads /*_files.length */ < _concurrentUploads) {
					uploadNextFile();
				}
			}
			else {
				// dispatch error event with relevant data
				var er:FileUploadEvent = new FileUploadEvent(FileUploadEvent.UPLOAD_ERROR, e.target.id);
				er.error = 'Error #203: ' + e.error.errorMsg;
				if (debugMode) {
					trace("FlavorAssetSetContent failed:");
					KStringUtil.traceObject(e.target);
					KStringUtil.traceObject(e.error.requestArgs);
				}
				dispatchEvent(er);
			}
		}
		
		/**
		 * get an upload vo by the name of the file it represents 
		 * @param name	file name
		 * @param noUploadToken	if true, only get vos that don't have upload token yet.
		 * @return 
		 */
		protected function getVoByFileName(name:String, noUploadToken:Boolean = false):FileUploadVO {
			var vo:FileUploadVO;
			for each (vo in _preprocessedFiles) {
				if (vo.file.name == name) {
					if (!noUploadToken || !vo.uploadToken) {
						return vo;
					}
				}
			}
			for each (vo in _files) {
				if (vo.file.name == name) {
					return vo;
				}
			}
			return null;
		}
		
		
		/**
		 * get the next file on uploads queue 
		 */
		protected function getNextFile():FileUploadVO {
			var result:FileUploadVO = null;
			for (var i:int = 0; i<_files.length; i++) {
				if (_files[i].status == FileUploadVO.STATUS_QUEUED) {
					result = _files[i];
					break;
				}
			}
			return result;
		}
		
		
		/**
		 * upload the next file on queue 
		 */		
		protected function uploadNextFile():void {
			var vo:FileUploadVO = getNextFile();
			if (vo) {
				_ongoingUploads++;
				vo.status = FileUploadVO.STATUS_UPLOADING;
				var utu:UploadTokenUpload = new UploadTokenUpload(vo.uploadToken, vo.file);
				utu.queued = false;
				utu.useTimeout = false;
				// add listeners with weak references because if upload fails, we can't clean them manually
				utu.addEventListener(BorhanEvent.COMPLETE, wrapUpUpload, false, 0, true);
				utu.addEventListener(BorhanEvent.FAILED, wrapUpUpload, false, 0, true);
				vo.file.addEventListener(IOErrorEvent.IO_ERROR, fileFailed );
				vo.file.addEventListener(SecurityErrorEvent.SECURITY_ERROR, fileFailed);
				_kc.post(utu);
				dispatchEvent(new FileUploadEvent(FileUploadEvent.UPLOAD_STARTED, vo.id));
			}
		}
		
	
		/**
		 * dispatch complete event and remove the file from the list
		 */
		protected function wrapUpUpload(e:BorhanEvent):void {
			e.target.removeEventListener(BorhanEvent.COMPLETE, wrapUpUpload);
			e.target.removeEventListener(BorhanEvent.FAILED, wrapUpUpload);
			var file:FileUploadVO;
			if (e.type == BorhanEvent.COMPLETE) {
				file = getUploadByUploadToken(e.data.id);
				file.status = FileUploadVO.STATUS_COMPLETE;
				// dispatch "fileUploadComplete" event with relevant unique identifier
				dispatchEvent(new FileUploadEvent(FileUploadEvent.UPLOAD_COMPLETE, file.id));
				// remove file from files list 
				var ind:int = getQueuePosition(file.id);
				_files.splice(ind, 1);
				filesCollection.refresh();
			}
			else {
				file = getUploadByUploadToken(e.error.requestArgs.uploadTokenId);
				file.status = FileUploadVO.STATUS_FAILED;
				// dispatch error event with relevant data
				var er:FileUploadEvent = new FileUploadEvent(FileUploadEvent.UPLOAD_ERROR, file.entryId);
				er.error = "Error #204: " + e.error.errorMsg;
				if (debugMode) {
					trace("UploadTokenUpload failed:");
					KStringUtil.traceObject(file);
					KStringUtil.traceObject(e.error.requestArgs);
				}
				dispatchEvent(er);
			}
			_ongoingUploads--;
			// start uploading the next file
			uploadNextFile();
		}
		
		

		
		/**
		 * update a single flavor asset, without creating replacement entry 
		 * @param file
		 */
		protected function updateFlavorAsset(e:BorhanEvent = null):void {
			e.target.removeEventListener(BorhanEvent.COMPLETE, updateFlavorAsset);
			e.target.removeEventListener(BorhanEvent.FAILED, updateFlavorAsset);
			if (e.type == BorhanEvent.COMPLETE) {
				var file:FileUploadVO = e.target as FileUploadVO;
				if (e && e.data is BorhanUploadToken) {
					file.uploadToken = e.data.id;
				}
				var resource:BorhanUploadedFileTokenResource = new BorhanUploadedFileTokenResource();
				// the token we used to upload the file
				resource.token = file.uploadToken;	
				var fau:FlavorAssetSetContent = new FlavorAssetSetContent(file.flavorAssetId, resource);
				
				// add listeners for complete / failed
				// pass events via fuv so we can retrieve a relevant vo after the call returns.
				file.addEventListener(BorhanEvent.COMPLETE, startUploadSingle/*, false, 0, true*/);
				file.addEventListener(BorhanEvent.FAILED, startUploadSingle/*, false, 0, true*/);
				
				fau.addEventListener(BorhanEvent.COMPLETE, file.bubbleEvent);
				fau.addEventListener(BorhanEvent.FAILED, file.bubbleEvent);
				_kc.post(fau);
			}
			else {
				// dispatch error event with relevant data
				var er:FileUploadEvent = new FileUploadEvent(FileUploadEvent.UPLOAD_ERROR, '');
				er.error = 'Error #205: ' + e.error.errorMsg;
				if (debugMode) {
					trace("UploadTokenAdd failed:");
					KStringUtil.traceObject(e.target);
					KStringUtil.traceObject(e.error.requestArgs);
				}
				dispatchEvent(er);
			}
		}

		
		/**
		 * add a single flavor asset to a no-media entry 
		 */		
		protected function addFlavorAsset(e:BorhanEvent):void {
			e.target.removeEventListener(BorhanEvent.COMPLETE, addFlavorAsset);
			e.target.removeEventListener(BorhanEvent.FAILED, addFlavorAsset);
			if (e.type == BorhanEvent.COMPLETE) {
				var file:FileUploadVO = e.target as FileUploadVO;
				file.uploadToken = (e.data as BorhanUploadToken).id;
				var flavorAsset:BorhanFlavorAsset = new BorhanFlavorAsset();
				// pass in the flavorParamsId of the flavor we want this to be;
				flavorAsset.flavorParamsId = file.flavorParamsId;
				flavorAsset.setUpdatedFieldsOnly(true);
				flavorAsset.setInsertedFields(true);
				var resource:BorhanUploadedFileTokenResource = new BorhanUploadedFileTokenResource();
				// the token we used to upload the file
				resource.token = file.uploadToken;	
				
				// add listeners for complete / failed
				// pass events via fuv so we can retrieve a relevant vo after the call returns.
				file.addEventListener(BorhanEvent.COMPLETE, saveAssetParamsId/*, false, 0, true*/);
				file.addEventListener(BorhanEvent.FAILED, saveAssetParamsId/*, false, 0, true*/);
				
				var faa:FlavorAssetAdd = new FlavorAssetAdd(file.entryId, flavorAsset);
				faa.addEventListener(BorhanEvent.COMPLETE, file.bubbleEvent);
				faa.addEventListener(BorhanEvent.FAILED, file.bubbleEvent);
				// when this call returns, we need to save the assetParamsId to the VO.
				_kc.post(faa);
			} 
			else {
				// dispatch error event with relevant data
				var er:FileUploadEvent = new FileUploadEvent(FileUploadEvent.UPLOAD_ERROR, '');
				er.error = 'Error #206: ' + e.error.errorMsg;
				if (debugMode) {
					trace("UploadTokenAdd failed:");
					KStringUtil.traceObject(e.target);
					KStringUtil.traceObject(e.error.requestArgs);
				}
				dispatchEvent(er);
			}
		}
		
		
		
		/**
		 * saves the result's assetparams id to the target vo 
		 */
		protected function saveAssetParamsId(e:BorhanEvent):void {
			e.target.removeEventListener(BorhanEvent.COMPLETE, saveAssetParamsId);
			e.target.removeEventListener(BorhanEvent.FAILED, saveAssetParamsId);
			if (e.type == BorhanEvent.COMPLETE) {
				(e.target as FileUploadVO).flavorAssetId = (e.data as BorhanFlavorAsset).id;
				updateFlavorAsset(e);
			}
			else {
				// dispatch error event with relevant data
				var er:FileUploadEvent = new FileUploadEvent(FileUploadEvent.UPLOAD_ERROR, e.target.id);
				er.error = 'Error #207: ' + e.error.errorMsg;
				if (debugMode) {
					trace("FlavorAssetAdd failed:");
					KStringUtil.traceObject(e.target);
					KStringUtil.traceObject(e.error.requestArgs);
				}
				dispatchEvent(er);
			}
		}
		
		
		/**
		 * handler for security error or io error 
		 */		
		protected function fileFailed(e:Event):void {
			// clean listeners
			var file:FileReference = e.target as FileReference;
			file.removeEventListener(IOErrorEvent.IO_ERROR, fileFailed );
			file.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, fileFailed);
			var fuv:FileUploadVO = getUploadByFr(file);
			if (fuv) {
				fuv.status = FileUploadVO.STATUS_FAILED;
			}
			_ongoingUploads--;
			uploadNextFile();
			// alert user 
			var er:FileUploadEvent = new FileUploadEvent(FileUploadEvent.UPLOAD_ERROR, "0");
			er.error = ResourceManager.getInstance().getString('cms', 'uploadFailedMessage') + ", " + file.name;
			if (debugMode) {
				trace("actual upload failed: ", e.type);
				KStringUtil.traceObject(e);
			}
			dispatchEvent(er);
		}

		

		/**
		 * Cancels an upload according to uploadid.
		 *
		 * @param uploadid
		 */
		public function cancelUpload(uploadid:String):void {
			var file:FileUploadVO = getFile(uploadid);
			if (!file) {
				return;
			}
			
			if (file.status == FileUploadVO.STATUS_UPLOADING) {
				file.file.cancel();
			}
			else {
				// call uploadToken.delete with relevant upload token.
				var utd:UploadTokenDelete = new UploadTokenDelete(file.uploadToken);
				file.addEventListener(BorhanEvent.COMPLETE, handleDeleteResult);
				file.addEventListener(BorhanEvent.FAILED, handleDeleteResult);
				
				utd.addEventListener(BorhanEvent.COMPLETE, file.bubbleEvent);
				utd.addEventListener(BorhanEvent.FAILED, file.bubbleEvent);
				
				_kc.post(utd);
			}
			// Dispatch "fileUploadCanceled" event.
			dispatchEvent(new FileUploadEvent(FileUploadEvent.UPLOAD_CANCELED, uploadid));
			// Remove relevant fileVo from files list.	
			var ind:int = getQueuePosition(uploadid);
			_files.splice(ind, 1);
			filesCollection.refresh();
			if (file.status == FileUploadVO.STATUS_UPLOADING) {
				_ongoingUploads--;
				uploadNextFile();
			}
		}
		
		
		/**
		 * remove delete listeners, handle error. 
		 */
		protected function handleDeleteResult(e:BorhanEvent):void {
			e.target.removeEventListener(BorhanEvent.COMPLETE, handleDeleteResult);
			e.target.removeEventListener(BorhanEvent.FAILED, handleDeleteResult);
			if (e.type == BorhanEvent.FAILED) {
				// dispatch error event with relevant data
				var er:FileUploadEvent = new FileUploadEvent(FileUploadEvent.UPLOAD_ERROR, e.target.id);
				er.error = "Error #208: " + e.error.errorMsg;
				if (debugMode) {
					trace("UploadTokenDelete failed:");
					KStringUtil.traceObject(e.target);
					KStringUtil.traceObject(e.error.requestArgs);
				}
				dispatchEvent(er);
			}
		}

		/**
		 * Retrieve a file vo according to its file reference object 
		 * @param id	file reference
		 * @return 		FileUploadVO 
		 */		
		protected function getUploadByFr(o:FileReference):FileUploadVO {
			var result:FileUploadVO = null;
			for each (var file:FileUploadVO in _files) {
				if (file.file == o) {
					result = file;
					break;
				}
			}
			return result;
		}
		
		/**
		 * Retrieve a file vo according to uploadToken 
		 * @param id	uploadToken id
		 * @return 		FileUploadVO 
		 */		
		protected function getUploadByUploadToken(id:String):FileUploadVO {
			var result:FileUploadVO = null;
			for each (var file:FileUploadVO in _files) {
				if (file.uploadToken == id) {
					result = file;
					break;
				}
			}
			return result;
		}

	

		/**
		 * Get the position in the queue of a certain upload
		 *
		 * @param uploadid	id of the requested upload
		 *
		 * @return 	index of the upload in the uploads queue, or -1 if not found
		 */
		public function getQueuePosition(uploadid:String):int {
			var result:int = -1;
			for (var i:int = 0; i < _files.length; i++) {
				if (_files[i].id == uploadid) {
					result = i;
					break;
				}
			}
			return result;
		}


		/**
		 * Tries to move the referenced Vo to the supplied index.
		 * Uploads that are further down the queue will be pushed down.
		 *
		 * @param uploadid	id of the requested upload
		 * @param requiredIndex	the index to move the upload to.
		 *
		 * @return	true if move succeeded, false otherwise (i.e. illegal index).
		 */
		public function setQueuePosition(uploadid:String, requiredIndex:int):Boolean {
			if (requiredIndex > _files.length - 1) {
				return false;
			}
			// if the item at requiredIndex is already upoloading, return false
			var file:FileUploadVO = _files[requiredIndex] as FileUploadVO;
			if (file.status == FileUploadVO.STATUS_UPLOADING) {
				return false;
			} 
			var ind:int = getQueuePosition(uploadid);
			if (ind == -1) {
				return false;
			}
			// move file
			file = getFile(uploadid);
			_files.splice(ind, 1);
			_files.splice(requiredIndex, 0, file);
			filesCollection.refresh();
			return true;
		}

		
		/**
		 * Retrieve a file vo from the list.
		 *
		 * @param uploadid	id of the requested upload
		 *
		 * @return the file Vo referenced by the uploadid supplied, or null if not found
		 */
		public function getFile(uploadid:String):FileUploadVO {
			var result:FileUploadVO = null;
			for each (var file:FileUploadVO in _files) {
				if (file.id == uploadid) {
					result = file;
					break;
				}
			}
			return result;
		}

		[Bindable(event="filesChanged")]
		/**
		 * Retrieve all fileVos currently queued.
		 * Used for creating the dataprovider of the uploads tab.
		 *
		 * @return a vector of FileVo-s.
		 * 		references are to the actual objects, not to clones.
		 */
		public function getAllFiles():Array //Vector.<FileUploadVO> {
		{
			return _files.concat(_preprocessedFiles);
		}


		/**
		 * Determines the number of simultaneous uploads
		 */
		public function get concurrentUploads():int {
			return _concurrentUploads;
		}


		/**
		 * @private
		 */
		public function set concurrentUploads(value:int):void {
			_concurrentUploads = value;
		}


		/**
		 * client for API requests
		 */
		public function get kc():BorhanClient {
			return _kc;
		}


		/**
		 * @private
		 */
		public function set kc(value:BorhanClient):void {
			_kc = value;
		}


	}
}

class Enforcer {

}