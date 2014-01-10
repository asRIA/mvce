package pl.asria.tools.factory 
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public class LoaderFactory 
	{
		private static const _cache:Dictionary = new Dictionary();
		public function LoaderFactory() 
		{
			
		}
		
		
		public static function getLoader(urlr:URLRequest, contex:LoaderContext = null):Loader
		{
			var result:Loader = new Loader();
			if (_cache[urlr])
			{
				result.loadBytes(_cache[urlr].bytes,contex);
			}
			else
			{
				result.load(urlr, contex);
				result.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler,false,int.MAX_VALUE);
				result.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError, false, int.MAX_VALUE);
				
			}
			
			return result;
		}
		
		static protected function onError(e:IOErrorEvent):void 
		{
			
		}
		
		static private function completeHandler(e:Event):void 
		{
			var laoder:Loader = e.currentTarget.loader;
			var ba:ByteArray = new ByteArray();
			ba.writeObject(laoder.loaderInfo.bytes);
			_cache[laoder.contentLoaderInfo.url] = {
				timestamp:getTimer(),
				bytes:ba
			}
		}
	}

}