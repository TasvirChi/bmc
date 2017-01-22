package com.borhan.bmc.utils
{
	import com.borhan.bmc.modules.account.model.Context;
	import com.borhan.types.BorhanMetadataProfileCreateMode;
	import com.borhan.utils.parsers.MetadataProfileParser;
	import com.borhan.vo.BMCMetadataProfileVO;
	import com.borhan.vo.BorhanMetadataProfile;
	import com.borhan.vo.BorhanMetadataProfileListResponse;
	
	import mx.collections.ArrayCollection;

	/**
	 * This class it intended for creating a "listMetadataProfile" request
	 * and handling the response. Since the "list" request is sent from various places we will handle the result in this util. 
	 * @author Michal
	 * 
	 */	
	public class ListMetadataProfileUtil
	{
		/**
		 * This function will parse the given object and return an arrayCollection of the 
		 * suitable BMCMetadataProfileVO classes 
		 * @param response is the BorhanMetadataProfileList response, returned from the server
		 * @param context is the Context that will be used for the download url
		 * @return arrayCollection
		 */		
		public static function handleListMetadataResult(response:BorhanMetadataProfileListResponse, context:Context) : ArrayCollection 
		{
			var profilesArray:ArrayCollection = new ArrayCollection();
		
			if (response.objects) {
				for (var i:int = 0; i< response.objects.length; i++ ) {
					var recievedProfile:BorhanMetadataProfile = response.objects[i] as BorhanMetadataProfile;
					if (!recievedProfile)
						continue;
					var metadataProfile : BMCMetadataProfileVO = new BMCMetadataProfileVO();
					metadataProfile.profile = recievedProfile;
					metadataProfile.id = recievedProfile.id;
					metadataProfile.downloadUrl = context.kc.protocol + context.kc.domain + BMCMetadataProfileVO.serveURL + "/ks/" + context.kc.ks + "/id/" + recievedProfile.id;
					//parses only profiles that were created from BMC
					if (!(recievedProfile.createMode) || (recievedProfile.createMode == BorhanMetadataProfileCreateMode.BMC)) {
						try {
							metadataProfile.xsd = new XML(recievedProfile.xsd);
							metadataProfile.metadataFieldVOArray = MetadataProfileParser.fromXSDtoArray(metadataProfile.xsd);
						}
						catch (er:Error) {
							metadataProfile.profileDisabled = true;	
						}
					}
					//none BMC profile
					else {
						metadataProfile.profileDisabled = true;
					}
					
					profilesArray.addItem(metadataProfile);
				}
			}
			return profilesArray;
		}
	}
}