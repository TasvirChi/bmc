package com.borhan.bmc.modules.content.utils
{
	import com.borhan.types.BorhanCategoryUserPermissionLevel;

	public class CategoryUserUtil
	{
		public function CategoryUserUtil()
		{
		}
		
		
		public static function getPermissionNames(permissionLevel:int):String {
			var result:String;
			switch(permissionLevel) {
				case BorhanCategoryUserPermissionLevel.MEMBER:
					result = "CATEGORY_VIEW";
					break;
				case BorhanCategoryUserPermissionLevel.CONTRIBUTOR:
					result = "CATEGORY_CONTRIBUTE,CATEGORY_VIEW";
					break;
				case BorhanCategoryUserPermissionLevel.MODERATOR:
					result = "CATEGORY_MODERATE,CATEGORY_CONTRIBUTE,CATEGORY_VIEW";
					break;
				case BorhanCategoryUserPermissionLevel.MANAGER:
					result = "CATEGORY_EDIT,CATEGORY_MODERATE,CATEGORY_CONTRIBUTE,CATEGORY_VIEW";
					break;
			}
			return result;
		}
	}
}