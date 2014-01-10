package pl.asria.tools.display 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;
	/**
	 * ...
	 * @author Piotr Paczkowski
	 */
	public class Cursor extends MovieClip
	{
		protected var _stage:Stage;
		protected var _hideSystemCursor:Boolean;
		protected var _target:MovieClip;
		protected var _offset:Point;
		public function Cursor(target:MovieClip = null, offset:Point = null) 
		{
			_offset = offset || new Point();
			if (target)
			{
				target.x = offset.x;
				target.y = offset.y;
				
				addChild(target);
			}
			_target = this;
			_target.addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
			_target.addEventListener(Event.REMOVED_FROM_STAGE, deinit, false, 0, true);
			_target.mouseChildren = false;
			_target.mouseEnabled = false;
		}
		
		public function update():void 
		{
			if (_stage)
			{
				_target.x = _stage.mouseX;
				_target.y = _stage.mouseY;
			}
		}
		
		private function addedObjectHandler(e:Event):void 
		{
			stage.setChildIndex(_target, stage.numChildren);
		}
		
		private function moveCursorHandler(e:Event):void 
		{
			_target.x = stage.mouseX;
			_target.y = stage.mouseY;
		}
		
		private function init(e:Event):void 
		{
			_stage = stage;
			stage.addEventListener(Event.ENTER_FRAME, moveCursorHandler);
			stage.removeEventListener(Event.ADDED, addedObjectHandler);
			stage.addChild(this);
			if(_hideSystemCursor) Mouse.hide();
		}
		
		private function deinit(e:Event):void 
		{
			Mouse.show();
			stage.removeEventListener(Event.ENTER_FRAME, moveCursorHandler);
			_stage.removeEventListener(Event.ADDED, addedObjectHandler);
			_stage = null;
		}
		
		public function get hideSystemCursor():Boolean 
		{
			return _hideSystemCursor;
		}
		
		public function set hideSystemCursor(value:Boolean):void 
		{
			_hideSystemCursor = value;
		}
	}

}