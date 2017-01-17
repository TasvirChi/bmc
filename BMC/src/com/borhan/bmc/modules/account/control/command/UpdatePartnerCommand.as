package com.borhan.bmc.modules.account.control.command {
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.commands.partner.PartnerUpdate;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmc.business.JSGate;
	import com.borhan.bmc.modules.account.business.PartnerInfoUtil;
	import com.borhan.bmc.modules.account.model.AccountModelLocator;
	import com.borhan.bmc.modules.account.vo.NotificationVO;
	import com.borhan.vo.BorhanPartner;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.resources.ResourceManager;

	public class UpdatePartnerCommand implements ICommand {
		private var _model:AccountModelLocator = AccountModelLocator.getInstance();


		public function execute(event:CairngormEvent):void {
			_model.loadingFlag = true;

			var kp:BorhanPartner = _model.partnerData.partner;
			kp.notificationsConfig = PartnerInfoUtil.getNotificationsConfig(_model.partnerData.notifications);
			kp.setUpdatedFieldsOnly(true);
			var updatePartner:PartnerUpdate = new PartnerUpdate(kp, true);
			updatePartner.addEventListener(BorhanEvent.COMPLETE, result);
			updatePartner.addEventListener(BorhanEvent.FAILED, fault);
			_model.context.kc.post(updatePartner);
		}


		private function result(data:Object):void {
			_model.loadingFlag = false;
			_model.partnerData.partner = data.data as BorhanPartner; 
//			PartnerInfoUtil.createNotificationArray(resultKp.notificationsConfig, pvo.notifications);
			Alert.show(ResourceManager.getInstance().getString('account', 'changesSaved'));
		}


		private function fault(info:Object):void {
			_model.loadingFlag = false;
			if (info && info.error && info.error.errorMsg && info.error.errorMsg.toString().indexOf("Invalid KS") > -1) {
				JSGate.expired();
				return;
			}
			Alert.show(info.error.errorMsg, ResourceManager.getInstance().getString('account', 'error'));
		}
	}
}
