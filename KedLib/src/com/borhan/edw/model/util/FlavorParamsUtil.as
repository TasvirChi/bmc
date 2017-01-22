package com.borhan.edw.model.util
{
	import com.borhan.vo.BorhanFlavorParams;
	import com.borhan.utils.ObjectUtil;
	import com.borhan.core.KClassFactory;
	import flash.xml.XMLDocument;
	import mx.rpc.xml.SimpleXMLEncoder;
	import flash.xml.XMLNode;

	public class FlavorParamsUtil
	{
		/**
		 * validate the given object is BorhanFlavorParams.
		 * Otherwise, create new KFP and populate attributes with given object values.
		 * @param object
		 * @return 
		 */
		public static function makeFlavorParams(object:Object):BorhanFlavorParams {
			var result:BorhanFlavorParams;
			if (object is BorhanFlavorParams) {
				result = object as BorhanFlavorParams;
			}
			else {
				result = new KClassFactory(BorhanFlavorParams).newInstanceFromXML( XMLList(objectToXML(object)));
				result.originalObjectType = object.objectType; 
			}
			return result;
		}
		
		public static function makeManyFlavorParams(array:Array):Array {
			var result:Array = [];
			for each (var o:Object in array) {
				result.push(makeFlavorParams(o));
			}
			return result;
		}
		
		/**
		 * This function will convert a given object to an XML 
		 * @param obj
		 * @return 
		 */		
		public static function objectToXML(obj:Object):XML {
			var qName:QName = new QName("root");
			var xmlDocument:XMLDocument = new XMLDocument();
			var simpleXMLEncoder:SimpleXMLEncoder = new SimpleXMLEncoder(xmlDocument);
			var xmlNode:XMLNode = simpleXMLEncoder.encodeValue(obj, qName, xmlDocument);
			var xml:XML = new XML(xmlDocument.toString());
			return xml;
		}
	}
}