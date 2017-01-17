package com.borhan.edw.control.commands.captions
{
	import com.borhan.commands.MultiRequest;
	import com.borhan.commands.captionAsset.CaptionAssetAdd;
	import com.borhan.commands.captionAsset.CaptionAssetDelete;
	import com.borhan.commands.captionAsset.CaptionAssetSetAsDefault;
	import com.borhan.commands.captionAsset.CaptionAssetSetContent;
	import com.borhan.commands.captionAsset.CaptionAssetUpdate;
	import com.borhan.edw.control.commands.KedCommand;
	import com.borhan.edw.control.events.CaptionsEvent;
	import com.borhan.edw.model.datapacks.EntryDataPack;
	import com.borhan.edw.vo.EntryCaptionVO;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmvc.control.BMvCEvent;
	import com.borhan.types.BorhanNullableBoolean;
	import com.borhan.vo.BorhanContentResource;
	import com.borhan.vo.BorhanUploadedFileTokenResource;
	import com.borhan.vo.BorhanUrlResource;
	
	public class SaveCaptionsCommand extends KedCommand
	{
		override public function execute(event:BMvCEvent):void {
			var evt:CaptionsEvent = event as CaptionsEvent;	
			var mr:MultiRequest = new MultiRequest();
			var requestIndex:int = 1;
			//set as default
			if (evt.defaultCaption && evt.defaultCaption.caption.isDefault!=BorhanNullableBoolean.TRUE_VALUE) {
				var setDefault:CaptionAssetSetAsDefault = new CaptionAssetSetAsDefault(evt.defaultCaption.caption.id);
				mr.addAction(setDefault);
				requestIndex++;
			}
			if (evt.captionsToSave) {
				for each (var caption:EntryCaptionVO in evt.captionsToSave) {
					//handle resource
					var resource:BorhanContentResource; 
					if (caption.uploadTokenId) {
						resource = new BorhanUploadedFileTokenResource();
						resource.token = caption.uploadTokenId;
					}
					else if (caption.resourceUrl && (!caption.downloadUrl || (caption.resourceUrl!=caption.downloadUrl))) {
						resource = new BorhanUrlResource();
						resource.url = caption.resourceUrl;
					}
					//new caption
					if (!caption.caption.id) {		
						var addCaption:CaptionAssetAdd = new CaptionAssetAdd((_model.getDataPack(EntryDataPack) as EntryDataPack).selectedEntry.id, caption.caption);
						mr.addAction(addCaption);
						requestIndex++;
						if (resource) {
							var addContent:CaptionAssetSetContent = new CaptionAssetSetContent('0', resource);
							mr.mapMultiRequestParam(requestIndex-1, "id", requestIndex, "id");
							mr.addAction(addContent);
							requestIndex++;
						}
					}
						//update existing one
					else {
						caption.caption.setUpdatedFieldsOnly(true);
						var update:CaptionAssetUpdate = new CaptionAssetUpdate(caption.caption.id, caption.caption);
						mr.addAction(update);
						requestIndex++;
						if (resource) {
							var updateContent:CaptionAssetSetContent = new CaptionAssetSetContent(caption.caption.id, resource);
							mr.addAction(updateContent);
							requestIndex++;
						}
					}
				}
			}
			//delete captions
			if (evt.captionsToRemove) {
				for each (var delCap:EntryCaptionVO in evt.captionsToRemove) {
					var deleteAsset:CaptionAssetDelete = new CaptionAssetDelete(delCap.caption.id);
					mr.addAction(deleteAsset);
					requestIndex++;
				}
			}
			
			
			if (requestIndex > 1) {
				_model.increaseLoadCounter();
				mr.addEventListener(BorhanEvent.COMPLETE, result);
				mr.addEventListener(BorhanEvent.FAILED, fault);
				
				_client.post(mr);
			}
		}
		
		override public function result(data:Object):void {
			super.result(data);
			_model.decreaseLoadCounter();
		}
	}
}