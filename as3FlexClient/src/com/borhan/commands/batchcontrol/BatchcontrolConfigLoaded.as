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
package com.borhan.commands.batchcontrol
{
		import com.borhan.vo.BorhanScheduler;
	import com.borhan.delegates.batchcontrol.BatchcontrolConfigLoadedDelegate;
	import com.borhan.net.BorhanCall;

	/**
	* batch configLoaded action saves the configuration as loaded by a remote scheduler
	**/
	public class BatchcontrolConfigLoaded extends BorhanCall
	{
		public var filterFields : String;
		
		/**
		* @param scheduler BorhanScheduler
		* @param configParam String
		* @param configValue String
		* @param configParamPart String
		* @param workerConfigId int
		* @param workerName String
		**/
		public function BatchcontrolConfigLoaded( scheduler : BorhanScheduler,configParam : String,configValue : String,configParamPart : String = null,workerConfigId : int=int.MIN_VALUE,workerName : String = null )
		{
			service= 'batchcontrol';
			action= 'configLoaded';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
				keyValArr = borhanObject2Arrays(scheduler, 'scheduler');
				keyArr = keyArr.concat(keyValArr[0]);
				valueArr = valueArr.concat(keyValArr[1]);
			keyArr.push('configParam');
			valueArr.push(configParam);
			keyArr.push('configValue');
			valueArr.push(configValue);
			keyArr.push('configParamPart');
			valueArr.push(configParamPart);
			keyArr.push('workerConfigId');
			valueArr.push(workerConfigId);
			keyArr.push('workerName');
			valueArr.push(workerName);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new BatchcontrolConfigLoadedDelegate( this , config );
		}
	}
}
