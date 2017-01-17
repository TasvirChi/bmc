package com.borhan.bmc.modules.account.control.command {
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.commands.MultiRequest;
	import com.borhan.commands.conversionProfile.ConversionProfileList;
	import com.borhan.commands.conversionProfileAssetParams.ConversionProfileAssetParamsList;
	import com.borhan.commands.flavorParams.FlavorParamsList;
	import com.borhan.commands.thumbParams.ThumbParamsList;
	import com.borhan.controls.Paging;
	import com.borhan.edw.model.types.APIErrorCode;
	import com.borhan.edw.model.util.FlavorParamsUtil;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmc.modules.account.control.events.ConversionSettingsEvent;
	import com.borhan.bmc.modules.account.model.AccountModelLocator;
	import com.borhan.bmc.modules.account.utils.ListConversionProfilesUtil;
	import com.borhan.bmc.modules.account.vo.ConversionProfileVO;
	import com.borhan.vo.FlavorVO;
	import com.borhan.vo.BorhanConversionProfile;
	import com.borhan.vo.BorhanConversionProfileAssetParamsFilter;
	import com.borhan.vo.BorhanConversionProfileAssetParamsListResponse;
	import com.borhan.vo.BorhanConversionProfileListResponse;
	import com.borhan.vo.BorhanFilterPager;
	import com.borhan.vo.BorhanFlavorParams;
	import com.borhan.vo.BorhanFlavorParamsListResponse;
	import com.borhan.vo.BorhanLiveParams;
	import com.borhan.vo.BorhanThumbParams;
	import com.borhan.vo.BorhanThumbParamsListResponse;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;

	public class ListConversionProfilesAndFlavorParamsCommand implements ICommand, IResponder {
		private var _model:AccountModelLocator = AccountModelLocator.getInstance();


		public function execute(event:CairngormEvent):void {
			var mr:MultiRequest = new MultiRequest();

			_model.loadingFlag = true;

			if (!_model.mediaCPPager) {
				_model.mediaCPPager = new BorhanFilterPager();
			}
			if (event.data) {
				_model.mediaCPPager.pageIndex = event.data[0];
				_model.mediaCPPager.pageSize = event.data[1];
			}
			var listConversionProfiles:ConversionProfileList = new ConversionProfileList(_model.mediaCPFilter, _model.mediaCPPager);
			mr.addAction(listConversionProfiles);
			
			var p:BorhanFilterPager = new BorhanFilterPager();
			p.pageSize = 1000;	// this is a very large number that should be enough to get all items
			var cpapFilter:BorhanConversionProfileAssetParamsFilter = new BorhanConversionProfileAssetParamsFilter();
			cpapFilter.conversionProfileIdFilter = _model.mediaCPFilter;
			var cpaplist:ConversionProfileAssetParamsList = new ConversionProfileAssetParamsList(cpapFilter, p);
			mr.addAction(cpaplist);

			if (_model.mediaFlavorsData.length == 0) {
				// assume this means flavors were not yet loaded, let's load:
				var pager:BorhanFilterPager = new BorhanFilterPager();
				pager.pageSize = ListFlavorsParamsCommand.DEFAULT_PAGE_SIZE;
				var listFlavorParams:FlavorParamsList = new FlavorParamsList(null, pager);
				mr.addAction(listFlavorParams);
			}
			
			mr.addEventListener(BorhanEvent.COMPLETE, result);
			mr.addEventListener(BorhanEvent.FAILED, fault);
			_model.context.kc.post(mr);
		}


		public function result(event:Object):void {
			var kEvent:BorhanEvent = event as BorhanEvent;
			// error handling
			if (kEvent.data && kEvent.data.length > 0) {
				for (var i:int = 0; i < kEvent.data.length; i++) {
					if (kEvent.data[i].error) {
						var rm:IResourceManager = ResourceManager.getInstance();
						if (kEvent.data[i].error.code == APIErrorCode.SERVICE_FORBIDDEN) {
							Alert.show(rm.getString('common', 'forbiddenError', [kEvent.data[i].error.message]), rm.getString('common', 'forbiden_error_title'));
						}
						else {
							Alert.show(kEvent.data[i].error.message, rm.getString('common', 'forbiden_error_title'));
						}
						_model.loadingFlag = false;
						return;
					}
				}
			}

			// conversion profs
			var convProfilesTmpArrCol:ArrayCollection = new ArrayCollection();
			var convsProfilesRespones:BorhanConversionProfileListResponse = (kEvent.data as Array)[0] as BorhanConversionProfileListResponse;
			for each (var cProfile:BorhanConversionProfile in convsProfilesRespones.objects) {
				var cp:ConversionProfileVO = new ConversionProfileVO();
				cp.profile = cProfile;
				cp.id = cProfile.id.toString();

				if (cp.profile.isDefault) {
					convProfilesTmpArrCol.addItemAt(cp, 0);
				}
				else {
					convProfilesTmpArrCol.addItem(cp);
				}
			}
			
			// conversionProfileAssetParams
			_model.mediaCPAPs = (kEvent.data[1] as BorhanConversionProfileAssetParamsListResponse).objects;
			ListConversionProfilesUtil.addAssetParams(convProfilesTmpArrCol, _model.mediaCPAPs);
			
			// flavors
			var flvorsTmpArrCol:ArrayCollection;
			var liveFlvorsTmpArrCol:ArrayCollection;
			if (_model.mediaFlavorsData.length == 0) {
				flvorsTmpArrCol = new ArrayCollection();
				liveFlvorsTmpArrCol = new ArrayCollection();
				var flavorsResponse:BorhanFlavorParamsListResponse = (kEvent.data as Array)[2] as BorhanFlavorParamsListResponse;
				var flavor:FlavorVO;
				for each (var kFlavor:BorhanFlavorParams in flavorsResponse.objects) {
					// separate live flavorparams from all other flavor params, keep both
					flavor = new FlavorVO();
					flavor.kFlavor = kFlavor as BorhanFlavorParams;
					if (kFlavor is BorhanLiveParams) {
						liveFlvorsTmpArrCol.addItem(flavor);
					}
					else {
						flvorsTmpArrCol.addItem(flavor);
					}
				}
				// save live (regular is saved later)
				_model.liveFlavorsData = liveFlvorsTmpArrCol;
			}
			else {
				// take from model
				flvorsTmpArrCol = _model.mediaFlavorsData;
				_model.mediaFlavorsData = null; // refresh
			}
			
			// mark flavors of first profile
			var selectedItems:Array;
			if ((convProfilesTmpArrCol[0] as ConversionProfileVO).profile.flavorParamsIds) {
				// some partner managed to remove all flavors from his default profile, so BMC crashed on this line.
				selectedItems = (convProfilesTmpArrCol[0] as ConversionProfileVO).profile.flavorParamsIds.split(",");
			}
			else {
				selectedItems = new Array();
			}
			
			ListConversionProfilesUtil.selectFlavorParamsByIds(flvorsTmpArrCol, selectedItems);

			_model.mediaFlavorsData = flvorsTmpArrCol;
			_model.totalMediaConversionProfiles = convsProfilesRespones.totalCount; 
			_model.mediaConversionProfiles = convProfilesTmpArrCol;
			_model.loadingFlag = false;
		}


		public function fault(event:Object):void {
			Alert.show(ResourceManager.getInstance().getString('account', 'notLoadConversionProfiles') + "\n\t" + event.error.errorMsg, ResourceManager.getInstance().getString('account', 'error'));
			_model.loadingFlag = false;
		}


	}
}