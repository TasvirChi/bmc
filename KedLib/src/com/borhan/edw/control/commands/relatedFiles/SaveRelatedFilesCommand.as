package com.borhan.edw.control.commands.relatedFiles
{
	import com.borhan.commands.MultiRequest;
	import com.borhan.commands.attachmentAsset.AttachmentAssetAdd;
	import com.borhan.commands.attachmentAsset.AttachmentAssetDelete;
	import com.borhan.commands.attachmentAsset.AttachmentAssetSetContent;
	import com.borhan.commands.attachmentAsset.AttachmentAssetUpdate;
	import com.borhan.edw.control.commands.KedCommand;
	import com.borhan.edw.control.events.RelatedFileEvent;
	import com.borhan.edw.model.datapacks.EntryDataPack;
	import com.borhan.edw.vo.RelatedFileVO;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmvc.control.BMvCEvent;
	import com.borhan.vo.BorhanUploadedFileTokenResource;
	
	public class SaveRelatedFilesCommand extends KedCommand
	{
		override public function execute(event:BMvCEvent):void {
			var evt:RelatedFileEvent = event as RelatedFileEvent;

			var mr:MultiRequest = new MultiRequest();
			var requestIndex:int = 1;
			//add assets
			if (evt.relatedToAdd) {
				for each (var relatedFile:RelatedFileVO in evt.relatedToAdd) {
					//add asset
					var addFile:AttachmentAssetAdd = new AttachmentAssetAdd((_model.getDataPack(EntryDataPack) as EntryDataPack).selectedEntry.id, relatedFile.file);
					mr.addAction(addFile);
					requestIndex++;
					//set its content
					var resource:BorhanUploadedFileTokenResource = new BorhanUploadedFileTokenResource();
					resource.token = relatedFile.uploadTokenId;
					var addContent:AttachmentAssetSetContent = new AttachmentAssetSetContent('0', resource);
					mr.mapMultiRequestParam(requestIndex-1, "id", requestIndex, "id");
					mr.addAction(addContent);
					requestIndex++;	
				}
			}
			//update assets
			if (evt.relatedToUpdate) {
				for each (var updateRelated:RelatedFileVO in evt.relatedToUpdate) {
					updateRelated.file.setUpdatedFieldsOnly(true);
					var updateAsset:AttachmentAssetUpdate = new AttachmentAssetUpdate(updateRelated.file.id, updateRelated.file);
					mr.addAction(updateAsset);
					requestIndex++;
				}
			}
			if (evt.relatedToDelete) {
				for each (var deleteRelated:RelatedFileVO in evt.relatedToDelete) {
					var deleteAsset:AttachmentAssetDelete = new AttachmentAssetDelete(deleteRelated.file.id);
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