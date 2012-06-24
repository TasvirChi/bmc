package com.kaltura.kmc.modules.content.commands.cat
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.kaltura.commands.MultiRequest;
	import com.kaltura.commands.category.CategoryGet;
	import com.kaltura.commands.categoryUser.CategoryUserAdd;
	import com.kaltura.commands.categoryUser.CategoryUserCopyFromCaregory;
	import com.kaltura.commands.categoryUser.CategoryUserList;
	import com.kaltura.events.KalturaEvent;
	import com.kaltura.kmc.modules.content.commands.KalturaCommand;
	import com.kaltura.kmc.modules.content.events.CategoryEvent;
	import com.kaltura.vo.KalturaCategory;
	import com.kaltura.vo.KalturaCategoryUser;
	import com.kaltura.vo.KalturaCategoryUserFilter;
	import com.kaltura.vo.KalturaCategoryUserListResponse;
	import com.kaltura.vo.KalturaFilterPager;

	public class aInheritUsersCommand extends KalturaCommand {
		
//		/**
//		 * total number of userse on parent category 
//		 */		
//		private var _totalUsers:int;
//		
//		/**
//		 * last pager used for listing members 
//		 */		
//		private var _pager:KalturaFilterPager;
//		
//		/**
//		 * filter used for listing members
//		 */		
//		private var _filter:KalturaCategoryUserFilter;
//		
//		/**
//		 * the category to which users are added 
//		 */		
//		private var _category:KalturaCategory;
		
		override public function execute(event:CairngormEvent):void {
			_model.increaseLoadCounter();
//			_category = event.data as KalturaCategory;
//			_pager = new KalturaFilterPager();
//			_pager.pageIndex = 0;
//			_pager.pageSize = 50;
//			_filter = new KalturaCategoryUserFilter();
//			_filter.categoryIdEqual = _category.parentId;
//			getNextPage();
			var getUsrs:CategoryUserCopyFromCaregory = new CategoryUserCopyFromCaregory((event.data as KalturaCategory).id);
			getUsrs.addEventListener(KalturaEvent.COMPLETE, result);
			getUsrs.addEventListener(KalturaEvent.FAILED, fault);
			_model.context.kc.post(getUsrs);
			
		}
		
//		
//		/**
//		 * get the next chunk of users 
//		 */		
//		private function getNextPage():void {
//			_pager.pageIndex += 1;
//			var getUsrs:CategoryUserList = new CategoryUserList(_filter, _pager);
//			getUsrs.addEventListener(KalturaEvent.COMPLETE, addUsersToCategory);
//			getUsrs.addEventListener(KalturaEvent.FAILED, fault);
//			_model.context.kc.post(getUsrs);
//		}
		
		
//		/**
//		 * add the recieved users chunk to the category 
//		 */		
//		private function addUsersToCategory(event:KalturaEvent):void {
//			super.result(event);
//			var response:KalturaCategoryUserListResponse = event.data as KalturaCategoryUserListResponse;
//			_totalUsers = response.totalCount;
//			// if no users
//			if (_totalUsers == 0) {
//				_model.decreaseLoadCounter();
//				return;
//			}
//			var mr:MultiRequest = new MultiRequest();
//			var cua:CategoryUserAdd, cu:KalturaCategoryUser;
//			for (var i:int = 0; i<response.objects.length; i++) {
//				cu = response.objects[i] as KalturaCategoryUser;
//				cu.categoryId = _category.id;
//				cu.setInsertedFields(true);
//				cu.setUpdatedFieldsOnly(true);
//				cua = new CategoryUserAdd(cu);
//				mr.addAction(cua);
//			}
//			var getCat:CategoryGet = new CategoryGet(catid);
//			mr.addAction(getCat);
//			mr.addEventListener(KalturaEvent.COMPLETE, result);
//			mr.addEventListener(KalturaEvent.FAILED, fault);
//			_model.context.kc.post(mr);
//		}
		
//		
//		override public function result(data:Object):void {
//			super.result(data);
//			if (checkError(data)) {
//				_model.decreaseLoadCounter();
//				return;
//			}
//			if (_totalUsers > _pager.pageIndex * _pager.pageSize) {
//				getNextPage();
//			}
//			else {
//				var cg:CategoryEvent = new CategoryEvent(CategoryEvent.LIST_CATEGORY_USERS);
//				cg.dispatch();
//				_model.decreaseLoadCounter();
//			}
//		}
		
		override public function result(data:Object):void {
			super.result(data);
			if (!checkError(data)) {
				var cg:CategoryEvent = new CategoryEvent(CategoryEvent.LIST_CATEGORY_USERS);
				cg.dispatch();
				// set new numbers of members to the category object
				var updatedCat:KalturaCategory = data.data[data.data.length-1] as KalturaCategory;
				_model.categoriesModel.selectedCategory.membersCount = updatedCat.membersCount;
				_model.categoriesModel.selectedCategory.pendingMembersCount = updatedCat.pendingMembersCount;
			}
			_model.decreaseLoadCounter();
		}
	}
}