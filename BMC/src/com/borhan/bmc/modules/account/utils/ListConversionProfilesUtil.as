package com.borhan.bmc.modules.account.utils {
	import com.borhan.bmc.modules.account.model.AccountModelLocator;
	import com.borhan.bmc.modules.account.vo.ConversionProfileVO;
	import com.borhan.vo.FlavorVO;
	import com.borhan.vo.BorhanConversionProfile;
	import com.borhan.vo.BorhanConversionProfileAssetParams;
	
	import mx.collections.ArrayCollection;

	/**
	 * This util class will contain methods related to listConversionProfiles request
	 * @author Michal
	 *
	 */
	public class ListConversionProfilesUtil {


		/**
		 * set the default conversion profile first in list
		 * @param arr list of conversion profiles
		 * @return ordered list in ArrayCollection (<code>ConversionProfileVO</code> objects)
		 */
		public static function handleConversionProfilesList(arr:Array):ArrayCollection {
			var tempArrCol:ArrayCollection = new ArrayCollection();

			for each (var cProfile:BorhanConversionProfile in arr) {
				if (cProfile) {
					var cp:ConversionProfileVO = new ConversionProfileVO();
					cp.profile = cProfile;
					cp.id = cProfile.id.toString();
					if (cp.profile.isDefault) {
						tempArrCol.addItemAt(cp, 0);
					}
					else {
						tempArrCol.addItem(cp);
					}
				}
			}
			return tempArrCol;
		}
	
		
		public static function addAssetParams(cps:ArrayCollection, cpaps:Array):void {
			var cpid:int;	// conversion profile id
			var ar:Array;	// flavours list
			for each (var cpvo:ConversionProfileVO in cps) {
				cpid = cpvo.profile.id;
				ar = new Array();
				for each (var cpap:BorhanConversionProfileAssetParams in cpaps) {
					if (cpap.conversionProfileId == cpid) {
						ar.push(cpap);
					}
				}
				cpvo.flavors = ar;
			}
		}
		
		
		public static function selectFlavorParamsByIds(flavors:ArrayCollection, ids:Array):void {
			for each (var flavorId:String in ids) {
				for each (var flavorVO:FlavorVO in flavors) {
					if (flavorId == flavorVO.kFlavor.id.toString()) {
						flavorVO.selected = true;
						break;
					}
					/*else {
						flavorVO.selected = false;
					}*/
				}
			}
		}
	}
}
