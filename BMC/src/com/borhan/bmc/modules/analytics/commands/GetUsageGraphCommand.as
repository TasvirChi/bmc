package com.borhan.bmc.modules.analytics.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.bmc.modules.analytics.model.AnalyticsModelLocator;
	import com.borhan.bmc.modules.analytics.vo.AccountUsageVO;
	import com.borhan.commands.partner.PartnerGetUsage;
	import com.borhan.events.BorhanEvent;
	import com.borhan.vo.BorhanPartnerUsage;
	
	import mx.rpc.IResponder;
	
	public class GetUsageGraphCommand implements ICommand, IResponder
	{
		private var _model : AnalyticsModelLocator = AnalyticsModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			new BorhanPartnerUsage();
			var params:Object = event.data;
			var getPartnerUsage:PartnerGetUsage = new PartnerGetUsage(params.year, params.month, params.resolution);
			getPartnerUsage.addEventListener(BorhanEvent.COMPLETE, result);
			getPartnerUsage.addEventListener(BorhanEvent.FAILED, fault);
			_model.kc.post(getPartnerUsage);	
		}
		
		public function result(data:Object):void
		{
			var usageData:AccountUsageVO = new AccountUsageVO();
			usageData.hostingGB = data.data.hostingGB;
			usageData.totalBWSoFar = data.data.usageGB;
			usageData.totalPercentSoFar = data.data.Percent;
			usageData.usageSeries = data.data.usageGraph;
			usageData.packageBW = data.data.packageBW;
			
			_model.usageData = usageData;
		}
		
		public function fault(info:Object):void
		{
			
		}
	}
}