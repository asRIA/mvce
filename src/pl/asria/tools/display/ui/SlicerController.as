/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-05-17 14:57</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.display.ui 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import pl.asria.tools.display.buttons.BlockButton;
	import pl.asria.tools.display.InteractiveObject;
	import pl.asria.tools.event.display.InteractiveObjectEvent;
	import pl.asria.tools.event.ExtendEventDispatcher;
	
	/** 
	* Dispatched when user change progress value by action
	**/
	[Event(name="updateProgress", type="pl.asria.tools.display.ui.SlicerControllerEvent")]
	/** 
	* Dispatched when progress is manualed setted 
	**/
	[Event(name="setProgress", type="pl.asria.tools.display.ui.SlicerControllerEvent")]
	/** 
	* Dispatched when Progres movement is stopped 
	**/
	[Event(name="stopUpdateProgress", type="pl.asria.tools.display.ui.SlicerControllerEvent")]
	public class SlicerController extends ExtendEventDispatcher
	{
		protected var _progress:Number;
		protected var _view:Sprite;
		protected var _handlerBtn:BlockButton;
		protected var _handlerIo:InteractiveObject;
		protected var _property:String;
		protected var _minPosition:int;
		protected var _maxPosition:int;
		protected var _constProperty:String;
		protected var _constValue:Number;
	
		/**
		 * SlicerController - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function SlicerController() 
		{

		}
		
		public function setView(view:Sprite,horizontal:Boolean = false, minPosition:int = 0, maxPosition:int = 100):void
		{
			_view = view;
			_handlerBtn = new BlockButton(_view.getChildByName("handler") as MovieClip);
			_handlerBtn.autoblock = false;
			
			_handlerIo = new InteractiveObject(_handlerBtn.target);
			_handlerIo.draggable = true;
			_handlerIo.removable = false;
			_handlerIo.addEventListener(InteractiveObjectEvent.UPDATE_POSITION, updatePositionHandler);
			_handlerIo.addEventListener(InteractiveObjectEvent.STOP_DRAG, stopUpdatePositionHandler);
			// getHandler
			
			_maxPosition = maxPosition;
			_minPosition = minPosition;
			_property = horizontal ? "x" : "y";
			_constProperty = horizontal ? "y" : "x";
			_constValue = _handlerIo.target[_constProperty];
		}
		
		protected function stopUpdatePositionHandler(e:InteractiveObjectEvent):void 
		{
			_handlerIo.target[_constProperty] = _constProperty;
			_handlerIo.target[_property] = Math.max(_minPosition, _handlerIo.target[_property]);
			_handlerIo.target[_property] = Math.min(_maxPosition, _handlerIo.target[_property]);
			
			_progress = (_handlerIo.target[_property]  - _minPosition) / (_maxPosition - _minPosition);
			
			dispatchEvent(new SlicerControllerEvent(SlicerControllerEvent.STOP_UPDATE_PROGRESS));
		}

		protected function updatePositionHandler(e:InteractiveObjectEvent):void 
		{
			_handlerIo.target[_constProperty] = _constProperty;
			_handlerIo.target[_property] = Math.max(_minPosition, _handlerIo.target[_property]);
			_handlerIo.target[_property] = Math.min(_maxPosition, _handlerIo.target[_property]);
			
			_progress = (_handlerIo.target[_property]  - _minPosition) / (_maxPosition - _minPosition);
			
			dispatchEvent(new SlicerControllerEvent(SlicerControllerEvent.UPDATE_PROGRESS));
		}
		
		public function get progress():Number 
		{
			return _progress;
		}
		
		/**
		 * Manual set progres value
		 */
		public function set progress(value:Number):void 
		{
			_progress = value < 0 ? 0 : value > 1 ? 1 : value;
			
			if (_view)
			{
				_handlerIo.target[_property] = _minPosition + (_maxPosition - _minPosition) * _progress;
				_handlerIo.target[_constProperty] = _constProperty;
				dispatchEvent(new SlicerControllerEvent(SlicerControllerEvent.SET_PROGRESS));
			}
		}
		
		public function get handlerBtn():BlockButton 
		{
			return _handlerBtn;
		}
		
		
	}

}