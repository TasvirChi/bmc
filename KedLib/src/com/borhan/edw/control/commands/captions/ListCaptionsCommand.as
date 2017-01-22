package com.borhan.edw.control.commands.captions {
	import com.borhan.commands.MultiRequest;
	import com.borhan.commands.captionAsset.CaptionAssetGetUrl;
	import com.borhan.commands.captionAsset.CaptionAssetList;
	import com.borhan.edw.control.commands.KedCommand;
	import com.borhan.edw.model.datapacks.CaptionsDataPack;
	import com.borhan.edw.model.datapacks.EntryDataPack;
	import com.borhan.edw.vo.EntryCaptionVO;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmvc.control.BMvCEvent;
	import com.borhan.types.BorhanCaptionAssetStatus;
	import com.borhan.types.BorhanFlavorAssetStatus;
	import com.borhan.types.BorhanNullableBoolean;
	import com.borhan.vo.BorhanAssetFilter;
	import com.borhan.vo.BorhanCaptionAsset;
	import com.borhan.vo.BorhanCaptionAssetListResponse;
	import com.borhan.vo.BorhanFilterPager;

	public class ListCaptionsCommand extends KedCommand {
		private var _captionsArray:Array;
		/**
		 * array of captions in status ready, request download url only for these captions
		 * */
		private var _readyCaptionsArray:Array;


		override public function execute(event:BMvCEvent):void {
			_model.increaseLoadCounter();
			var filter:BorhanAssetFilter = new BorhanAssetFilter();
			filter.entryIdEqual = (_model.getDataPack(EntryDataPack) as EntryDataPack).selectedEntry.id;
			var pager:BorhanFilterPager = new BorhanFilterPager();
			pager.pageSize = 100;
			var listCaptions:CaptionAssetList = new CaptionAssetList(filter, pager);
			listCaptions.addEventListener(BorhanEvent.COMPLETE, listResult);
			listCaptions.addEventListener(BorhanEvent.FAILED, fault);

			_client.post(listCaptions);
		}


		private function listResult(data:Object):void {
			var listResponse:BorhanCaptionAssetListResponse = data.data as BorhanCaptionAssetListResponse;
			if (listResponse) {
				var mr:MultiRequest = new MultiRequest();
				_captionsArray = new Array();
				_readyCaptionsArray = new Array();
				for each (var caption:BorhanCaptionAsset in listResponse.objects) {
					var entryCaption:EntryCaptionVO = new EntryCaptionVO();
					entryCaption.caption = caption;
					entryCaption.bmcStatus = getBMCStatus(caption);
					entryCaption.serveUrl = _client.protocol + _client.domain + EntryCaptionVO.generalServeURL + "/ks/" + _client.ks + "/captionAssetId/" + caption.id;
					if (caption.isDefault == BorhanNullableBoolean.TRUE_VALUE) {
						entryCaption.isBmcDefault = true;
					}
					_captionsArray.push(entryCaption);
					if (caption.status == BorhanFlavorAssetStatus.READY) {
						var getUrl:CaptionAssetGetUrl = new CaptionAssetGetUrl(caption.id);
						mr.addAction(getUrl);
						_readyCaptionsArray.push(entryCaption);
					}
				}

				if (_readyCaptionsArray.length) {
					mr.addEventListener(BorhanEvent.COMPLETE, handleDownloadUrls);
					mr.addEventListener(BorhanEvent.FAILED, fault);
					_client.post(mr);
				}
				else //go strait to result
					result(data);
			}
		}


		private function getBMCStatus(caption:BorhanCaptionAsset):String {
			var result:String;
			switch (caption.status) {
				case BorhanCaptionAssetStatus.ERROR:
					result = EntryCaptionVO.ERROR;
					break;
				case BorhanCaptionAssetStatus.READY:
					result = EntryCaptionVO.SAVED;
					break;
//				case BorhanCaptionAssetStatus.DELETED:
//				case BorhanCaptionAssetStatus.IMPORTING:
//				case BorhanCaptionAssetStatus.QUEUED:
				default:
					result = EntryCaptionVO.PROCESSING;
					break;
				
			}
			return result;
		}


		private function handleDownloadUrls(data:Object):void {
			var urlResult:Array = data.data as Array;
			for (var i:int = 0; i < urlResult.length; i++) {
				if (urlResult[i] is String)
					(_readyCaptionsArray[i] as EntryCaptionVO).downloadUrl = urlResult[i] as String;
			}
			result(data);
		}


		override public function result(data:Object):void {
			super.result(data);
			
			(_model.getDataPack(CaptionsDataPack) as CaptionsDataPack).captionsArray = _captionsArray;
			_model.decreaseLoadCounter();
		}

	}
}