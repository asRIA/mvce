package pl.asria.tools.display.windows
{
	import flash.display.DisplayObject;
	import flash.display.NativeWindow;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import pl.asria.tools.display.DraggableObject;
	import pl.asria.tools.display.IWorkspace;
	import pl.asria.tools.event.display.WindowEvent;
	import pl.asria.tools.factory.Factory;
	import pl.asria.tools.managers.focus.FocusManager;
	import pl.asria.tools.managers.focus.FocusManagerObjectEvent;
	import pl.asria.tools.managers.focus.IFocusManagerObject;
	import pl.asria.tools.utils.trace.etrace;
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	[Event(name="closeWindow",type="pl.asria.tools.event.display.WindowEvent")]
	[Event(name="maxymalizeWindow",type="pl.asria.tools.event.display.WindowEvent")]
	[Event(name="minimalizeWindow",type="pl.asria.tools.event.display.WindowEvent")]
	[Event(name="changeFocus",type="pl.asria.tools.managers.focus.FocusManagerObjectEvent")]
	
	[Event(name="changeToUnfocus", type="pl.asria.tools.managers.focus.FocusManagerObjectEvent")]
	[Event(name="changeToFocus", type="pl.asria.tools.managers.focus.FocusManagerObjectEvent")]
	public class Window extends DraggableObject implements IWindow, IWorkspace
	{
		protected var _contentSettings:WindowConfigurationObject;
		protected var _vSubwindows:Vector.<Window> = new Vector.<Window>();
		
		private var _focusManager:FocusManager;
		private var _focus:int;
		private var _focusGrup:String;
		private var _minimalize:Boolean;
		private var _title:String;
		private var _scrollX:Boolean;
		private var _scrollY:Boolean;
		private var _scalableX:Boolean;
		private var _scalableY:Boolean;
		private var _currentContent:Sprite;
		private var _contentAlign:String;
		
		public var topbar:TopBarWindow;
		public var workspace:Sprite;
		public var contentSpace:Sprite;
		public var contentCentener:Sprite = new Sprite();
		public var background:Sprite;
		
		private var _contentClass:String;
		private var _freezed:Boolean = false;
		private var _pined:Boolean = false;
		private var _pinedTrigger:Timer = new Timer(1500);
		
		public function Window():void
		{
			super(null, null);
			setGrupName();
			topbar.minimalize.addEventListener(MouseEvent.CLICK, minimalizeClickHandler);
			topbar.close.addEventListener(MouseEvent.CLICK, closeClickHandler);
			if(topbar.pin) topbar.pin.addEventListener(MouseEvent.CLICK, pinClickHandler);
			addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			addEventListener(MouseEvent.CLICK, rollOverHandler);
			focusManager = FocusManager.instance;
			_focusManager.register(this);
			addEventListener(Event.ADDED_TO_STAGE, addedTaStageHandler);
			filters = [new DropShadowFilter(6, 120, 0, 0.4, 2, 2, 0.2, 3)];
			addChild(contentCentener);
			contentCentener.mask = contentSpace;
			workspace.visible = false;
			_pinedTrigger.addEventListener(TimerEvent.TIMER, triggerHandler);
			setDraggableParameters(this, topbar);
		}
		
		private function triggerHandler(e:TimerEvent):void 
		{
			if(parent) parent.addChild(this);
		}
		
		private function pinClickHandler(e:MouseEvent):void 
		{
			pined = ! pined;
		}
		
		private function addedTaStageHandler(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedTaStageHandler);
			registerInWindowsManagerAfterAddToStage();
		}
		
		public function setContent(content:Sprite, contentSettings:WindowConfigurationObject = null):void
		{
			if (!content || !(content is DisplayObject))
			{
				etrace("Should be display obejct, and not null", content)
				return;
			}
			
			removeCurrentContent();
			_currentContent = content;
			width = content.width;
			height = content.height;
			
			contentCentener.addChild(_currentContent);
			
			setConfiguration(contentSettings || _contentSettings || new WindowConfigurationObject());
			
		}
		public function set content(value:Sprite):void 
		{
			setContent(value);
		}
		
		public function get content():Sprite
		{
			return _currentContent;
		}
		public function set contentAlign(value:String):void
		{
			_contentAlign = value;
			if (!_currentContent) return;
			switch(value)
			{
				case WindowContentAlign.TOP_LEFT: 
					{
						(_currentContent as DisplayObject).x = contentSpace.x;
						(_currentContent as DisplayObject).y = contentSpace.y;
						break;
					}
				case WindowContentAlign.TOP_RIGHT: break;
				case WindowContentAlign.TOP_MIDDLE: break;
				case WindowContentAlign.MIDDLE_RIGHT: break;
				case WindowContentAlign.MIDDLE_LEFT: break;
				case WindowContentAlign.CENTER: break;
				case WindowContentAlign.BOTTOM_LEFT: break;
				case WindowContentAlign.BOTTOM_RIGHT: break;
				case WindowContentAlign.BOTTOM_MIDDLE: break;
			}
		}
		private function removeCurrentContent():Boolean 
		{
			if (!_currentContent) return false;
			contentCentener.removeChild(_currentContent as DisplayObject);
			_currentContent = null;
			
			return true;
		}
		
		private function rollOverHandler(e:MouseEvent):void
		{
			if(!_freezed) _focusManager.focusOn(this);
		}
		
		private function closeClickHandler(e:MouseEvent):void
		{
			close();
		}
		
		private function minimalizeClickHandler(e:MouseEvent):void
		{
			minimalize = !minimalize;
		}
		
		public function get minimalize():Boolean
		{
			return _minimalize;
		}
		
		public function set minimalize(value:Boolean):void
		{
			if (value)
			{
				dispatchEvent(new WindowEvent(WindowEvent.MINIMALIZE_WINDOW));
				background.visible = false;
				contentCentener.visible = false;
				topbar.alpha = 0.7;
				topbar.minimalize.rotation = 180;
				
			}
			else
			{
				dispatchEvent(new WindowEvent(WindowEvent.MAXYMALIZE_WINDOW));
				background.visible = true;
				contentCentener.visible = true;
				topbar.alpha = 1;
				topbar.minimalize.rotation = 0;
			}
			_minimalize = value;
		}
		
		public function close():void
		{
			if (_vSubwindows.length)
			{
				for (var i:int = 0, i_max:int = _vSubwindows.length; i < i_max; i++) 
				{
					if (_vSubwindows[i].minimalize)
					{
						_vSubwindows[i].minimalize = false;
					}
					_vSubwindows[i].focus = FocusManager.STATE_FOCUS;
				}
			}
			else
			{
				if (parent) parent.removeChild(this);
				pined = false;
				dispatchEvent(new WindowEvent(WindowEvent.CLOSE_WINDOW));
			}
			
		}
		
		public function setGrupName():void
		{
			focusGrup = "Global";
		}
		
		public function registerInWindowsManagerAfterAddToStage():void
		{
			var position:Point = WindowsManager.register(this);
			x = position.x;
			y = position.y;
		}
		
		public function clean():void
		{
		
		}
		
		public function getWorkspace():Rectangle
		{
			return contentCentener.getBounds(this);
		}
		
		/* INTERFACE pl.asria.tools.display.windows.IWindow */
		
		public function dispatchChangeFocusEvent():void
		{
			dispatchEvent(new FocusManagerObjectEvent(FocusManagerObjectEvent.CHANGE_FOCUS));
		}
		
		public function setConfiguration(windowConfiguration:WindowConfigurationObject):void 
		{
			_contentSettings = windowConfiguration;
			contentAlign = _contentSettings.position;
			title = _contentSettings.title;
			
			if (topbar.close) topbar.close.visible = windowConfiguration.visibleCloseButton;
			if (topbar.pin) topbar.pin.visible = windowConfiguration.visiblePinButton;
			if (topbar.minimalize) topbar.minimalize.visible = windowConfiguration.visibleMinimalizeButton;
		}
		
		public function addSubWindow(window:*):void 
		{
			var softWindow:Window = window as Window;
			if (softWindow)
			{
				_vSubwindows.push(window);
				window.addEventListener(WindowEvent.CLOSE_WINDOW, onCloseSubWindowhandler)
			}
			
		}
		
		protected function onCloseSubWindowhandler(e:WindowEvent):void 
		{
			var index:int = _vSubwindows.indexOf(e.currentTarget as Window);
			if (index >= 0)
			{
				_vSubwindows.splice(index, 1);
				if (_vSubwindows.length == 0 && _freezed) freezed = false;
			}
		}
		
		//[Inspectable(name="title",variable="title",type="String",defaultValue='',category='Other')]
		public function set title(value:String):void
		{
			_title = value;
			topbar.label.text = value;
		}
		
		public function get title():String
		{
			return _title;
		}
		
		public function set scrollX(value:Boolean):void
		{
			_scrollX = value;
		}
		
		public function set scrollY(value:Boolean):void
		{
			_scrollY = value;
		}
		
		public function get scrollY():Boolean
		{
			return _scrollY;
		}
		
		public function get scrollX():Boolean
		{
			return _scrollX;
		}
		
		public function set scalableX(value:Boolean):void
		{
			_scalableX = value;
		}
		
		public function set scalableY(value:Boolean):void
		{
			_scalableY = value;
		}
		
		public function get scalableX():Boolean
		{
			return _scalableX;
		}
		
		public function get scalableY():Boolean
		{
			return _scalableX;
		}

		public function set focus(value:int):void
		{
			var tmpFocus:int = _focus;
			_focus = value;
			
			if (tmpFocus != value)
				dispatchChangeFocusEvent();
				
			if (value && parent)
			{
				parent.addChild(this);
				transform.colorTransform = new ColorTransform();
				//filters = [new DropShadowFilter(3, 120, 0, 0.8, 0, 0, 0.4, 3)];
				filters = [new DropShadowFilter(6, 120, 0, 0.4, 0, 0, 0.6, 3)];
				dispatchEvent(new FocusManagerObjectEvent(FocusManagerObjectEvent.CHANGE_TO_FOCUS));
			}
			
			if (!value)
			{
				transform.colorTransform = new ColorTransform(1, 1, 1, 1, -50, -50, -50);
				filters = [new DropShadowFilter(6, 120, 0, 0.4, 0, 0, 0.6, 3)];
				dispatchEvent(new FocusManagerObjectEvent(FocusManagerObjectEvent.CHANGE_TO_UNFOCUS));
			}
		}
		
		public function get focus():int
		{
			return _focus;
		}
		
		public function set focusManager(value:FocusManager):void
		{
			_focusManager = value;
		}
		
		public function set focusGrup(value:String):void
		{
			_focusGrup = value;
		}
		
		public function get focusGrup():String
		{
			return _focusGrup;
		}
		
		override public function get height():Number
		{
			return super.height;
		}
	
		override public function set height(value:Number):void
		{
			background.height = value
			contentSpace.height = Math.max(0, value - 12);
			
		}
	
		override public function get width():Number
		{
			return getWorkspace().width;
		}
	
		override public function set width(value:Number):void
		{
			//getWorkspace().width = value;
			background.width =value
			contentSpace.width = Math.max(0, value - 12);
			topbar.width = value;
		}		
		
		[Inspectable (name = "contentClass", variable = "contentClass", type = "String", defaultValue = '', category = 'Other')]
		public function get contentClass():String 
		{
			return _contentClass;
		}
		
		public function set contentClass(value:String):void 
		{
			_contentClass = value;
			content = Factory.generateObejct(value);
		}
		
		public function get freezed():Boolean 
		{
			return _freezed;
		}
		
		public function set freezed(value:Boolean):void 
		{
			_freezed = value;
			contentCentener.mouseChildren = contentCentener.mouseEnabled = !value;
			if (value)
				contentCentener.transform.colorTransform = new ColorTransform(0.6, 0.6, 0.6);
			else
				contentCentener.transform.colorTransform = new ColorTransform();
		}
		
		public function get pined():Boolean 
		{
			return _pined;
		}
		
		public function set pined(value:Boolean):void 
		{
			if (value)
			{
				_pinedTrigger.reset();
				_pinedTrigger.start();
				if(topbar.pin) topbar.pin.transform.colorTransform = new ColorTransform(1,1,1,1,-70,-70,-70,0);
			}
			else 
			{
				if(topbar.pin) topbar.pin.transform.colorTransform = new ColorTransform();
				_pinedTrigger.stop();
			}
			_pined = value;
		}
	/*
	   override public function get scaleX():Number
	   {
	   return NaN;
	   }
	
	   override public function set scaleX(value:Number):void
	   {
	   //super.scaleX = value;
	   }
	
	   override public function get scaleY():Number
	   {
	   return NaN;
	   }
	
	   override public function set scaleY(value:Number):void
	   {
	   //super.scaleY = value;
	   }
	   override public function get scaleZ():Number
	   {
	   return NaN;
	   }
	
	   override public function set scaleZ(value:Number):void
	   {
	   //super.scaleZ = value;
	   }
	
	   override public function get height():Number
	   {
	   return getWorkspace().height;
	   }
	
	   override public function set height(value:Number):void
	   {
	   getWorkspace().height = value;
	   }
	
	   override public function get width():Number
	   {
	   return getWorkspace().width;
	   }
	
	   override public function set width(value:Number):void
	   {
	   getWorkspace().width = value;
	   }
	 */
		
	}

}