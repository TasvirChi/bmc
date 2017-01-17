package com.borhan.bmc.modules.account.view.windows.accesscontrol.renderers
{
	import com.borhan.types.BorhanNullableBoolean;
	import com.borhan.vo.AccessControlProfileVO;
	
	import mx.containers.HBox;

	public class AccessControlRendererBase extends HBox
	{
		public function AccessControlRendererBase()
		{
			super();
		}
		
		public function setDefaultContainer():void
		{
			if((data as AccessControlProfileVO).profile.isDefault == BorhanNullableBoolean.TRUE_VALUE)
			{
				this.toolTip = resourceManager.getString('account', 'defaultAccessContolProfileToolTip');
				this.setStyle("backgroundColor", "#FFFDEF");
			}
			else
			{
				this.toolTip = null;
				this.setStyle("backgroundColor", null);
			}
		}
		
		override public function validateNow():void
		{
			super.validateNow();
			setDefaultContainer();
		}
		
	}
}