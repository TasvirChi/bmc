package com.borhan.bmc.modules.account.control.command {
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.analytics.GoogleAnalyticsConsts;
	import com.borhan.analytics.GoogleAnalyticsTracker;
	import com.borhan.analytics.KAnalyticsTracker;
	import com.borhan.analytics.KAnalyticsTrackerConsts;
	import com.borhan.commands.MultiRequest;
	import com.borhan.commands.accessControl.AccessControlDelete;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmc.business.JSGate;
	import com.borhan.bmc.modules.account.control.events.AccessControlEvent;
	import com.borhan.bmc.modules.account.model.AccountModelLocator;
	import com.borhan.types.BorhanStatsBmcEventType;
	import com.borhan.vo.AccessControlProfileVO;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;

	public class DeleteAccessControlProfilesCommand implements ICommand, IResponder {
		private var _model:AccountModelLocator = AccountModelLocator.getInstance();

		private var _profiles:Array;

		public function execute(event:CairngormEvent):void {
			var rm:IResourceManager = ResourceManager.getInstance(); 
			_profiles = event.data;
			
			if (_profiles.length == 0) {
				Alert.show(rm.getString('account', 'noProfilesSelected'));
				return;
			}
			
			var delStr:String = '';
			for each (var acp:AccessControlProfileVO in _profiles) {
				if (!acp.profile.isDefault) {
					delStr += '\n' + acp.profile.name;
				}
			}
			
			var msg:String = rm.getString('account', 'deleteAccessControlAlertMsg', [delStr]);
			var title:String = rm.getString('account', 'deleteAccessControlAlertTitle');
			Alert.show(msg, title, Alert.YES | Alert.NO, null, deleteSelectedProfiles);
		}
		
		
		private function deleteSelectedProfiles(evt:CloseEvent):void {
			if (evt.detail == Alert.YES) {
				var mr:MultiRequest = new MultiRequest();
				for each (var prof:AccessControlProfileVO in _profiles) {
					var deleteProf:AccessControlDelete = new AccessControlDelete(prof.profile.id);
					mr.addAction(deleteProf);
				}
				
				mr.addEventListener(BorhanEvent.COMPLETE, result);
				mr.addEventListener(BorhanEvent.FAILED, fault);
				_model.context.kc.post(mr);
				
				KAnalyticsTracker.getInstance().sendEvent(KAnalyticsTrackerConsts.ACCOUNT, BorhanStatsBmcEventType.ACCOUNT_ACCESS_CONTROL_DELETE, "Account>Access Control Delete");
				GoogleAnalyticsTracker.getInstance().sendToGA(GoogleAnalyticsConsts.ACCOUNT_ACCESS_CONTROL_DELETE, GoogleAnalyticsConsts.ACCOUNT);
			}
		}



		public function result(data:Object):void {
			_model.loadingFlag = false;
			if (data.success) {
				if (_profiles.length > 1) {
					Alert.show(ResourceManager.getInstance().getString('account', 'deleteAccessProfilesDoneMsg'));
				}
				else {
					Alert.show(ResourceManager.getInstance().getString('account', 'deleteAccessProfileDoneMsg'));
				}
				var getAllProfilesEvent:AccessControlEvent = new AccessControlEvent(AccessControlEvent.ACCOUNT_LIST_ACCESS_CONTROLS_PROFILES);
				getAllProfilesEvent.dispatch();
			}
			else {
				Alert.show(data.error, ResourceManager.getInstance().getString('account', 'error'));
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
