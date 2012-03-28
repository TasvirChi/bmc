package com.kaltura.edw.components.fltr
{
	import com.kaltura.edw.components.fltr.indicators.IndicatorVo;
	import com.kaltura.edw.components.fltr.indicators.Indicators;
	import com.kaltura.edw.components.fltr.indicators.IndicatorsEvent;
	import com.kaltura.edw.model.FilterModel;
	import com.kaltura.types.KalturaSearchOperatorType;
	import com.kaltura.utils.ObjectUtil;
	import com.kaltura.vo.KalturaContentDistributionSearchItem;
	import com.kaltura.vo.KalturaFilter;
	import com.kaltura.vo.KalturaMetadataSearchItem;
	import com.kaltura.vo.KalturaSearchItem;
	import com.kaltura.vo.KalturaSearchOperator;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.containers.VBox;
	import mx.core.Container;
	
	[ResourceBundle("filter")]
	
	/**
	 * dispatched when the contents of the filter have changed 
	 */	
	[Event(name="filterChanged", type="flash.events.Event")]
	
	
	/**
	 * Base class for Filter classes 
	 * @author Atar
	 * 
	 */
	public class BaseFilter extends VBox {
		
		/**
		 * @internal
		 * public because used in different panels
		 * */
		public static const DATE_FIELD_WIDTH:Number = 80;
		
		/**
		 * set new value on the changed panel's attribute 
		 * @param event	change event of an IFilterComponent
		 * 
		 */
		protected function updateFilterValue(event:FilterComponentEvent):void {
			
			// update KalturaFilter relevant values
			if (event.target is IMultiAttributeFilterComponent) {
				var atts:Array = (event.target as IMultiAttributeFilterComponent).attributes;
				var fltrs:Array = (event.target as IMultiAttributeFilterComponent).kfilters;
				for (var i:int = 0; i<atts.length; i++) {
					_kalturaFilter[atts[i]] = fltrs[i];
				}
			}
			else if (event.target is IAdvancedSearchFilterComponent) {
				handelAdvancedSearchComponent((event.target as IAdvancedSearchFilterComponent).filter as KalturaSearchItem,
					(event.target as IAdvancedSearchFilterComponent).attribute);
			}
			else if (event.target is IFilterComponent) {
				var tgt:IFilterComponent = event.target as IFilterComponent;
				_kalturaFilter[tgt.attribute] = tgt.filter;
			}
			
			// show correct indicators
			updateIndicators(event.kind, event.data);
			
			// tell the world
			dispatchEvent(new Event("filterChanged"));
		}
		
		
		/**
		 * add / remove indicator vo to reflect current filtering status
		 * @param action	add / remove / remove all
		 * @param item		the item to act upon
		 */
		protected function updateIndicators(action:String, item:IndicatorVo):void {
			var i:int;
			var ivo:IndicatorVo;
			switch (action) {
				case FilterComponentEvent.EVENT_KIND_UPDATE:
					// add if not found
					for (i = 0; i<indicators.length; i++) {
						ivo = indicators.getItemAt(i) as IndicatorVo;
						if (ivo.attribute == item.attribute) {
							if (ivo.value == item.value) {
								// if found, replace 
								indicators.removeItemAt(i);
								break;
							}
						}
					}
					// if not found, i == indicators.length
					indicators.addItemAt(item, i);
					break;
				
				case FilterComponentEvent.EVENT_KIND_ADD:
					indicators.addItem(item);
					break;
				
				case FilterComponentEvent.EVENT_KIND_REMOVE:
					for (i = 0; i<indicators.length; i++) {
						ivo = indicators.getItemAt(i) as IndicatorVo;
						if (ivo.attribute == item.attribute) {
							if (ivo.value == item.value) {
								indicators.removeItemAt(i);
								break;
							}
						}
					}
					break;
				
				case FilterComponentEvent.EVENT_KIND_REMOVE_ALL:
					for (i = indicators.length-1; i >= 0; i--) {
						ivo = indicators.getItemAt(i) as IndicatorVo;
						if (ivo.attribute == item.attribute) {
							indicators.removeItemAt(i);
						}
					}
					break;
			}
		}
		 
		
		/**
		 * remove relevant searchItem according to filterType, then add the given one 
		 * @param searchItem	search item to add to filter
		 * @param filterType	search item identifier
		 */
		protected function handelAdvancedSearchComponent(searchItem:KalturaSearchItem, filterId:String):void {
			// create advanced search item if required:
			if (!_kalturaFilter.advancedSearch) {
				_kalturaFilter.advancedSearch = new KalturaSearchOperator();
				(_kalturaFilter.advancedSearch as KalturaSearchOperator).type = KalturaSearchOperatorType.SEARCH_AND;
				(_kalturaFilter.advancedSearch as KalturaSearchOperator).items = [];
			}
			var items:Array = (_kalturaFilter.advancedSearch as KalturaSearchOperator).items;
			var i:int;
			// if distribution filter:
			if (filterId == "distributionProfiles") {
				// find the distribtion search item and remove it.
				// there is only one distribution item, and we recognise it by the contents of its items.
				for (i = 0; i<items.length; i++) {
					var ksi:KalturaSearchOperator = items[i] as KalturaSearchOperator; 
					if (ksi) { // SearchItems which are not SearchOpreators will fall here
						if (ksi.items && ksi.items[0] is KalturaContentDistributionSearchItem) {
							(_kalturaFilter.advancedSearch as KalturaSearchOperator).items.splice(i, 1);
							break;
						}
					} 
				} 
			}
			else {
				// otherwise, metadataProfiles:
				// remove search item for this profile if exists.
				// there is only one item which matches the profile (filterType is profile id).
				for (i = 0; i<items.length; i++) {
					var msi:KalturaMetadataSearchItem = items[i] as KalturaMetadataSearchItem; 
					if (msi) { // SearchItems which are not KalturaMetadataSearchItem will fall here
						if (msi.metadataProfileId.toString() == filterId) {
							(_kalturaFilter.advancedSearch as KalturaSearchOperator).items.splice(i, 1);
							break;
						}
					} 
				}
			}
			
			// add new 
			if (searchItem) {
				(_kalturaFilter.advancedSearch as KalturaSearchOperator).items.push(searchItem);	
			}
		}
		
		// --------------------
		// free text search
		// --------------------
		
		private var _freeTextSearch:IFilterComponent;

		public function get freeTextSearch():IFilterComponent {
			return _freeTextSearch;
		}

		public function set freeTextSearch(value:IFilterComponent):void {
			_freeTextSearch = value;
			_freeTextSearch.addEventListener(FilterComponentEvent.VALUE_CHANGE, updateFilterValue, false, 0, true);
		}
		
		
		
		// --------------------
		// additional filters
		// --------------------
		
		/**
		 * @copy #additionalFiltersIds 
		 */		
		protected var _additionalFiltersIds:String;

		
		public function get additionalFiltersIds():String {
			return _additionalFiltersIds;
		}

		/**
		 * list of additional filters to show.
		 * if null, all available panels will be shown.
		 */		
		public function set additionalFiltersIds(value:String):void {
			_additionalFiltersIds = value;
		}
		
		
		// --------------------
		// filter indicators
		// --------------------
		

		[Bindable]
		/**
		 * list of vos with data relevant to showing current filtering status.
		 * <code>IndicatorVo</code> objects
		 */
		public var indicators:ArrayCollection = new ArrayCollection();

		
		/**
		 * remove a filter by its representing vo 
		 * @param vo	representation vo
		 * 
		 */
		public function removeFilter(item:IndicatorVo):void {
			// remove from indicators list
			for (var i:int = 0; i<indicators.length; i++) {
				if (indicators.getItemAt(i) == item) {
					indicators.removeItemAt(i);
					break;
				}
			}
			// let filter component remove the relevant attribute
			var comp:IFilterComponent;
			if (_freeTextSearch && _freeTextSearch.attribute == item.attribute) {
				comp = _freeTextSearch;
			}
			else {
				comp = getComponentByAttribute(item.attribute, this);
			}
			comp.removeItem(item);
		}
		
		/**
		 * retreive a filter component that matches a given attribute  
		 * @param attribute	
		 * @param container
		 * @return filter component whose attribute is the same as the given
		 */
		protected function getComponentByAttribute(attribute:String, container:Container):IFilterComponent {
			if (isIt(attribute, container)) {
				return container as IFilterComponent;
			}
			
			var child:DisplayObject;
			var fc:IFilterComponent;
			// scan all direct children
			for (var i:int = 0; i<container.numChildren; i++) {
				child = container.getChildAt(i);
				if (isIt(attribute, child)) {
					return child as IFilterComponent;
				}
				if (child is Container) {
					fc = getComponentByAttribute(attribute, child as Container);
					if (fc) {
						return fc;
					}
				}
			}
			// not found in this container, return null
			return null;
		}
		
		/**
		 * is the given DisplayObject a IFilterComponent whose attribute matches the given one 
		 * @param attribute
		 * @param child
		 * @return true if it is 
		 */
		private function isIt(attribute:String, child:DisplayObject):Boolean {
			if (child is IFilterComponent) {
				if ((child as IFilterComponent).attribute == attribute) {
					return true;
				}
				else if (child is IMultiAttributeFilterComponent) {
					// the vos generated by these hold all attributes concatenated.
					var at:String = (child as IMultiAttributeFilterComponent).attributes.join ("~~");
					if (at == attribute) {
						return true;						
					}
				}
			}
			return false;
		}
		
		// --------------------
		// model
		// --------------------
		
		/**
		 * @copy #filterModel 
		 */		
		protected var _filterModel:FilterModel;

		
		public function get filterModel():FilterModel {
			return _filterModel;
		}

		[Bindable]
		/**
		 * the model on which to store API calls results for reuse 
		 * (possibly by other parts of the application)
		 */		
		public function set filterModel(value:FilterModel):void {
			_filterModel = value;
		}
		
		
		// --------------------
		// KalturaFilter VO
		// --------------------
		/**
		 * @copy #kalturaFilter 
		 */		
		protected var _kalturaFilter:KalturaFilter;
		
		public function get kalturaFilter():KalturaFilter {
			return _kalturaFilter;
		}
		
		[Bindable]
		/**
		 * the Kaltura API filter object being manipulated by this component 
		 */		
		public function set kalturaFilter(value:KalturaFilter):void {
			_kalturaFilter = value;
			indicators = new ArrayCollection();
			setFilterValuesToComponents();
		}
		
		protected function setFilterValuesToComponents():void {
			var comp:IFilterComponent;
			var att:String;
			var keys:Array = ObjectUtil.getObjectAllKeys(_kalturaFilter);
			for (var i:int = 0; i<keys.length; i++) {
				att = keys[i];
				if (_kalturaFilter[att] && _kalturaFilter[att] != int.MIN_VALUE) { // default value for strings is null, numbers int.MIN_VALUE
					comp = getComponentByAttribute(att, this);
					if (comp) {
						comp.filter = _kalturaFilter[att];
					}
					else {
						if (_freeTextSearch && att == _freeTextSearch.attribute) {
							_freeTextSearch.filter = _kalturaFilter[att];
						}
					}
				}
			}
		}
	}
}