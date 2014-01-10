package pl.asria.tools.display.ui 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import pl.asria.tools.display.DraggableObject;
	import pl.asria.tools.display.IWorkspace;
	import pl.asria.tools.event.display.DraggableObjectEvent;
	import pl.asria.tools.event.display.ui.ScrollbarEvent;
	import pl.asria.tools.utils.trace.etrace;
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	[Event(name="changeIndex", type="pl.asria.tools.event.display.ui.ScrollbarEvent")]
	public class ScrollbarBase extends MovieClip implements IWorkspace
	{
		// make index grower
		public var up:Sprite;
		
		// make index lowe
		public var down:Sprite;
		
		public var handler:Sprite;
		public var handlerDraggable:DraggableObject;
		public var ws:Sprite;
		private var _currentIndex:int = 0;
		private var min:int;
		private var max:int;
		
		public function ScrollbarBase() 
		{
			if (ws) removeChild(ws);
			if (handler is DraggableObject)
			{
				handlerDraggable = handler as DraggableObject;
				
			}
			else
			{
				handlerDraggable = new DraggableObject(handler);
			}
			handler.visible = false;
			
			up.addEventListener(MouseEvent.CLICK, clickUpHandler);
			down.addEventListener(MouseEvent.CLICK, clickDownHandler);
			handlerDraggable.setBounds(getWorkspace());
			handlerDraggable.addEventListener(DraggableObjectEvent.UPDATE_POINT, updateHandlerHandler);
		}
		
		private function updateHandlerHandler(e:DraggableObjectEvent):void 
		{
			
		}
		
		private function clickDownHandler(e:MouseEvent):void 
		{
			currentIndex--;
		}
		
		private function clickUpHandler(e:MouseEvent):void 
		{
			currentIndex++;
		}
		
		private function checkBorderVariables():void 
		{
			down.buttonMode = min != _currentIndex;
			down.mouseEnabled = min != _currentIndex;
			down.mouseChildren = min != _currentIndex;
			
			up.buttonMode = max != _currentIndex;
			up.mouseEnabled = max != _currentIndex;
			up.mouseChildren = max != _currentIndex;
		}
		
		public function setRange(min:int, max:int):void
		{
			this.max = max;
			this.min = min;
			if (min > _currentIndex) currentIndex = min;
			if (max < _currentIndex) currentIndex = max;
			checkBorderVariables();
		}
		
		public function clean():void
		{

		}
		
		/* INTERFACE pl.asria.tools.display.IWorkspace */
		
		public function getWorkspace():Rectangle 
		{
			return ws.getRect(this);
		}
		
		public function set currentIndex(value:int):void 
		{
			
			value = Math.max(min, value);
			value = Math.min(max, value);
			
			if (_currentIndex != value)
			{
				_currentIndex = value;
				dispatchEvent(new ScrollbarEvent(ScrollbarEvent.CHANGE_INDEX, value));
			}
			
			checkBorderVariables();
			
		}
		
		public function get rangeMin():int 
		{
			return min;
		}
		
		public function get rangeMax():int 
		{
			return max;
		}
		
		public function get currentIndex():int 
		{
			return _currentIndex;
		}
	}

}