package com.borhan.bmc.modules.content.commands.cat
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.commands.MultiRequest;
	import com.borhan.commands.category.CategoryUpdate;
	import com.borhan.errors.BorhanError;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmc.business.CategoryUtils;
	import com.borhan.bmc.modules.content.commands.BorhanCommand;
	import com.borhan.vo.BorhanCategory;
	
	import mx.controls.Alert;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;

	public class UpdateSubCategoriesCommand extends BorhanCommand {
		
		override public function execute(event:CairngormEvent):void {
			_model.increaseLoadCounter();
			
			var ar:Array = event.data as Array;
			var mr:MultiRequest = new MultiRequest();
			var catUpdate:CategoryUpdate;
			for (var i:int = 0; i<ar.length; i++) {
				ar[i].setUpdatedFieldsOnly(true);
				CategoryUtils.resetUnupdateableFields(ar[i] as BorhanCategory);
				catUpdate = new CategoryUpdate(ar[i].id, ar[i]);
				mr.addAction(catUpdate);
			}
			
			mr.addEventListener(BorhanEvent.COMPLETE, result);
			mr.addEventListener(BorhanEvent.FAILED, fault);
			_model.context.kc.post(mr);
		}
		
		
		override public function result(data:Object):void {
			_model.decreaseLoadCounter();
			super.result(data);
			var rm:IResourceManager = ResourceManager.getInstance();
			
			// check for errors
			var er:BorhanError = (data as BorhanEvent).error;
			if (er) { 
				Alert.show(getErrorText(er), rm.getString('cms', 'error'));
				return;
			}
			else {
				// look iside MR
				for each (var o:Object in data.data) {
					er = o as BorhanError;
					if (er) {
						Alert.show(getErrorText(er), rm.getString('cms', 'error'));
					}
					else if (o.error) {
						// in MR errors aren't created
						var str:String = rm.getString('cms', o.error.code);
						if (!str) {
							str = o.error.message;
						} 
						Alert.show(str, rm.getString('cms', 'error'));
					}
				}	
			}
			
			
		}
	}
}