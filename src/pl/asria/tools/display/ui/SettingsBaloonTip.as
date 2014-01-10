/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-04-17 11:34</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.display.ui 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class SettingsBaloonTip 
	{
		protected var _hideOnMove:Boolean;
		protected var _movable:Boolean;
		protected var _content:Sprite;
		protected var _placementArea:Rectangle;
		protected var _offsetBaloon:Point;
		protected var _unregisterAfterHide:Boolean;
		protected var _showNow:Boolean;

	
		/**
		 * SettingsBaloonTip - Class with settings used in ballonTip
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function SettingsBaloonTip(content:Sprite, movable:Boolean, hideOnMove:Boolean, offsetBaloon:Point = null,  placementArea:Rectangle = null, unregisterAfterHide:Boolean = false, showNow:Boolean = false) 
		{
			_showNow = showNow;
			_unregisterAfterHide = unregisterAfterHide;
			_offsetBaloon = offsetBaloon || new Point();
			_placementArea = placementArea;
			_hideOnMove = hideOnMove;
			_content = content;
			_movable = movable;
			
		}
		
		public function getCoordinates(position:Point):Point
		{
			var result:Point = position.clone();
			if (_placementArea)
			{
				result.x = Math.max(result.x, _placementArea.x);
				result.x = Math.min(result.x, _placementArea.right);
				
				result.y = Math.max(result.y, _placementArea.y);
				result.y = Math.min(result.y, _placementArea.bottom);
			}
			result = result.add(_offsetBaloon);
			return result;
		}
		public function get movable():Boolean 
		{
			return _movable;
		}
		
		public function get hideOnMove():Boolean 
		{
			return _hideOnMove;
		}
		
		public function get content():DisplayObject 
		{
			return _content;
		}
		
		public function get unregisterAfterHide():Boolean 
		{
			return _unregisterAfterHide;
		}
		
		public function get showNow():Boolean 
		{
			return _showNow;
		}
		
	}

}