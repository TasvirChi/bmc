package com.borhan.edw.control.commands.relatedFiles
{
	import com.borhan.commands.attachmentAsset.AttachmentAssetUpdate;
	import com.borhan.edw.control.commands.KedCommand;
	import com.borhan.edw.control.events.RelatedFileEvent;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmvc.control.BMvCEvent;
	import com.borhan.vo.BorhanAttachmentAsset;
	
	public class UpdateRelatedFileCommand extends KedCommand
	{
		override public function execute(event:BMvCEvent):void {
			_model.increaseLoadCounter();
			var file:BorhanAttachmentAsset = (event as RelatedFileEvent).attachmentAsset;
			file.setUpdatedFieldsOnly(true);
			
			var updateAsset:AttachmentAssetUpdate = new AttachmentAssetUpdate(file.id, file);
			updateAsset.addEventListener(BorhanEvent.COMPLETE, result);
			updateAsset.addEventListener(BorhanEvent.FAILED, fault);
			
			_client.post(updateAsset);
		}
		
		override public function result(data:Object):void {
			super.result(data);
			
			_model.decreaseLoadCounter();
		}
	}
}