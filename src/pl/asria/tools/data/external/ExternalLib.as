/**
* CHANGELOG:
* 
* 2012-04-06 13:32: 1.2 : Add public state and isComplete
* 2012-03-14 10:43: 1.1 : Add ASDoc
* 2011-11-18 12:14: 1.0 : Create file
*/
package pl.asria.tools.data.external 
{
	import flash.display.Loader;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	import flash.utils.ByteArray;
	
	 /**
	  * In case some error of loeader
	  */
	[Event(name = "error", type = "flash.events.ErrorEvent")]
	
	/**
	 * Progress event of loader external lib
	 */
	[Event(name = "progress", type = "flash.events.ProgressEvent")]
	
	/** 
	* Dispatched when all data are loaded success 
	**/
	[Event(name="complete", type="flash.events.Event")]
	public class ExternalLib extends EventDispatcher
	{
		public static const NOT_INITED:uint = 0;
		public static const INITED:uint = 1;
		public static const READY:uint = 2;
		public static const ERROR:uint = 3;
		public static const DOWNLOADING:uint = 4;
		
		private var _loader:Loader;
		private var _state:int = NOT_INITED;
		private var _applicationDomain:ApplicationDomain;
		
		/**
		 * ...
		 * @author Piotr Paczkowski - kontakt@trzeci.eu
		 * @version	1.1
		 */
		public function ExternalLib():void
		{
			
		}
		
		/**
		 * Load data from byteArray 
		 * @param	swfObject
		 */
		public function loadBytes(swfObject:ByteArray = null, loaderContext:LoaderContext = null):void
		{
			_state = INITED;
			prepareLoader();
			_loader.loadBytes(swfObject,loaderContext);
		}
		private function prepareLoader():void
		{
			clean();
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, cmpLoaderHandler);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorEventHandler);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.NETWORK_ERROR, errorEventHandler);
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressEventHandler);
			
		}
		
		private function progressEventHandler(e:ProgressEvent):void 
		{
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, e.bytesLoaded, e.bytesTotal));
		}
		
		private function errorEventHandler(e:IOErrorEvent):void 
		{
			_state = ERROR;
			dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
		}
		
		private function cmpLoaderHandler(e:Event):void 
		{
			_applicationDomain = _loader.contentLoaderInfo.applicationDomain;
			_state = READY;
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/**
		 * Load external swf lib via URL
		 * @param	urlRequest
		 */
		public function loadURI(urlRequest:URLRequest, loaderContext:LoaderContext = null):void
		{
			prepareLoader();
			_loader.load(urlRequest,loaderContext);
			_state = DOWNLOADING;
		}
		
		/**
		 * Return instance of asset class name
		 * @param	className
		 * @return
		 */
		public function getAsset(className:String):*
		{
			var classDefinition:Class = getClass(className);
			if (classDefinition) return new classDefinition();
			return null;
		}
		
		
		/**
		 * Return class definition
		 * @param	className
		 * @return
		 */
		public function getClass(className:String):Class
		{
			if (_applicationDomain && _state == READY && _applicationDomain.hasDefinition(className))
			{
				var classDefinition:Class = _applicationDomain.getDefinition(className) as Class;
				return classDefinition;
			}
			return null;
		}
		
		
		/**
		 * Clean loader
		 */
		public function clean():void
		{
			_state = NOT_INITED;
			if (_loader)
			{
				_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, cmpLoaderHandler);
				_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, errorEventHandler);
				_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.NETWORK_ERROR, errorEventHandler);
				if(_loader.contentLoaderInfo.bytes)_loader.contentLoaderInfo.bytes.clear();
				try
				{
					_loader.close();
				}
				catch (e:Error)
				{
					trace("5:", e.message);
				}
			}
			
			_loader = null;
		}
		
		/**
		 * Is loaded complete
		 * @return
		 */
		public function isComplete():Boolean
		{
			return _state == READY;
		}
		/**
		 * Is loaded complete
		 * @return
		 */
		public function isInited():Boolean
		{
			return _state == INITED;
		}
		
		/**
		 * State of current lib
		 */
		public function get state():int 
		{
			return _state;
		}
		
		/**
		 * Application domain for loaded external libs, this property is in default taken from loaded asset lib
		 * @param	value
		 */
		public function setApplicationDomain(value:ApplicationDomain):void 
		{
			_applicationDomain = value;
		}
		
		public function getApplicationDomain():ApplicationDomain 
		{
			return _applicationDomain;
		}
		
		
	}

}