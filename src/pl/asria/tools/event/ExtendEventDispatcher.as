package pl.asria.tools.event
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	
	public class ExtendEventDispatcher extends EventDispatcher
	{
		protected var _target:IEventDispatcher;
		
		protected var _dHandlers:Dictionary;
		protected var _dHandlersCapture:Dictionary;
		
		/**
		 * ...
		 * @author Piotr Paczkowski - kontakt@trzeci.eu
		 */
	
		public function ExtendEventDispatcher(target:IEventDispatcher=null)
		{
			super(target)
			_target = target;
			
			_dHandlers = new Dictionary();
			_dHandlersCapture = new Dictionary();

		}
		/**
		 * Registers an event listener object with an EventDispatcher object so that the listener 
		 * receives notification of an event. You can register event listeners on all nodes in the 
		 * display list for a specific type of event, phase, and priority.After you successfully register an event listener, you cannot change its priority
		 * through additional calls to addEventListener(). To change a listener's
		 * priority, you must first call removeListener(). Then you can register the
		 * listener again with the new priority level. Keep in mind that after the listener is registered, subsequent calls to
		 * addEventListener() with a different type or
		 * useCapture value result in the creation of a separate listener registration. 
		 * For example, if you first register a listener with useCapture set to 
		 * true, it listens only during the capture phase. If you call 
		 * addEventListener() again using the same listener object, but with
		 * useCapture set to false, you have two separate listeners: one
		 * that listens during the capture phase and another that listens during the target and
		 * bubbling phases.You cannot register an event listener for only the target phase or the bubbling 
		 * phase. Those phases are coupled during registration because bubbling 
		 * applies only to the ancestors of the target node.If you no longer need an event listener, remove it by calling 
		 * removeEventListener(), or memory problems could result. Event listeners are not automatically
		 * removed from memory because the garbage
		 * collector does not remove the listener as long as the dispatching object exists (unless the useWeakReference
		 * parameter is set to true).Copying an EventDispatcher instance does not copy the event listeners attached to it. 
		 * (If your newly created node needs an event listener, you must attach the listener after
		 * creating the node.) However, if you move an EventDispatcher instance, the event listeners 
		 * attached to it move along with it.If the event listener is being registered on a node while an event is being processed
		 * on this node, the event listener is not triggered during the current phase but can be 
		 * triggered during a later phase in the event flow, such as the bubbling phase.If an event listener is removed from a node while an event is being processed on the node,
		 * it is still triggered by the current actions. After it is removed, the event listener is
		 * never invoked again (unless registered again for future processing).
		 * @param	type	The type of event.
		 * @param	listener	The listener function that processes the event. This function must accept
		 *   an Event object as its only parameter and must return nothing, as this example shows:
		 *   <codeblock>
		 *   function(evt:Event):void
		 *   </codeblock>
		 *   The function can have any name.
		 * @param	useCapture	Determines whether the listener works in the capture phase or the 
		 *   target and bubbling phases. If useCapture is set to true, 
		 *   the listener processes the event only during the capture phase and not in the 
		 *   target or bubbling phase. If useCapture is false, the
		 *   listener processes the event only during the target or bubbling phase. To listen for
		 *   the event in all three phases, call addEventListener twice, once with 
		 *   useCapture set to true, then again with
		 *   useCapture set to false.
		 * @param	priority	The priority level of the event listener. The priority is designated by
		 *   a signed 32-bit integer. The higher the number, the higher the priority. All listeners
		 *   with priority n are processed before listeners of priority n-1. If two
		 *   or more listeners share the same priority, they are processed in the order in which they
		 *   were added. The default priority is 0.
		 * @param	useWeakReference	Determines whether the reference to the listener is strong or
		 *   weak. A strong reference (the default) prevents your listener from being garbage-collected.
		 *   A weak reference does not. Class-level member functions are not subject to garbage 
		 *   collection, so you can set useWeakReference to true for 
		 *   class-level member functions without subjecting them to garbage collection. If you set
		 *   useWeakReference to true for a listener that is a nested inner 
		 *   function, the function will be garbage-collected and no longer persistent. If you create 
		 *   references to the inner function (save it in another variable) then it is not 
		 *   garbage-collected and stays persistent.
		 * @langversion	3.0
		 * @playerversion	Flash 9
		 * @playerversion	Lite 4
		 * @throws	ArgumentError The listener specified is not a function.
		 */
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void 
		{
			if (useCapture)
			{
				if (_dHandlersCapture[type] == undefined) _dHandlersCapture[type] = new Vector.<Function>();
				_dHandlersCapture[type].push(listener);
			}
			else
			{
				if (_dHandlers[type] == undefined) _dHandlers[type] = new Vector.<Function>();
				_dHandlers[type].push(listener);
			}
			
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		
		public function addEventListenerDelayed(activationEvent:String, deactivationEvent:String, delay:int, eventToDispatch:Event):void
		{
			/* TODO Delayed event */
		}
		
		
		
		/**
		 * Removes a listener from the EventDispatcher object. If there is no matching listener registered with the EventDispatcher object, a call to this method has no effect.
		 * @param	type	The type of event.
		 * @param	listener	The listener object to remove.
		 * @param	useCapture	Specifies whether the listener was registered for the capture phase or the 
		 *   target and bubbling phases. If the listener was registered for both the capture phase and the
		 *   target and bubbling phases, two calls to removeEventListener() are required 
		 *   to remove both, one call with useCapture() set to true, and another 
		 *   call with useCapture() set to false.
		 * @langversion	3.0
		 * @playerversion	Flash 9
		 * @playerversion	Lite 4
		 */
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void 
		{
			super.removeEventListener(type, listener, useCapture);
			var index:int;
			if (useCapture)
			{
				if (_dHandlersCapture[type] != undefined)
				{
					index = _dHandlersCapture[type].lastIndexOf(listener);
					_dHandlersCapture[type].splice(index, 1);
				}
			}
			else
			{
				if (_dHandlers[type] != undefined)
				{
					index = _dHandlers[type].lastIndexOf(listener);
					_dHandlers[type].splice(index, 1);
				}
			}
			
		}
		
		/**
		 * Removes all listeners from the EventDispatcher object. If there is no matching listener registered with the EventDispatcher object, a call to this method has no effect.
		 * @param	useCapture	Specifies whether the listener was registered for the capture phase or the 
		 *   target and bubbling phases. If the listener was registered for both the capture phase and the
		 *   target and bubbling phases, two calls to removeEventListener() are required 
		 *   to remove both, one call with useCapture() set to true, and another 
		 *   call with useCapture() set to false.
		 * @param	iKnowItIsPossibleDangerForApplication	To be sure, that this operation is special. Please set true
		 * @langversion	3.0
		 * @playerversion	Flash 9
		 * @playerversion	Lite 4
		 */
		public function removeAllListeners(useCapture:Boolean = false, iKnowItIsPossibleDangerForApplication:Boolean = false):Boolean
		{
			if (!iKnowItIsPossibleDangerForApplication)
			{
				trace("ExtendEventDispatcher: removeAllListeners aborded");
				return false;
			}
			
			if (useCapture)
			{
				for each (var type:String in _dHandlersCapture) 
				{
					removeEventsByType(type, useCapture);
				}
				_dHandlersCapture = new Dictionary();
			}
			else
			{
				for each (type in _dHandlers) 
				{
					removeEventsByType(type, useCapture);
				}
				_dHandlers = new Dictionary();
			}
			
			return true;
		}
		
		/**
		 * 
		 * @param	type
		 * @param	useCapture
		 */
		public function removeEventsByType(type:String, useCapture:Boolean):void 
		{
			var handlers:Vector.<Function>;
			if (!useCapture && _dHandlers[type])
			{
				handlers = _dHandlers[type];
				delete _dHandlers[type]
			}
			
			if (useCapture && _dHandlersCapture[type])
			{
				handlers = _dHandlersCapture[type];
				delete _dHandlersCapture[type];
			}
			
			if (handlers && handlers.length)
			{
				for (var i:int = 0, i_max:int = handlers.length; i < i_max; i++) 
				{
					super.removeEventListener(type, handlers[i], useCapture);
				}
			}
		}
	
	}

}
