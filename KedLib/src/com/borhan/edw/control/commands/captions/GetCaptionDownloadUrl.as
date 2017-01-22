package com.borhan.edw.control.commands.captions
{
	import com.borhan.commands.captionAsset.CaptionAssetGet;
	import com.borhan.commands.captionAsset.CaptionAssetGetUrl;
	import com.borhan.edw.control.commands.KedCommand;
	import com.borhan.edw.control.events.CaptionsEvent;
	import com.borhan.edw.vo.EntryCaptionVO;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmvc.control.BMvCEvent;
	import com.borhan.types.BorhanFlavorAssetStatus;
	import com.borhan.vo.BorhanCaptionAsset;
	
	
	public class GetCaptionDownloadUrl extends KedCommand
	{
		private var _captionVo:EntryCaptionVO;
		
		/**
		 * Will get the captionAsset, if its status=ready will ask for the updated donwload URL 
		 * @param event
		 * 
		 */		
		override public function execute(event:BMvCEvent):void {
			_captionVo = (event as CaptionsEvent).captionVo;
			if (_captionVo.caption && _captionVo.caption.id) {
				_model.increaseLoadCounter();
				
				var getCaption:CaptionAssetGet = new CaptionAssetGet(_captionVo.caption.id);
				getCaption.addEventListener(BorhanEvent.COMPLETE, captionRecieved);
				getCaption.addEventListener(BorhanEvent.FAILED, fault);
				
				_client.post(getCaption);
			}
		}
		
		/**
		 * On captionAsset result, will call getDownloadUrl if in status ready 
		 * @param event
		 * 
		 */		
		private function captionRecieved(event:BorhanEvent):void {
			if (event.data is BorhanCaptionAsset) {
				var resultCaption:BorhanCaptionAsset = event.data as BorhanCaptionAsset;
				_captionVo.caption.status = resultCaption.status;
				if (_captionVo.caption.status == BorhanFlavorAssetStatus.READY) {
//					var getUrl:CaptionAssetGetDownloadUrl = new CaptionAssetGetDownloadUrl(_captionVo.caption.id);
					var getUrl:CaptionAssetGetUrl = new CaptionAssetGetUrl(_captionVo.caption.id);
					getUrl.addEventListener(BorhanEvent.COMPLETE, result);
					getUrl.addEventListener(BorhanEvent.FAILED, fault);
					_client.post(getUrl);
				}
				else {
					_model.decreaseLoadCounter();
				}
			}
		}
		
		/**
		 * will reset the upload token id since upload has finished
		 * */
		override public function result(data:Object):void {
			super.result(data);
			_captionVo.downloadUrl = data.data as String;
			_captionVo.uploadTokenId = null;
			_model.decreaseLoadCounter();
		}
	}
}