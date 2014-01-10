/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-04-27 10:07</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.fx.popups 
{
	import com.greensock.TweenMax;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import pl.asria.framework.display.popups.PopupLayer;
	import pl.asria.framework.display.popups.PopupManager;
	import pl.asria.framework.events.PopupEvent;
	
	public class PopupLayersFX 
	{
		protected var _popupManager:PopupManager;
		protected var _dLayersCounts:Dictionary;
		protected var _count:int;
		protected var _extraFX:int;
		
		/**
		 * PopupLayersFX - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function PopupLayersFX(popupManager:PopupManager) 
		{
			_popupManager = popupManager;
			_dLayersCounts = new Dictionary();
			_count = 0;
			_popupManager.addEventListener("BEGIN_HIDE_ANIMATION", popup_beginHide);
			_popupManager.addEventListener("BEGIN_SHOW_ANIMATION", popup_beginShow);
			_popupManager.addEventListener("END_HIDE_ANIMATION", popup_endHide);
			_popupManager.addEventListener("END_SHOW_ANIMATION", popup_endShow);
		}
		
		
		public function clean():void
		{
			_dLayersCounts = null;
			_popupManager.removeEventListener("BEGIN_HIDE_ANIMATION", popup_beginHide);
			_popupManager.removeEventListener("BEGIN_SHOW_ANIMATION", popup_beginShow);
			_popupManager.removeEventListener("END_HIDE_ANIMATION", popup_endHide);
			_popupManager.removeEventListener("END_SHOW_ANIMATION", popup_endShow);
			_popupManager = null;
		}
		
		public function addLayer(layer:PopupLayer):void 
		{
			if (!_dLayersCounts[layer.layerName])
			{
				var layerFXDefinition:Object = { count:0, order:_count++, layer:layer, active:false };
				_dLayersCounts[layer.layerName] = layerFXDefinition;
			}
			
		}
		
		protected function popup_beginHide(e:PopupEvent):void 
		{
			
		}
		
		protected function popup_beginShow(e:PopupEvent):void 
		{
			if (_dLayersCounts[e.popupLayer])
			{
				_dLayersCounts[e.popupLayer].count++;
				adoptToCurrentState();
			}

		}
		
		protected function popup_endHide(e:PopupEvent):void 
		{
			if (_dLayersCounts[e.popupLayer])
			{
				_dLayersCounts[e.popupLayer].count--;
				adoptToCurrentState();
			}
		}
		
		protected function popup_endShow(e:PopupEvent):void 
		{

		}
		
		protected function adoptToCurrentState():void 
		{
			var _selected:Array = [];
			var _unselected:Array = [];
			for each (var item:Object in _dLayersCounts) 
			{
				if (item.count > 0)
				{
					_selected.push(item);
				}
				else
				{
					_unselected.push(item);
				}
			}
			
			if (_selected.length)
			{
				_selected = _selected.sortOn(["order"], Array.NUMERIC | Array.DESCENDING);
				if(_extraFX == 0) _unselected.push(_selected.shift()); // last one should be not filtred/etc
				
				for (var i:int = 0, i_max:int = _selected.length; i < i_max; i++) 
				{
					_selected[i].active = true;
				}
				
			}
			
			i_max = _unselected.length;
			for (i = 0; i < i_max; i++ )
			{
				if (!_unselected[i].active) continue;
				removeFilter(_unselected[i].layer);
			}
			
			
			i_max = _selected.length;
			for (i = 0; i < i_max; i++ )
			{
				setFilter(_selected[i].layer, i+_extraFX);
			}
			
		}
		
		protected function setFilter(layer:Sprite, power:int):void 
		{
			layer.mouseChildren = false;
			layer.mouseEnabled = false;
			
			TweenMax.to(layer, 0.2, {/*blurFilter:{quality:1, blurX:(2+int(power/2)), blurY:(2+int(power/2))},*/ colorTransform:{brightness:Math.max(0.2, 0.8-power*0.15)}});
		}
		
		protected function removeFilter(layer:Sprite):void 
		{
			layer.mouseChildren = true;
			layer.mouseEnabled = true;
			TweenMax.to(layer, 0.2, {/*blurFilter:{quality:1, blurX:0, blurY:0, remove:true},*/colorTransform:{brightness:1}});
		}
		
		public function get extraFX():int 
		{
			return _extraFX;
		}
		
		public function set extraFX(value:int):void 
		{
			value = value < 0 ? 0 : value;
			if (value != _extraFX)
			{
				_extraFX = value;
				adoptToCurrentState();
			}
			
		}
		
		
	}

}