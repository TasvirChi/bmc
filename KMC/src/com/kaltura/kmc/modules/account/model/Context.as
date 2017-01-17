package com.borhan.bmc.modules.account.model
{
	import com.borhan.BorhanClient;
	
	[Bindable]
	public class Context
	{
		public static const DEFAULT_UI_CONFIG_ID:String = "10000";
	 	public static const DEFAULT_METADATA_PROFILE_NAME : String ="BMC_PROFILE";
	 
 		public var userId:String;
		public var isAnonymous:Boolean;
	//	public var partnerId:String;
		public var subpId:String;
	//	public var ks:String;
		public var uiConfigId:String = DEFAULT_UI_CONFIG_ID;
		public var permissions:int = -1;
		public var groupId:String;
		
		/**
		 * The PS3 - new flex client API
		 * 
		 */
		public var kc:BorhanClient;
		
		/**
		* protocol (like http://) and then  domain (like www.borhan.com)
		* e.g: swf that came from http://www.yourdomain.com/dir/file.swf will have "http://www.yourdomain.com/" as its root url
		*/
	 	public var rootUrl : String; 
		
		/**
		* This url from which this swf came from, omitting the [filename.swf]
		* e.g: swf that came from http://www.yourdomain.com/dir/file.swf will have "http://www.yourdomain.com/dir/" as its source url
		*/
		 public var sourceUrl:String; 

		/**
		 *The hosting server name, e.g. "borhan.com"
		 */
		 public var hostName:String;  
		/**
		 *The main swf file name (e.g "ContributionWizard.swf")
		 */
		public var fileName:String

		public function get defaultUrlVars() :Object
		{
			return {uid: userId,
					partner_id: kc.partnerId,
					subp_id: subpId,
					ks: kc.ks};
		}
	}
}