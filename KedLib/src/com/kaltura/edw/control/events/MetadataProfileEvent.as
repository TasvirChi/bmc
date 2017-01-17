package com.borhan.edw.control.events {
	import com.borhan.bmvc.control.BMvCEvent;

	/**
	 * this class represents events related to metadataProfile
	 * @author Michal
	 *
	 */
	public class MetadataProfileEvent extends BMvCEvent {
		public static const LIST:String = "content_listMetadataProfile";
//		public static const ADD : String = "content_addMetadataProfile";
//		public static const UPDATE : String = "content_updateMetadataProfile";
		public static const GET:String = "content_getMetadataProfile";
		
		public static const GET_METADATA_UICONF:String = "get_metadata_uiconf";

		public var profileId:int;


		public function MetadataProfileEvent(type:String, profile_id:int = -1,
							bubbles:Boolean = false, cancelable:Boolean = false) {
			this.profileId = profile_id;
			super(type, bubbles, cancelable);
		}
	}
}