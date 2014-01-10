/**
* CHANGELOG:
*
* 2012-01-14 10:12: Create file
*/
package pl.asria.tools.media.sound 
{
	import flash.display.MovieClip;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import pl.asria.tools.factory.Factory;
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public class SoundFactory 
	{
		private static const _dSoundGenerators:Dictionary = new Dictionary();
		private static const _dSoundsLoaders:Dictionary = new Dictionary();
		/**
		 * TODO: 
		 * PullFactory:
			 * garbage coolector
			 * poolobject : time periodic, min objects
		 * GameClock:
			 * pause
			 * play
			 * timeoutsCallbacks
		 */
		public function SoundFactory() 
		{

		}
		
		public static function getController(uri:String):SoundController
		{
			var soundControler:SoundController = new SoundController();
			var _loader:SoundLoader;
			if (_dSoundGenerators[uri] == undefined)
			{
				var sound:Sound = new Sound();
				var request:URLRequest = new URLRequest(uri)
				var watchdog:int = 3;
				sound.load(request);
				sound.addEventListener(IOErrorEvent.IO_ERROR, 
					function():void 
						{ 
							/*if (watchdog-->0) 
								sound.load(request);*/
							delete	_dSoundGenerators[uri];// = sound;
						}
					);
				_dSoundGenerators[uri] = sound;
			}
			soundControler.setSound(_dSoundGenerators[uri]);
			return soundControler;
		}
		
		public static function pushSound(uri:String, sound:Sound):void
		{
			_dSoundGenerators[uri] = sound;
		}
		
		/**
		 * 
		 * @param	uri
		 * @param	aplicationDomain
		 * @return
		 */
		public function getSound(uri:String, aplicationDomain:ApplicationDomain = null):SoundController
		{
			var constructor:Class;
			var soundObject:Sound;
			if(aplicationDomain && aplicationDomain.hasDefinition(uri))
			{
				constructor = aplicationDomain.getDefinition(uri) as Class;
				soundObject = new constructor() as Sound;
			}
			else
			{
				soundObject = Factory.generateObejct(uri);
			}
			
			if (soundObject)
			{
				
				var soundControler:SoundController = new SoundController();
				soundControler.setSound(soundObject);
				return soundControler;
			}
			return null
		}
	}

}