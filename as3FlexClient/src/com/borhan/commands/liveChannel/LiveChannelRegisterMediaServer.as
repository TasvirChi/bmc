// ===================================================================================================
//                           _  __     _ _
//                          | |/ /__ _| | |_ _  _ _ _ __ _
//                          | ' </ _` | |  _| || | '_/ _` |
//                          |_|\_\__,_|_|\__|\_,_|_| \__,_|
//
// This file is part of the Borhan Collaborative Media Suite which allows users
// to do with audio, video, and animation what Wiki platfroms allow them to do with
// text.
//
// Copyright (C) 2006-2016  Borhan Inc.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//
// @ignore
// ===================================================================================================
package com.borhan.commands.liveChannel
{
	import com.borhan.delegates.liveChannel.LiveChannelRegisterMediaServerDelegate;
	import com.borhan.net.BorhanCall;

	/**
	* Register media server to live entry
	**/
	public class LiveChannelRegisterMediaServer extends BorhanCall
	{
		public var filterFields : String;
		
		/**
		* @param entryId String
		* @param hostname String
		* @param mediaServerIndex String
		* @param applicationName String
		* @param liveEntryStatus int
		**/
		public function LiveChannelRegisterMediaServer( entryId : String,hostname : String,mediaServerIndex : String,applicationName : String = null,liveEntryStatus : int=1 )
		{
			service= 'livechannel';
			action= 'registerMediaServer';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('entryId');
			valueArr.push(entryId);
			keyArr.push('hostname');
			valueArr.push(hostname);
			keyArr.push('mediaServerIndex');
			valueArr.push(mediaServerIndex);
			keyArr.push('applicationName');
			valueArr.push(applicationName);
			keyArr.push('liveEntryStatus');
			valueArr.push(liveEntryStatus);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new LiveChannelRegisterMediaServerDelegate( this , config );
		}
	}
}