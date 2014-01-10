/**
* CHANGELOG:
*
* 2012-01-15 19:59: Create file
*/
package pl.asria.tools.media.sound 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	[Event(name="getSoundComplete", type="pl.asria.tools.media.sound.SoundLoaderEvent")]
	[Event(name="progress", type="flash.events.ProgressEvent")]
	public class SoundLoader extends EventDispatcher
	{
		private var loader:URLLoader;
		private var autoClear:Boolean;
		private var data:ByteArray;
		private var bussy:Boolean = false;
		private var _complete:Boolean = false;
		private var _url:String;
		public function SoundLoader() 
		{
		}
		
		public function get loadedMode():Boolean { return Boolean(loader)}
		
		public function get complete():Boolean 
		{
			return _complete;
		}
		
		public function get url():String 
		{
			return _url;
		}
		public function load(urlRequest:URLRequest):void
		{
			_url = urlRequest.url;
			bussy = true;
			_complete = false;
			loader = new URLLoader(urlRequest);
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(ProgressEvent.PROGRESS, progressLoaderEventHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, errorLoaderEventHandler);
			loader.addEventListener(Event.COMPLETE, completeLoaderEventHandler);
		}
		
		/**
		 * 
		 * @param	data
		 * @param	autoClear	clean source after complete load
		 */
		public function loadBin(data:ByteArray, autoClear:Boolean = true):void
		{
			_complete = false;
			bussy = true;
			loadBytes(data);
		}
		
		private function loadBytes(data:ByteArray):void
		{
			this.data = data;
			var mp3Transcoder:MP3Transcoder = new MP3Transcoder();
			mp3Transcoder.addEventListener(MP3SoundEvent.COMPLETE, completeTranscodeHandler);
			mp3Transcoder.addEventListener(MP3SoundEvent.ERROR, errorTranscodeHabdler);
			mp3Transcoder.getSound(data);
		}
		
		private function errorTranscodeHabdler(e:MP3SoundEvent):void 
		{
			bussy = false;
		}
		private function completeTranscodeHandler(e:MP3SoundEvent):void 
		{
			data.clear();
			if (loader) (loader.data as ByteArray).clear();
			bussy = false;
			_complete = true;
			dispatchEvent(new SoundLoaderEvent(SoundLoaderEvent.GET_SOUND_COMPLETE, e.soundClass));
		}
		
		private function completeLoaderEventHandler(e:Event):void 
		{
			loadBytes((e.currentTarget as URLLoader).data);
		}
		
		private function errorLoaderEventHandler(e:IOErrorEvent):void 
		{
			loader = null;
			bussy = false;
			dispatchEvent(e.clone());
		}
		
		private function progressLoaderEventHandler(e:ProgressEvent):void 
		{
			dispatchEvent(e.clone());
		}
		
	}

}