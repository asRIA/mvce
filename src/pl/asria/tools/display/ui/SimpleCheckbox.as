package pl.asria.tools.display.ui 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import pl.asria.framework.display.buttons.ToggleButton;
	/**
	 * ...
	 * @author Michal Mazur
	 */
	
	[Event(name="click", type="flash.events.MouseEvent")] 
	public class SimpleCheckbox extends EventDispatcher
	{
		private var _graphic:MovieClip;
		private var _selected:Boolean = false;
		
		private var _button:ToggleButton = null;
		
		public function SimpleCheckbox(graphic:MovieClip) 
		{
			_graphic = graphic;
			if (_graphic.totalFrames > 2)
			{
				_button = new ToggleButton(_graphic);
				_button.addEventListener(MouseEvent.CLICK, onMouseClick);
			}
			else
			{
				_graphic.gotoAndStop(1);
				_graphic.addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
				_graphic.addEventListener(MouseEvent.CLICK, onMouseClick);
			}
			_graphic.buttonMode = true;
		}
		
		private function onRemoved(e:Event):void 
		{
			_graphic.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			_graphic.removeEventListener(MouseEvent.CLICK, onMouseClick);
			if (_button)
			{
				_button.removeEventListener(MouseEvent.CLICK, onMouseClick);
				_button = null;
			}
			dispatchEvent(new Event(Event.REMOVED_FROM_STAGE));
		}
		
		public function onMouseClick(e:MouseEvent):void 
		{
			dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
		
		public function get graphic():MovieClip 
		{
			return _graphic;
		}
		
		public function get selected():Boolean 
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void 
		{
			_selected = value;
			if (_button)
			{
				_button.isOn = value;
			}
			else
			{
				if (!value)
					_graphic.gotoAndStop(1);
				else
					_graphic.gotoAndStop(2);
			}
		}
		
		public function get button():ToggleButton 
		{
			return _button;
		}
		
		
	}

}