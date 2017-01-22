package com.borhan.autocomplete.itemRenderers
{
	import com.borhan.autocomplete.itemRenderers.selection.UserSelectedItem;
	
	public class UserFilterSelectedItem extends UserSelectedItem
	{
		override protected function getUnregisteredMsg(userId:String):String{
			return resourceManager.getString("autocomplete", "unregisteredUserForFilterMsg");
		}
	}
}