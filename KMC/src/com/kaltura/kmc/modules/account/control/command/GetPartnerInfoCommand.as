package com.borhan.bmc.modules.account.control.command {
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.commands.partner.PartnerGetInfo;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmc.business.JSGate;
	import com.borhan.bmc.modules.account.business.PartnerInfoUtil;
	import com.borhan.bmc.modules.account.model.AccountModelLocator;
	import com.borhan.bmc.modules.account.vo.NotificationVO;
	import com.borhan.bmc.modules.account.vo.PartnerVO;
	import com.borhan.vo.BorhanPartner;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;

	public class GetPartnerInfoCommand implements ICommand, IResponder {
		private var _model:AccountModelLocator = AccountModelLocator.getInstance();


		public function execute(event:CairngormEvent):void {
			//we only load the partner info 1 time in this app
			if (_model.partnerInfoLoaded)
				return;

			_model.loadingFlag = true;

			var getPartnerInfo:PartnerGetInfo = new PartnerGetInfo();
			getPartnerInfo.addEventListener(BorhanEvent.COMPLETE, result);
			getPartnerInfo.addEventListener(BorhanEvent.FAILED, fault);
			_model.context.kc.post(getPartnerInfo);
		}


		public function result(data:Object):void {
			_model.loadingFlag = false;
			if (data.data is BorhanPartner) {
				var resultKp:BorhanPartner = data.data as BorhanPartner;
				var pvo:PartnerVO = new PartnerVO;
				pvo.partner = resultKp;

				pvo.partnerId = _model.context.kc.partnerId;
				pvo.subPId = _model.context.subpId;

				PartnerInfoUtil.createNotificationArray(resultKp.notificationsConfig, pvo.notifications);

				_model.partnerData = pvo;
			}
			_model.partnerInfoLoaded = true;
		}


		public function fault(info:Object):void {
			if (info && info.error && info.error.errorMsg && info.error.errorMsg.toString().indexOf("Invalid KS") > -1) {
				JSGate.expired();
				return;
			}
			Alert.show(ResourceManager.getInstance().getString('account', 'notLoadPartnerData'), ResourceManager.getInstance().getString('account', 'error'));
			_model.loadingFlag = false;
		}


	}
}
