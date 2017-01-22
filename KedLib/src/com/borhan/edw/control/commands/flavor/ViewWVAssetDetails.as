package com.borhan.edw.control.commands.flavor
{
	import com.borhan.edw.control.commands.KedCommand;
	import com.borhan.edw.view.window.flavors.DRMDetails;
	import com.borhan.edw.vo.FlavorAssetWithParamsVO;
	import com.borhan.bmvc.control.BMvCEvent;
	
	import flash.display.DisplayObject;
	
	import mx.core.Application;
	import mx.managers.PopUpManager;

	public class ViewWVAssetDetails extends KedCommand
	{
		override public function execute(event:BMvCEvent):void
		{		
			var win:DRMDetails = new DRMDetails();
			win.flavorAssetWithParams = event.data as FlavorAssetWithParamsVO;
			PopUpManager.addPopUp(win, (Application.application as DisplayObject), true);
			PopUpManager.centerPopUp(win);
		}
	}
}