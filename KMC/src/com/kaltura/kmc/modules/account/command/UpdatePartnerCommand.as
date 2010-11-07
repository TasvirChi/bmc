package com.kaltura.kmc.modules.account.command
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.kaltura.commands.partner.PartnerUpdate;
	import com.kaltura.events.KalturaEvent;
	import com.kaltura.kmc.modules.account.model.KMCModelLocator;
	import com.kaltura.kmc.modules.account.vo.NotificationVO;
	import com.kaltura.types.KalturaPartnerType;
	import com.kaltura.vo.KalturaPartner;
	
	import flash.external.ExternalInterface;
	import flash.utils.setTimeout;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.managers.PopUpManager;
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;

	public class UpdatePartnerCommand implements ICommand, IResponder
	{
		private var _model : KMCModelLocator = KMCModelLocator.getInstance();
		public function execute(event:CairngormEvent):void
		{
			_model.loadingFlag = true;
			
	//		var params : Object = _model.context.defaultUrlVars;
			
	//		params.partner_url2 = _model.partnerData.url2;		 
	//		params.partner_url1	= _model.partnerData.url1;	
	//		params.partner_notificationsConfig = getNotificationsConfig(_model.partnerData.notifications);	
	//		params.partner_allowMultiNotification = _model.partnerData.allowMultiNotification;	
			
	//		params.partner_appearInSearch = _model.partnerData.appearInSearch;	 
	//		params.partner_adminName = _model.partnerData.adminName;
	//		params.partner_adminEmail = _model.partnerData.adminEmail;		 
	//		params.partner_description = _model.partnerData.description;	
			
	//		params.partner_contentCategories = _model.partnerData.contentCategories;
	//		params.partner_type = _model.partnerData.type;
	//		params.partner_phone = _model.partnerData.phone;		 
	//		params.partner_describeYourself = _model.partnerData.describeYourself;
	//		params.partner_adultContent = _model.partnerData.adultContent ? 1 : 0;
			
	//		params.partner_defConversionProfileType = _model.partnerData.defConversionProfileType; 
	//		params.partner_notify = _model.partnerData.notify ? 1 : 0;  
	//		params.partner_shouldForceUniqueKshow = _model.partnerData.shouldForceUniqueKshow ? 1 : 0;  
	//		params.partner_returnDuplicateKshow = _model.partnerData.returnDuplicateKshow ? 1 : 0;    
	//		params.partner_allowQuickEdit = _model.partnerData.allowQuickEdit ? 1 : 0;
	//		params.partner_mergeEntryLists = _model.partnerData.mergeEntryLists ? 1 : 0;
	//		params.partner_userLandingPage = _model.partnerData.userLandingPage;
	//		params.partner_landingPage = _model.partnerData.landingPage;   
	//		params.partner_maxUploadSize = _model.partnerData.maxUploadSize; 
	//		params.allow_empty_field = "1"; //Must send the whole object when use allow_empty_field=1

		/* 	var delegate : UpdatePartnerDelegate = new UpdatePartnerDelegate( this );
			delegate.updatePartner( params );
			 */
			 
			var kp:KalturaPartner = new KalturaPartner();
			kp.adminEmail = _model.partnerData.adminEmail;	
			kp.adminName = _model.partnerData.adminName;
	//		kp.adminSecret = 
			kp.adultContent = _model.partnerData.adultContent;
			kp.allowQuickEdit = _model.partnerData.allowQuickEdit ? 1 : 0;
			kp.appearInSearch = _model.partnerData.appearInSearch;	
	//		kp.cmsPassword = _model.partnerData.
	//		kp.commercialUse = _model.partnerData.commercialUse; 
			kp.contentCategories = _model.partnerData.contentCategories;
	// 		kp.createdAt = _model.partnerData.createdAt;
			kp.defConversionProfileType = _model.partnerData.defConversionProfileType;
			kp.describeYourself = _model.partnerData.describeYourself;
			kp.description = _model.partnerData.description;
			kp.id =  int(_model.partnerData.pId);
			kp.landingPage = _model.partnerData.landingPage;
			kp.maxUploadSize = _model.partnerData.maxUploadSize; 
			kp.mergeEntryLists = _model.partnerData.mergeEntryLists ? 1 : 0;
	 		kp.name = _model.partnerData.name;
			kp.notificationsConfig = getNotificationsConfig(_model.partnerData.notifications);
			kp.notificationUrl =  _model.partnerData.url2;
			kp.notify = _model.partnerData.notify ? 1 : 0;
			kp.partnerPackage = _model.partnerData.partnerPackage;
			kp.phone = _model.partnerData.phone;
			kp.secret =  _model.partnerData.secret;
	 		kp.status = _model.partnerData.status;
			kp.type = _model.partnerData.type;
			kp.uid =  _model.partnerData.subPId;
			kp.userLandingPage = _model.partnerData.userLandingPage;
			kp.website = _model.partnerData.url1;
			
			
			var updatePartner:PartnerUpdate = new PartnerUpdate(kp, true);
			updatePartner.addEventListener(KalturaEvent.COMPLETE, result);
			updatePartner.addEventListener(KalturaEvent.FAILED, fault);
			_model.context.kc.post(updatePartner);	
		}
		
		private function getNotificationsConfig( notifications : ArrayCollection ) : String
		{
			var str : String = "*=0;"
			for(var i:int=0; i < notifications.length ; i++)
			{
				var nvo : NotificationVO = notifications[i] as NotificationVO;
				var res : int = 0;
				
				if(nvo.availableInServer && nvo.availableInClient && nvo.clientEnabled)
					res = 3;
				else if(nvo.availableInClient && nvo.clientEnabled)
					res = 2;
				else if( nvo.availableInServer )
					res = 1;
				else
					res = 0;	
				
				str += nvo.nId +"="+res+";";	
			}
			return str;
		}
		
		public function closeAlert( alertRef : Alert ) : void
		{
			PopUpManager.removePopUp( alertRef );
		}
		
		public function result(data:Object):void
		{
			KalturaPartner(data.data);
			_model.loadingFlag = false;
			if(_model.saveAndExitFlag)
			{
				ExternalInterface.call("onTabChange");
				return;
			}
			
			var alert : Alert =  Alert.show( ResourceManager.getInstance().getString('kmc', 'changesSaved') );
			setTimeout( closeAlert , 3000 , alert);
		}
		
		public function fault(info:Object):void
		{
			_model.loadingFlag = false;			
			if(info && info.error && info.error.errorMsg && info.error.errorMsg.toString().indexOf("Invalid KS") > -1 )
			{
				ExternalInterface.call("kmc.functions.expired");
				return;
			}
			var alert : Alert =  Alert.show(info.error.errorMsg, ResourceManager.getInstance().getString('kmc', 'error'));
			setTimeout( closeAlert , 3000 , alert);
		}
	}
}