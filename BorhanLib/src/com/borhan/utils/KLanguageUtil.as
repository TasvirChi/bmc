package com.borhan.utils {
	import com.borhan.dataStructures.HashMap;
	import com.borhan.types.BorhanLanguage;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceBundle;
	import mx.resources.ResourceManager;

	/**
	 * Singleton class
	 * This util class handles all issues related to Languages UI - including the locales for all countries
	 */
	public class KLanguageUtil {
		[ResourceBundle("languages")]
		private static var rb:ResourceBundle;

		/**
		 * Singleton instance
		 */
		private static var _instance:KLanguageUtil = null;

		/**
		 * language.code => language Object
		 * language.value => language Object
		 * (for easy access)
		 */
		private var _languagesMap:HashMap = new HashMap();

		/**
		 * {label: localized language name, code: upper-case language code, value:BorhanLanguage.<code>}
		 */
		private var _languagesArr:ArrayCollection = new ArrayCollection();


		/**
		 * C'tor
		 */
		public function KLanguageUtil(enforcer:Enforcer) {
			initLanguagesArr();
			initlanguagesMap();
		}


		public static function get instance():KLanguageUtil {
			if (_instance == null) {
				_instance = new KLanguageUtil(new Enforcer());
			}

			return _instance;
		}


		/***
		 * Get the list of all languages
		 */
		public function get languagesArr():ArrayCollection {
			return _languagesArr;
		}


		/**
		 * This function is used to get the language object
		 * The object is with fields : code, label and index
		 * code - language code
		 * label - language label in the active locale
		 * index - the index of the language in the languages array collection
		 * @param code - language code
		 * @return langauge object
		 */
		public function getLanguageByCode(code:String):Object {
			var lang:Object = _languagesMap.getValue(code.toUpperCase());
			return lang;
		}


		private function initLanguagesArr():void {
			var rm:IResourceManager = ResourceManager.getInstance();
			var tmp:Array = [
				{label: rm.getString('languages', 'AA'), code: "AA", value:BorhanLanguage.AA},
				{label: rm.getString('languages', 'AB'), code: "AB", value:BorhanLanguage.AB},
				{label: rm.getString('languages', 'AF'), code: "AF", value:BorhanLanguage.AF},
				{label: rm.getString('languages', 'AM'), code: "AM", value:BorhanLanguage.AM},
				{label: rm.getString('languages', 'AR'), code: "AR", value:BorhanLanguage.AR},
				{label: rm.getString('languages', 'AS'), code: "AS", value:BorhanLanguage.AS_},
				{label: rm.getString('languages', 'AY'), code: "AY", value:BorhanLanguage.AY},
				{label: rm.getString('languages', 'AZ'), code: "AZ", value:BorhanLanguage.AZ},
				{label: rm.getString('languages', 'BA'), code: "BA", value:BorhanLanguage.BA},
				{label: rm.getString('languages', 'BE'), code: "BE", value:BorhanLanguage.BE},
				{label: rm.getString('languages', 'BG'), code: "BG", value:BorhanLanguage.BG},
				{label: rm.getString('languages', 'BH'), code: "BH", value:BorhanLanguage.BH},
				{label: rm.getString('languages', 'BI'), code: "BI", value:BorhanLanguage.BI},
				{label: rm.getString('languages', 'BN'), code: "BN", value:BorhanLanguage.BN},
				{label: rm.getString('languages', 'BO'), code: "BO", value:BorhanLanguage.BO},
				{label: rm.getString('languages', 'BR'), code: "BR", value:BorhanLanguage.BR},
				{label: rm.getString('languages', 'CA'), code: "CA", value:BorhanLanguage.CA},
				{label: rm.getString('languages', 'CO'), code: "CO", value:BorhanLanguage.CO},
				{label: rm.getString('languages', 'CS'), code: "CS", value:BorhanLanguage.CS},
				{label: rm.getString('languages', 'CY'), code: "CY", value:BorhanLanguage.CY},
				{label: rm.getString('languages', 'DA'), code: "DA", value:BorhanLanguage.DA},
				{label: rm.getString('languages', 'DE'), code: "DE", value:BorhanLanguage.DE},
				{label: rm.getString('languages', 'DZ'), code: "DZ", value:BorhanLanguage.DZ},
				{label: rm.getString('languages', 'EL'), code: "EL", value:BorhanLanguage.EL},
//				{label: rm.getString('languages', 'EN'), code: "EN", value:BorhanLanguage.EN},
				{label: rm.getString('languages', 'EN_GB'), code: "EN_GB", value:BorhanLanguage.EN_GB},
				{label: rm.getString('languages', 'EN_US'), code: "EN_US", value:BorhanLanguage.EN_US},
				{label: rm.getString('languages', 'EO'), code: "EO", value:BorhanLanguage.EO},
				{label: rm.getString('languages', 'ES'), code: "ES", value:BorhanLanguage.ES},
				{label: rm.getString('languages', 'ET'), code: "ET", value:BorhanLanguage.ET},
				{label: rm.getString('languages', 'EU'), code: "EU", value:BorhanLanguage.EU},
				{label: rm.getString('languages', 'FA'), code: "FA", value:BorhanLanguage.FA},
				{label: rm.getString('languages', 'FI'), code: "FI", value:BorhanLanguage.FI},
				{label: rm.getString('languages', 'FJ'), code: "FJ", value:BorhanLanguage.FJ},
				{label: rm.getString('languages', 'FO'), code: "FO", value:BorhanLanguage.FO},
				{label: rm.getString('languages', 'FR'), code: "FR", value:BorhanLanguage.FR},
				{label: rm.getString('languages', 'FY'), code: "FY", value:BorhanLanguage.FY},
				{label: rm.getString('languages', 'GA'), code: "GA", value:BorhanLanguage.GA},
				{label: rm.getString('languages', 'GD'), code: "GD", value:BorhanLanguage.GD},
				{label: rm.getString('languages', 'GL'), code: "GL", value:BorhanLanguage.GL},
				{label: rm.getString('languages', 'GN'), code: "GN", value:BorhanLanguage.GN},
				{label: rm.getString('languages', 'GU'), code: "GU", value:BorhanLanguage.GU},
				{label: rm.getString('languages', 'HA'), code: "HA", value:BorhanLanguage.HA},
				{label: rm.getString('languages', 'HI'), code: "HI", value:BorhanLanguage.HI},
				{label: rm.getString('languages', 'HR'), code: "HR", value:BorhanLanguage.HR},
				{label: rm.getString('languages', 'HU'), code: "HU", value:BorhanLanguage.HU},
				{label: rm.getString('languages', 'HY'), code: "HY", value:BorhanLanguage.HY},
				{label: rm.getString('languages', 'IA'), code: "IA", value:BorhanLanguage.IA},
				{label: rm.getString('languages', 'IE'), code: "IE", value:BorhanLanguage.IE},
				{label: rm.getString('languages', 'IK'), code: "IK", value:BorhanLanguage.IK},
				{label: rm.getString('languages', 'IN'), code: "IN", value:BorhanLanguage.IN},
				{label: rm.getString('languages', 'IS'), code: "IS", value:BorhanLanguage.IS},
				{label: rm.getString('languages', 'IT'), code: "IT", value:BorhanLanguage.IT},
				{label: rm.getString('languages', 'IW'), code: "IW", value:BorhanLanguage.IW},
				{label: rm.getString('languages', 'JA'), code: "JA", value:BorhanLanguage.JA},
				{label: rm.getString('languages', 'JI'), code: "JI", value:BorhanLanguage.JI},
				{label: rm.getString('languages', 'JW'), code: "JW", value:BorhanLanguage.JV},
				{label: rm.getString('languages', 'KA'), code: "KA", value:BorhanLanguage.KA},
				{label: rm.getString('languages', 'KK'), code: "KK", value:BorhanLanguage.KK},
				{label: rm.getString('languages', 'KL'), code: "KL", value:BorhanLanguage.KL},
				{label: rm.getString('languages', 'KM'), code: "KM", value:BorhanLanguage.KM},
				{label: rm.getString('languages', 'KN'), code: "KN", value:BorhanLanguage.KN},
				{label: rm.getString('languages', 'KO'), code: "KO", value:BorhanLanguage.KO},
				{label: rm.getString('languages', 'KS'), code: "KS", value:BorhanLanguage.KS},
				{label: rm.getString('languages', 'KU'), code: "KU", value:BorhanLanguage.KU},
				{label: rm.getString('languages', 'KY'), code: "KY", value:BorhanLanguage.KY},
				{label: rm.getString('languages', 'LA'), code: "LA", value:BorhanLanguage.LA},
				{label: rm.getString('languages', 'LN'), code: "LN", value:BorhanLanguage.LN},
				{label: rm.getString('languages', 'LO'), code: "LO", value:BorhanLanguage.LO},
				{label: rm.getString('languages', 'LT'), code: "LT", value:BorhanLanguage.LT},
				{label: rm.getString('languages', 'LV'), code: "LV", value:BorhanLanguage.LV},
				{label: rm.getString('languages', 'MG'), code: "MG", value:BorhanLanguage.MG},
				{label: rm.getString('languages', 'MI'), code: "MI", value:BorhanLanguage.MI},
				{label: rm.getString('languages', 'MK'), code: "MK", value:BorhanLanguage.MK},
				{label: rm.getString('languages', 'ML'), code: "ML", value:BorhanLanguage.ML},
				{label: rm.getString('languages', 'MN'), code: "MN", value:BorhanLanguage.MN},
				{label: rm.getString('languages', 'MU'), code: "MU", value:BorhanLanguage.MU},
				{label: rm.getString('languages', 'MO'), code: "MO", value:BorhanLanguage.MO},
				{label: rm.getString('languages', 'MR'), code: "MR", value:BorhanLanguage.MR},
				{label: rm.getString('languages', 'MS'), code: "MS", value:BorhanLanguage.MS},
				{label: rm.getString('languages', 'MT'), code: "MT", value:BorhanLanguage.MT},
				{label: rm.getString('languages', 'MY'), code: "MY", value:BorhanLanguage.MY},
				{label: rm.getString('languages', 'NA'), code: "NA", value:BorhanLanguage.NA},
				{label: rm.getString('languages', 'NE'), code: "NE", value:BorhanLanguage.NE},
				{label: rm.getString('languages', 'NL'), code: "NL", value:BorhanLanguage.NL},
				{label: rm.getString('languages', 'NO'), code: "NO", value:BorhanLanguage.NO},
				{label: rm.getString('languages', 'OC'), code: "OC", value:BorhanLanguage.OC},
				{label: rm.getString('languages', 'OM'), code: "OM", value:BorhanLanguage.OM},
				{label: rm.getString('languages', 'OR'), code: "OR", value:BorhanLanguage.OR_},
				{label: rm.getString('languages', 'PA'), code: "PA", value:BorhanLanguage.PA},
				{label: rm.getString('languages', 'PL'), code: "PL", value:BorhanLanguage.PL},
				{label: rm.getString('languages', 'PS'), code: "PS", value:BorhanLanguage.PS},
				{label: rm.getString('languages', 'PT'), code: "PT", value:BorhanLanguage.PT},
				{label: rm.getString('languages', 'QU'), code: "QU", value:BorhanLanguage.QU},
				{label: rm.getString('languages', 'RM'), code: "RM", value:BorhanLanguage.RM},
				{label: rm.getString('languages', 'RN'), code: "RN", value:BorhanLanguage.RN},
				{label: rm.getString('languages', 'RO'), code: "RO", value:BorhanLanguage.RO},
				{label: rm.getString('languages', 'RU'), code: "RU", value:BorhanLanguage.RU},
				{label: rm.getString('languages', 'RW'), code: "RW", value:BorhanLanguage.RW},
				{label: rm.getString('languages', 'SA'), code: "SA", value:BorhanLanguage.SA},
				{label: rm.getString('languages', 'SD'), code: "SD", value:BorhanLanguage.SD},
				{label: rm.getString('languages', 'SG'), code: "SG", value:BorhanLanguage.SG},
				{label: rm.getString('languages', 'SH'), code: "SH", value:BorhanLanguage.SH},
				{label: rm.getString('languages', 'SI'), code: "SI", value:BorhanLanguage.SI},
				{label: rm.getString('languages', 'SK'), code: "SK", value:BorhanLanguage.SK},
				{label: rm.getString('languages', 'SL'), code: "SL", value:BorhanLanguage.SL},
				{label: rm.getString('languages', 'SM'), code: "SM", value:BorhanLanguage.SM},
				{label: rm.getString('languages', 'SN'), code: "SN", value:BorhanLanguage.SN},
				{label: rm.getString('languages', 'SO'), code: "SO", value:BorhanLanguage.SO},
				{label: rm.getString('languages', 'SQ'), code: "SQ", value:BorhanLanguage.SQ},
				{label: rm.getString('languages', 'SR'), code: "SR", value:BorhanLanguage.SR},
				{label: rm.getString('languages', 'SS'), code: "SS", value:BorhanLanguage.SS},
				{label: rm.getString('languages', 'ST'), code: "ST", value:BorhanLanguage.ST},
				{label: rm.getString('languages', 'SU'), code: "SU", value:BorhanLanguage.SU},
				{label: rm.getString('languages', 'SV'), code: "SV", value:BorhanLanguage.SV},
				{label: rm.getString('languages', 'SW'), code: "SW", value:BorhanLanguage.SW},
				{label: rm.getString('languages', 'TA'), code: "TA", value:BorhanLanguage.TA},
				{label: rm.getString('languages', 'TE'), code: "TE", value:BorhanLanguage.TE},
				{label: rm.getString('languages', 'TG'), code: "TG", value:BorhanLanguage.TG},
				{label: rm.getString('languages', 'TH'), code: "TH", value:BorhanLanguage.TH},
				{label: rm.getString('languages', 'TI'), code: "TI", value:BorhanLanguage.TI},
				{label: rm.getString('languages', 'TK'), code: "TK", value:BorhanLanguage.TK},
				{label: rm.getString('languages', 'TL'), code: "TL", value:BorhanLanguage.TL},
				{label: rm.getString('languages', 'TN'), code: "TN", value:BorhanLanguage.TN},
				{label: rm.getString('languages', 'TO'), code: "TO", value:BorhanLanguage.TO},
				{label: rm.getString('languages', 'TR'), code: "TR", value:BorhanLanguage.TR},
				{label: rm.getString('languages', 'TS'), code: "TS", value:BorhanLanguage.TS},
				{label: rm.getString('languages', 'TT'), code: "TT", value:BorhanLanguage.TT},
				{label: rm.getString('languages', 'TW'), code: "TW", value:BorhanLanguage.TW},
				{label: rm.getString('languages', 'UK'), code: "UK", value:BorhanLanguage.UK},
				{label: rm.getString('languages', 'UR'), code: "UR", value:BorhanLanguage.UR},
				{label: rm.getString('languages', 'UZ'), code: "UZ", value:BorhanLanguage.UZ},
				{label: rm.getString('languages', 'VI'), code: "VI", value:BorhanLanguage.VI},
				{label: rm.getString('languages', 'VO'), code: "VO", value:BorhanLanguage.VO},
				{label: rm.getString('languages', 'WO'), code: "WO", value:BorhanLanguage.WO},
				{label: rm.getString('languages', 'XH'), code: "XH", value:BorhanLanguage.XH},
				{label: rm.getString('languages', 'YO'), code: "YO", value:BorhanLanguage.YO},
				{label: rm.getString('languages', 'ZH'), code: "ZH", value:BorhanLanguage.ZH},
				{label: rm.getString('languages', 'ZU'), code: "ZU", value:BorhanLanguage.ZU}
			];
			tmp.sortOn('label');
			// put english first
			tmp.unshift({label: rm.getString('languages', 'EN'), code: "EN", value:BorhanLanguage.EN});
			_languagesArr = new ArrayCollection(tmp);
		}


		/**
		 * for each language, keep in hashmap both by name (BorhanLanguage) and code 
		 */
		private function initlanguagesMap():void {
			var index:int = 0;
			for each (var lang:Object in _languagesArr) {
				lang.index = index;
				_languagesMap.put(lang.code, lang);
				_languagesMap.put(lang.value.toUpperCase(), lang);
				index++;
			}
		}


//		public static const GV : String = 'Gaelic (Manx)';
//		public static const HE : String = 'Hebrew';
//		public static const ID : String = 'Indonesian';
//		public static const IU : String = 'Inuktitut';
//		public static const LI : String = 'Limburgish ( Limburger)';
//		public static const UG : String = 'Uighur';
//		public static const YI : String = 'Yiddish';


	}
}

class Enforcer {

}
