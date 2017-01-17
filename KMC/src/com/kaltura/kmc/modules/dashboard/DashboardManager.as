package com.borhan.bmc.modules.dashboard {
	import com.borhan.BorhanClient;
	import com.borhan.commands.partner.PartnerGetInfo;
	import com.borhan.commands.partner.PartnerGetStatistics;
	import com.borhan.commands.partner.PartnerGetUsage;
	import com.borhan.commands.report.ReportGetGraphs;
	import com.borhan.dataStructures.HashMap;
	import com.borhan.edw.business.permissions.PermissionManager;
	import com.borhan.edw.model.types.APIErrorCode;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmc.business.JSGate;
	import com.borhan.bmc.events.BmcNavigationEvent;
	import com.borhan.bmc.modules.BmcModule;
	import com.borhan.types.BorhanReportType;
	import com.borhan.vo.BorhanPartner;
	import com.borhan.vo.BorhanPartnerStatistics;
	import com.borhan.vo.BorhanPartnerUsage;
	import com.borhan.vo.BorhanReportGraph;
	import com.borhan.vo.BorhanReportInputFilter;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.StaticText;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.formatters.DateFormatter;
	import mx.managers.PopUpManager;
	import mx.resources.ResourceManager;

	/**
	 * A singlton class - this class manages the behavior of the controlers and uses as cashe for the server's data
	 * In the first phase of the dashboard this class does it all, later on we will split it to
	 */
	public class DashboardManager extends EventDispatcher {
		public const BORHAN_OFFSET:Number = 21600; //(6 hours * 60 min * 60 sec = 21600)

		///it is set to 30 DAYS just to get some data
		public const SECONDES_IN_30_DAYS:Number = 30 * 24 * 60 * 60; // 7d x 24h x 60m x 60s

		public const TODAY_DATE:Date = new Date();
		public const DATE_30_DAYS_AGO:Date = new Date(new Date().time - (SECONDES_IN_30_DAYS * 1000));

		/** single instanse for this class **/
		private static var _instance:DashboardManager;

		/** borhan client object - for contacting the server **/
		private var _kc:BorhanClient; //borhan client that make all borhan API calls
		public var app:BmcModule;
		
		[Bindable]
		public var showGraphs : Boolean = true;

		/** map for the graphs data **/
		private var dimMap:HashMap = new HashMap();

		/** the selected graph data in a format of ArrayCollection {(X1,Y1), ... , (Xn,Yn)}  **/
		[Bindable]
		private var _selectedDim:ArrayCollection = new ArrayCollection();

		[Bindable]
		public var totalBWSoFar:String = '0';
		[Bindable]
		public var totalPercentSoFar:String = '0';
		[Bindable]
		public var totalUsage:String = '0';
		[Bindable]
		public var hostingGB:String = '0';
		[Bindable]
		public var partnerPackage:String = '0';
		
		[Bindable]
		/**
		 * publisher name for welcome message
		 * */
		public var publisherName:String;


		public function get kc():BorhanClient {
			return _kc;
		}


		public function set kc(kC:BorhanClient):void {
			_kc = kC;
		}


		/**
		 * Singlton pattern call for this class instance
		 *
		 */
		public static function get instance():DashboardManager {
			if (_instance == null) {
				_instance = new DashboardManager(new Enforcer());
			}

			return _instance;
		}


		/**
		 * Constracture - for a singlton - enforcer class can't be reached outside this class
		 *
		 */
		public function DashboardManager(enforcer:Enforcer, target:IEventDispatcher = null) {
			super(target);
		}


		[Bindable]
		public function get selectedDim():ArrayCollection {
			return _selectedDim;
		}


		public function set selectedDim(selectedDim:ArrayCollection):void {
			_selectedDim = selectedDim;
		}


		/**
		 * Data Calling from the servers
		 *
		 */
		public function getData():void {
			if (showGraphs)
			{
				getGraphData();
			}
			getUsageData();
			getPartnerData();
		}
		
		
		private function getPartnerData():void {
			var getPartnerInfo:PartnerGetInfo = new PartnerGetInfo();
			getPartnerInfo.addEventListener(BorhanEvent.COMPLETE, onPartnerInfo);
			getPartnerInfo.addEventListener(BorhanEvent.FAILED, fault);
			kc.post(getPartnerInfo);	
		}

		
		private function onPartnerInfo(ke:BorhanEvent):void {
			publisherName = (ke.data as BorhanPartner).name;
		}
		

		/**
		 * Calling for the Account usage data from the server
		 *
		 *
		 */
		private function getUsageData():void {
			var now:Date = new Date();
			new BorhanPartnerUsage();
			var partnerGetStatistics:PartnerGetStatistics = new PartnerGetStatistics();
			partnerGetStatistics.addEventListener(BorhanEvent.COMPLETE, onPartnerStatistics);
			partnerGetStatistics.addEventListener(BorhanEvent.FAILED, fault);
			kc.post(partnerGetStatistics);	
		}
		
		protected function onPartnerStatistics(result:Object):void
		{
			var statistics:BorhanPartnerStatistics = result.data as BorhanPartnerStatistics;
			totalBWSoFar = statistics.bandwidth.toFixed(2);
			totalPercentSoFar = statistics.usagePercent.toFixed();
			hostingGB = statistics.hosting.toFixed(2);
			partnerPackage = statistics.packageBandwidthAndStorage.toFixed();
			totalUsage = statistics.usage.toString();
		}


		/**
		 * In case the usage data call has errors
		 */
		private function onSrvFlt(fault:Object):void {
			Alert.show(ResourceManager.getInstance().getString('kdashboard', 'usageErrorMsg') + ":\n" + fault.error.errorMsg, ResourceManager.getInstance().getString('kdashboard', 'error'));
		}

		
		private static var dateFormatter:DateFormatter; 
		private static function initDateFormatter():void {
			dateFormatter = new DateFormatter();
			dateFormatter.formatString = "YYYYMMDD"; 
		}
		
		
		/**
		 * Calling for the graph's data from the server
		 */
		private function getGraphData():void {
			var krif:BorhanReportInputFilter = new BorhanReportInputFilter();
			if (!dateFormatter) initDateFormatter();
			
			var today:Date = new Date();
			
			// use new filters (YYYYMMDD). send local date.
			krif.toDay = dateFormatter.format(today);
			var ONE_DAY:int = 1000 * 60 * 60 * 24;
			krif.fromDay = dateFormatter.format(new Date(today.time - 30*ONE_DAY));
			krif.timeZoneOffset = today.timezoneOffset;

			var reportGetGraphs:ReportGetGraphs = new ReportGetGraphs(BorhanReportType.TOP_CONTENT, krif, 'sum_time_viewed'); //  sum_time_viewed count_plays

			reportGetGraphs.addEventListener(BorhanEvent.COMPLETE, result);
			reportGetGraphs.addEventListener(BorhanEvent.FAILED, fault);
			kc.post(reportGetGraphs);
		}


		/**
		 * The result for the graph's data. Preparing the data as need for the graphs.
		 * Saving it in a map, for easy navigation between the graphs.
		 *
		 */
		private function result(result:Object):void {
			var krpArr:Array = result.data as Array;

			for (var i:int = 0; i < krpArr.length; i++) {
				var krp:BorhanReportGraph = BorhanReportGraph(krpArr[i]);
				var pointsArr:Array = krp.data.split(";");
				var graphPoints:ArrayCollection = new ArrayCollection();

				for (var j:int = 0; j < pointsArr.length; j++) {
					if (pointsArr[j]) {
						var xYArr:Array = pointsArr[j].split(",");
						var year:String = String(xYArr[0]).substring(0, 4);
						var month:String = String(xYArr[0]).substring(4, 6);
						var date:String = String(xYArr[0]).substring(6, 8);
						var newDate:Date = new Date(Number(year), Number(month) - 1, Number(date));
						var timestamp:Number = newDate.time;
						graphPoints.addItem({x: timestamp, y: xYArr[1]});
					}
				}

				dimMap.put(krp.id, graphPoints);
			}

			// set the first AC as the default for the graph
			selectedDim = dimMap.getValue('count_plays');
		}


		public function updateSelectedDim(dimCode:String):void {
			selectedDim = dimMap.getValue(dimCode) != null ? dimMap.getValue(dimCode) : new ArrayCollection();
		}


		/**
		 * In case of fault when calling the graph's data
		 * @param info
		 *
		 */
		private function fault(info:Object):void {
			if ((info as BorhanEvent).error) {
				if (info.error.errorCode == APIErrorCode.INVALID_KS) {
					JSGate.expired();
				}
				else if (info.error.errorCode == APIErrorCode.SERVICE_FORBIDDEN) {
					// added the support of non closable window
					
					Alert.show(ResourceManager.getInstance().getString('common', 'forbiddenError'), 
						ResourceManager.getInstance().getString('kdashboard', 'error'), Alert.OK, null, logout);
					//de-activate the HTML tabs
//					ExternalInterface.call("bmc.utils.activateHeader", false);
				}
				else if((info as BorhanEvent).error.errorMsg) {
					Alert.show((info as BorhanEvent).error.errorMsg, ResourceManager.getInstance().getString('kdashboard', 'error'));
				}
			}
		}

		protected function logout(e:Object):void {
			JSGate.expired();
		}


		/**
		 * launch the links by clicking on the linkbuttons in the dashboard application
		 * 
		 * @param linkCode
		 * @param pageNum
		 * 
		 */
		public function launchOuterLink(linkCode:String, pageNum:String=null):void
		{
			var linkStr:String = ResourceManager.getInstance().getString('kdashboard', linkCode);
			linkStr += pageNum ? ('#page=' + pageNum) : '';
			var urlr:URLRequest = new URLRequest(linkStr);
			navigateToURL(urlr, "_blank");
		}

		/**
		 * open a new page with the given url
		 * @param url 	address to open
		 */
		public function launchExactOuterLink(url:String):void {
			var urlr:URLRequest = new URLRequest(url);
			navigateToURL(urlr, "_blank");
		}


		/**
		 * Loading a outer module by calling JS function and the html wrapper of this SWF application
		 */
		public function loadBMCModule(moduleName:String, subModule:String = ''):void {
			dispatchEvent(new BmcNavigationEvent(BmcNavigationEvent.NAVIGATE, moduleName, subModule));
		}

	}
}

class Enforcer {

}