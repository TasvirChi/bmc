package com.kaltura.kmc.modules.account.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	public class ConversionSettingsEvent extends CairngormEvent
	{
		public static const ADD_NEW_CONVERSION_PROFILE : String = "addNewConversionProfile";
		public static const DELETE_CONVERSION_PROFILE : String = "deleteConversionProfile";
		public static const LIST_CONVERSION_PROFILES : String = "listConversionProfiles";
		public static const LIST_FLAVOR_PARAMS : String = "listFlavorParams";
		public static const LIST_CONVERSION_PROFILES_AND_FLAVOR_PARAMS : String = "listConversionProfilesAndFlavorParams";
		public static const MARK_FLAVORS : String = "markFlavors";
		public static const MARK_CONVERSION_PROFILES : String = "markConversionProfiles";
		public static const UPDATE_CONVERSION_PROFILE_CHANGES : String = "updateConversionProfileChanges";
		
		public var selected : Boolean;
		
		public function ConversionSettingsEvent(type:String, 
												selected:Boolean=false, 
												data:Object=null,
										  		bubbles:Boolean=false, 
										  		cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.selected = selected;
			this.data = data;
		}
	}
}