package com.borhan.bmc.modules.account.control.command
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.commands.MultiRequest;
	import com.borhan.commands.metadataProfile.MetadataProfileAdd;
	import com.borhan.commands.metadataProfile.MetadataProfileList;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmc.business.JSGate;
	import com.borhan.bmc.modules.account.model.AccountModelLocator;
	import com.borhan.bmc.utils.ListMetadataProfileUtil;
	import com.borhan.types.BorhanMetadataObjectType;
	import com.borhan.types.BorhanMetadataOrderBy;
	import com.borhan.types.BorhanMetadataProfileCreateMode;
	import com.borhan.utils.parsers.MetadataProfileParser;
	import com.borhan.vo.BMCMetadataProfileVO;
	import com.borhan.vo.BorhanMetadataProfile;
	import com.borhan.vo.BorhanMetadataProfileFilter;
	import com.borhan.vo.BorhanMetadataProfileListResponse;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;
	
	/**
	 * This class handles the addition of a new profile to the current partner 
	 * @author Michal
	 * 
	 */	
	public class AddMetadataProfileCommand implements ICommand, IResponder {
		
		private var _model:AccountModelLocator = AccountModelLocator.getInstance();
		
		/**
		 * Will send a MetadataProfileAdd request with the current XSD. 
		 * @param event the event that triggered this command.
		 * 
		 */		
		public function execute(event:CairngormEvent):void
		{
			_model.loadingFlag = true;
			
			var mr:MultiRequest = new MultiRequest();
			
			_model.selectedMetadataProfile.profile.createMode = BorhanMetadataProfileCreateMode.BMC;		
			var addMetadataProfile:MetadataProfileAdd = new MetadataProfileAdd(_model.selectedMetadataProfile.profile, _model.selectedMetadataProfile.xsd.toXMLString());
			mr.addAction(addMetadataProfile);
			
			//list the latest metadata profiles (after all deletion is done)s
			var filter:BorhanMetadataProfileFilter = new BorhanMetadataProfileFilter();
			filter.orderBy = BorhanMetadataOrderBy.CREATED_AT_DESC;
			filter.createModeNotEqual = BorhanMetadataProfileCreateMode.APP;
			filter.metadataObjectTypeIn = BorhanMetadataObjectType.ENTRY + "," + BorhanMetadataObjectType.CATEGORY;
			var listMetadataProfile:MetadataProfileList = new MetadataProfileList(filter, _model.metadataFilterPager);
			mr.addAction(listMetadataProfile);
			
			mr.addEventListener(BorhanEvent.COMPLETE, result);
			mr.addEventListener(BorhanEvent.FAILED, fault);
			_model.context.kc.post(mr);
		}
		
		/**
		 * Will be called when the result from the server returns 
		 * @param data the data recieved from the server
		 * 
		 */		
		public function result(data:Object):void
		{
			_model.loadingFlag = false;
			var responseArray:Array = data.data as Array;
			if (responseArray[0].error != null){
				Alert.show(responseArray[0].error.message, ResourceManager.getInstance().getString('account', 'error'));
			} else {
				_model.selectedMetadataProfile.isCurrentlyEdited = false;
			}
			//last request is always the list request
			var listResult:BorhanMetadataProfileListResponse = responseArray[1]as BorhanMetadataProfileListResponse;
			_model.metadataProfilesTotalCount = listResult.totalCount;
			_model.metadataProfilesArray = ListMetadataProfileUtil.handleListMetadataResult(listResult, _model.context);
		}
		
		/**
		 * Will be called when the request fails 
		 * @param info the info from the server
		 * 
		 */	
		public function fault(info:Object):void
		{
			if(info && info.error && info.error.errorMsg && info.error.errorMsg.toString().indexOf("Invalid KS") > -1 )
			{
				JSGate.expired();
				return;
			}
			_model.loadingFlag = false;
			Alert.show(info.error.errorMsg, ResourceManager.getInstance().getString('account', 'error'));

		}
	
	}
}