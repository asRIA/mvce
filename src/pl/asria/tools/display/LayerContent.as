/**
* CHANGELOG:
* 2011-11-03 11:49:	0.0.1 - First release
* 2011-11-03 11:17: Create file
*/
package pl.asria.tools.display 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	/**
	 * Classe have very strict rules to create or remove layers (childs) in this space. It is not possible to create a child and just add in this content. 
	 * Rulles are indroduced, to have very clean order. 
	 * @usage Main thread of usability is working on the layers. Basic methods <code>$createLatey</code> and <code>$removeLayer</code> 
	 * <code>
	 * var _layerContent:LayerContent = new LayerContent();
	 * addChild(_layerContent);
	 * var _layerBackground:Sprite = _layerContent.$createLayer("background");
	 * var _layerGameplay:Sprite = _layerContent.$createLayer("gameplay");
	 * var _layerHud:Sprite = _layerContent.$createLayer("hud");
	 * 
	 * // at this time _layerContent has 3 layers - childs.  
	 * 
	 * </code>
	 * 
	 * This class has disabled basic methods:
	 * <blockquote>
	 * - removeChild
	 * - removeChildAt
	 * - addChild
	 * - addChildAt
	 * - removeChild
	 * </blockquote>
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public class LayerContent extends Sprite
	{
		
		public function LayerContent() 
		{
			
		}
		
		/**
		 * Create layer inside this LayerContent. This is only way to add some content to this object.
		 * @param	layerName this is property equals <code>name</code> in DisplayObject
		 * @param	index index in display list
		 * @return	return Sprite, represents current created layer.
		 */
		public function $createLayer(layerName:String, index:uint = uint.MAX_VALUE):Sprite
		{
			var _layer:Sprite = new Sprite();
			_layer.name = layerName;
			index = Math.min(index, numChildren);
			super.addChildAt(_layer, index);
			return _layer;
		}
		
		
		public function $getLayer(layerName:String):Sprite
		{
			return super.getChildByName(layerName) as Sprite;
		}
		
		/**
		 * 
		 * @return	Array with every children of this LayerCOntent
		 */
		public function $getLayers():Array
		{
			var i:int = numChildren;
			var result:Array = [];
			while (--i) result.unshift(super.getChildAt(i));
			return result;
		}
		
		/**
		 * 
		 * @param	layerName name of layer. This is only one way to remove layer from content. <code>removeChilde</code>, and <code>removeChildAt</code> in this content is already blocked.
		 * @return	Returns <code>true</code> if layer is already in this LAyerContent otherwise <code>false</code>.
		 */
		public function $removeLayer(layerName:String):Boolean
		{
			var layer:Sprite = getChildByName(layerName) as Sprite;
			if (layer) super.removeChild(layer);
			return layer as Boolean;
		}
		
		public function $removeLayers():void 
		{
			while (numChildren)
			{
				super.removeChildAt(0);
			}
		}
		
		/**
		 * @throws	Every time throws error. This function is already disabled. Please to use <code>$createLayer</code>
		 * @param	child
		 * @return
		 */
		override public function addChild(child:DisplayObject):flash.display.DisplayObject 
		{
			throw new Error("This method is already disabled. please to use $createLayer method");
		}
		
		/**
		 * @throws	Every time throws error. This function is already disabled. Please to use <code>$createLayer</code>
		 * @param	child
		 * @param	index
		 * @return
		 */
		override public function addChildAt(child:DisplayObject, index:int):flash.display.DisplayObject 
		{
			throw new Error("This method is already disabled. please to use $createLayer method");
		}
		
		/**
		 * @throws	Every time throws error. This function is already disabled. Please to use <code>$removeLayer</code>
		 * @param	child
		 * @return
		 */
		override public function removeChild(child:DisplayObject):flash.display.DisplayObject 
		{
			throw new Error("This method is already disabled. please to use $removeLayer method");
		}
		
		/**
		 * @throws	Every time throws error. This function is already disabled. Please to use <code>$removeLayer</code>
		 * @param	child
		 * @param	index
		 * @return
		 */
		override public function removeChildAt(index:int):flash.display.DisplayObject 
		{
			throw new Error("This method is already disabled. please to use $removeLayer method");
		}
		
		/**
		 * @throws	Every time throws error. This function is already disabled. Please to use <code>$removeLayer</code>
		 * @param	beginIndex
		 * @param	endIndex
		 * @return
		 */
		//CONFIG::FP11
		override public function removeChildren(beginIndex:int = 0, endIndex:int = int.MAX_VALUE):void 
		{
			throw new Error("This method is already disabled. please to use $removeLayer method");
		}
		
		
		
	}

}