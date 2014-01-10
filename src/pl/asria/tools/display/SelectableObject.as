package pl.asria.tools.display 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import pl.asria.tools.event.display.MultiStateMovieClip;
	import pl.asria.tools.event.display.SelectableObjectEvent;
	import pl.asria.tools.managers.focus.FocusManager;
	import pl.asria.tools.managers.focus.FocusManagerObjectEvent;
	import pl.asria.tools.managers.focus.IFocusManagerObject;

	/**
	 * ...
	 * @author Piotr Paczkowski
	 * Base states: on, off
	 * sub states: click, off, on
	 */
	[Event(name="changeFocus", type="pl.asria.tools.managers.focus.FocusManagerObjectEvent")]
	[Event(name="setStateFocus", type="pl.asria.tools.managers.focus.FocusManagerObjectEvent")]
	[Event(name="changeToUnfocus", type="pl.asria.tools.managers.focus.FocusManagerObjectEvent")]
	[Event(name="changeToFocus", type="pl.asria.tools.managers.focus.FocusManagerObjectEvent")]
	public class SelectableObject extends MultiStateMovieClip implements IFocusManagerObject
	{
		private var _selected:Boolean = false;
		private var _focus:int = FocusManager.STATE_NOSET;
		private var _focusManager:FocusManager;
		private var _focusGrup:String = "";
		protected var _autoUnselect:Boolean = true;
		
		public function SelectableObject(target:MovieClip = null) 
		{
			super(target)
			_target.buttonMode = true;
			_target.addEventListener(MouseEvent.ROLL_OUT, outHandler);
			_target.addEventListener(MouseEvent.ROLL_OVER, overHandler);
			_target.addEventListener(MouseEvent.CLICK, downHandler);
			_target.addEventListener(MouseEvent.MOUSE_UP, overHandler);
			baseState = "off";
			subState = "_off";
			gotoCurrentState();
		}
		
		/* INTERFACE pl.asria.tools.managers.focus.IFocusManagerObject */
		
		public function set focus(value:int):void 
		{
			if (_focus == FocusManager.STATE_NOSET && value != FocusManager.STATE_NOSET)
			{
				dispatchEvent(new FocusManagerObjectEvent(FocusManagerObjectEvent.SET_STATE_FOCUS));
			}
			else if (_focus != value)
			{
				dispatchChangeFocusEvent();
				if (value == FocusManager.STATE_FOCUS)
					dispatchEvent(new FocusManagerObjectEvent(FocusManagerObjectEvent.CHANGE_TO_FOCUS));
				else
					dispatchEvent(new FocusManagerObjectEvent(FocusManagerObjectEvent.CHANGE_TO_UNFOCUS));
			}
			
			_focus = value;
			if(value==FocusManager.STATE_FOCUS)
				baseState="on";
			else if(value == FocusManager.STATE_UNFOCUS)
				baseState="off";
			gotoCurrentState();
		}
		
		public function get focus():int 
		{
			return _focus;
		}
		
		public function set focusManager(value:FocusManager):void 
		{
			_focusManager = value;
			if (_focusManager && _focusGrup != "")
				_focusManager.register(this);
		}
		
		public function set focusGrup(value:String):void 
		{
			_focusGrup = value;
			if (_focusManager && _focusGrup != "")
				_focusManager.register(this);
		}
		
		public function get focusGrup():String 
		{
			return _focusGrup;
		}
		
		public function dispatchChangeFocusEvent():void 
		{
			dispatchEvent(new FocusManagerObjectEvent(FocusManagerObjectEvent.CHANGE_FOCUS));
		}
		
		private function clickHandler(e:MouseEvent):void 
		{
			
		}
		
		private function downHandler(e:MouseEvent):void 
		{
			subState  = "_click";
			if (_autoUnselect)
				selected = !selected;
			else if (!selected) selected = true;
			
			if(_selected) _focusManager.focusOn(this);
			//gotoCurrentState();
		}
		
		private function outHandler(e:MouseEvent):void 
		{
			subState = "_off";
			gotoCurrentState();
		}
		
		private function overHandler(e:MouseEvent):void 
		{
			subState = "_on";
			gotoCurrentState();
		}
		
		public function get selected():Boolean 
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void 
		{
			if (value == true) baseState="on";
			else baseState = "off";
			
			if (_selected != value) 
			{
				_selected = value;
				dispatchEvent(new SelectableObjectEvent(SelectableObjectEvent.CHANGE));
				if(value) dispatchEvent(new SelectableObjectEvent(SelectableObjectEvent.SELECT));
				else dispatchEvent(new SelectableObjectEvent(SelectableObjectEvent.UNSELECT));
			}
			gotoCurrentState();
			
			
		}
		
		public function get autoUnselect():Boolean 
		{
			return _autoUnselect;
		}
		
		public function set autoUnselect(value:Boolean):void 
		{
			_autoUnselect = value;
		}
	}

}