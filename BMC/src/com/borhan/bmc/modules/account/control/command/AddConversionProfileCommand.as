package com.borhan.bmc.modules.account.control.command {
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.commands.MultiRequest;
	import com.borhan.commands.conversionProfile.ConversionProfileAdd;
	import com.borhan.commands.conversionProfileAssetParams.ConversionProfileAssetParamsUpdate;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmc.business.JSGate;
	import com.borhan.bmc.modules.account.control.events.ConversionSettingsEvent;
	import com.borhan.bmc.modules.account.model.AccountModelLocator;
	import com.borhan.bmc.modules.account.vo.ConversionProfileVO;
	import com.borhan.vo.BorhanConversionProfileAssetParams;
	
	import mx.controls.Alert;
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;

	public class AddConversionProfileCommand implements ICommand, IResponder {
		private var _model:AccountModelLocator = AccountModelLocator.getInstance();

		private var _nextEvent:CairngormEvent;

		public function execute(event:CairngormEvent):void {
			_nextEvent = (event as ConversionSettingsEvent).nextEvent;
			
			var cProfile:ConversionProfileVO = event.data as ConversionProfileVO;
			
			var mr:MultiRequest = new MultiRequest();
			var cnt:int = 1;	// mr index counter
			cProfile.profile.setUpdatedFieldsOnly(true);
			cProfile.profile.setInsertedFields(true);
			var addConversionProfile:ConversionProfileAdd = new ConversionProfileAdd(cProfile.profile);
			mr.addAction(addConversionProfile);
			
			var cpapu:ConversionProfileAssetParamsUpdate;
			// see if any conversion flavours need to be updated:
			for each (var cpap:BorhanConversionProfileAssetParams in cProfile.flavors) {
				if (cpap.dirty) {
					cnt ++;
					cpap.setUpdatedFieldsOnly(true);
					cpapu = new ConversionProfileAssetParamsUpdate(-1, cpap.assetParamsId, cpap);
					mr.mapMultiRequestParam(1, "id", cnt, "conversionProfileId");
					mr.addAction(cpapu);
				}
			} 
			
			mr.addEventListener(BorhanEvent.COMPLETE, result);
			mr.addEventListener(BorhanEvent.FAILED, fault);
			_model.context.kc.post(mr);
		}


		public function result(data:Object):void {
			_model.loadingFlag = false;
			if (_nextEvent) {
				_nextEvent.dispatch();
			}
		}


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