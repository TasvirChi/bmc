package com.borhan.edw.control.commands
{
	import com.borhan.bmvc.control.BMvCEvent;
	import com.borhan.commands.uploadToken.UploadTokenAdd;
	import com.borhan.commands.uploadToken.UploadTokenUpload;
	import com.borhan.events.BorhanEvent;
	import com.borhan.edw.control.events.UploadTokenEvent;
	import com.borhan.edw.vo.AssetVO;
	import com.borhan.vo.BorhanUploadToken;
	
	import flash.net.FileReference;
	import com.borhan.edw.control.commands.KedCommand;

	/**
	 * This class will start an upload using uploadToken service. will save the token
	 * on the given object 
	 * @author Michal
	 * 
	 */	
	public class UploadTokenCommand extends KedCommand
	{
		private var _fr:FileReference;
		private var _asset:AssetVO;
		
		override public function execute(event:BMvCEvent):void {
			_model.increaseLoadCounter();
			_fr = (event as UploadTokenEvent).fileReference
			_asset = (event as UploadTokenEvent).assetVo;
			
			var uploadToken:BorhanUploadToken = new BorhanUploadToken();
			var uploadTokenAdd:UploadTokenAdd = new UploadTokenAdd(uploadToken);
			
			uploadTokenAdd.addEventListener(BorhanEvent.COMPLETE, uploadTokenAddHandler);
			uploadTokenAdd.addEventListener(BorhanEvent.FAILED, fault);
			_client.post(uploadTokenAdd);
		}
		
		private function uploadTokenAddHandler(event:BorhanEvent):void {
			var result:BorhanUploadToken = event.data as BorhanUploadToken;
			if (result) {
				_asset.uploadTokenId = result.id;
				//_caption.downloadUrl = null;
				var uploadTokenUpload:UploadTokenUpload = new UploadTokenUpload(result.id, _fr);
				uploadTokenUpload.queued = false;
				uploadTokenUpload.useTimeout = false;
				uploadTokenUpload.addEventListener(BorhanEvent.FAILED, fault);
				
				_client.post(uploadTokenUpload);
			}
			_model.decreaseLoadCounter();
		}
	}
}