package com.borhan.edw.vo
{
	import com.borhan.vo.BorhanConversionProfile;
	
	import mx.collections.ArrayCollection;

	[Bindable]
	/**
	 * Couples <code>BorhanConversionProfile</code> with its 
	 * <code>BorhanConversionProfileAssetParams</code>.
	 * @author Atar
	 */
	public class ConversionProfileWithFlavorParamsVo {
		
		/**
		 * Conversion Profile 
		 */
		public var profile:BorhanConversionProfile;
		
		[ArrayElementType("com.borhan.vo.BorhanConversionProfileAssetParams")]
		/**
		 * all flavor params objects whos ids are associated with this profile.
		 * <code>BorhanConversionProfileAssetParams</code> objects 
		 */		
		public var flavors:ArrayCollection;
		
		public function ConversionProfileWithFlavorParamsVo(){
			flavors = new ArrayCollection();
		}
		
	}
}