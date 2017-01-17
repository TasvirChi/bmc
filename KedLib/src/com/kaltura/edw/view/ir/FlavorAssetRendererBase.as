package com.borhan.edw.view.ir
{
	import com.borhan.edw.vo.FlavorAssetWithParamsVO;
	import com.borhan.managers.FileUploadManager;
	import com.borhan.vo.FileUploadVO;
	import com.borhan.vo.BorhanFlavorAssetWithParams;
	
	import mx.containers.HBox;
	import mx.events.FlexEvent;

	public class FlavorAssetRendererBase extends HBox
	{
		public function FlavorAssetRendererBase()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreatoinComplete);
		}
		
		protected function onCreatoinComplete(e:FlexEvent):void
		{
			/* var obj:FlavorAssetWithParamsVO = data as FlavorAssetWithParamsVO;
			var bgColor:String = (obj.borhanFlavorAssetWithParams.flavorAsset != null) ? '#FFFFFF' : '#DED2D2';
			
			this.setStyle("backgroundColor", bgColor); */
			
			horizontalScrollPolicy = "off";
			verticalScrollPolicy = "off";
		}	
				
	}
}