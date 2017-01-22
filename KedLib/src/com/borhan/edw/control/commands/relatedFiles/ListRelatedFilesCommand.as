package com.borhan.edw.control.commands.relatedFiles
{
	import com.borhan.commands.attachmentAsset.AttachmentAssetList;
	import com.borhan.edw.control.commands.KedCommand;
	import com.borhan.edw.model.datapacks.EntryDataPack;
	import com.borhan.edw.model.datapacks.RelatedFilesDataPack;
	import com.borhan.edw.vo.RelatedFileVO;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmvc.control.BMvCEvent;
	import com.borhan.vo.BorhanAssetFilter;
	import com.borhan.vo.BorhanAttachmentAsset;
	import com.borhan.vo.BorhanAttachmentAssetListResponse;
	
	import mx.collections.ArrayCollection;

	public class ListRelatedFilesCommand extends KedCommand
	{
		override public function execute(event:BMvCEvent):void {
			_model.increaseLoadCounter();
			var filter:BorhanAssetFilter = new BorhanAssetFilter();
			filter.entryIdEqual = (_model.getDataPack(EntryDataPack) as EntryDataPack).selectedEntry.id;
			var list:AttachmentAssetList = new AttachmentAssetList(filter);
			list.addEventListener(BorhanEvent.COMPLETE, result);
			list.addEventListener(BorhanEvent.FAILED, fault);
			
			_client.post(list);
		}
		
		override public function result(data:Object):void {
			super.result(data);
			var listResult:BorhanAttachmentAssetListResponse = data.data as BorhanAttachmentAssetListResponse;
			if (listResult) {
				var relatedAC:ArrayCollection = new ArrayCollection();
				for each (var asset:BorhanAttachmentAsset in listResult.objects) {
					var relatedVo:RelatedFileVO = new RelatedFileVO();
					relatedVo.file = asset;
					relatedVo.serveUrl = _client.protocol + _client.domain + RelatedFileVO.serveURL + "/ks/" + _client.ks + "/attachmentAssetId/" + asset.id;
					relatedAC.addItem(relatedVo);
				}
				(_model.getDataPack(RelatedFilesDataPack) as RelatedFilesDataPack).relatedFilesAC = relatedAC;
			}
			
			_model.decreaseLoadCounter();
		}
	}
}