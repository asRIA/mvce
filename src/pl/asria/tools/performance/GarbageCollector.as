/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-04-25 11:44</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.performance 
{
	import flash.events.TimerEvent;
	import flash.net.LocalConnection;
	import flash.system.System;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	
	public final class GarbageCollector 
	{
		protected static var _vFlushCallbacks:Vector.<Function> = new Vector.<Function>();
		protected static var _vCollectGarbages:Vector.<Function> = new Vector.<Function>();
		
		protected static var _enabled:Boolean = true;
		/**
		 * if<code> true</code> then with next switch to 'enabled' system runs native garbageCollector
		 */
		public static var enableFlushNativeGC:Boolean = false;
		
		/**
		 * if <code>true</code> after time GarbageCollector.WATCHDOG_TIMER GarbageCollector runs PullFactory.gc() and Animation.gc()
		 */
		public static var enablWatchdog:Boolean = true;
		
		
		private static const WATCHDOG_TIMER:int = 1000;
		
		private static var _lastTimestamp:uint;
		private static var _watchdodTime:uint = 5000;
		private static const _watchDog:Timer = new Timer(WATCHDOG_TIMER);
		
		// statci cosntructor
		{
			_watchDog.addEventListener(TimerEvent.TIMER, watchdogHandler);
			_watchDog.start();
			_lastTimestamp = getTimer();
		}
		
		
		private static function watchdogHandler(event:TimerEvent):void
		{
			if(enablWatchdog && (getTimer()-_lastTimestamp) >= _watchdodTime)
			{
				_lastTimestamp = getTimer();
				GarbageCollector.gc();
				
				if (_enabled)
				{
					GarbageCollector.flushGC();
				}
			}
		}
		
		/**
		 * Register garbage collecting process
		 * @param	gc	function without arguments, and voice typped
		 */
		public static function registerGarbagesCollector(gc:Function):void
		{
			if(_vCollectGarbages.indexOf(gc) < 0)
				_vCollectGarbages.push(gc);
		}
		
		/**
		 * Register functions to flush garbages collecteb ny collectiong proccess
		 * @param	flushGC	function without arguments, and voice typped
		 */
		public static function registerFlushGarbages(flushGC:Function):void
		{
			if(_vFlushCallbacks.indexOf(flushGC) < 0)
				_vFlushCallbacks.push(flushGC);
		}
		
		/**
		 * If this falue is enabled, then manegers like: PullFactory, Animation get perrmision to flush pending resources. Otherwise they are blocked
		 */
		public static function get enabled():Boolean 
		{
			return _enabled;
		}
		
		/**
		 * If this falue is enabled, then manegers like: PullFactory, Animation get perrmision to flush pending resources after some intervale. Otherwise they are blocked
		 */
		public static function set enabled(value:Boolean):void 
		{
			if (value && value != _enabled) 
			{
				GarbageCollector.flushGC();	
			}
			_enabled = value;
		}
		
		/**
		 * After every time interwale internal GarbageColector clean values. Please take a look on the WATCHDOG_TIME, because even whet watchdogTime will be set to 0, then it is possible to run next loop after GarbageCOllector.WATCHDOG_TIME
		 */
		public static function get watchdodTime():uint 
		{
			return _watchdodTime;
		}
		
		public static function set watchdodTime(value:uint):void 
		{
			_watchdodTime = value;
		}
		
		/**
		 * Collect resources to flush by GarbageCollector
		 */
		public static function gc():void
		{
			for (var i:int = 0, i_max:int = _vCollectGarbages.length; i < i_max; i++) 
			{
				_vCollectGarbages[i]();
			}
		}
		
		/**
		 * Flush and release resources collected by GarbageCollector
		 */
		public static function flushGC():void
		{
			var __time:int = getTimer();
			
			// flush managers
			for (var i:int = 0, i_max:int = _vFlushCallbacks.length; i < i_max; i++) 
			{
				_vFlushCallbacks[i]();
			}
			//trace("2:Flush GarbageColletor in time: ", getTimer() - __time, "ms");
			
			if (enableFlushNativeGC)
			{
				forceFlushNativeGC();
			}
		}
		
		/**
		 * Force run native garbage collector in FP9, FP10, FP11 (release player support) 
		 */
		public static function forceFlushNativeGC():void 
		{
			if ("pauseForGCIfCollectionImminent" in System)
			{
				System["pauseForGCIfCollectionImminent"](0.2);
				trace("2:Run System.pauseForGCIfCollectionImminent(0.2)")
			}
			else
			{
				try 
				{
					new LocalConnection().connect('game-factory.eu');
					new LocalConnection().connect('game-factory.eu');
				} 
				catch (e:*) 
				{
					trace("2:Force flush native GC by workaround")
				}
				
			}
			
		}
		
	}

}