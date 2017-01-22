package com.borhan.bmc.modules.account.control.command
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.BorhanClient;
	import com.borhan.commands.storageProfile.StorageProfileList;
	import com.borhan.edw.business.ClientUtil;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmc.business.JSGate;
	import com.borhan.bmc.modules.account.model.AccountModelLocator;
	import com.borhan.types.BorhanStorageProfileStatus;
	import com.borhan.vo.BorhanFilter;
	import com.borhan.vo.BorhanStorageProfile;
	import com.borhan.vo.BorhanStorageProfileFilter;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;

	public class ListStorageProfilesCommand implements ICommand, IResponder {
		
		private var _model : AccountModelLocator = AccountModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void {
			_model.loadingFlag = true;
			var f:BorhanStorageProfileFilter = new BorhanStorageProfileFilter();
			f.statusIn = BorhanStorageProfileStatus.AUTOMATIC + "," + BorhanStorageProfileStatus.MANUAL;
			var list:StorageProfileList = new StorageProfileList(f);
			list.addEventListener(BorhanEvent.COMPLETE, result);
			list.addEventListener(BorhanEvent.FAILED, fault);
			_model.context.kc.post(list);
		}
		
		public function result(event:Object):void {
			_model.loadingFlag = false;
			var temp:Array = new Array();
			// add the "none" object
			var rs:BorhanStorageProfile = new BorhanStorageProfile();
			rs.id = BorhanClient.NULL_INT; // same as "delete value" of the client
			rs.name = ResourceManager.getInstance().getString('account', 'n_a');
			temp.push(rs);
			// add the rest of the storages
			for each (var o:Object in event.data.objects) {
				if (!(o is BorhanStorageProfile)) {
					o = ClientUtil.createClassInstanceFromObject(BorhanStorageProfile, o);
				}
				temp.push(o);
			} 
			
			_model.storageProfiles = new ArrayCollection(temp);
		}
		
		public function fault(event:Object):void {
			_model.loadingFlag = false;
			if(event && event.error && event.error.errorMsg) {
				if(event.error.errorMsg.toString().indexOf("Invalid KS") > -1 ) {
					JSGate.expired();
				} else {
					Alert.show(event && event.error && event.error.errorMsg);
				}
			}
		}
	}
}