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
package com.borhan.vo
{
	import com.borhan.vo.BorhanEventNotificationDispatchJobData;

	[Bindable]
	public dynamic class BorhanHttpNotificationDispatchJobData extends BorhanEventNotificationDispatchJobData
	{
		/**
		* Remote server URL
		**/
		public var url : String = null;

		/**
		* Request method.
		* @see com.borhan.types.BorhanHttpNotificationMethod
		**/
		public var method : int = int.MIN_VALUE;

		/**
		* Data to send.
		**/
		public var data : String = null;

		/**
		* The maximum number of seconds to allow cURL functions to execute.
		**/
		public var timeout : int = int.MIN_VALUE;

		/**
		* The number of seconds to wait while trying to connect.
		* Must be larger than zero.
		**/
		public var connectTimeout : int = int.MIN_VALUE;

		/**
		* A username to use for the connection.
		**/
		public var username : String = null;

		/**
		* A password to use for the connection.
		**/
		public var password : String = null;

		/**
		* The HTTP authentication method to use.
		* @see com.borhan.types.BorhanHttpNotificationAuthenticationMethod
		**/
		public var authenticationMethod : int = int.MIN_VALUE;

		/**
		* The SSL version (2 or 3) to use.
		* By default PHP will try to determine this itself, although in some cases this must be set manually.
		* @see com.borhan.types.BorhanHttpNotificationSslVersion
		**/
		public var sslVersion : int = int.MIN_VALUE;

		/**
		* SSL certificate to verify the peer with.
		**/
		public var sslCertificate : String = null;

		/**
		* The format of the certificate.
		* @see com.borhan.types.BorhanHttpNotificationCertificateType
		**/
		public var sslCertificateType : String = null;

		/**
		* The password required to use the certificate.
		**/
		public var sslCertificatePassword : String = null;

		/**
		* The identifier for the crypto engine of the private SSL key specified in ssl key.
		**/
		public var sslEngine : String = null;

		/**
		* The identifier for the crypto engine used for asymmetric crypto operations.
		**/
		public var sslEngineDefault : String = null;

		/**
		* The key type of the private SSL key specified in ssl key - PEM / DER / ENG.
		* @see com.borhan.types.BorhanHttpNotificationSslKeyType
		**/
		public var sslKeyType : String = null;

		/**
		* Private SSL key.
		**/
		public var sslKey : String = null;

		/**
		* The secret password needed to use the private SSL key specified in ssl key.
		**/
		public var sslKeyPassword : String = null;

		/**
		* Adds a e-mail custom header
		**/
		public var customHeaders : Array = null;

		/**
		* The secret to sign the notification with
		**/
		public var signSecret : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('url');
			arr.push('method');
			arr.push('data');
			arr.push('timeout');
			arr.push('connectTimeout');
			arr.push('username');
			arr.push('password');
			arr.push('authenticationMethod');
			arr.push('sslVersion');
			arr.push('sslCertificate');
			arr.push('sslCertificateType');
			arr.push('sslCertificatePassword');
			arr.push('sslEngine');
			arr.push('sslEngineDefault');
			arr.push('sslKeyType');
			arr.push('sslKey');
			arr.push('sslKeyPassword');
			arr.push('customHeaders');
			arr.push('signSecret');
			return arr;
		}

		override public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = super.getInsertableParamKeys();
			return arr;
		}

		override public function getElementType(arrayName:String):String
		{
			var result:String = '';
			switch (arrayName) {
				case 'customHeaders':
					result = 'BorhanKeyValue';
					break;
				default:
					result = super.getElementType(arrayName);
					break;
			}
			return result;
		}
	}
}
