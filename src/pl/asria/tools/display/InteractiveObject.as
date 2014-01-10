package pl.asria.tools.display 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import pl.asria.tools.event.display.InteractiveObjectEvent;
	import pl.asria.tools.event.display.ui.RightClickEvent;
	import pl.asria.tools.utils.DisplayObjectUtils;
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	[Event(name="updatePosition", type="pl.asria.tools.event.display.InteractiveObjectEvent")]
	[Event(name = "doubleClick", type = "pl.asria.tools.event.display.InteractiveObjectEvent")]
	[Event(name="rightClick", type="pl.asria.tools.event.display.InteractiveObjectEvent")]
	[Event(name="stopDrag", type="pl.asria.tools.event.display.InteractiveObjectEvent")]
	[Event(name="startDrag", type="pl.asria.tools.event.display.InteractiveObjectEvent")]
	[Event(name="onceClick", type="pl.asria.tools.event.display.InteractiveObjectEvent")]
	[Event(name="holdClick", type="pl.asria.tools.event.display.InteractiveObjectEvent")]
	[Event(name="requestRemove", type="pl.asria.tools.event.display.InteractiveObjectEvent")]
	public class InteractiveObject extends MovieClip
	{
		protected var _draggablePoint:Point;
		protected var _target:MovieClip;
		private var _doubleClickOffset:uint = 200;
		private var _snapValue:int =0 ;
		private var storeClicPosition:Point = new Point();
		private var _storeBasePosition:Point = new Point();
		private var _draggable:Boolean = false;
		private var last:int;
		private var _holdClickTime:Number;
		private var _holdClickTimer:Timer;
		private var _isDraged:Boolean;
		public function InteractiveObject(target:MovieClip = null) 
		{
			_target = target || this;
			
			if (_target.stage) 
				init(null);
			else 
				_target.addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
				
			_target.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false,0,true);
			_target.addEventListener(RightClickEvent.RIGHT_CLICK, rightClickHandler, false,0,true);
			_target.buttonMode = true;
		}
		
		public function set removable(value:Boolean):void 
		{
			if(value) DisplayObjectUtils.addMenuItem(_target, "remove this", true, destroy);
		}
		
		private function destroy():void 
		{
			dispatchEvent(new InteractiveObjectEvent(InteractiveObjectEvent.REQUEST_REMOVE));
		}
		
		private function rightClickHandler(e:RightClickEvent):void 
		{
			dispatchEvent(new InteractiveObjectEvent(InteractiveObjectEvent.RIGHT_CLICK));
		}
		
		private function mouseDownHandler(e:MouseEvent):void 
		{
			
			if (_holdClickTimer)
			{
				_holdClickTimer.reset();
				_holdClickTimer.start();
			}
			
			if (getTimer() - last < doubleClickOffset)
			{
				var __doubleClicked:Boolean = true;
			}
			
			last = getTimer();
			if(_draggable)
			{
				storeClicPosition.x = _target.parent.mouseX;
				storeClicPosition.y = _target.parent.mouseY;
				
				_storeBasePosition.x = _target.x;
				_storeBasePosition.y = _target.y;
				
				_target.stage.addEventListener(MouseEvent.MOUSE_MOVE, mauseMoveHandler, false,0,true);
				dispatchEvent(new InteractiveObjectEvent(InteractiveObjectEvent.START_DRAG));
				if (_target.parent) _target.parent.setChildIndex(_target, _target.parent.numChildren - 1);
				_isDraged = true;
			}
			else if(!__doubleClicked)
			{
				dispatchEvent(new InteractiveObjectEvent(InteractiveObjectEvent.ONCE_CLICK, true));
			}
			if (__doubleClicked)
			{
				dispatchEvent(new InteractiveObjectEvent(InteractiveObjectEvent.DOUBLE_CLICK,true));
			}
		}
		
		public function setUpdateCoordinate(draggablePoint:Point):void
		{
			_draggablePoint = draggablePoint;
			
		}
		
		private function mauseMoveHandler(e:MouseEvent):void 
		{
			var _x:Number = _target.parent.mouseX - storeClicPosition.x + _storeBasePosition.x  + snapValue /2;
			var _y:Number = _target.parent.mouseY - storeClicPosition.y + _storeBasePosition.y + snapValue /2;
			
			if (snapValue  > 0)
			{
				_x = Math.floor(_x / snapValue) * snapValue;
				_y = Math.floor(_y / snapValue) * snapValue;
			}
			
			if (_draggablePoint)
			{
				_draggablePoint.x =  _x;
				_draggablePoint.y =  _y;
			}
			else
			{
				_target.x =  _x;
				_target.y =  _y;
			}
			
			
			dispatchEvent(new InteractiveObjectEvent(InteractiveObjectEvent.UPDATE_POSITION,false));
		}
		
		private function mauseUpHandler(e:Event):void 
		{
			if (!_target.stage) return;
			if (_isDraged)
			{
				dispatchEvent(new InteractiveObjectEvent(InteractiveObjectEvent.STOP_DRAG));
				_target.stage.removeEventListener(Event.MOUSE_LEAVE, mauseUpHandler);
				_target.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mauseMoveHandler);
				_isDraged = false;
			}
			if (_holdClickTimer)
				_holdClickTimer.stop();
		}
		private function init(e:Event):void 
		{
			_target.removeEventListener(Event.ADDED_TO_STAGE, init);
			_target.stage.addEventListener(MouseEvent.MOUSE_UP, mauseUpHandler, false, 0, true);
			_target.stage.addEventListener(Event.MOUSE_LEAVE, mauseUpHandler, false, 0, true);
			_target.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandeler, false,0,true);
			
		}
		
		private function removedFromStageHandeler(e:Event):void 
		{
			_target.removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandeler);
			
		}
		
		[Inspectable (name = "doubleClickOffset", variable = "doubleClickOffset", type = "int", defaultValue = '200', category = 'Other')]
		public function get doubleClickOffset():uint 
		{
			return _doubleClickOffset;
		}
		
		public function set doubleClickOffset(value:uint):void 
		{
			_doubleClickOffset = value;
		}
		
		[Inspectable (name = "snapValue", variable = "snapValue", type = "int", defaultValue = '0', category = 'Other')]
		public function get snapValue():int 
		{
			return _snapValue;
		}
		
		public function set snapValue(value:int):void 
		{
			_snapValue = value;
		}
		
		[Inspectable (name = "draggable", variable = "draggable", type = "Boolean", defaultValue = '0', category = 'Other')]
		public function get draggable():Boolean 
		{
			return _draggable;
		}
		
		public function set draggable(value:Boolean):void 
		{
			_draggable = value;
		}
		
		[Inspectable (name = "holdClickTime", variable = "holdClickTime", type = "Number", defaultValue = '0', category = 'Other')]
		public function get holdClickTime():Number 
		{
			return _holdClickTime;
		}
		
		public function set holdClickTime(value:Number):void 
		{
			if (value > 0)
			{
				if (_holdClickTimer)
				{
					_holdClickTimer.stop();
					_holdClickTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, holdClickTimerHandler);
				}
				
				_holdClickTimer = new Timer(_holdClickTime, 1);
				_holdClickTimer.addEventListener(TimerEvent.TIMER_COMPLETE, holdClickTimerHandler, false,0,true);
			}
			_holdClickTime = value;
		}
		
		public function get storeBasePosition():Point 
		{
			return _storeBasePosition;
		}
		
		public function get draggablePoint():Point 
		{
			return _draggablePoint;
		}
		
		public function get target():MovieClip 
		{
			return _target;
		}
		
		private function holdClickTimerHandler(e:TimerEvent):void 
		{
			dispatchEvent(new InteractiveObjectEvent(InteractiveObjectEvent.HOLD_CLICK, true));
		}
		
	}

}