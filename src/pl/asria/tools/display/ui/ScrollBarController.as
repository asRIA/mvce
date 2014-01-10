/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-05-21 10:39</li>
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
	import pl.asria.tools.event.display.ui.ScrollbarEvent;
	import pl.asria.tools.event.ExtendEventDispatcher;
	
	/** 
	* Dispatched when ... 
	**/
	[Event(name="requestUnlock", type="pl.asria.tools.event.display.ui.ScrollbarEvent")]
	/** 
	* Dispatched when ... 
	**/
	[Event(name="requestLock", type="pl.asria.tools.event.display.ui.ScrollbarEvent")]
	/** 
	* Dispatched when ... 
	**/
	[Event(name="changeIndex", type="pl.asria.tools.event.display.ui.ScrollbarEvent")]
	public class ScrollBarController extends ExtendEventDispatcher
	{
		protected var _buttonPreviously:Sprite;
		protected var _buttonNext:Sprite;
		protected var _min:int;
		protected var _max:int;
		protected var _currentIndex:int;
	
		/**
		 * ScrollBarController - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function ScrollBarController() 
		{
			
		}
		
		public function initArrows(buttonNext:Sprite, buttonPreviously:Sprite):void
		{
			_buttonNext = buttonNext;
			_buttonPreviously = buttonPreviously;
		}
		
		public function setRange(min:int, max:int):void
		{
			_max = Math.max(0, max);
			_min = Math.max(0, min);
			
			if (_min > _currentIndex) currentIndex = _min;
			if (_max < _currentIndex) currentIndex = _max;
			
			checkBorderVariables();
		}
		
		public function set currentIndex(value:int):void 
		{
			
			value = Math.max(_min, value);
			value = Math.min(_max, value);
			
			if (_currentIndex != value)
			{
				_currentIndex = value;
				dispatchEvent(new ScrollbarEvent(ScrollbarEvent.CHANGE_INDEX, value));
			}
			
			checkBorderVariables();
			
		}
		
		private function checkBorderVariables():void 
		{
			if (_max == _currentIndex)
			{
				dispatchEvent(new ScrollbarEvent(ScrollbarEvent.REQUEST_LOCK, _buttonNext));

			}
			else
			{
				dispatchEvent(new ScrollbarEvent(ScrollbarEvent.REQUEST_UNLOCK, _buttonNext));
			}
			
			
			if (_min == _currentIndex)
			{
				dispatchEvent(new ScrollbarEvent(ScrollbarEvent.REQUEST_LOCK, _buttonPreviously));

			}
			else
			{			
				dispatchEvent(new ScrollbarEvent(ScrollbarEvent.REQUEST_UNLOCK, _buttonPreviously));	
			}
			
		}
		
		public function get currentIndex():int 
		{
			return _currentIndex;
		}
		
		public function get rangeMin():int 
		{
			return _min;
		}
		
		public function get rangeMax():int 
		{
			return _max;
		}
		
	}

}