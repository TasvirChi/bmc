package com.borhan.bmc.modules.content.commands {
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.commands.flavorParams.FlavorParamsList;
	import com.borhan.errors.BorhanError;
	import com.borhan.events.BorhanEvent;
	import com.borhan.edw.model.types.APIErrorCode;
	import com.borhan.vo.BorhanFilterPager;
	import com.borhan.vo.BorhanFlavorParams;
	import com.borhan.vo.BorhanFlavorParamsListResponse;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;
	import com.borhan.edw.model.util.FlavorParamsUtil;

	public class ListFlavorsParamsCommand extends BorhanCommand implements ICommand, IResponder {
		public static const DEFAULT_PAGE_SIZE:int = 500;
		
		override public function execute(event:CairngormEvent):void {
			_model.increaseLoadCounter();
			var flavorsPager:BorhanFilterPager = new BorhanFilterPager();
			flavorsPager.pageSize = DEFAULT_PAGE_SIZE;
			var getListFlavorParams:FlavorParamsList = new FlavorParamsList(null, flavorsPager);
			getListFlavorParams.addEventListener(BorhanEvent.COMPLETE, result);
			getListFlavorParams.addEventListener(BorhanEvent.FAILED, fault);
			_model.context.kc.post(getListFlavorParams);
		}


		override public function result(event:Object):void {
//			super.result(event);
			if (event.error) {
				var er:BorhanError = event.error as BorhanError;
				if (er) {
					Alert.show(er.errorMsg, "Error");
				}
			}
			else {
				clearOldData();
				var tempFlavorParamsArr:ArrayCollection = new ArrayCollection();
				var response:BorhanFlavorParamsListResponse = event.data as BorhanFlavorParamsListResponse;
				// loop on Object and cast to BorhanFlavorParams so we don't crash on unknown types:
				for each (var kFlavor:Object in response.objects) {
					if (kFlavor is BorhanFlavorParams) {
						tempFlavorParamsArr.addItem(kFlavor);
					}
					else {
						tempFlavorParamsArr.addItem(FlavorParamsUtil.makeFlavorParams(kFlavor));
					}
				}
				_model.filterModel.flavorParams = tempFlavorParamsArr;
			}
			_model.decreaseLoadCounter();
		}

//		/**
//		 * This function will be called if the request failed
//		 * @param info the info returned from the server
//		 * 
//		 */		
//		override public function fault(info:Object):void
//		{
//			
//			if(info && info.error && info.error.errorMsg && info.error.errorCode != APIErrorCode.SERVICE_FORBIDDEN)
//			{
//				Alert.show(info.error.errorMsg, ResourceManager.getInstance().getString('cms', 'error'));
//			}
//			_model.decreaseLoadCounter();
//		}

		private function clearOldData():void {
			_model.filterModel.flavorParams.removeAll();
		}
	}
}