package com.borhan.edw.control.commands
{
	import com.borhan.commands.MultiRequest;
	import com.borhan.commands.accessControl.AccessControlList;
	import com.borhan.commands.baseEntry.BaseEntryCount;
	import com.borhan.commands.category.CategoryList;
	import com.borhan.commands.distributionProfile.DistributionProfileList;
	import com.borhan.commands.flavorParams.FlavorParamsList;
	import com.borhan.core.KClassFactory;
	import com.borhan.dataStructures.HashMap;
	import com.borhan.edw.business.ClientUtil;
	import com.borhan.edw.business.IDataOwner;
	import com.borhan.edw.control.DataTabController;
	import com.borhan.edw.control.events.LoadEvent;
	import com.borhan.edw.control.events.MetadataProfileEvent;
	import com.borhan.edw.model.FilterModel;
	import com.borhan.edw.model.datapacks.DistributionDataPack;
	import com.borhan.edw.model.datapacks.EntryDataPack;
	import com.borhan.edw.model.util.FlavorParamsUtil;
	import com.borhan.edw.vo.CategoryVO;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmvc.control.BMvCEvent;
	import com.borhan.types.BorhanAccessControlOrderBy;
	import com.borhan.types.BorhanDistributionProfileStatus;
	import com.borhan.types.BorhanEntryStatus;
	import com.borhan.types.BorhanMediaType;
	import com.borhan.vo.AccessControlProfileVO;
	import com.borhan.vo.BorhanAccessControl;
	import com.borhan.vo.BorhanAccessControlFilter;
	import com.borhan.vo.BorhanAccessControlListResponse;
	import com.borhan.vo.BorhanBaseRestriction;
	import com.borhan.vo.BorhanCategory;
	import com.borhan.vo.BorhanCategoryFilter;
	import com.borhan.vo.BorhanCategoryListResponse;
	import com.borhan.vo.BorhanDistributionProfile;
	import com.borhan.vo.BorhanDistributionProfileListResponse;
	import com.borhan.vo.BorhanDistributionThumbDimensions;
	import com.borhan.vo.BorhanFilterPager;
	import com.borhan.vo.BorhanFlavorParams;
	import com.borhan.vo.BorhanFlavorParamsListResponse;
	import com.borhan.vo.BorhanMediaEntryFilter;
	
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.resources.ResourceManager;
	import mx.rpc.xml.SimpleXMLEncoder;

	/**
	 * load all data that is relevant for filter:
	 * <lu>
	 * <li>distribution profiles</li>
	 * <li>flavor params</li>
	 * <li>metadata profile</li>
	 * <li>access control profiles</li>
	 * <li>categories</li>
	 * </lu> 
	 * @author Atar
	 * 
	 */	
	public class LoadFilterDataCommand extends KedCommand {
		
		public static const DEFAULT_PAGE_SIZE:int = 500;
		
		/**
		 * reference to the filter model in use
		 * */
		private var _filterModel:FilterModel;
		
		/**
		 * the element that triggered the data load.
		 */		
		private var _caller:IDataOwner;
		
		override public function execute(event:BMvCEvent):void {
			_caller = (event as LoadEvent).caller;
			_filterModel = (event as LoadEvent).filterModel;
			
			if (!_filterModel.loadingRequired) {
				_caller.onRequestedDataLoaded();				
				return;
			}
			
			_model.increaseLoadCounter();
			
			var pager:BorhanFilterPager;
			
			// custom data hack
			if (_filterModel.enableCustomData) {
				var lmdp:MetadataProfileEvent = new MetadataProfileEvent(MetadataProfileEvent.LIST);
				DataTabController.getInstance().dispatch(lmdp);
			}
			
			var multiRequest:MultiRequest = new MultiRequest();
			
			// distribution
			if (_filterModel.enableDistribution) {
				pager = new BorhanFilterPager();
				pager.pageSize = DEFAULT_PAGE_SIZE;
				var listDistributionProfile:DistributionProfileList = new DistributionProfileList(null, pager);
				multiRequest.addAction(listDistributionProfile);
			}
			// flavor params
			pager = new BorhanFilterPager();
			pager.pageSize = DEFAULT_PAGE_SIZE;
			var listFlavorParams:FlavorParamsList = new FlavorParamsList(null, pager);
			multiRequest.addAction(listFlavorParams);
			// access control
			var acfilter:BorhanAccessControlFilter = new BorhanAccessControlFilter();
			acfilter.orderBy = BorhanAccessControlOrderBy.CREATED_AT_DESC;
			pager = new BorhanFilterPager();
			pager.pageSize = 1000;
			var getListAccessControlProfiles:AccessControlList = new AccessControlList(acfilter, pager);
			multiRequest.addAction(getListAccessControlProfiles);
			
			// listeners
			multiRequest.addEventListener(BorhanEvent.COMPLETE, result);
			multiRequest.addEventListener(BorhanEvent.FAILED, fault);
			
			_client.post(multiRequest);
		}
	
		override public function result(data:Object):void {
			if (!checkErrors(data)) {
				var responseCount:int = 0;
				
				if (_filterModel.enableDistribution) {
					// distribution
					handleListDistributionProfileResult(data.data[responseCount] as BorhanDistributionProfileListResponse);
					responseCount ++;
				}
				
				// flavor params
				handleFlavorsData(data.data[responseCount] as BorhanFlavorParamsListResponse);
				responseCount ++;
				
				// access control
				handleAccessControls(data.data[responseCount] as BorhanAccessControlListResponse);
				responseCount ++;
				
				_filterModel.loadingRequired = false;
				_caller.onRequestedDataLoaded();
			}
			_model.decreaseLoadCounter();

		}
		
		
		/**
		 * coppied from ListDistributionProfilesCommand 
		 */
		private function handleListDistributionProfileResult(profilesResult:BorhanDistributionProfileListResponse) : void {
			var dum:BorhanDistributionThumbDimensions;
			var profilesArray:Array = new Array();
			//as3flexClient can't generate these objects since we don't include them in the swf 
			for each (var profile:Object in profilesResult.objects) {
				var newProfile:BorhanDistributionProfile;
				if (profile is BorhanDistributionProfile) {
					newProfile = profile as BorhanDistributionProfile;
				}
				else {
					newProfile = ClientUtil.createClassInstanceFromObject(BorhanDistributionProfile, profile);
					//fix bug: simpleXmlEncoder not working properly for nested objects
					if (profile.requiredThumbDimensions is Array)
						newProfile.requiredThumbDimensions = profile.requiredThumbDimensions;
				}
				if (newProfile.status == BorhanDistributionProfileStatus.ENABLED)
					profilesArray.push(newProfile);
			}
			var ddp:DistributionDataPack = _model.getDataPack(DistributionDataPack) as DistributionDataPack;
			ddp.distributionInfo.distributionProfiles = profilesArray;
			ddp.distributionInfo.entryDistributions = new Array();
		}
		
		
		/**
		 * coppied from ListFlavorsParamsCommand 
		 */
		private function handleFlavorsData(response:BorhanFlavorParamsListResponse):void {
			clearOldFlavorData();
			var tempFlavorParamsArr:ArrayCollection = new ArrayCollection();
			// loop on Object and cast to BorhanFlavorParams so we don't crash on unknown types:
			for each (var kFlavor:Object in response.objects) {
				if (kFlavor is BorhanFlavorParams) {
					tempFlavorParamsArr.addItem(kFlavor);
				}
				else {
					tempFlavorParamsArr.addItem(FlavorParamsUtil.makeFlavorParams(kFlavor));
				}
			}
			_filterModel.flavorParams = tempFlavorParamsArr;
		}
		
		
		/**
		 * coppied from ListAccessControlsCommand 
		 */
		private function handleAccessControls(response:BorhanAccessControlListResponse):void {
			var tempArrCol:ArrayCollection = new ArrayCollection();
			for each(var kac:BorhanAccessControl in response.objects)
			{
				var acVo:AccessControlProfileVO = new AccessControlProfileVO();
				acVo.profile = kac;
				acVo.id = kac.id;
				if (kac.restrictions) {
					// remove unknown objects
					// if any restriction is unknown, we remove it from the list.
					// this means it is not supported in BMC at the moment
					for (var i:int = 0; i<kac.restrictions.length; i++) {
						if (! (kac.restrictions[i] is BorhanBaseRestriction)) {
							kac.restrictions.splice(i, 1);
						}
					}
				}
				tempArrCol.addItem(acVo);
			}
			_filterModel.accessControlProfiles = tempArrCol;
		}
		
		
		
		private function clearOldFlavorData():void {
			_filterModel.flavorParams.removeAll();
		}
		
	}
}