package com.borhan.bmc.modules.admin.control.commands
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.commands.partner.PartnerGetInfo;
	import com.borhan.events.BorhanEvent;
	import com.borhan.vo.BorhanPartner;

	public class GetPartnerInfoCommand extends BaseCommand {
		
		override public function execute(event:CairngormEvent):void {
			var getPartnerInfo:PartnerGetInfo = new PartnerGetInfo();
			getPartnerInfo.addEventListener(BorhanEvent.COMPLETE, result);
			getPartnerInfo.addEventListener(BorhanEvent.FAILED, fault);
			_model.increaseLoadCounter();
			_model.kc.post(getPartnerInfo);	
		}
		
		override protected function result(data:Object):void {
			super.result(data);
			if (data.success) {
				_model.usersModel.loginUsersQuota = (data.data as BorhanPartner).adminLoginUsersQuota;
				_model.usersModel.adminUserId = (data.data as BorhanPartner).adminUserId;
				_model.usersModel.crippledUsers = [(data.data as BorhanPartner).adminUserId, _model.usersModel.currentUserInfo.user.id]; 
			}
			_model.decreaseLoadCounter();
		}
		
	}
}