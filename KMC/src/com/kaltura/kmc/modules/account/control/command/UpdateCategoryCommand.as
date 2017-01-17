package com.borhan.bmc.modules.account.control.command {
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.commands.category.CategoryUpdate;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmc.business.JSGate;
	import com.borhan.bmc.modules.account.control.events.IntegrationEvent;
	import com.borhan.bmc.modules.account.model.AccountModelLocator;
	import com.borhan.vo.BorhanCategory;
	
	import mx.controls.Alert;
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;

	public class UpdateCategoryCommand implements ICommand, IResponder {

		private var _model:AccountModelLocator = AccountModelLocator.getInstance();


		public function execute(event:CairngormEvent):void {
			_model.loadingFlag = true;
			var kCat:BorhanCategory = event.data as BorhanCategory;
			kCat.setUpdatedFieldsOnly(true);
			var update:CategoryUpdate = new CategoryUpdate(kCat.id, kCat);
			update.addEventListener(BorhanEvent.COMPLETE, result);
			update.addEventListener(BorhanEvent.FAILED, fault);
			_model.context.kc.post(update);
		}


		public function result(data:Object):void {
			var event:BorhanEvent = data as BorhanEvent;
			_model.loadingFlag = false;
			if (event.success) {
				// list categories with context again
				var list:IntegrationEvent = new IntegrationEvent(IntegrationEvent.LIST_CATEGORIES_WITH_PRIVACY_CONTEXT);
				list.dispatch();
			}
			else {
				Alert.show((data as BorhanEvent).error.errorMsg, ResourceManager.getInstance().getString('account', 'error'));
			}

		}


		public function fault(info:Object):void {
			if (info && info.error && info.error.errorMsg) {
				
			 	if (info.error.errorMsg.toString().indexOf("Invalid KS") > -1) {
					JSGate.expired();
					return;
				}
				else {
					Alert.show(info.error.errorMsg, ResourceManager.getInstance().getString('account', 'error'));	
				}
			}
			_model.loadingFlag = false;
		}

	}
}
