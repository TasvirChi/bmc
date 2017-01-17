package com.borhan.bmc.modules.analytics.commands {
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.commands.report.ReportGetTable;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmc.modules.analytics.model.AnalyticsModelLocator;
	import com.borhan.types.BorhanReportType;
	import com.borhan.vo.BorhanFilterPager;
	import com.borhan.vo.BorhanReportInputFilter;
	import com.borhan.vo.BorhanReportTable;
	
	import mx.collections.ArrayCollection;
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;

	public class GetApplicationsCommand implements ICommand, IResponder {
		private var _model:AnalyticsModelLocator = AnalyticsModelLocator.getInstance();


		public function execute(event:CairngormEvent):void {
			_model.loadingFlag = true;
			_model.loadingApplicationsFlag = true;

			ExecuteReportHelper.reportSetupBeforeExecution();

			var applicationPager : BorhanFilterPager = new BorhanFilterPager();
			applicationPager.pageSize = 10000;
			applicationPager.pageIndex = 1;
	
			var reportGetTable:ReportGetTable;

			var krif : BorhanReportInputFilter = ExecuteReportHelper.createFilterFromCurrentReport(_model.filter);
			reportGetTable = new ReportGetTable(BorhanReportType.APPLICATIONS,
												krif, 
												applicationPager);
			 
			reportGetTable.queued = false;
			reportGetTable.addEventListener(BorhanEvent.COMPLETE, result);
			reportGetTable.addEventListener(BorhanEvent.FAILED, fault);
			_model.kc.post(reportGetTable);
		}


		public function result(result:Object):void {
			// set loading flags
			_model.loadingApplicationsFlag = false;
			_model.checkLoading();
			
			var krt:BorhanReportTable = BorhanReportTable(result.data);

			// spread received data through the model
			var tablesArr:Array;
			var arrCol:ArrayCollection;
			if(krt.data)
			{
				tablesArr = krt.data.split(";");
				arrCol = new ArrayCollection(tablesArr);
				
				//Remove the last empty cell
				arrCol.removeItemAt(arrCol.length-1);	
				
				//add all as the first item in the list
				arrCol.addItemAt(ResourceManager.getInstance().getString('analytics', 'all'),0);
				_model.applicationsList = arrCol;
			}
			else
			{
				tablesArr = new Array();
				tablesArr.push(ResourceManager.getInstance().getString('analytics', 'all'));
				arrCol = new ArrayCollection(tablesArr);
				_model.applicationsList = arrCol;
			}
		}

		public function fault(info:Object):void {
			//resets selectedReportData to clean view
			_model.selectedReportData.tableDp = _model.reportDataMap[_model.currentScreenState].tableDp = null;
			_model.selectedReportData.totalCount = _model.reportDataMap[_model.currentScreenState].totalCount = 0;

			_model.loadingTableFlag = false;
			_model.checkLoading();
		}
	}
}