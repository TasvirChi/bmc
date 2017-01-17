package com.borhan.edw.control.commands {
	import com.borhan.commands.flavorAsset.FlavorAssetGetFlavorAssetsWithParams;
	import com.borhan.edw.control.events.KedEntryEvent;
	import com.borhan.edw.model.datapacks.DistributionDataPack;
	import com.borhan.edw.model.datapacks.EntryDataPack;
	import com.borhan.edw.model.types.APIErrorCode;
	import com.borhan.edw.vo.FlavorAssetWithParamsVO;
	import com.borhan.errors.BorhanError;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmvc.control.BMvCEvent;
	import com.borhan.types.BorhanFlavorAssetStatus;
	import com.borhan.vo.BorhanBaseEntry;
	import com.borhan.vo.BorhanFlavorAssetWithParams;
	import com.borhan.vo.BorhanLiveParams;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.resources.ResourceManager;

	public class ListFlavorAssetsByEntryIdCommand extends KedCommand {
		override public function execute(event:BMvCEvent):void {
			_model.increaseLoadCounter();
			(_model.getDataPack(DistributionDataPack) as DistributionDataPack).flavorsLoaded = false;
			var entryId:String = (event as KedEntryEvent).entryVo.id;
			var getAssetsAndFlavorsByEntryId:FlavorAssetGetFlavorAssetsWithParams = new FlavorAssetGetFlavorAssetsWithParams(entryId);
			getAssetsAndFlavorsByEntryId.addEventListener(BorhanEvent.COMPLETE, result);
			getAssetsAndFlavorsByEntryId.addEventListener(BorhanEvent.FAILED, fault);
			_client.post(getAssetsAndFlavorsByEntryId);
		}


		override public function fault(info:Object):void {
			_model.decreaseLoadCounter();
			var entry:BorhanBaseEntry = (_model.getDataPack(EntryDataPack) as EntryDataPack).selectedEntry;
			// if this is a replacement entry
			if (entry.replacedEntryId) {
				var er:BorhanError = (info as BorhanEvent).error;
				if (er.errorCode == APIErrorCode.ENTRY_ID_NOT_FOUND) {
					Alert.show(ResourceManager.getInstance().getString('cms','replacementNotExistMsg'),ResourceManager.getInstance().getString('cms','replacementNotExistTitle'));
				}		
				else {
					Alert.show(ResourceManager.getInstance().getString('cms', 'flavorAssetsErrorMsg') + ":\n" + er.errorMsg, ResourceManager.getInstance().getString('cms', 'error'));
				}
			}
			else {
				Alert.show(ResourceManager.getInstance().getString('cms', 'flavorAssetsErrorMsg') + ":\n" + info.error.errorMsg, ResourceManager.getInstance().getString('cms', 'error'));
			}
		}


		override public function result(event:Object):void {
			super.result(event);
			setDataInModel((event as BorhanEvent).data as Array);
			(_model.getDataPack(DistributionDataPack) as DistributionDataPack).flavorsLoaded = true;
			_model.decreaseLoadCounter();
		}


		private function setDataInModel(arrCol:Array):void {
			var flavorParamsAndAssetsByEntryId:ArrayCollection = new ArrayCollection();
			var tempAc:ArrayCollection = new ArrayCollection();
			var foundIsOriginal:Boolean = false;
			for each (var assetWithParam:BorhanFlavorAssetWithParams in arrCol) {
				if (assetWithParam.flavorAsset && assetWithParam.flavorAsset.status == BorhanFlavorAssetStatus.TEMP) {
					// flavor assets will have status temp if it's source of conversion 
					// profile that has no source, during transcoding. we don't want to 
					// show these.
					continue;
				}
				if ((assetWithParam.flavorAsset != null) && (assetWithParam.flavorAsset.isOriginal)) {
					foundIsOriginal = true;
				}
				var kawp:FlavorAssetWithParamsVO = new FlavorAssetWithParamsVO();
				kawp.borhanFlavorAssetWithParams = assetWithParam;
				if (assetWithParam.flavorAsset != null) {
					// first we add the ones with assets
					flavorParamsAndAssetsByEntryId.addItem(kawp);
					if (assetWithParam.flavorAsset.actualSourceAssetParamsIds) {
						// get the list of sources on the VO
						kawp.sources = getFlavorsByIds(assetWithParam.flavorAsset.actualSourceAssetParamsIds, arrCol);
					}
				}
				else if (assetWithParam.flavorParams && !(assetWithParam.flavorParams is BorhanLiveParams)) {
					// only keep non-live flavor params 
					tempAc.addItem(kawp);
				}
			}

			// then we add the ones without asset
			for each (var tmpObj:FlavorAssetWithParamsVO in tempAc) {
				flavorParamsAndAssetsByEntryId.addItem(tmpObj);
			}

			if (foundIsOriginal) {
				// let all flavors know we have original
				for each (var afwps:FlavorAssetWithParamsVO in flavorParamsAndAssetsByEntryId) {
					afwps.hasOriginal = true;
				}
			}
			(_model.getDataPack(DistributionDataPack) as DistributionDataPack).flavorParamsAndAssetsByEntryId = flavorParamsAndAssetsByEntryId;
		}
		
		private function getFlavorsByIds(sourceAssetParamsIds:String, allFlavors:Array):Array {
			allFlavors = allFlavors.slice();
			var result:Array = [];
			var required:Array = sourceAssetParamsIds.split(',');
			var assetWithParam:BorhanFlavorAssetWithParams; 
			for each (var source:int in required) {
				for (var i:int = 0; i<allFlavors.length; i++) {
					assetWithParam = allFlavors[i];
					if (assetWithParam.flavorParams.id == source) {
						result.push(assetWithParam.flavorParams);
						allFlavors.splice(i, 1);
						break;
					}
				}
			}
			return result;
		}
	}
}