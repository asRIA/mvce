/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-06-20 11:20</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.managers 
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.getTimer;
	import org.osflash.signals.Signal;
	
	public class SEnterFrameJuggler 
	{
		
		private static var _timestamp:int = 0;
		private static const _detector:Shape = new Shape();
		protected static var _vJugglableObjects:Vector.<IJugglable> = new Vector.<IJugglable>();
		protected static var _pendingPush:Vector.<IJugglable> = new Vector.<IJugglable>();
		protected static var _pendingdDelete:Vector.<IJugglable> = new Vector.<IJugglable>();
		protected static var _process:Boolean;
		protected static var _dirty:Boolean;
		
		public static var updateSignal:Signal = new Signal(uint);
		/**
		 * inframes
		 */
		public static var FLUSH_GARBAGES_TTL:int = 600;
		private static var _watchDog:int;
		
		{
			_watchDog = FLUSH_GARBAGES_TTL;
			_timestamp = getTimer();
			_detector.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		
		/**
		 * Remove null nodes
		 */
		protected static function flushGarbages():void
		{
			var _jugglables:Vector.<IJugglable> = new Vector.<IJugglable>();
			for (var i:int = 0, i_max:int = _vJugglableObjects.length; i < i_max; i++) 
			{
				if (_vJugglableObjects[i] != null)_jugglables.push(_vJugglableObjects[i]);
			}
			_vJugglableObjects = _jugglables;
			_dirty = false;
		}

		
		private static function enterFrameHandler(e:Event):void
		{
			var _offset:int = getTimer() - _timestamp;
			_process = true;
			for (var i:int = 0, i_max:int = _vJugglableObjects.length; i < i_max; i++) 
			{
				if(_vJugglableObjects[i] && _vJugglableObjects[i].enableJuggler)
					_vJugglableObjects[i].update(_offset);
			}
			updateSignal.dispatch(_offset);
			_process = false;
			_timestamp += _offset;
			
			if (_pendingdDelete.length)
			{
				i_max = _pendingdDelete.length;
				for (i = 0; i < i_max; i++)
				{
					if (_pendingdDelete[i]) 
					{
						var index:int = _vJugglableObjects.indexOf(_pendingdDelete[i]);
						if(index >=0 )
						{
							_vJugglableObjects[index] = null;
							_dirty = true;
						}
					}
				}
				_pendingdDelete = new Vector.<IJugglable>();
			}
			if (_pendingPush.length)
			{
				i_max = _pendingPush.length;
				for (i = 0; i < i_max; i++)
				{
					if (_pendingPush[i] && _vJugglableObjects.indexOf(_pendingPush[i]) < 0) _vJugglableObjects.push(_pendingPush[i]);
				}
				_pendingPush = new Vector.<IJugglable>();
			}
			if (--_watchDog == 0) 
			{
				if(_dirty) flushGarbages();
				_watchDog = FLUSH_GARBAGES_TTL;
			}
		}
		
		public static function register(iteam:IJugglable):void 
		{
			if (_process)
			{
				var index:int = _pendingPush.indexOf(iteam);
				
				if (index < 0)
				{
					_pendingPush.push(iteam);
				}
				
				// check that object is pending to remove
				index = _pendingdDelete.indexOf(iteam);
				if (index >= 0) _pendingdDelete[index] = null;
				
			}
			else
			{
				if(_vJugglableObjects.indexOf(iteam) < 0) _vJugglableObjects.push(iteam);
			}
		}
		
		public static function unregister(iteam:IJugglable):void
		{
			if (_process)
			{
				var index:int;
				
				index = _pendingdDelete.indexOf(iteam)
				if (index < 0)
				{
					_pendingdDelete.push(iteam);
				}
				
				// check that object is pending to add
				index = _pendingPush.indexOf(iteam);
				if (index >= 0) _pendingPush[index] = null;
			}
			else
			{
				index = _vJugglableObjects.indexOf(iteam);
				if (index >= 0)
				{
					_vJugglableObjects[index] = null;
					_dirty = true;
				}
				
			}
		}
		

	}
}