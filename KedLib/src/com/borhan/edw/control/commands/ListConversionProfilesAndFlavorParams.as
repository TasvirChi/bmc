package com.borhan.edw.control.commands {
	import com.borhan.commands.MultiRequest;
	import com.borhan.commands.conversionProfile.ConversionProfileList;
	import com.borhan.commands.conversionProfileAssetParams.ConversionProfileAssetParamsList;
	import com.borhan.commands.flavorParams.FlavorParamsList;
	import com.borhan.edw.model.datapacks.FlavorsDataPack;
	import com.borhan.edw.model.util.FlavorParamsUtil;
	import com.borhan.edw.vo.ConversionProfileWithFlavorParamsVo;
	import com.borhan.errors.BorhanError;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmvc.control.BMvCEvent;
	import com.borhan.types.BorhanAssetParamsOrigin;
	import com.borhan.types.BorhanConversionProfileOrderBy;
	import com.borhan.types.BorhanConversionProfileType;
	import com.borhan.vo.BorhanConversionProfile;
	import com.borhan.vo.BorhanConversionProfileAssetParams;
	import com.borhan.vo.BorhanConversionProfileAssetParamsFilter;
	import com.borhan.vo.BorhanConversionProfileAssetParamsListResponse;
	import com.borhan.vo.BorhanConversionProfileFilter;
	import com.borhan.vo.BorhanConversionProfileListResponse;
	import com.borhan.vo.BorhanFilterPager;
	import com.borhan.vo.BorhanFlavorParams;
	import com.borhan.vo.BorhanFlavorParamsListResponse;
	import com.borhan.vo.BorhanLiveParams;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;

	public class ListConversionProfilesAndFlavorParams extends KedCommand {

		override public function execute(event:BMvCEvent):void {
			_model.increaseLoadCounter();
			var p:BorhanFilterPager = new BorhanFilterPager();
			p.pageSize = 1000;	// this is a very large number that should be enough to get all items

			var fdp:FlavorsDataPack = _model.getDataPack(FlavorsDataPack) as FlavorsDataPack;
			
			var mr:MultiRequest = new MultiRequest();
			if (!fdp.conversionProfileLoaded) {
				var cpFilter:BorhanConversionProfileFilter = new BorhanConversionProfileFilter();
				cpFilter.orderBy = BorhanConversionProfileOrderBy.CREATED_AT_DESC;
				cpFilter.typeEqual = BorhanConversionProfileType.MEDIA;
				var listConversionProfiles:ConversionProfileList = new ConversionProfileList(cpFilter, p);
				mr.addAction(listConversionProfiles);
				
				var listFlavorParams:FlavorParamsList = new FlavorParamsList(null, p);
				mr.addAction(listFlavorParams);
			}

			
			var f:BorhanConversionProfileAssetParamsFilter = new BorhanConversionProfileAssetParamsFilter();
			f.originIn = BorhanAssetParamsOrigin.INGEST + "," + BorhanAssetParamsOrigin.CONVERT_WHEN_MISSING;
			var listcpaps:ConversionProfileAssetParamsList = new ConversionProfileAssetParamsList(f, p);
			mr.addAction(listcpaps);

			mr.addEventListener(BorhanEvent.COMPLETE, result);
			mr.addEventListener(BorhanEvent.FAILED, fault);
			_client.post(mr);
		}


		override public function result(event:Object):void {
			// error handling
			var er:BorhanError ;
			if (event.error) {
				er = event.error as BorhanError;
				if (er) {
					Alert.show(er.errorMsg, "Error");
				}
			}
			else {
				for (var i:int = 0; i<event.data.length; i++) {
					if (event.data[i].error) {
						er = event.data[i].error as BorhanError;
						if (er) {
							Alert.show(er.errorMsg, "Error");
						}
					}
				}
			}
			
			// result
			if (!er) {
				var startIndex:int; 
				var profs:Array;
				var params:Array;
				var fdp:FlavorsDataPack = _model.getDataPack(FlavorsDataPack) as FlavorsDataPack;
				// conversion profiles, flavor params
				if (fdp.conversionProfileLoaded) {
					startIndex = 0;
					profs = fdp.conversionProfiles;
					params = fdp.flavorParams;
				}
				else {
					startIndex = 2;
					profs = (event.data[0] as BorhanConversionProfileListResponse).objects;
					fdp.conversionProfiles = profs;
					var temp:Array = FlavorParamsUtil.makeManyFlavorParams((event.data[1] as BorhanFlavorParamsListResponse).objects); 
					params = new Array();
					for each (var fp:BorhanFlavorParams in temp) {
						if (!(fp is BorhanLiveParams)) {
							params.push(fp);
						}
					}
					fdp.flavorParams = params;
					fdp.conversionProfileLoaded = true;
				}
				
				var cpaps:Array = (event.data[startIndex] as BorhanConversionProfileAssetParamsListResponse).objects;
				
				var tempArrCol:ArrayCollection = new ArrayCollection();

				for each (var cProfile:Object in profs) {
					if (cProfile is BorhanConversionProfile) {
						var cp:ConversionProfileWithFlavorParamsVo = new ConversionProfileWithFlavorParamsVo();
						cp.profile = cProfile as BorhanConversionProfile;
						addFlavorParams(cp, cpaps, params);
						tempArrCol.addItem(cp);
					}
				}
				fdp.conversionProfsWFlavorParams = tempArrCol;
			}	
			_model.decreaseLoadCounter();
		}
			
		/**
		 * create a list of <code>BorhanConversionProfileAssetParams</code> that belong to 
		 * the conversion profile on the given VO, and add it to the VO.
		 * @param cp		VO to be updated
		 * @param cpaps		objects to filter
		 * @param params	flavor params objects, used for their names.
		 * 
		 */
		protected function addFlavorParams(cp:ConversionProfileWithFlavorParamsVo, cpaps:Array, params:Array):void {
			var profid:int = cp.profile.id;
			for each (var cpap:BorhanConversionProfileAssetParams in cpaps) {
				if (cpap && cpap.conversionProfileId == profid && cpap.origin != BorhanAssetParamsOrigin.CONVERT) {
					for each (var ap:BorhanFlavorParams in params) {
						if (ap && ap.id == cpap.assetParamsId) {
							// add flavor name to the cpap, to be used in dropdown in IR
							cpap.name = ap.name;
							cp.flavors.addItem(cpap);
							break;
						}
					}
				}
			}
		}
		
		
		/**
		 * get cpap by keys 
		 * @param cpid	conversion profile id
		 * @param apid	asset params id
		 * @return 
		 */
		protected function getCpap(cpid:int, apid:int, cpaps:Array):BorhanConversionProfileAssetParams {
			for each (var cpap:BorhanConversionProfileAssetParams in cpaps) {
				if (cpap.assetParamsId == apid && cpap.conversionProfileId == cpid) {
					return cpap;
				}
			}
			return null;
		}
	}
}