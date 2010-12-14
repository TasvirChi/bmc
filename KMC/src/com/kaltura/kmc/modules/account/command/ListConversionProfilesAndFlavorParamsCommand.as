package com.kaltura.kmc.modules.account.command
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.kaltura.commands.MultiRequest;
	import com.kaltura.commands.conversionProfile.ConversionProfileList;
	import com.kaltura.commands.flavorParams.FlavorParamsList;
	import com.kaltura.events.KalturaEvent;
	import com.kaltura.kmc.modules.account.events.ConversionSettingsAccountEvent;
	import com.kaltura.kmc.modules.account.model.AccountModelLocator;
	import com.kaltura.kmc.modules.account.vo.ConversionProfileVO;
	import com.kaltura.kmc.modules.account.vo.FlavorVO;
	import com.kaltura.vo.KalturaConversionProfile;
	import com.kaltura.vo.KalturaConversionProfileListResponse;
	import com.kaltura.vo.KalturaFilterPager;
	import com.kaltura.vo.KalturaFlavorParams;
	import com.kaltura.vo.KalturaFlavorParamsListResponse;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;
	
	public class ListConversionProfilesAndFlavorParamsCommand implements ICommand, IResponder
	{
		private var _model : AccountModelLocator = AccountModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			var mr:MultiRequest = new MultiRequest();
			
			_model.loadingFlag = true;
			
			var getListFlavorParams:FlavorParamsList = new FlavorParamsList();
			mr.addAction(getListFlavorParams);
			
			var getListConversionProfiles:ConversionProfileList = new ConversionProfileList(_model.cpFilter, new KalturaFilterPager());
		 	mr.addAction(getListConversionProfiles);
			
		 	mr.addEventListener(KalturaEvent.COMPLETE, result);
			mr.addEventListener(KalturaEvent.FAILED, fault);
			_model.context.kc.post(mr);	
		}
		
		public function result(event:Object):void
		{
			var flvorsTmpArrCol:ArrayCollection = new ArrayCollection();
			var kEvent:KalturaEvent = event as KalturaEvent;
			var flavorsRespones:KalturaFlavorParamsListResponse = (kEvent.data as Array)[0] as KalturaFlavorParamsListResponse;
			
			for each(var kFlavor:Object in flavorsRespones.objects)
			{
				if (kFlavor is KalturaFlavorParams) {
					var flavor:FlavorVO = new FlavorVO();
					flavor.kFlavor = kFlavor as KalturaFlavorParams;
					flvorsTmpArrCol.addItem(flavor);
				}
			}
			var convProfilesTmpArrCol:ArrayCollection = new ArrayCollection();
			var convsProfilesRespones:KalturaConversionProfileListResponse = (kEvent.data as Array)[1] as KalturaConversionProfileListResponse;
			for each(var cProfile:KalturaConversionProfile in convsProfilesRespones.objects)
			{
				var cp:ConversionProfileVO = new ConversionProfileVO();
				cp.profile = cProfile;
				
				if(cp.profile.isDefault)
				{
					convProfilesTmpArrCol.addItemAt(cp, 0);
				}
				else
				{
					convProfilesTmpArrCol.addItem(cp);
				}
				
			}
			var selectedItems:Array = (convProfilesTmpArrCol[0] as ConversionProfileVO).profile.flavorParamsIds.split(",");
			for each (var flavora:String in selectedItems)
			{
				trace(flavora);
				for each (var flavorVO:FlavorVO in flvorsTmpArrCol )
				{
					if (flavora == flavorVO.kFlavor.id.toString()) 
						flavorVO.selected = true;
				}
			}
			

			
			
			_model.flavorsData = flvorsTmpArrCol;
			_model.conversionData = convProfilesTmpArrCol;
			
/*			var tsEvent:ConversionSettingsAccountEvent = new ConversionSettingsAccountEvent(ConversionSettingsAccountEvent.MARK_FLAVORS, false);
			tsEvent.dispatch();*/
			
			_model.loadingFlag = false;
	
			_model.partnerInfoLoaded = true;
		}
		
		public function fault(event:Object):void
		{
			Alert.show(ResourceManager.getInstance().getString('account', 'notLoadConversionProfiles') + "\n\t" + event.error.errorMsg, ResourceManager.getInstance().getString('account', 'error'));
			_model.loadingFlag = false;
		}
		

	}
}