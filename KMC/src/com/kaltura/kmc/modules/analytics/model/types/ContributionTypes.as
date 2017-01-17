package com.borhan.bmc.modules.analytics.model.types
{
	import com.borhan.types.BorhanSearchProviderType;
	import com.borhan.types.BorhanSourceType;
	
	import mx.resources.ResourceManager;

	public class ContributionTypes
	{
		public static function getContributionType(type:int):String
		{
			switch (type)
			{
				// mix entries have no source attribute in DB, so we get -1 for them.
				case -1:
					return ResourceManager.getInstance().getString('sourceTypes', 'UNKNOWN');
					break;
				case int(BorhanSourceType.FILE):
					return ResourceManager.getInstance().getString('sourceTypes', 'FILE');
					break;
				case int(BorhanSourceType.SEARCH_PROVIDER):
					return ResourceManager.getInstance().getString('sourceTypes', 'SEARCH_PROVIDER');
					break;
				case int(BorhanSourceType.URL):
					return ResourceManager.getInstance().getString('sourceTypes', 'URL');
					break;
				case int(BorhanSourceType.WEBCAM):
					return ResourceManager.getInstance().getString('sourceTypes', 'WEBCAM');
					break;
				case BorhanSearchProviderType.FLICKR:
					return ResourceManager.getInstance().getString('sourceTypes', 'FLICKR');
					break;
				case BorhanSearchProviderType.ARCHIVE_ORG:
					return ResourceManager.getInstance().getString('sourceTypes', 'ARCHIVE_ORG');
					break;
				case BorhanSearchProviderType.CCMIXTER:
					return ResourceManager.getInstance().getString('sourceTypes', 'CCMIXTER');
					break;
				case BorhanSearchProviderType.CURRENT:
					return ResourceManager.getInstance().getString('sourceTypes', 'CURRENT');
					break;
				case BorhanSearchProviderType.JAMENDO:
					return ResourceManager.getInstance().getString('sourceTypes', 'JAMENDO');
					break;
				case BorhanSearchProviderType.BORHAN:
					return ResourceManager.getInstance().getString('sourceTypes', 'BORHAN');
					break;
				case BorhanSearchProviderType.BORHAN_PARTNER:
					return ResourceManager.getInstance().getString('sourceTypes', 'BORHAN_PARTNER');
					break;
				case BorhanSearchProviderType.BORHAN_USER_CLIPS:
					return ResourceManager.getInstance().getString('sourceTypes', 'BORHAN_USER_CLIPS');
					break;
				case BorhanSearchProviderType.MEDIA_COMMONS:
					return ResourceManager.getInstance().getString('sourceTypes', 'MEDIA_COMMONS');
					break;
				case BorhanSearchProviderType.METACAFE:
					return ResourceManager.getInstance().getString('sourceTypes', 'METACAFE');
					break;
				case BorhanSearchProviderType.MYSPACE:
					return ResourceManager.getInstance().getString('sourceTypes', 'MYSPACE');
					break;
				case BorhanSearchProviderType.NYPL:
					return ResourceManager.getInstance().getString('sourceTypes', 'NYPL');
					break;
				case BorhanSearchProviderType.PHOTOBUCKET:
					return ResourceManager.getInstance().getString('sourceTypes', 'PHOTOBUCKET');
					break;
				case BorhanSearchProviderType.YOUTUBE:
					return ResourceManager.getInstance().getString('sourceTypes', 'YOUTUBE');
					break;
				case BorhanSearchProviderType.SEARCH_PROXY:
					return ResourceManager.getInstance().getString('sourceTypes', 'SEARCH_PROXY');
					break;
			}

			return "";
		}
	}
}