package com.borhan.bmc.modules.content.commands.live {
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.commands.conversionProfile.ConversionProfileList;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmc.modules.content.commands.BorhanCommand;
	import com.borhan.types.BorhanConversionProfileType;
	import com.borhan.types.BorhanNullableBoolean;
	import com.borhan.vo.BorhanConversionProfile;
	import com.borhan.vo.BorhanConversionProfileFilter;
	import com.borhan.vo.BorhanConversionProfileListResponse;
	import com.borhan.vo.BorhanFilterPager;
	
	import mx.collections.ArrayCollection;

	[ResourceBundle("live")]
	
	public class ListLiveConversionProfilesCommand extends BorhanCommand {

		override public function execute(event:CairngormEvent):void {
			
			var p:BorhanFilterPager = new BorhanFilterPager();
			p.pageIndex = 1;
			p.pageSize = 500; // trying to get all conversion profiles here, standard partner has no more than 10
			var f:BorhanConversionProfileFilter = new BorhanConversionProfileFilter();
			f.typeEqual = BorhanConversionProfileType.LIVE_STREAM;
			var listProfiles:ConversionProfileList = new ConversionProfileList(f, p);
			listProfiles.addEventListener(BorhanEvent.COMPLETE, result);
			listProfiles.addEventListener(BorhanEvent.FAILED, fault);
			_model.increaseLoadCounter();
			_model.context.kc.post(listProfiles);
		}


		override public function result(data:Object):void {
			super.result(data);
			
			var result:Array = new Array();
			for each (var bcp:BorhanConversionProfile in (data.data as BorhanConversionProfileListResponse).objects) {
				if (bcp.isDefault == BorhanNullableBoolean.TRUE_VALUE) {
					result.unshift(bcp);
				}
				else {
					result.push(bcp);
				}
			}
			
			_model.liveConversionProfiles = new ArrayCollection(result);
			_model.decreaseLoadCounter();

		}
	}
}
