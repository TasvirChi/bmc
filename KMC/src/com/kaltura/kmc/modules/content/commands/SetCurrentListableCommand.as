package com.borhan.bmc.modules.content.commands {
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.bmc.modules.content.events.SetListableEvent;
	import com.borhan.bmc.modules.content.model.CmsModelLocator;

	public class SetCurrentListableCommand extends BorhanCommand {

		override public function execute(event:CairngormEvent):void {
			_model.listableVo = (event as SetListableEvent).listableVo;

		}
	}
}