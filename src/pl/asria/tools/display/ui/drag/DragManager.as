/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-10-03 20:13</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.display.ui.drag 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import pl.asria.tools.data.ICleanable;
	
	/* TODO 
	 * add support*/
	public class DragManager extends EventDispatcher
	{
		
		/** reference to singleton Class **/
		private static var _instance:DragManager;
		/** private lock to avoid usage constuctor. **/
		private static var _lock:Boolean = true;
		
		protected var _dSources:Dictionary = new Dictionary(true);
		protected var _layer:DisplayObjectContainer;
		protected var _currentContext:DragSource;
		protected var _dTargets:Dictionary = new Dictionary(true);
		protected var _currentDescription:DragDescription;
		protected var _vDragPath:Vector.<DragTarget> = new Vector.<DragTarget>();
		
		[Inline]
		public static function get instance():DragManager 
		{
			if(null == _instance) 
			{
				_lock = false;
				_instance = new DragManager();
				_lock = true;
			}
			return _instance;
		}
		
		/**
		 * Singleton Class of DragManager - 
		 * @usage - access via: .instance only
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function DragManager() 
		{
			if(_lock) throw new Error("NewClassSingleton is a Singleton Design Pattern, please use NewClassSingleton.instance to get definition");
		}
		
		public function init(layer:DisplayObjectContainer):void
		{
			_layer = layer;
			_layer.mouseChildren = false;
			_layer.mouseEnabled = false;
		}
		
		/**
		 * 
		 * @param	trigger	exent after this, drag object will be activated
		 * @param	triggerDispatcher	source object, on this object will be dispatched DragEvent.REQUEST_PREPARATE_DESCRIPTION, and this event have to be handler, and event.data have to be set
		 * @param	triggerDrop this is oposition to trigger, after triggerDrop current draged element is released
		 * @param	triggerDropDispatcher in most cases this is stage. for example, if trigger is MOUSE_DOWN, then stage is waiting for MOUSE_UP, and release current dragged object
		 */
		public function registerSource(source:DragSource):void
		{
			if (_dSources[source.triggerDispatcher] == undefined)
			{
				_dSources[source.triggerDispatcher] = source;
				source.triggerDispatcher.addEventListener(source.trigger, tiiggerStartDragHandler, false, 0,true);
			}
		}
		
		/**
		 * unregoster source from system
		 * @param	triggerDispatcher
		 */
		public function unregisterSource(source:DragSource):void
		{
			if (_dSources[source.triggerDispatcher])
			{
				source.triggerDispatcher.removeEventListener(source.trigger, tiiggerStartDragHandler);
				
				delete _dSources[source.triggerDispatcher];
				
				// if context is current one, then every actions and collect proccess will be terminated inmediatly
				if (source == _currentContext)
				{
					terminateCurrentContext();
				}
			}
		}
		
		protected function tiiggerStartDragHandler(e:Event):void 
		{
			// only one context in the same time is possible to handle
			if (!_currentContext)
			{
				activeTargets();
				var context:DragSource = _dSources[e.currentTarget];
				//if (e.target != context.triggerDispatcher) return;
				var event:DragManagerEvent = new DragManagerEvent(DragManagerEvent.REQUEST_PREPARATE_DESCRIPTION, null);
				context.dispatchEvent(event);
				
				_currentDescription = event.description;
				if (_currentDescription)
				{
					for each (var item:DragTarget in _dTargets) 
					{
						if (item)
						{
							if (item.isSupported(_currentDescription.type))
							{
								item.dispatchEvent(new DragManagerEvent(DragManagerEvent.START_DRAG_SUPPORTED_ITEM, _currentDescription));
							}
							else
							{
								item.dispatchEvent(new DragManagerEvent(DragManagerEvent.START_DRAG_UNSUPPORTED_ITEM, _currentDescription));
							}
						}
					}
					if (_currentDescription.view)
					{
						_currentDescription.view.x = _layer.mouseX;
						_currentDescription.view.y = _layer.mouseY;
						_currentDescription.view.mouseChildren = false;
						_currentDescription.view.mouseEnabled = false;
						_layer.addChild(_currentDescription.view);
						_currentDescription.view.startDrag();
					}
					_currentContext = context;
					_currentContext.triggerDropDispatcher.addEventListener(_currentContext.triggerDrop, dropEventHandler, false, 0, true);
				}
			}
		}
		
		protected function activeTargets():void 
		{
			for (var row:Object in _dTargets) 
			{
				var displayTarget:DisplayObject = row as DisplayObject;
				displayTarget.addEventListener(MouseEvent.ROLL_OUT, rollOutTargetHanndler, false,0,true);
				displayTarget.addEventListener(MouseEvent.MOUSE_MOVE, moveTargetHanndler, false,0,true);
				displayTarget.addEventListener(MouseEvent.ROLL_OVER, rollOverTargetHanndler, false,0,true);
			}
		}
		protected function deactiveTargets():void 
		{
			for (var row:Object in _dTargets) 
			{
				var displayTarget:DisplayObject = row as DisplayObject;
				displayTarget.removeEventListener(MouseEvent.ROLL_OUT, rollOutTargetHanndler);
				displayTarget.removeEventListener(MouseEvent.MOUSE_MOVE, moveTargetHanndler);
				displayTarget.removeEventListener(MouseEvent.ROLL_OVER, rollOverTargetHanndler);
			}
		}
		
		public function unregisterTarget(target:DragTarget):void
		{
			if (_dTargets[target.displayTarget])
			{
				target.displayTarget.removeEventListener(MouseEvent.ROLL_OUT, rollOutTargetHanndler);
				target.displayTarget.removeEventListener(MouseEvent.MOUSE_MOVE, moveTargetHanndler);
				target.displayTarget.removeEventListener(MouseEvent.ROLL_OVER, rollOverTargetHanndler);
				delete _dTargets[target.displayTarget];
				target.decorateObject(DragTarget.NONE);
				
				var index:int = _vDragPath.indexOf(target);
				if (index >= 0)
				{
					_vDragPath.splice(index, 1);
				}
				
			}
		}
		
		public function registerTarget(target:DragTarget):void
		{
			if (_dTargets[target.displayTarget] == undefined)
			{
				_dTargets[target.displayTarget] = target;
				//target.displayTarget.addEventListener(MouseEvent.ROLL_OUT, rollOutTargetHanndler, false,0,true);
				//target.displayTarget.addEventListener(MouseEvent.ROLL_OVER, rollOverTargetHanndler, false,0,true);
			}
		}
		
		protected function moveTargetHanndler(e:MouseEvent):void 
		{
			rollOverTargetHanndler(e);
		}
		
		protected function rollOutTargetHanndler(e:MouseEvent):void 
		{
			if (_currentContext)// uncollect only if some obiect is dragged
			{
				var dragTarget:DragTarget = _dTargets[e.currentTarget];
				
				
				if (dragTarget)
				{
					dragTarget.decorateObject(DragTarget.NONE);
					
					var idnex:int = _vDragPath.indexOf(dragTarget);
					if (idnex == _vDragPath.length - 1)
					{
						_vDragPath.pop();
					}
					else if (idnex >= 0)
					{
						//throw new Error("Invalidated data structure, try to delede without queye"); // moze trzeba będzi usunąć na wypadek animacji kolejka sie rozjebie
					}
					
					if (dragTarget.isSupported(_currentDescription.type))
					{
						dragTarget.dispatchEvent(new DragManagerEvent(DragManagerEvent.ROLL_OUT_SUPPORTED, _currentDescription));
					}
					else
					{
						dragTarget.dispatchEvent(new DragManagerEvent(DragManagerEvent.ROLL_OUT_UNSUPPORTED, _currentDescription));
					}
				}
			}
		}
		
		protected function rollOverTargetHanndler(e:MouseEvent):void 
		{
			if (_currentContext) // collect only if some obiect is dragged
			{
				var dragTarget:DragTarget = _dTargets[e.currentTarget];
				e.currentTarget.removeEventListener(MouseEvent.MOUSE_MOVE, moveTargetHanndler);
				if (dragTarget)
				{
					if (dragTarget.isSupported(_currentDescription.type))
					{
						// supported place, add to queye
						var event:DragManagerEvent = new DragManagerEvent(DragManagerEvent.ROLL_ON_SUPPORTED, _currentDescription);
						dragTarget.dispatchEvent(event);
						if (!event.terminated) dragTarget.decorateObject(DragTarget.SUPPORTED);
						
						if (_vDragPath.indexOf(dragTarget) < 0)
						{
							_vDragPath.push(dragTarget);
						}
						else
						{
							//throw new Error("Invalidated data structure, attempt to add again the same DragTarget")
						}
						
					}
					else
					{
						event = new DragManagerEvent(DragManagerEvent.ROLL_ON_UNSUPPORTED, _currentDescription)
						dragTarget.dispatchEvent(event);
						// unsupported targer
						if (!event.terminated) dragTarget.decorateObject(DragTarget.UNSUPPORTED);
						
						// add unsupported to path
						if (_vDragPath.indexOf(dragTarget) < 0)
						{
							_vDragPath.push(dragTarget);
						}
						else
						{
							//throw new Error("Invalidated data structure, attempt to add again the same DragTarget")
						}
					}
				}
			}
		}
		
		protected function dropEventHandler(e:Event):void 
		{
			if (!_currentDescription) throw new Error("Unvalidated data, there is no DragDescription active");
			if (!_currentContext) throw new Error("Unvalidated data, there is no context active");
			
			var event:DragManagerEvent = new DragManagerEvent(DragManagerEvent.DROP_CONTENT_SUPPORTED, _currentDescription);
			var eventUnsupported:DragManagerEvent = new DragManagerEvent(DragManagerEvent.DROP_CONTENT_UNSUPPORTED, _currentDescription);
			
			var _suporter:Vector.<DragTarget> = new Vector.<DragTarget>();
			var _unsuporter:Vector.<DragTarget> = new Vector.<DragTarget>();
			
			for (var i:int = _vDragPath.length-1; i >= 0 ; i--)
			{
				if (_vDragPath[i].isSupported(_currentDescription.type))
				{
					_suporter.push(_vDragPath[i]);
				}
				else
				{
					_unsuporter.push(_vDragPath[i]);
				}
			}
			for (var j:int = 0, j_max:int = _suporter.length; j < j_max; j++) 
			{
				if (!event.terminated) _suporter[j].dispatchEvent(event);
				else break;
			}
			
			for (j = 0, j_max = _unsuporter.length; j < j_max; j++) 
			{
				if (!eventUnsupported.terminated) _unsuporter[j].dispatchEvent(eventUnsupported);
				else break;
			}
			
			terminateCurrentContext();
			
		}
		
		protected function terminateCurrentContext():void 
		{
			if (_currentContext)
			{
				_currentContext.triggerDropDispatcher.removeEventListener(_currentContext.triggerDrop, dropEventHandler);
			}
			
			for (var i:int = 0, i_max:int = _vDragPath.length; i < i_max; i++) 
			{
				_vDragPath[i].decorateObject(DragTarget.NONE);
			}
			_vDragPath = new Vector.<DragTarget>();
			if (_currentDescription &&  _currentDescription.view)
			{
				_layer.removeChild(_currentDescription.view);
				_currentDescription.view.stopDrag();
				if (_currentDescription.view is ICleanable) (_currentDescription.view as ICleanable).clean();
			}
			_currentDescription = null;
			_currentContext = null
			deactiveTargets();
		}
	}
}
