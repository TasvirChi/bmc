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
package com.borhan.commands.scheduleEvent
{
		import flash.net.FileReference;
		import com.borhan.net.BorhanFileCall;
		import com.borhan.vo.BorhanBulkUploadICalJobData;
	import com.borhan.delegates.scheduleEvent.ScheduleEventAddFromBulkUploadDelegate;

	/**
	* Add new bulk upload batch job
	**/
	public class ScheduleEventAddFromBulkUpload extends BorhanFileCall
	{
		public var fileData:Object;

		
		/**
		* @param fileData Object - FileReference or ByteArray
		* @param bulkUploadData BorhanBulkUploadICalJobData
		**/
		public function ScheduleEventAddFromBulkUpload( fileData : Object,bulkUploadData : BorhanBulkUploadICalJobData=null )
		{
			service= 'schedule_scheduleevent';
			action= 'addFromBulkUpload';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			this.fileData = fileData;
			if (bulkUploadData) { 
				keyValArr = borhanObject2Arrays(bulkUploadData, 'bulkUploadData');
				keyArr = keyArr.concat(keyValArr[0]);
				valueArr = valueArr.concat(keyValArr[1]);
			} 
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new ScheduleEventAddFromBulkUploadDelegate( this , config );
		}
	}
}