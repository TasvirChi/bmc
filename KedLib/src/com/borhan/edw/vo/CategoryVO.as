package com.borhan.edw.vo
{
	import com.borhan.utils.ObjectUtil;
	import com.borhan.vo.BorhanCategory;
	
	import mx.collections.ArrayCollection;
	
	dynamic public class CategoryVO
	{
		public var id:Number;
		
		[Bindable]
		public var name:String;
		
		public var category:BorhanCategory;
		
		
		[Bindable]
		/**
		 * is this category available for selection in the tree. 
		 */		
		public var enabled:Boolean = true;
		
		
		[ArrayElementType("com.borhan.edw.vo.CategoryVO")]
		public var children:ArrayCollection;
		
		
		public function CategoryVO(id:Number, name:String, category:BorhanCategory)
		{
			this.id = id;
			this.name = name;
			this.category = category;
			
			if (category && category.directSubCategoriesCount > 0) {
				children = new ArrayCollection();
			}
		}
		
		public function clone():CategoryVO {
			var clonedVo:CategoryVO = new CategoryVO(id, name, new BorhanCategory());
			ObjectUtil.copyObject(this.category, clonedVo.category);
			return clonedVo;
		}

	}
}