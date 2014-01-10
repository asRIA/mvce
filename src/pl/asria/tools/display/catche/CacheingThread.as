/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2013-02-08 11:47</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.display.catche 
{
	import pl.asria.tools.managers.IJugglable;
	import pl.asria.tools.performance.IChunk;
	
	public class CacheingThread implements IJugglable, IChunk
	{
		
		/** reference to singleton Class **/
		private static var _instance:CacheingThread;
		/** private lock to avoid usage constuctor. **/
		private static var _lock:Boolean = true;
		
		public static function get instance():CacheingThread 
		{
			if(null == _instance) 
			{
				_lock = false;
				_instance = new CacheingThread();
				_lock = true;
			}
			return _instance;
		}
		
		/**
		 * Singleton Class of CacheingThread - 
		 * @usage - access via: .instance only
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function CacheingThread() 
		{
			if(_lock) throw new Error("CacheingThread is a Singleton Design Pattern, please use CacheingThread.instance to get definition");
			
		}
		
		/* INTERFACE pl.asria.tools.managers.IJugglable */
		
		public function get enableJuggler():Boolean 
		{
			return _enableJuggler;
		}
		
		public function update(offestTime:int):void 
		{
			
		}
		
		public function reqister(seqwence:CachedSeqwence):void
		{
			
		}
		
		/* INTERFACE pl.asria.tools.performance.IChunk */
		
		public function resetChunk():void 
		{
			
		}
		
		public function updateChunk():Boolean 
		{
			
		}
	}
}