package pl.asria.tools.display 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	import pl.asria.tools.event.display.DraggableObjectEvent;
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	[Event(name="updatePoint", type="pl.asria.tools.event.display.DraggableObjectEvent")]
	public class DraggableObject extends Sprite
	{
		private var _targetPoint:Point;
		private var last:int;
		private var storeClicPosition:Point = new Point();
		private var storeBasePosition:Point = new Point();
		
		public var snapValue:int = 0;
		public var removable:Boolean;
		private var _sensor:Sprite;
		private var _target:Sprite;
		
		public function DraggableObject(target:Sprite = null, sensor:Sprite = null) 
		{
			setDraggableParameters(target ? target : this, sensor ? sensor : this);
		}
		
		public static function makeDraggable(target:Sprite):DraggableObject
		{
			return new DraggableObject(target);
		}
		
		/**
		* function should:
		** set mouseDown handler on target
		** disable doubleClick // we have own system for it
		** set buttonMode = true
		*/
		protected function setDraggableParameters(target:Sprite, sensor:Sprite):void
		{
			_target = target;
			if (_sensor)
			{
				_sensor.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
				_sensor.buttonMode = false;
				_sensor.doubleClickEnabled = true;
			}
			
			_sensor = sensor;
			_sensor.buttonMode = true;
			_sensor.doubleClickEnabled = false;
			_sensor.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}
		
		protected function doubeClickHandler():void 
		{ 
			_sensor.dispatchEvent(new MouseEvent(MouseEvent.DOUBLE_CLICK, true));
		}
		
		public function setBounds(bounds:Rectangle):void
		{
			
		}
		protected function mouseDownHandler(e:MouseEvent):void 
		{
			if (getTimer() - last < 200)
			{
				doubeClickHandler();
			}
			else
			{
				last = getTimer();
				
				storeClicPosition.x = _sensor.stage.mouseX;
				storeClicPosition.y = _sensor.stage.mouseY;
				
				storeBasePosition.x = x;
				storeBasePosition.y = y;
				
				_sensor.stage.addEventListener(MouseEvent.MOUSE_UP, mauseUpHandler);
				_sensor.stage.addEventListener(MouseEvent.MOUSE_MOVE, mauseMoveHandler);
				_sensor.stage.addEventListener(Event.MOUSE_LEAVE, mauseUpHandler);
				if (_sensor.parent) 
					_sensor.parent.setChildIndex(_sensor, _sensor.parent.numChildren-1);
			}
			
		}
		
		private function mauseMoveHandler(e:MouseEvent):void 
		{
			var _x:int = _sensor.stage.mouseX - storeClicPosition.x +storeBasePosition.x  + snapValue /2;
			var _y:int = _sensor.stage.mouseY - storeClicPosition.y + storeBasePosition.y + snapValue /2;
			
			if (snapValue  > 0)
			{
				_x = Math.floor(_x / snapValue) * snapValue;
				_y = Math.floor(_y / snapValue) * snapValue;
			}
			_target.x =  _x;
			_target.y =  _y;
			
			if (_targetPoint)
			{
				_targetPoint.y = _sensor.y;
				_targetPoint.x = _sensor.x;
			}
			_target.dispatchEvent(new DraggableObjectEvent(DraggableObjectEvent.UPDATE_POINT));
			if(_target != this) dispatchEvent(new DraggableObjectEvent(DraggableObjectEvent.UPDATE_POINT));
		}
		
		private function mauseUpHandler(e:Event):void 
		{
			_sensor.stage.removeEventListener(MouseEvent.MOUSE_UP, mauseUpHandler);
			_sensor.stage.removeEventListener(Event.MOUSE_LEAVE, mauseUpHandler);
			_sensor.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mauseMoveHandler);
		}
		
		public function set targetPoint(value:Point):void 
		{
			_targetPoint = value;
			_sensor.x = _targetPoint.x;
			_sensor.y = _targetPoint.y;
		}
		
	}

}