package com.borhan.bmc.modules.content.commands.cat
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.commands.MultiRequest;
	import com.borhan.commands.categoryUser.CategoryUserList;
	import com.borhan.commands.user.UserGet;
	import com.borhan.commands.user.UserList;
	import com.borhan.errors.BorhanError;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmc.modules.content.commands.BorhanCommand;
	import com.borhan.bmc.modules.content.events.CategoryEvent;
	import com.borhan.vo.BorhanCategoryUser;
	import com.borhan.vo.BorhanCategoryUserFilter;
	import com.borhan.vo.BorhanCategoryUserListResponse;
	import com.borhan.vo.BorhanFilterPager;
	import com.borhan.vo.BorhanUser;
	import com.borhan.vo.BorhanUserFilter;
	import com.borhan.vo.BorhanUserListResponse;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;

	public class ListCategoryUsersCommand extends BorhanCommand {
		
		
		
		/**
		 * the last filter used for list action 
		 * @internal
		 * the inherit users from parent action ends in listing users, and requires the last used filter.
		 */		
		private static var lastFilter:BorhanCategoryUserFilter;
		
		
		private const CHUNK_SIZE:int = 20;
		
		private var _totalCategoryUsers:int;
		private var _categoryUsers:Array;
		
		private var _users:Array;
		private var _lastCatUsrIndex:int;
		
		
		override public function execute(event:CairngormEvent):void {
			if (event.type == CategoryEvent.RESET_CATEGORY_USER_LIST) {
				_model.categoriesModel.categoryUsers = null;
				_model.categoriesModel.totalCategoryUsers = 0;
				return;
			}
			
			
			_model.increaseLoadCounter();
			var f:BorhanCategoryUserFilter;
			var p:BorhanFilterPager;
			
			if (event.data is Array) {
				f = event.data[0];
				p = event.data[1];
			}
			
			if (f) {
				// remember given filter
				lastFilter = f;
			}
			else if (lastFilter) {
				// use saved filter
				f = lastFilter;
			}
			
			var getUsrs:CategoryUserList = new CategoryUserList(f, p);
			getUsrs.addEventListener(BorhanEvent.COMPLETE, getUsers);
			getUsrs.addEventListener(BorhanEvent.FAILED, fault);
			_model.context.kc.post(getUsrs);	   
		}
		
		
		private function getUsers(data:BorhanEvent):void {
			super.result(data);
			if (!checkError(data)) {
				var resp:BorhanCategoryUserListResponse = data.data as BorhanCategoryUserListResponse; 
				_categoryUsers = resp.objects;
				_totalCategoryUsers = resp.totalCount;
				
				_users = [];
				
				
				var mr:MultiRequest = new MultiRequest();
				var ug:UserGet;
				for each (var kcu:BorhanCategoryUser in _categoryUsers) {
					ug = new UserGet(kcu.userId);
					mr.addAction(ug);
				}
				mr.addEventListener(BorhanEvent.COMPLETE, getUsersResult);
				mr.addEventListener(BorhanEvent.FAILED, fault);
				
				_model.increaseLoadCounter();
				_model.context.kc.post(mr);
				
			}
			_model.decreaseLoadCounter();
		}
		
		
		private function getUsersResult(e:BorhanEvent):void {
			_model.decreaseLoadCounter();
			for each (var o:Object in e.data) {
				if (o is BorhanUser) {
					_users.push(o);
				}
			}
			
			// match to categoryUsers
			addNameToCategoryUsers();
		}
		
		
		
		/**
		 * get the next chunk of BorhanUser objects 
		 */		
		private function getUsersChunk():void {
			var ids:String = '';
			var i:int;
			for (i = 0; i < CHUNK_SIZE; i++) {
				if (_lastCatUsrIndex + i < _categoryUsers.length) {
					ids += (_categoryUsers[_lastCatUsrIndex + i] as BorhanCategoryUser).userId + ",";  
				}
				else {
					break;
				}
			} 
			_lastCatUsrIndex = _lastCatUsrIndex + i;
			
			var f:BorhanUserFilter = new BorhanUserFilter();
			f.idIn = ids;
			
			// CHUNK_SIZE is less than the default pager, so no need to add one.
			var getUsrs:UserList = new UserList(f);
			getUsrs.addEventListener(BorhanEvent.COMPLETE, getUsersChunkResult);
			getUsrs.addEventListener(BorhanEvent.FAILED, fault);
			
			_model.increaseLoadCounter();
			_model.context.kc.post(getUsrs);
		}
		
		
		/**
		 * accunulate received result and trigger next load if needed 
		 * @param data	users data from server
		 */		
		private function getUsersChunkResult(data:BorhanEvent):void {
			super.result(data);
			if (!checkError(data)) {
				_users = _users.concat((data.data as BorhanUserListResponse).objects);
				if (_lastCatUsrIndex < _categoryUsers.length) {
					// there are more users to load
					getUsersChunk();
				}
				else {
					// match to categoryUsers
					addNameToCategoryUsers();
				}
			}
			_model.decreaseLoadCounter();	
		}
		
		private function addNameToCategoryUsers():void {
			var usr:BorhanUser;
			for each (var cu:BorhanCategoryUser in _categoryUsers) {
				for (var i:int = 0; i<_users.length; i++) {
					usr = _users[i] as BorhanUser;
					if (cu.userId == usr.id) {
						cu.userName = usr.screenName;
						_users.splice(i, 1);
						break;
					}
				}
			}
			_model.categoriesModel.categoryUsers = new ArrayCollection(_categoryUsers);
			_model.categoriesModel.totalCategoryUsers = _totalCategoryUsers;
		}
		
	}
}