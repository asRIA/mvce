/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-10-09 17:05</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.display.ui.menu 
{
	import pl.asria.tools.model.ProxyMap;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.utils.Dictionary;
	import pl.asria.tools.utils.getClass;
	
	/** 
	* Dispatched when source would like to create menu object iteam
	**/
	[Event(name="globalRequestDescription", type="pl.asria.tools.display.ui.menu.ContextMenuSourceEvent")]
	public class ContextMenuManager extends EventDispatcher
	{
		protected var _dRegistred:Dictionary = new Dictionary(true);
		protected var _displayContent:Sprite;
		protected var _stage:Stage;
		protected var _currentContentMenu:Sprite;
		protected var _currentDescription:ContextMenuDescription;
		protected var _allowToDestroy:Boolean;
		protected var _proxyMap:ProxyMap = new ProxyMap();
		
		/** reference to singleton Class **/
		private static var _instance:ContextMenuManager;
		/** private lock to avoid usage constuctor. **/
		private static var _lock:Boolean = true;
		
		// permanent existing of instance
		{
			_lock = false;
			_instance = new ContextMenuManager();
			_lock = true;
		}
		
		public static function get instance():ContextMenuManager 
		{
			return _instance;
		}
		
		/**
		 * Singleton Class of ContextMenuManager - 
		 * @usage - access via: .instance only
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function ContextMenuManager() 
		{
			if(_lock) throw new Error("ContextMenuManager is a Singleton Design Pattern, please use ContextMenuManager.instance to get definition");
		}
		
		
		public function init(displayContent:Sprite, stage:Stage):void
		{
			_stage = stage;
			_displayContent = displayContent;
		}
		
		public function registerSource(contextMenuSource:ContextMenuSource):void
		{
			if (_dRegistred[contextMenuSource.object])
			{
				unregisterOverSource(contextMenuSource);
			}
			
			for (var i:int = 0, i_max:int = contextMenuSource.triggers.length; i < i_max; i++) 
			{
				contextMenuSource.object.addEventListener(contextMenuSource.triggers[i], triggetHandler);
			}
			
			_dRegistred[contextMenuSource.object] = contextMenuSource
			//if (_dRegistred[contextMenuSource.object])
				//_dRegistred[contextMenuSource.object].push(contextMenuSource);
			//else
				//_dRegistred[contextMenuSource.object] = Vector.<ContextMenuSource>([contextMenuSource])
		}
		
		protected function triggetHandler(e:Event):void 
		{
			destroyCurrentMenu();
			
			var sourceObject:ContextMenuSource = _dRegistred[e.currentTarget];
			
			// dispatch local direectly on source obejct
			var event:ContextMenuSourceEvent = new ContextMenuSourceEvent(ContextMenuSourceEvent.REQUEST_DESCRIPTION, sourceObject);
			sourceObject.dispatchEvent(event);
			
			// dispatch global, event is strictly fixed witch source type for performance
			var event2:ContextMenuSourceEvent = new ContextMenuSourceEvent(ContextMenuSourceEvent.GLOBAL_REQUEST_DESCRIPTION+sourceObject.type, sourceObject)
			event2.internal_description = event.internal_description;
			dispatchEvent(event2);
			
			if (event2.internal_description) // this properti have to be set by some handler of event
			{
				invokeBuilders(event2.internal_description);
			}
			else
			{
				trace("2:[ContextMenuManager.triggetHandler] Uncatched event: ContextMenuSourceEvent.REQUEST_DESCRIPTION, or not registred handler ContextMenuSourceEvent.GLOBAL_REQUEST_DESCRIPTION for type:", sourceObject)
			}
		}
		
		/**
		 * Manual invoke description builders
		 * @param	description
		 */
		public function invokeBuilders(description:ContextMenuDescription):void 
		{
			_currentContentMenu = new Sprite();
			_allowToDestroy = true;
			
			for (var i:int = 0, i_max:int = description._vItems.length; i < i_max; i++) 
			{
				var iteam:ContextMenuItem = description._vItems[i];
				var builder:Class = _proxyMap.getProxy(getClass(iteam.description), false);
				if (builder)
				{
					var builderInstance:ContextMenuBuilder = new builder() as ContextMenuBuilder;
					builderInstance.build(iteam);
					
					if (builderInstance.content)
					{
						builderInstance.content.y = _currentContentMenu.height;
						_currentContentMenu.addChildAt(builderInstance.content, 0);
					}
				}
				else
				{
					trace("3:[ContextMenuManager.invokeBuilders] There is no registred builder of context menu typed", description._vItems[i].description);
				}
			}
			
			// collect builded menu to single contenet
			if (_currentContentMenu.numChildren)
			{
				_currentContentMenu.addEventListener(MouseEvent.ROLL_OVER, rollOverHandelr);
				_currentContentMenu.addEventListener(MouseEvent.ROLL_OUT, rollOutHandelr);
			
				_currentDescription = description;
				_currentContentMenu.x = _displayContent.mouseX - 5;
				_currentContentMenu.y = _displayContent.mouseY - 5;
				
				_stage.addEventListener(MouseEvent.MOUSE_UP, triggerDestroyHandler);
				_stage.addEventListener(MouseEvent.MIDDLE_MOUSE_UP, triggerDestroyHandler);
				_stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP, triggerDestroyHandler);
			
				_displayContent.addChild(_currentContentMenu);
				
				// decorate 
				_currentContentMenu.filters = [new DropShadowFilter(6, 120, 0, 0.4, 0, 0, 0.6, 3)];
			}
			// display content on stage
		}
		
		protected function rollOutHandelr(e:MouseEvent):void 
		{
			_allowToDestroy = true;
			
		}
		
		protected function rollOverHandelr(e:MouseEvent):void 
		{
			_allowToDestroy = false;
		}
		
		protected function triggerDestroyHandler(e:MouseEvent):void 
		{
			if (_allowToDestroy)
			{
				destroyCurrentMenu();
			}
		}
		
		public function unregisterOverSource(contextMenuSource:ContextMenuSource):void
		{
			for (var i:int = 0, i_max:int = contextMenuSource.triggers.length; i < i_max; i++) 
			{
				contextMenuSource.object.removeEventListener(contextMenuSource.triggers[i], triggetHandler);
			}
			delete _dRegistred[contextMenuSource.object];
		}
		
		public function retriveMenuSourceObject(object:IEventDispatcher):ContextMenuSource
		{
			return _dRegistred[object];
		}
		
		public function unregisterOverObject(object:IEventDispatcher):void
		{
			if (_dRegistred[object])
			{
				unregisterOverSource(_dRegistred[object])
			}
		}
		
		/**
		 * 
		 * @param	builder class of ContextMenuBuilder
		 * @param	type
		 */
		public function registerBuilder(builder:Class, description:Class):void
		{
			_proxyMap.addProxy(builder, description)
		}
		
		public function unregisterBuilder(description:Class):void
		{
			_proxyMap.removeProxyAlias(description);
		}
		
		/**
		 * please to use registerHandler
		 * @param	type
		 * @param	listener
		 * @param	useCapture
		 * @param	priority
		 * @param	useWeakReference
		 */
		public override function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void 
		{
			throw new Error("Please to use registerHandler");
		}
		
		/**
		 * please to use unregisterHadnler!
		 * @param	type
		 * @param	listener
		 * @param	useCapture
		 */
		public override function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void 
		{
			throw new Error("Please to use unregisterHadnler");
		}
		
		public function registerHandler(type:String, typeSourceObject:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			super.addEventListener(type + typeSourceObject, listener, useCapture, priority, useWeakReference);
		}
		
		public function unregisterHadnler(type:String, typeSourceObject:String, listener:Function, useCapture:Boolean = false):void
		{
			super.removeEventListener(type + typeSourceObject, listener, useCapture);
		}
		
		internal function invoke(event:Event):void 
		{
			// remove menu
			destroyCurrentMenu();
			if(event) dispatchEvent(event);
		}
		
		protected function destroyCurrentMenu():void 
		{
			if(_currentContentMenu && _currentContentMenu.parent)
			{
				_displayContent.removeChild(_currentContentMenu);
				_currentContentMenu.removeEventListener(MouseEvent.ROLL_OVER, rollOverHandelr);
				_currentContentMenu.removeEventListener(MouseEvent.ROLL_OUT, rollOutHandelr);
			}
				
			_currentContentMenu = null;
			if(_currentDescription)
				_currentDescription.clean();
			_currentDescription = null;
			
			_stage.removeEventListener(MouseEvent.MOUSE_UP, triggerDestroyHandler);
			_stage.removeEventListener(MouseEvent.MIDDLE_MOUSE_UP, triggerDestroyHandler);
			_stage.removeEventListener(MouseEvent.RIGHT_MOUSE_UP, triggerDestroyHandler);
		}
	}
}