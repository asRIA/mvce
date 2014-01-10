package pl.asria.tools.display.proxy 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import pl.asria.tools.display.proxy.proxy;
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	[Event(name="requestUri", type="pl.asria.tools.display.proxy.ProxyEvent")]
	public class ProxyManager 
	{
		private static const _lib:Dictionary = new Dictionary();
		private static const _pending:Dictionary = new Dictionary(); // todo: przerobić na vektor zawierający odnośniki -> jeden do wielu
		
		
		/**
		 * Callback to generate base adress, in default separate packages to dirs
		 * @example	<code>asset.ui.popup.finish.type__jpg__background</code> translate to: <code>asset/ui/popup/finish/background.jpg</code>
		 */
		static public var callbackURIGenerater:Function;
		
		/**
		 * Callback to generate extension loocking on the packages dir
		 * @default	 <code>asset.ui.popup.finish.type__jpg__background</code> return: <code>jpg</code>
		 */
		
		{
			callbackURIGenerater = generateURI;
		}
		
		/**
		 * In default every objects call request after add to stage, this is automatic process
		 * @param	proxyObject
		 */
		static proxy function request(proxyObject:ProxyObject, target:DisplayObjectContainer):void 
		{
			var _uri:String =  callbackURIGenerater(target);
			_pending[_uri] = proxyObject;
			dispatchEvent(ProxyEvent.REQUEST_URI,_uri);
		}
		
		static private function generateURI(obejct:Object):String
		{
			var _class:String = getQualifiedClassName(obejct);
			_class = _class.split(".").join("/").split("::").join("/");
			var _splited:Array = _class.split("__");
			var _typed:int = _splited.indexOf("type");
			if (_typed >=0)
			{
				var type:String = _splited[_typed + 1];
				_splited.splice(_typed, 2);
				_class = _splited.join("");
				_class += "." + type;
			}
			return _class;
		}
		
		static private function dispatchEvent(eventType:String, uri:String):void
		{
			//trace( "ProxyManager.dispatchEvent > eventType : " + eventType + ", uri : " + uri );
			if (_lib[eventType] == undefined) return;
			var _v:Vector.<Function> = _lib[eventType];
			for each (var callback:Function in _v) 
				callback(new ProxyEvent(eventType, uri))
		}
		
		/**
		 * @param	eventType
		 * @param	handler
		 * @example	most simplest implementation
		 * <listing version="3.0">
		 * private function requestUriHandler(e:ProxyEvent):void 
			{
				var loader:Loader = new Loader();
				loader.load(new URLRequest("assets/proxy/" + e.uri + ".png"));
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeLoader);
				function completeLoader(event:Event):void
				{
					ProxyManager.join(loader.content, e.uri);
				}
				
			}
		 * </listing>
		 */
		static public function addEventListener(eventType:String, handler:Function):void
		{
			if (_lib[eventType] == undefined)_lib[eventType] = new Vector.<Function>();
			_lib[eventType].push(handler);
		}
		
		static public function removeEventListener(eventType:String, handler:Function):void
		{
			if (_lib[eventType] == undefined) return;
			var _v:Vector.<Function> = _lib[eventType];
			var _index:int = _v.lastIndexOf(handler);
			_v.splice(_index, 1);
		}
		
		/**
		 * Method please to call after some request. This Method add reference/proxy object into target object, repleace content dynamic
		 * @param	object	result of proxy
		 * @param	uri		special uri get from ProxyEvent during listener
		 */
		static public function join(object:DisplayObject, uri:String):void
		{
			if (_pending[uri] == undefined) return;
			var _pendingObject:ProxyObject = _pending[uri];
			delete _pending[uri];
			use namespace proxy;
			_pendingObject.adoptObject(object);
			use namespace AS3;
			
		}
		
	}

}