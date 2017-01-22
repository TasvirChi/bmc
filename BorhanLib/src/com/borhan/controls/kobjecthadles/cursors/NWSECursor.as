/*
This file is part of the Borhan Collaborative Media Suite which allows users 
to do with audio, video, and animation what Wiki platfroms allow them to do with 
text.

Copyright (C) 2006-2008  Borhan Inc.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

@ignore
*/
package com.borhan.controls.kobjecthadles.cursors
{
	import flash.display.Sprite;
	import com.borhan.controls.kobjecthadles.managers.HandleCursorManager;
	import flash.display.Sprite;
	import mx.core.BitmapAsset;
	import mx.effects.Rotate;
	
	public class NWSECursor extends Sprite
	{
		[Embed(source="/com/borhan/controls/kobjecthadles/assets/cursors/light/SizeNWSE.png")] [Bindable] public var CursorNWSECls:Class;
		
		private var rottationEffect : Rotate;
		
		public function NWSECursor()
		{
			super();
			
			var bitmapAsset : BitmapAsset = new CursorNWSECls();
			rottationEffect = new Rotate( bitmapAsset );
			rottationEffect.duration = 1;
			rottationEffect.originX = bitmapAsset.width/2;
			rottationEffect.originY = bitmapAsset.height/2;
			rottationEffect.angleFrom = 0;
			rottationEffect.angleTo = HandleCursorManager.getInstance().currentObjectRotation;
			rottationEffect.play();
			addChild( bitmapAsset );
		}
		
	}
}
