package com.borhan.edw.components.fltr.panels
{
	import com.borhan.base.types.MetadataCustomFieldTypes;
	import com.borhan.edw.components.fltr.FilterComponentEvent;
	import com.borhan.edw.components.fltr.IAdvancedSearchFilterComponent;
	import com.borhan.types.BorhanSearchOperatorType;
	import com.borhan.vo.BorhanMetadataSearchItem;
	import com.borhan.vo.BorhanSearchCondition;
	import com.borhan.vo.MetadataFieldVO;
	
	import flash.events.Event;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	
	public class MetadataProfileFilter extends AdditionalFilter implements IAdvancedSearchFilterComponent {
		
		public function MetadataProfileFilter(){
			BindingUtils.bindSetter(www, this, "width");
		} 
		private function www(value:Number):void {
			
			for (var i:int = 0; i<numChildren; i++) {
				getChildAt(i).width = value - getStyle("paddingLeft") - getStyle("paddingRight");
			}
		} 
		
		/**
		 * filter is BorhanMetadataSearchItem whose items are BorhanMetadataSearchItems
		 */
		override public function set filter(value:Object):void {
			// scan filter items (fields)
			for each (var msi:BorhanMetadataSearchItem in value.items) {
				// for each field, find a matching filter and set it.
				for (var i:int = 0; i<numChildren; i++) {
					// MetadataFilter.data is the field MFVO 
					var child:MetadataFilter = getChildAt(i) as MetadataFilter;
					var mfvo:MetadataFieldVO = child.data as MetadataFieldVO;
					if (mfvo.xpath == (msi.items[0] as BorhanSearchCondition).field) {
						child.filter = msi;
					}
				}
			}
		}
		
		override public function get filter():Object {
			// create search item for the profile:
			var profileSearchItem:BorhanMetadataSearchItem = new BorhanMetadataSearchItem();
			profileSearchItem.type = BorhanSearchOperatorType.SEARCH_AND;
			profileSearchItem.metadataProfileId = parseInt(id); // EntriesFilter sets this attribute to the profile id
			profileSearchItem.items = [];
			
			// for each of the relevant fields/filters:
			for (var i:int = 0; i<numChildren; i++) {
				var metadataFilter:MetadataFilter = getChildAt(i) as MetadataFilter;
				var searchItem:BorhanMetadataSearchItem = metadataFilter.filter as BorhanMetadataSearchItem;
				if (searchItem) {
					profileSearchItem.items.push(searchItem);
				}
			}
			
			return profileSearchItem;
		}
		
		override public function set dataProvider(value:ArrayCollection):void {
			// dp items are MetadataFieldVO
			_dataProvider = value;
			buildFilters();
		}
		
		
		/**
		 * build MetadataFilters for the searchable fields 
		 * in the dataProvider
		 */		
		protected function buildFilters():void {
			var metadataFilter:MetadataFilter;
			for each (var mfvo:MetadataFieldVO in _dataProvider) {
				if (mfvo.appearInSearch && mfvo.type == MetadataCustomFieldTypes.LIST) {
					metadataFilter = new MetadataFilter();
//					metadataFilter.percentWidth = 100;
					metadataFilter.addEventListener(FilterComponentEvent.VALUE_CHANGE, updateFilterValue, false, 0, true);
					metadataFilter.data = mfvo;
					metadataFilter.attribute = mfvo.id;
					metadataFilter.mainButtonTitle = mfvo.displayedLabel;
					metadataFilter.dataProvider = new ArrayCollection(mfvo.optionalValues);
					addChild(metadataFilter);
				}
			}
		}
		
		private function updateFilterValue(e:FilterComponentEvent):void {
			e.stopImmediatePropagation();
			// need to have this item as event.target..
			dispatchChange(e.data, e.kind);
		}
	}
}