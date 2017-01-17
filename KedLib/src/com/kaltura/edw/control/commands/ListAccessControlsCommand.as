package com.borhan.edw.control.commands {
	import com.borhan.commands.accessControl.AccessControlList;
	import com.borhan.edw.control.commands.KedCommand;
	import com.borhan.edw.model.datapacks.FilterDataPack;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmvc.control.BMvCEvent;
	import com.borhan.types.BorhanAccessControlOrderBy;
	import com.borhan.vo.AccessControlProfileVO;
	import com.borhan.vo.BorhanAccessControl;
	import com.borhan.vo.BorhanAccessControlFilter;
	import com.borhan.vo.BorhanAccessControlListResponse;
	import com.borhan.vo.BorhanBaseRestriction;
	import com.borhan.vo.BorhanFilterPager;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.resources.ResourceManager;

	public class ListAccessControlsCommand extends KedCommand {

		override public function execute(event:BMvCEvent):void {
			_model.increaseLoadCounter();
			var filter:BorhanAccessControlFilter = new BorhanAccessControlFilter();
			filter.orderBy = BorhanAccessControlOrderBy.CREATED_AT_DESC;
			var pager:BorhanFilterPager = new BorhanFilterPager();
			pager.pageSize = 1000;
			var listAcp:AccessControlList = new AccessControlList(filter, pager);
			listAcp.addEventListener(BorhanEvent.COMPLETE, result);
			listAcp.addEventListener(BorhanEvent.FAILED, fault);
			_client.post(listAcp);
		}


		override public function result(data:Object):void {
			super.result(data);
			if (data.success) {
				var response:BorhanAccessControlListResponse = data.data as BorhanAccessControlListResponse;
				var tempArrCol:ArrayCollection = new ArrayCollection();
				for each (var kac:BorhanAccessControl in response.objects) {
					var acVo:AccessControlProfileVO = new AccessControlProfileVO();
					acVo.profile = kac;
					acVo.id = kac.id;
					if (kac.restrictions ) {
						// remove unknown objects
						// if any restriction is unknown, we remove it from the list.
						// this means it is not supported in BMC at the moment
						for (var i:int = 0; i<kac.restrictions.length; i++) {
							if (! (kac.restrictions[i] is BorhanBaseRestriction)) {
								kac.restrictions.splice(i, 1);
							}
						}
					}
					tempArrCol.addItem(acVo);
				}
				(_model.getDataPack(FilterDataPack) as FilterDataPack).filterModel.accessControlProfiles = tempArrCol;
			}
			else {
				Alert.show(data.error, ResourceManager.getInstance().getString('cms', 'error'));
			}

			_model.decreaseLoadCounter();
		}
	}
}