package com.borhan.autocomplete.controllers
{
	import com.hillelcoren.components.AutoComplete;
	import com.hillelcoren.utils.StringUtils;
	import com.borhan.BorhanClient;
	import com.borhan.autocomplete.controllers.base.KACControllerBase;
	import com.borhan.commands.user.UserGet;
	import com.borhan.commands.user.UserList;
	import com.borhan.errors.BorhanError;
	import com.borhan.events.BorhanEvent;
	import com.borhan.net.BorhanCall;
	import com.borhan.vo.BorhanFilterPager;
	import com.borhan.vo.BorhanUser;
	import com.borhan.vo.BorhanUserFilter;
	import com.borhan.vo.BorhanUserListResponse;
	
	import flash.events.Event;
	
	import mx.binding.utils.BindingUtils;
	
	public class KACUsersController extends KACControllerBase
	{
		public function KACUsersController(autoComp:AutoComplete, client:BorhanClient)
		{
			super(autoComp, client);
			
			autoComp.labelField = "id";
			autoComp.dropDownLabelFunction = userLabelFunction;
			autoComp.autoSelectFunction = userSelectFunction;
			autoComp.setStyle("unregisteredSelectedItemStyleName", "unregisteredSelectionBox"); 
			BindingUtils.bindSetter(onIdentifierSet, autoComp, "selectedItemIdentifier");
			autoComp.addEventListener(Event.CHANGE, onSelectionChanged, false, int.MAX_VALUE);
		}
		
		private function userSelectFunction(user:BorhanUser, text:String):Boolean{
			return user.id == text;
		}
		
		private function onSelectionChanged(event:Event):void
		{
			for (var index:uint = 0; index < _autoComp.selectedItems.length; index++){
				var item:Object = _autoComp.selectedItems.getItemAt(index);
				if (item is String){
					var userItem:BorhanUser = new BorhanUser();
					userItem.id = item as String;
					_autoComp.selectedItems.setItemAt(userItem, index);
				}
			}
		}
		
		private function onIdentifierSet(ident:Object):void
		{
			var userId:String = ident as String;
			if (userId != null){
				var getUser:UserGet = new UserGet(userId);
				getUser.addEventListener(BorhanEvent.COMPLETE, getUserSuccess);
				getUser.addEventListener(BorhanEvent.FAILED, fault);
				getUser.queued = false;
				
				_client.post(getUser);
			} else {
				_autoComp.selectedItem = null;
			}
		}
		
		private function getUserSuccess(data:Object):void
		{
			if (data.data is BorhanError){
				fault(data as BorhanEvent);
			} else {
				var user:BorhanUser = data.data as BorhanUser;
				if (_autoComp.selectedItems != null){
					_autoComp.selectedItems.addItem(user);
				} else {
					_autoComp.selectedItem = user;
				}
			}
		}
		
		override protected function createCallHook():BorhanCall{
			var filter:BorhanUserFilter = new BorhanUserFilter();
			filter.idOrScreenNameStartsWith = _autoComp.searchText;
			
			var pager:BorhanFilterPager = new BorhanFilterPager();
			pager.pageIndex = 0;
			pager.pageSize = 30;
			
			var listUsers:UserList = new UserList(filter, pager);
			
			return listUsers;
		}
		
		override protected function fetchElements(data:Object):Array{
			return (data.data as BorhanUserListResponse).objects;
		}
		
		private function userLabelFunction(item:Object):String{
			var user:BorhanUser = item as BorhanUser;
			
			var labelText:String;
			if (user.screenName != null && user.screenName != ""){
				labelText = user.screenName + " (" + user.id + ")";
			} else {
				labelText = user.id;
			}
			
			var searchStr:String = _autoComp.searchText;
			
			// there are problems using ">"s and "<"s in HTML
			labelText = labelText.replace( "<", "&lt;" ).replace( ">", "&gt;" );				
			
			var returnStr:String = StringUtils.highlightMatch( labelText, searchStr );
			
			var isDisabled:Boolean = false;
			var currUser:BorhanUser = item as BorhanUser;
			var ku:BorhanUser;
			for each (ku in _autoComp.disabledItems.source){
				if (ku.id == currUser.id){
					isDisabled = true;
					break;
				}
			}
			
			var isSelected:Boolean = false;
			for each (ku in _autoComp.selectedItems.source){
				if (ku.id == currUser.id){
					isSelected = true;
					break;
				}
			}
			
			if (isSelected || isDisabled)
			{
				returnStr = "<font color='" + Consts.COLOR_TEXT_DISABLED + "'>" + returnStr + "</font>";
			}
			
			return returnStr;
		}
	}
}