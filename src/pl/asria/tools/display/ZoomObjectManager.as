/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2013-01-29 12:50</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.display 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class ZoomObjectManager 
	{
		protected var _validedPoint:Point;
		protected var _objectBounds:Rectangle;
		protected var _renderBounds:Rectangle;
		protected var _scale:Number = 1;
		
		protected var _settingsScaleMin:Number = 1;
		protected var _settingsScaleMax:Number = 2;
		
		protected var _projectorArea:Rectangle;
		protected var _boundsAvailable:Rectangle;
		protected var _dirtyScale:Boolean = true;
		protected var _dirtyTargetPoint:Boolean;
		protected var _focusX:Number;
		protected var _focusY:Number;
	
		/**
		 * ZoomObjectManager - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function ZoomObjectManager() 
		{
			_validedPoint = new Point();
		}
		
		
		public function get scale():Number 
		{
			return _scale;
		}
		
		public function set scale(value:Number):void 
		{
			value = value < _settingsScaleMin ? _settingsScaleMin : value > _settingsScaleMax ? _settingsScaleMax : value;
			if (_scale != value)
			{
				_scale = value;
				_dirtyScale = true;
			}
		}
		
		public function registerSystem(renderBounds:Rectangle, objectBounds:Rectangle, currentScale:Number):void
		{
			_renderBounds = renderBounds.clone();
			_objectBounds = objectBounds.clone();
			_scale = currentScale;
			focusX = _objectBounds.width / 2;
			focusY = _objectBounds.height / 2;
			invalidate();
			
		}
		
		public function invalidate():Boolean
		{
			var result:Boolean = _dirtyScale || _dirtyTargetPoint;
			if (_dirtyScale) calcBounds();
			if (_dirtyTargetPoint) calcTargetPoint();
			return result;
		}
		
		protected function calcBounds():void
		{
			// generic rectangle
			_boundsAvailable = _objectBounds.clone();
			
			// projector rectangle accorgind to scale (space of display taken by projector (app instance)
			_projectorArea = new Rectangle(0, 0, _renderBounds.width / _scale, _renderBounds.height / _scale );
			_boundsAvailable.x += _projectorArea.width / 2;
			_boundsAvailable.y += _projectorArea.height / 2;
			
			// adopt orign area to avaliable according to _boundsAvailable
			if (_boundsAvailable.height < _projectorArea.height) _boundsAvailable.height = 1;
			else _boundsAvailable.height -= _projectorArea.height;
			
			if (_boundsAvailable.width < _projectorArea.width) _boundsAvailable.width = 1;
			else _boundsAvailable.width -= _projectorArea.width;
			
			_dirtyScale = false;
			_dirtyTargetPoint = true;
		}
		
		
		public function get settingsScaleMin():Number 
		{
			return _settingsScaleMin;
		}
		
		public function set settingsScaleMin(value:Number):void 
		{
			_settingsScaleMin = value;
			scale = scale;
		}
		
		public function get settingsScaleMax():Number 
		{
			return _settingsScaleMax;
		}
		
		public function set settingsScaleMax(value:Number):void 
		{
			_settingsScaleMax = value;
			scale = scale;
		}
		
		public function get validedPoint():Point 
		{
			return _validedPoint;
		}
		
		public function get focusX():Number 
		{
			return _focusX;
		}
		
		public function set focusX(value:Number):void 
		{
			if (_focusX != value) _dirtyTargetPoint = true;
			_focusX = value;
		}
		
		public function get focusY():Number 
		{
			return _focusY;
		}
		
		public function set focusY(value:Number):void 
		{
			if (_focusY != value) _dirtyTargetPoint = true;
			_focusY = value;
		}
		
		
		protected function calcTargetPoint():void 
		{
			var tmp:Point = new Point(_focusX, _focusY);
			if (!containsXY(_boundsAvailable, _focusX, _focusY))
			{
				if (_focusX < _boundsAvailable.x) tmp.x = _boundsAvailable.x;
				else if (_focusX > _boundsAvailable.right) tmp.x = _boundsAvailable.right;
				if (_focusY < _boundsAvailable.y) tmp.y = _boundsAvailable.y;
				else if (_focusY > _boundsAvailable.bottom) tmp.y = _boundsAvailable.bottom;
			}
			_validedPoint.x = -tmp.x;
			_validedPoint.y = -tmp.y;
			_dirtyTargetPoint = false;
		}
		
		private function containsPoint(area:Rectangle, point:Point):Boolean
		{
			return area.x <= point.x && area.right >= point.x && area.y <=point.y && area.bottom >= point.y;
		}
		private function containsXY(area:Rectangle, x:Number, y:Number):Boolean
		{
			return area.x <= x && area.right >= x && area.y <=y && area.bottom >= y;
		}
		
		protected function moveFocusPoint(dx:Number, dy:Number):void 
		{
			focusX =  -_validedPoint.x + dx;
			focusY =  -_validedPoint.y + dy;
		}
	}

}