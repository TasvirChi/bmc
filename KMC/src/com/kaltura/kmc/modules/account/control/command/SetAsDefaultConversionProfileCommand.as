package com.borhan.bmc.modules.account.control.command
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.commands.MultiRequest;
	import com.borhan.commands.conversionProfile.ConversionProfileList;
	import com.borhan.commands.conversionProfile.ConversionProfileSetAsDefault;
	import com.borhan.commands.conversionProfileAssetParams.ConversionProfileAssetParamsList;
	import com.borhan.errors.BorhanError;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmc.business.JSGate;
	import com.borhan.bmc.modules.account.control.events.ConversionSettingsEvent;
	import com.borhan.bmc.modules.account.model.AccountModelLocator;
	import com.borhan.bmc.modules.account.utils.ListConversionProfilesUtil;
	import com.borhan.bmc.modules.account.vo.ConversionProfileVO;
	import com.borhan.types.BorhanConversionProfileType;
	import com.borhan.vo.BorhanConversionProfile;
	import com.borhan.vo.BorhanConversionProfileAssetParamsListResponse;
	import com.borhan.vo.BorhanConversionProfileFilter;
	import com.borhan.vo.BorhanConversionProfileListResponse;
	import com.borhan.vo.BorhanFilterPager;
	
	import mx.controls.Alert;
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;
	
	public class SetAsDefaultConversionProfileCommand implements ICommand, IResponder
	{
		private var _model : AccountModelLocator = AccountModelLocator.getInstance();
		
		private var _nextEvent:CairngormEvent;
		
		public function execute(event:CairngormEvent):void {
			_model.loadingFlag = true;
			
			_nextEvent = (event as ConversionSettingsEvent).nextEvent;
			
			var cp:BorhanConversionProfile = event.data as BorhanConversionProfile;
			var setDefault:ConversionProfileSetAsDefault = new ConversionProfileSetAsDefault(cp.id);
			
			setDefault.addEventListener(BorhanEvent.COMPLETE, result);
			setDefault.addEventListener(BorhanEvent.FAILED, fault);
			
			_model.context.kc.post(setDefault);
		}
		
		
		public function result(event:Object):void {
			_model.loadingFlag = false;
			var er:BorhanError;
			if (event.error) {
				er = event.error as BorhanError;
				if (er) {
					Alert.show(er.errorMsg, ResourceManager.getInstance().getString('account', 'error'));
				}
			}
			if (_nextEvent) {
				_nextEvent.dispatch();
			}
		}
		
		
		public function fault(info:Object):void
		{
			_model.loadingFlag = false;
			if (info && info.error && info.error.errorMsg) {
				if (info.error.errorMsg.toString().indexOf("Invalid KS") > -1 ) {
					JSGate.expired();
				} 
				else {
					Alert.show(info && info.error && info.error.errorMsg);
					
				}
			}
		}
	}
}