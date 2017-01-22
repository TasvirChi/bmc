package com.borhan.bmc.modules.account.control.command {
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.commands.category.CategoryList;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmc.business.JSGate;
	import com.borhan.bmc.modules.account.model.AccountModelLocator;
	import com.borhan.vo.BorhanCategory;
	import com.borhan.vo.BorhanCategoryFilter;
	import com.borhan.vo.BorhanCategoryListResponse;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;

	public class ListCategoriesCommand implements ICommand, IResponder {

		private var _model:AccountModelLocator = AccountModelLocator.getInstance();


		public function execute(event:CairngormEvent):void {
			var filter:BorhanCategoryFilter = new BorhanCategoryFilter();
			filter.privacyContextEqual = "*";	
			var list:CategoryList = new CategoryList(filter);
			list.addEventListener(BorhanEvent.COMPLETE, result);
			list.addEventListener(BorhanEvent.FAILED, fault);
			_model.context.kc.post(list);
		}


		public function result(data:Object):void {
			var listResult:BorhanCategoryListResponse = data.data as BorhanCategoryListResponse;
			if (!listResult.objects || listResult.objects.length == 0) {
				var n_a:String = ResourceManager.getInstance().getString('account', 'n_a');
				var dummy:BorhanCategory = new BorhanCategory();
				dummy.name = n_a;
				dummy.privacyContext = n_a;
				dummy.disabled = true;	// will later use this value to disable actions in IR
				_model.categoriesWithPrivacyContext = [dummy];
			} 
			else {
				_model.categoriesWithPrivacyContext = listResult.objects;
			}
		}


		/**
		 * This function handles errors from the server
		 * @param info the error from the server
		 *
		 */
		public function fault(info:Object):void {
			if (info && info.error && info.error.errorMsg && info.error.errorMsg.toString().indexOf("Invalid KS") > -1) {
				JSGate.expired();
				return;
			}
			_model.loadingFlag = false;
			Alert.show(info.error.errorMsg, ResourceManager.getInstance().getString('account', 'error'));

		}
	}
}
