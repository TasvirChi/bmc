package com.borhan.bmc.modules.account.control.command
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
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
	import com.borhan.vo.BorhanFilterPager;
	import com.borhan.vo.BorhanMetadataProfile;
	import com.borhan.vo.BorhanMetadataProfileFilter;
	import com.borhan.vo.BorhanMetadataProfileListResponse;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;
	
	/**
	 * This class is used for sending MetadataProfileList requests 
	 * @author Michal
	 * 
	 */	
	public class ListMetadataProfileCommand implements ICommand, IResponder {
	
		private var _model:AccountModelLocator = AccountModelLocator.getInstance();
		

		/**
		 * This function sends a MetadataProfileList request, with filter and pager
		 * that will make it recieve only the last created profile 
		 * @param event the event that triggered this command
		 * 
		 */		
		public function execute(event:CairngormEvent):void
		{
			var filter:BorhanMetadataProfileFilter = new BorhanMetadataProfileFilter();
			filter.orderBy = BorhanMetadataOrderBy.CREATED_AT_DESC;
			filter.createModeNotEqual = BorhanMetadataProfileCreateMode.APP;
			filter.metadataObjectTypeIn = BorhanMetadataObjectType.ENTRY + "," + BorhanMetadataObjectType.CATEGORY;
			var listMetadataProfile:MetadataProfileList = new MetadataProfileList(filter, _model.metadataFilterPager);
			listMetadataProfile.addEventListener(BorhanEvent.COMPLETE, result);
			listMetadataProfile.addEventListener(BorhanEvent.FAILED, fault);
			_model.context.kc.post(listMetadataProfile);
		}
		
		/**
		 * This function handles the response from the server
		 * @param data the data returned from the server
		 * 
		 */		
		public function result(data:Object):void
		{
			//last request is always the list request
			var listResult:BorhanMetadataProfileListResponse  = data.data as BorhanMetadataProfileListResponse;
			_model.metadataProfilesTotalCount = listResult.totalCount;
			_model.metadataProfilesArray = ListMetadataProfileUtil.handleListMetadataResult(listResult, _model.context);
		}
		
		/**
		 * This function handles errors from the server 
		 * @param info the error from the server
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
