package com.borhan.edw.control.commands {
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.commands.conversionProfile.ConversionProfileList;
	import com.borhan.edw.control.commands.KedCommand;
	import com.borhan.edw.model.datapacks.FlavorsDataPack;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmvc.control.BMvCEvent;
	import com.borhan.types.BorhanConversionProfileType;
	import com.borhan.types.BorhanNullableBoolean;
	import com.borhan.vo.BorhanConversionProfile;
	import com.borhan.vo.BorhanConversionProfileFilter;
	import com.borhan.vo.BorhanConversionProfileListResponse;
	import com.borhan.vo.BorhanFilterPager;
	
	import mx.collections.ArrayCollection;

	[ResourceBundle("live")]
	
	public class ListLiveConversionProfilesCommand extends KedCommand {

		override public function execute(event:BMvCEvent):void {
			
			var p:BorhanFilterPager = new BorhanFilterPager();
			p.pageIndex = 1;
			p.pageSize = 500; // trying to get all conversion profiles here, standard partner has no more than 10
			var f:BorhanConversionProfileFilter = new BorhanConversionProfileFilter();
			f.typeEqual = BorhanConversionProfileType.LIVE_STREAM;
			var listProfiles:ConversionProfileList = new ConversionProfileList(f, p);
			listProfiles.addEventListener(BorhanEvent.COMPLETE, result);
			listProfiles.addEventListener(BorhanEvent.FAILED, fault);
			_model.increaseLoadCounter();
			_client.post(listProfiles);
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
			var fdp:FlavorsDataPack = _model.getDataPack(FlavorsDataPack) as FlavorsDataPack;
			fdp.liveConversionProfiles = new ArrayCollection(result);
			_model.decreaseLoadCounter();

		}
	}
}
