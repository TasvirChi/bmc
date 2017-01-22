package com.borhan.edw.model.util
{
	import mx.collections.ArrayCollection;
	import com.borhan.vo.FlavorVO;
	import com.borhan.vo.BorhanFlavorParams;
	import com.borhan.utils.KCountriesUtil;
	import com.borhan.vo.BorhanSiteRestriction;
	import com.borhan.types.BorhanSiteRestrictionType;
	import mx.resources.ResourceManager;
	import mx.resources.IResourceManager;
	import com.borhan.vo.BorhanIpAddressRestriction;
	import com.borhan.types.BorhanIpAddressRestrictionType;
	import com.borhan.vo.BorhanLimitFlavorsRestriction;
	import com.borhan.types.BorhanLimitFlavorsRestrictionType;
	import com.borhan.types.BorhanCountryRestrictionType;
	import com.borhan.vo.BorhanCountryRestriction;
	import com.borhan.edw.model.FilterModel;

	/**
	 * This class holds helper methods used in Entry Access Control section. 
	 * @author atar.shadmi
	 * @see modules.ked.EntryAccessControl
	 */
	public class EntryAccessControlUtil
	{
		private static var resourceManager:IResourceManager = ResourceManager.getInstance();
		
		private static var _filterModel:FilterModel;
		
		public static function setModel(value:FilterModel):void {
			_filterModel = value;
		}
		
		public static function getSiteRestrictionText (rstrct:BorhanSiteRestriction):String {
			var result:String;
			if (rstrct.siteRestrictionType == BorhanSiteRestrictionType.ALLOW_SITE_LIST) {
				result = resourceManager.getString('drilldown', 'ALLOW_SITES') + ":  ";
			}
			else {
				result = resourceManager.getString('drilldown', 'RESTRICT_SITES') + ":  ";
			}
			result += rstrct.siteList;
			return result;
		}
		
		public static function getIPRestrictionText (rstrct:BorhanIpAddressRestriction):String {
			var result:String;
			if (rstrct.ipAddressRestrictionType == BorhanIpAddressRestrictionType.ALLOW_LIST) {
				result = resourceManager.getString('drilldown', 'ALLOW_IPS') + ":  ";
			}
			else {
				result = resourceManager.getString('drilldown', 'RESTRICT_IPS') + ":  ";
			}
			result += rstrct.ipAddressList;
			return result;
		}
		
		/**
		 * NOTE: filter model must be set before triggering this method 
		 * @param rstrct
		 * @return 
		 * 
		 */
		public static function getFlavorRestrictionText (rstrct:BorhanLimitFlavorsRestriction):String {
			var result:String;
			if (rstrct.limitFlavorsRestrictionType == BorhanLimitFlavorsRestrictionType.ALLOW_LIST) {
				result = resourceManager.getString('drilldown', 'ALLOW_FLAVORS') + ":  ";
			}
			else {
				result = resourceManager.getString('drilldown', 'RESTRICT_FLAVORS') + ":  ";
			}
//			result += "\n";
			var tmp:Array = rstrct.flavorParamsIds.split(",");
			for each (var flavorParamsId:int in tmp) {
				result += "\n" + getFlavorNameById(flavorParamsId);
			}
//			if (tmp.length) {
//				// at least one flavor
//				result = result.substr(0, result.length - 2);
//			}
			return result;
		}
		
		public static function getCountryRestrictionText (rstrct:BorhanCountryRestriction):String {
			var result:String;
			if (rstrct.countryRestrictionType == BorhanCountryRestrictionType.ALLOW_COUNTRY_LIST) {
				result = resourceManager.getString('drilldown', 'ALLOW_COUNTRIES') + ": "
			}
			else {
				result = resourceManager.getString('drilldown', 'RESTRICT_COUNTRIES') + ": ";
			}
			result += "\n" + EntryAccessControlUtil.getCountriesList(rstrct.countryList);
			
			return result;
		}
		
		private static function getFlavorNameById(flavorParamsId:int):String {
			for each (var kFlavor:BorhanFlavorParams in _filterModel.flavorParams) {
				if (kFlavor.id == flavorParamsId) {
					return kFlavor.name;
				}
			}
			return '';
		}
		
		/**
		 * filter model holds BorhanFlavorParams, but the window requires FlavorVOs.
		 * this method wraps each BorhanFlavorParams in FlavorVO like Account module does.
		 * */
		public static function wrapInFlavorVo(ac:ArrayCollection):ArrayCollection {
			var tempArrCol:ArrayCollection = new ArrayCollection();
			var flavor:FlavorVO;
			for each(var kFlavor:Object in ac) {
				if (kFlavor is BorhanFlavorParams) {
					flavor = new FlavorVO();
					flavor.kFlavor = kFlavor as BorhanFlavorParams;
					tempArrCol.addItem(flavor);
				}
			}
			return tempArrCol;
		}
		
		
		public static function getCountriesList(countriesCodesList:String):String {
			var cArr:Array = countriesCodesList.split(',');
			var countriesList:String = '';
			for each (var countryCode:String in cArr) {
				countriesList += KCountriesUtil.instance.getCountryName(countryCode) + ', ';
			}
			
			return countriesList.substr(0, countriesList.length - 2);
		}
		
		
		/**
		 * show profile name in profiles dropdown 
		 * @param item
		 * @return 
		 * 
		 */
		public static function dropdownLabelFunction(item:Object):String {
			return item.profile.name;
		}
	}
}