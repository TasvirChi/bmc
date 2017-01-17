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
package com.borhan.commands.filesyncImportBatch
{
		import com.borhan.vo.BorhanFileSyncFilter;
	import com.borhan.delegates.filesyncImportBatch.FilesyncImportBatchLockPendingFileSyncsDelegate;
	import com.borhan.net.BorhanCall;

	/**
	* batch lockPendingFileSyncs action locks file syncs for import by the file sync periodic worker
	**/
	public class FilesyncImportBatchLockPendingFileSyncs extends BorhanCall
	{
		public var filterFields : String;
		
		/**
		* @param filter BorhanFileSyncFilter
		* @param workerId int
		* @param sourceDc int
		* @param maxCount int
		* @param maxSize int
		**/
		public function FilesyncImportBatchLockPendingFileSyncs( filter : BorhanFileSyncFilter,workerId : int,sourceDc : int,maxCount : int,maxSize : int=int.MIN_VALUE )
		{
			service= 'multicenters_filesyncimportbatch';
			action= 'lockPendingFileSyncs';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
				keyValArr = borhanObject2Arrays(filter, 'filter');
				keyArr = keyArr.concat(keyValArr[0]);
				valueArr = valueArr.concat(keyValArr[1]);
			keyArr.push('workerId');
			valueArr.push(workerId);
			keyArr.push('sourceDc');
			valueArr.push(sourceDc);
			keyArr.push('maxCount');
			valueArr.push(maxCount);
			keyArr.push('maxSize');
			valueArr.push(maxSize);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new FilesyncImportBatchLockPendingFileSyncsDelegate( this , config );
		}
	}
}
