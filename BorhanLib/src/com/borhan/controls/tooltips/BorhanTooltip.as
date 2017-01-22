package com.borhan.controls.tooltips
{
	import mx.controls.ToolTip;

	
	/**
	 * This class enforce a specific CSS class for the tooltip. It is made
	 * to seperate tooltips between one flex application loading a new flex applicatio.
	 */
	public class BorhanTooltip extends ToolTip
	{
		public function BorhanTooltip()
		{
			super();
			styleName = "BorhanTooltip";
		}
		
	}
}