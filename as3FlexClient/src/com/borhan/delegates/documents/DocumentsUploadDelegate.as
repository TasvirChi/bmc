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
package com.borhan.delegates.documents
{
	import com.borhan.config.BorhanConfig;
	import com.borhan.net.BorhanCall;
	import com.borhan.delegates.WebDelegateBase;
	import com.borhan.core.KClassFactory;
	import com.borhan.errors.BorhanError;
	import com.borhan.commands.documents.DocumentsUpload;

	import ru.inspirit.net.MultipartURLLoader;
	import mx.utils.UIDUtil;

	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.FileReference;
	import flash.net.URLLoaderDataFormat;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;

	public class DocumentsUploadDelegate extends WebDelegateBase
	{
		protected var mrloader:MultipartURLLoader;

		public function DocumentsUploadDelegate(call:BorhanCall, config:BorhanConfig)
		{
			super(call, config);
		}

		override public function parse(result:XML) : *
		{
			return result.result.toString();
		}

		override protected function sendRequest():void {
			//construct the loader
			createURLLoader();
			
			//create the service request for normal calls
			var variables:String = decodeURIComponent(call.args.toString());
			var req:String = _config.protocol + _config.domain + "/" + _config.srvUrl + "/service/" + call.service + "/action/" + call.action + "?" + variables;
			if ((call as DocumentsUpload).fileData is FileReference) {
				(call as DocumentsUpload).fileData.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA,onDataComplete);
				var urlRequest:URLRequest = new URLRequest(req);
				((call as DocumentsUpload).fileData as FileReference).upload(urlRequest,"fileData");
			}
			else {
				mrloader.addFile(((call as DocumentsUpload).fileData as ByteArray), UIDUtil.createUID(), 'fileData'); 
				mrloader.dataFormat = URLLoaderDataFormat.TEXT;
				mrloader.load(req);
			}
		}

		// Event Handlers
		override protected function onDataComplete(event:Event):void {
			try {
				if ((call as DocumentsUpload).fileData is FileReference) {
					handleResult( XML(event["data"]) );
				}
				else {
					handleResult( XML(event.target.loader.data) );
 				}
			}
 			catch( e:Error ){
 				var kErr : BorhanError = new BorhanError();
 				kErr.errorCode = String(e.errorID);
 				kErr.errorMsg = e.message;
 				_call.handleError( kErr );
			}
		}

		override protected function createURLLoader():void {
			mrloader = new MultipartURLLoader();
			mrloader.addEventListener(Event.COMPLETE, onDataComplete);
		}

	}
}
