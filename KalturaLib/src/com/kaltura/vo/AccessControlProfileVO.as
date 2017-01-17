package com.borhan.vo {
	import com.adobe.cairngorm.vo.IValueObject;
	
	import mx.utils.ObjectProxy;
	import flash.utils.flash_proxy;

	[Bindable]
	/**
	 * This class is a wrapper for the BorhanAccessControl VO.
	 */
	public class AccessControlProfileVO extends ObjectProxy implements IValueObject {
		
		
		public static const SELECTED_CHANGED_EVENT:String = "accessControlSelectedChanged";


		/**
		 *  BorhanAccessControl VO, hold all the profile properties
		 */
		public var profile:BorhanAccessControl;
		
		/**
		 * id of the wrapped profile 
		 */		
		public var id:int;


		/**
		 * Constructor
		 *
		 */
		public function AccessControlProfileVO() {
//			profile = new BorhanAccessControl();
		}



		/**
		 * Creates a AccessControlProfileVO
		 * @return a new AccessControlProfileVO object
		 *
		 */
		public function clone():AccessControlProfileVO {
			var newAcp:AccessControlProfileVO = new AccessControlProfileVO();
			newAcp.profile = new BorhanAccessControl();
			newAcp.profile.name = this.profile.name.slice();
			newAcp.profile.description = this.profile.description.slice();
			newAcp.profile.createdAt = this.profile.createdAt;
			newAcp.profile.id = this.profile.id;
			newAcp.profile.isDefault = this.profile.isDefault;
			newAcp.profile.restrictions = new Array();

			for each (var restriction:BorhanBaseRestriction in this.profile.restrictions) {
				if (restriction is BorhanSiteRestriction) {
					var ksr:BorhanSiteRestriction = new BorhanSiteRestriction();
					ksr.siteRestrictionType = (restriction as BorhanSiteRestriction).siteRestrictionType;
					ksr.siteList = (restriction as BorhanSiteRestriction).siteList;
					newAcp.profile.restrictions.push(ksr);
				}
				else if (restriction is BorhanCountryRestriction) {
					var kcr:BorhanCountryRestriction = new BorhanCountryRestriction();
					kcr.countryRestrictionType = (restriction as BorhanCountryRestriction).countryRestrictionType;
					kcr.countryList = (restriction as BorhanCountryRestriction).countryList;
					newAcp.profile.restrictions.push(kcr);
				}
				else if (restriction is BorhanPreviewRestriction) {
					var kpr:BorhanPreviewRestriction = new BorhanPreviewRestriction();
					kpr.previewLength = (restriction as BorhanPreviewRestriction).previewLength;
					newAcp.profile.restrictions.push(kpr);
				}
				else if (restriction is BorhanSessionRestriction) {
					var kser:BorhanSessionRestriction = new BorhanSessionRestriction();
					newAcp.profile.restrictions.push(kser);
				}
				else if (restriction is BorhanDirectoryRestriction) {
					var kdr:BorhanDirectoryRestriction = new BorhanDirectoryRestriction();
					kdr.directoryRestrictionType = (restriction as BorhanDirectoryRestriction).directoryRestrictionType;
					newAcp.profile.restrictions.push(kdr);
				}
				else if (restriction is BorhanIpAddressRestriction) {
					var kir:BorhanIpAddressRestriction = new BorhanIpAddressRestriction();
					kir.ipAddressRestrictionType = (restriction as BorhanIpAddressRestriction).ipAddressRestrictionType;
					kir.ipAddressList = (restriction as BorhanIpAddressRestriction).ipAddressList;
					newAcp.profile.restrictions.push(kir);
				}
				else if (restriction is BorhanLimitFlavorsRestriction) {
					var klf:BorhanLimitFlavorsRestriction = new BorhanLimitFlavorsRestriction();
					klf.limitFlavorsRestrictionType = (restriction as BorhanLimitFlavorsRestriction).limitFlavorsRestrictionType;
					klf.flavorParamsIds = (restriction as BorhanLimitFlavorsRestriction).flavorParamsIds;
					newAcp.profile.restrictions.push(klf);
				}
			}


			return newAcp;
		}

	}
}
