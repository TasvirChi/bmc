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
package com.borhan.commands.scheduledTaskProfile
{
		import com.borhan.vo.BorhanScheduledTaskProfile;
	import com.borhan.delegates.scheduledTaskProfile.ScheduledTaskProfileUpdateDelegate;
	import com.borhan.net.BorhanCall;

	/**
	* Update an existing scheduled task profile
	**/
	public class ScheduledTaskProfileUpdate extends BorhanCall
	{
		public var filterFields : String;
		
		/**
		* @param id int
		* @param scheduledTaskProfile BorhanScheduledTaskProfile
		**/
		public function ScheduledTaskProfileUpdate( id : int,scheduledTaskProfile : BorhanScheduledTaskProfile )
		{
			service= 'scheduledtask_scheduledtaskprofile';
			action= 'update';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('id');
			valueArr.push(id);
				keyValArr = borhanObject2Arrays(scheduledTaskProfile, 'scheduledTaskProfile');
				keyArr = keyArr.concat(keyValArr[0]);
				valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new ScheduledTaskProfileUpdateDelegate( this , config );
		}
	}
}
