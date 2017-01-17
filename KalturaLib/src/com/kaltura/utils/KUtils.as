package com.borhan.utils
{
	/**
	 * A class that contains Borhan specific functions
	 *
	 */
	public class KUtils
	{
		public static function hostFromCode(hostCode:String):String
		{
			/*if( URLUtil.isHttpURL(hostCode) ||  URLUtil.isHttpsURL(hostCode))
				return hostCode.substr( 7 );*/
				
			var hostUrl:String;
			switch (hostCode)
			{
				case "0":
					hostUrl = "kaldev.borhan.com";
				break;
				// default server is www.borhan.com
				case null:
				case "1":
					hostUrl = "www.borhan.com";
				break;

				case "2":
					hostUrl = "localhost";
				break;

				case "3":
					hostUrl = "sandbox.borhan.com";
				break;

				default: // a url
					hostUrl = hostCode;
				break;
			}
			return hostUrl;
		}
		
		
		public static function logicalAnd(exp1:Boolean, exp2:Boolean):Boolean {
			return exp1 && exp2;
		}
		
		public static function logicalOr(exp1:Boolean, exp2:Boolean):Boolean {
			return exp1 || exp2;
		}
	}
}