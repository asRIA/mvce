/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-06-24 16:07</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.display.catche 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.system.System;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	import pl.asria.tools.managers.IJugglable;
	import pl.asria.tools.managers.SEnterFrameJuggler;
	import pl.asria.tools.performance.GarbageCollector;
	import pl.asria.tools.performance.WeakReference;
	import pl.asria.tools.utils.getInstance;
	
	/** 
	* Dispatched if dispatchFrameOnEnd is set true, then after jump to last frame this event will be dispatched
	**/
	[Event(name="complete", type="flash.events.Event")]
	public class CachedSeqwence extends MovieClip implements IJugglable
	{
		protected var _source:Sprite;
		protected var _uid:String;
		protected var _totalFrames:int;
		protected var _currentFrame:int;
		protected var _fps:int = 30;
		protected var _seqwence:SeqwenceFrames;
		
		
		protected static var _pendingToCache:int;
		protected static var _currentCached:int;
		
		protected static const _dLiblary:Dictionary = new Dictionary(); //main storage of cached elements - SeqwenceFrames
		protected static const _dWeakLiblary:Dictionary = new Dictionary(true); // vector of reference to this UID 
		protected static const _dExtraWeekKeepersTime:Dictionary = new Dictionary(true); // extra protector to omit flush 
		protected static var _aPendingGC:Array = []; //elements without current active reference, pendint to flush accordind to timeout - keys and timestamp
		protected static var _aPendingFlushGC:Array = []; // final storage to dispoze memory - only keys
		
		protected var _played:Boolean;
		protected var _aFrameScripts:Array;
		protected var _vFrames:Vector.<SingleFrame>;
		protected var _pause:Boolean;
		protected var _cachemode:int;
		protected var _renderer:Renderer;
		protected var currentOnFrameFunction:Function;
		
		public static var MAX_CACHEING_THREADS:uint = 1;
		
		
		/**
		 * No cache, only control source MovieCLip
		 */
		public static const CACHE_MODE_NONE:int = 0;

		/**
		 * look at CACHE_THREADS, if is no permission to cache then is show source img 
		 */
		public static const CACHE_MODE_DIRECT:int = 1;
		
	   
	   /**
		* Cache without looking at CACHEIN_THREADS
		*/
		public static const CACHE_MODE_FORCE:int = 3;
		
		/**
		 * This is dynamic cached, according to available CACHE_THREADS
		 */
		public static const CACHE_MODE_ON_COMPLETE:int = 2;
		
		
		/**
		 * After cache all frames
		 */
		protected static const CACHE_MODE_CACHED:int = 1000;
		
		
		//determine that current SachedSeqwence is cacheing runtime
		protected var _isCacheing:Boolean;
		protected var _nextFrame:int;
		protected var _initCacheMode:int;
		protected var _scaleX:Number;
		protected var _scaleY:Number;
		protected var _rotation:Number;
		protected var _weakReference:WeakReference;
		protected var _currentLabels:Array;
		protected var _animSource:MovieClip;
		protected var _dispatchCompleteOnEnd:Boolean;
		protected var _totalSpendTime:int = 0;
		protected var _frameTime:Number = 1000 / 60;
		protected var _frameTimeInvert:Number = 60 / 1000;
		protected var _fpsMode:Boolean;

		// static constuctor and register in GarbageCollector mechanizm
		{
			GarbageCollector.registerFlushGarbages(flushGC);
			GarbageCollector.registerGarbagesCollector(gc);
		}
		
		
		private static function dispose(key:String):void
		{
			if (_dLiblary[key])
			{
				var v:SeqwenceFrames = _dLiblary[key];
				trace( "0:CachedSeqwence.dispose key  [" + key +"] with "+v.vFrames.length+" frames");
				v.destroy();
			}
			
			delete _dLiblary[key];
			delete _dWeakLiblary[key];
			delete _dExtraWeekKeepersTime[key];
			
		}
		
		/**
		 * Check that exists unlinked bitmap definition, and add to pending queue to flush. flushGC can be done manual, or after switch GarbageCollector.enabled to true.
		 */
		private static function gc():void
		{
			var v:Vector.<WeakReference>;
			var gcReady:Boolean;
			var _ts:int = getTimer();
			for (var key:String in _dWeakLiblary) 
			{
				v = _dWeakLiblary[key];
				gcReady = true;
				
				for (var i:int = v.length -1; i >= 0; i--) 
				{
					if (v[i].$)
					{
						gcReady = false;
						break;
					}
					else
					{
						v.pop();
					}
				}
				if (gcReady)
				{
					var timeToFlush:int = _dExtraWeekKeepersTime[key];
					if (timeToFlush >= 0)
					{
						_aPendingGC.push({key:key, ts:timeToFlush+_ts});
						trace("0:CachedSeqwence.gc, add to pending flush:" + key, "in time:", timeToFlush, "ms");
					}
					delete _dWeakLiblary[key];
				}
			}
			
			var __pending:Array = [];
			var i_max:int = _aPendingGC.length;
			for (i = 0; i < i_max; i++) 
			{
				if (_aPendingGC[i].ts <= _ts)
				{
					_aPendingFlushGC.push(_aPendingGC[i].key);
				}
				else
				{
					__pending.push(_aPendingGC[i]);
				}
			}
			_aPendingGC = __pending;
			
		}
		
		/**
		 * Dispose every nodes collected by CachedSeqwence.gc (Garbage Collector) 
		 */
		private static function flushGC():void
		{
			if (_aPendingFlushGC.length)
			{
				var systemMemory:Number = System.totalMemoryNumber;
				for (var i:int = 0, i_max:int = _aPendingFlushGC.length; i < i_max; i++) 
				{
					dispose(_aPendingFlushGC[i]);
				}
				_aPendingFlushGC = [];
				systemMemory -= System.totalMemoryNumber;
				trace( "4:Animation.flushGC: save: " + int(systemMemory/1024)+"kb" );
				trace( "3:Animation.flushGC: pending: " + _aPendingGC.length + " nodes" );
			}
		}
		
		public static function getMemoryRaport():XML
		{
			var memoryRaport:XML = <CachedSeqwence ts={getTimer()}/>;
			var count:int = 0;
			var size:Number = 0;
			
			for (var key:String in _dLiblary) 
			{
				var sf:SeqwenceFrames = _dLiblary[key];
				if (sf)
				{
					var sfRaport:XML = sf.getMemoryRaport();
					sfRaport.@uid = key;
					
					memoryRaport.appendChild(sfRaport);
					count++;
					size += parseFloat(sfRaport.@size);
				}
			}
			memoryRaport.@count = count;
			memoryRaport.@size = size;
			
			
			return memoryRaport;
		}
		
		/**
		 * This function: Create CacheSeqwence according to passed arguments. If some object has parent, then this instance of CachedSeqvence will be injected into parent of source object
		 * @param	source - display object to cache
		 * @param	uid	- sume unique ID of graphic, if this graphic has linkage class name, you can pass 'null' then uid will be equals of class name
		 * @param	initCacheMode - some static values from CachedSeqwence, default: CachedSeqwence.CACHE_MODE_DIRECT
		 * @param	scaleX	- if <code>NaN</code> then scaleX will be equals source scaleY
		 * @param	scaleY - if <code>NaN</code> then scaleY will be equals source scaleX
		 * @param	rotation - if <code>NaN</code> then rotation will be equals source rotation
		 * @return
		 */
		public static function createAndInject(source:Sprite, uid:String = null, initCacheMode:int = 1, scaleX:Number = NaN, scaleY:Number = NaN, rotation:Number = NaN):CachedSeqwence
		{
			var _parent:DisplayObjectContainer = source.parent;
			var _index:int = _parent ? _parent.getChildIndex(source) : -1;
			var seq:CachedSeqwence = new CachedSeqwence(source, uid, initCacheMode, scaleX, scaleY, rotation);
			if (_index >= 0) _parent.addChildAt(seq, _index);
			
			seq.x = source.x;
			seq.y = source.y;
			
			return seq;
		}
		
		public static function getOrCreateSeqwenceFrames(uid:String, frames:int):SeqwenceFrames
		{
			if (!_dLiblary[uid]) _dLiblary[uid] = new SeqwenceFrames(frames);
			return _dLiblary[uid];
		}
		
		public static function isDefinedUID(uid:String):Boolean 
		{
			return _dLiblary[uid];
		}
		
		public static function isDefinedAndCachedUID(uid:String):Boolean 
		{
			var cf:SeqwenceFrames = _dLiblary[uid];
			return cf && cf.completed;
		}
		public static function isDefined(uid:String, scaleX:Number, scaleY:Number, rotation:Number):Boolean 
		{
			uid = uid + [scaleX, scaleY, rotation].join("_");
			return _dLiblary[uid];
		}
		
		public static function isDefinedAndCached(uid:String, scaleX:Number, scaleY:Number, rotation:Number):Boolean 
		{
			uid = uid + [scaleX, scaleY, rotation].join("_");
			var cf:SeqwenceFrames = _dLiblary[uid];
			return cf && cf.completed;
		}
		
		
		/**
		 * CachedSeqwence - Automated cacheing system with features - 
		 * - cache with preview
		 * - cache queue with editable limit
		 * - force cacheing
		 * - cache livetime, but render prototype of animation
		 * - update cacheind seqvence after cacheing (for example, after change label in animation)
		 * - crate different prototypes for combinations of scale/rotation
		 * - implement Renderer with improveSmoothing(pixelSnapping and smoothing of bitmaps it is general failure of Flash)
		 * - support weak reference, so after some periodic time of not usaga animation, space will bi disposed
		 * - support frames from prototype
		 * - support addFrameScript
		 * @usage - 
		 * @version - 1.4
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 * @param	source - display object to cache, you can pass null, but only if you are sure that UID with set scaleX, scaleY and rotation exist in system (for example by preacacheing system)
		 * @param	uid	- sume unique ID of graphic, if this graphic has linkage class name, you can pass 'null' then uid will be equals of class name
		 * @param	initCacheMode - some static values from CachedSeqwence, default: CachedSeqwence.CACHE_MODE_DIRECT
		 * @param	scaleX	- if <code>NaN</code> then scaleX will be equals source scaleY
		 * @param	scaleY - if <code>NaN</code> then scaleY will be equals source scaleX
		 * @param	rotation - if <code>NaN</code> then rotation will be equals source rotation
		 */
		public function CachedSeqwence(source:Sprite, uid:String = null, initCacheMode:int = 1, scaleX:Number = NaN, scaleY:Number = NaN, rotation:Number = NaN):void 
		{
			uid = uid || getQualifiedClassName(source);
			
			if (!isNaN(scaleX)) 
			{
				if(source) source.scaleX = scaleX
			}
			else scaleX = source.scaleX;
			
			if (!isNaN(scaleY) ) 
			{
				if(source) source.scaleY = scaleY
			}
			else scaleY = source.scaleY;
			
			if (!isNaN(rotation) )
			{
				if(source) source.rotation = rotation
			}
			else rotation = source.rotation;
			
			
			_scaleX = scaleX;
			_scaleY = scaleY;
			_rotation = rotation;
			
			var tansforms:Array = [scaleX, scaleY, rotation];
			
			_uid = uid + "_" + tansforms.join("_");
			
			
			// remove from pending to flush
			for (var i:int = 0, i_max:int = _aPendingGC.length; i < i_max; i++) 
			{
				if (_aPendingGC[i].key == _uid)
				{
					_aPendingGC.splice(i, 1);
					break;
				}
			}
			_aPendingFlushGC.splice(_aPendingFlushGC.indexOf(_uid), 1);
			
			
			_source = source;
			if (!_source && uid && !isDefinedAndCachedUID(_uid)) _source = getInstance(uid);
			if (_source && _source is MovieClip)
			{
				_animSource = _source as MovieClip;
				_animSource.stop();
				_totalFrames = _animSource.totalFrames;
				_currentFrame = _animSource.currentFrame - 1;
				_nextFrame = (_currentFrame + 1) % _totalFrames;
				_initCacheMode = initCacheMode;
				_currentLabels  = _animSource.currentLabels;
			}
			else
			{				
				_totalFrames = 1;
				_initCacheMode = CACHE_MODE_FORCE;
				_currentLabels = []
			}
			
			_renderer = new Renderer();
			
			if (!_dWeakLiblary[_uid])
			{
				_dWeakLiblary[_uid] = new Vector.<WeakReference>();
			}
			
			_weakReference = new WeakReference(this);
			_dWeakLiblary[_uid].push(_weakReference);
			
			_seqwence = getOrCreateSeqwenceFrames(_uid, _totalFrames);
			
			_vFrames = _seqwence.vFrames;
			
			if (!_seqwence.completed)
			{
				//if (_vFrames.length > _totalFrames) _totalFrames = _vFrames.length;
				_pendingToCache++;
				cachemode = _initCacheMode;
			}
			else 
			{
				cachemode = CACHE_MODE_CACHED;
				_totalFrames = _seqwence.vFrames.length;
				_currentFrame = 0;
			}
			
			_aFrameScripts = [];
			_played = false;
			
			_seqwence.addEventListener(Event.COMPLETE, completeCachedHandler, false, 0, true);
			_seqwence.addEventListener(Event.REMOVED, removedCachedHandler, false, 0, true);
			
			// jump to current frame, show render
			currentOnFrameFunction();
			
			// check cache
		}
		
		/** according to available threads
		 * Secure from remove from GC for time 
		 * @param	time -1 -> always time in ms
		 */
		public function keepFromGC(time:int):CachedSeqwence
		{
			_dExtraWeekKeepersTime[_uid] = time;
			return this;
		}
		
		protected function removedCachedHandler(e:Event):void 
		{
			_pendingToCache++;
			cachemode = _initCacheMode;
			currentOnFrameFunction();
		}
		
		protected function set cachemode(value:int):void 
		{
			_cachemode = value;
			switch(_cachemode)
			{
				case CACHE_MODE_FORCE:
					currentOnFrameFunction = onEnterFrame_cacheForce;
					displayRenderer();
					break;
				case CACHE_MODE_DIRECT:
					currentOnFrameFunction = onEnterFrame_cacheDirect;
					displayRenderer();
					break;
						
				case CACHE_MODE_NONE:
					currentOnFrameFunction = onEnterFrame_cacheNone;
					displaySource();
					break;
					
				case CACHE_MODE_ON_COMPLETE:
					currentOnFrameFunction = onEnterFrame_cacheOnComplete;
					displaySource();
					break;
					
				case CACHE_MODE_CACHED:
					currentOnFrameFunction = onEnterFrame_cachePlayBack;
					displayRenderer();
					break;
					
				default:
					throw new IllegalOperationError("Illegal value of cache mode");
					break;
			}
		}
		
		
		/**
		 * Move content of this cache aniamtion to unique space
		 * @param	newUID
		 */
		public function makeUnique(newUID:String):void
		{
			throw new Error("Not implement yet");
		}
		
		/**
		 * If source changed, then refresh cachce seqwence. It works only on unique source animation.
		 */
		public function refreshCache():void
		{
			_seqwence.cleanFrames();
		}
		
		protected function completeCachedHandler(e:Event):void 
		{
			_pendingToCache--;
			cachemode = CACHE_MODE_CACHED;
			if (_isCacheing)
			{
				_currentCached--;
				_isCacheing = false;
			}
			currentOnFrameFunction();
		}
		
		protected function displaySource():void 
		{
			if (_renderer.parent) removeChild(_renderer);
			addChild(_source);
		}
		
		protected function displayRenderer():void 
		{
			if(_source && _source.parent) _source.parent.removeChild(_source);
			addChild(_renderer);
		}
		
		override public function get currentLabels():Array 
		{
			return _currentLabels;
		}
		
		public function getFrameInt(frame:Object):int 
		{
			var _frame:int;
			if (frame is String)
			{
				for each (var item:FrameLabel in _currentLabels) 
					if (item.name == (frame as String)) return item.frame;
			}
			else if (frame is FrameLabel)
			{
				return (frame as FrameLabel).frame;
			}
			else if (frame is int || frame is Number || frame is uint)
			{
				_frame = int(frame);
				_frame = _frame <= 0 ? 1 : _frame > _totalFrames ? _totalFrames : _frame;
				return _frame;
			}
			return 1;
		}
		
		/**
		 * Playback storaged frames as quick as it is possible
		 */
		protected function onEnterFrame_cachePlayBack():void
		{
			_renderer.render(_vFrames[_currentFrame]);
		}
		
		/**
		 * control source mC, pending to cache, can be assigned to loop command, only if mode is cacheind 
		 */
		protected function onEnterFrame_pendingToCacheSelectorRender():void
		{
			
			if (_currentCached < MAX_CACHEING_THREADS)
			{
				// add join to cache threads
				_currentCached++;
				cachemode = _cachemode; // refresh cache mode
				_isCacheing = true;
				displayRenderer();
				if (!_seqwence.isDefined(_currentFrame))
				{
					_seqwence.setFrame(_currentFrame, new SingleFrame(_source, _currentFrame+1));
				}
				_renderer.render(_vFrames[_currentFrame]);
			}
			else
			{
				if (_seqwence.isDefined(_currentFrame))
				{
					displayRenderer();
					_renderer.render(_vFrames[_currentFrame]);
				}
				else
				{
					displaySource();
					_animSource.gotoAndStop(_currentFrame);
				}
			}
		}
		
		/**
		 * control source mC, pending to cache, can be assigned to loop command, only if mode is cacheind 
		 */
		protected function onEnterFrame_pendingToCache():void
		{
			_animSource.gotoAndStop(_currentFrame);
			if (_currentCached < MAX_CACHEING_THREADS)
			{
				// add join to cache threads
				_currentCached++;
				cachemode = _cachemode; // refresh cache mode
				_isCacheing = true;
			}
		}
		
		/**
		 * control source mC
		 */
		protected function onEnterFrame_cacheNone():void
		{
			_animSource.gotoAndStop(_currentFrame);
		}
		
		/**
		 * Cache, but still displayed source MC
		 */
		protected function onEnterFrame_cacheOnComplete():void
		{
			_animSource.gotoAndStop(_currentFrame);
			if (!_seqwence.isDefined(_currentFrame))
			{
				_seqwence.setFrame(_currentFrame, new SingleFrame(_source, _currentFrame+1));
			}
		}
		
		/**
		 * Simillar to onEntarFrame_cacheDirect, but during play, condytion about available threads is not important
		 */
		protected function onEnterFrame_cacheForce():void
		{
			if (!_seqwence.isDefined(_currentFrame))
			{
				if (_seqwence.leftFrames > 1)
				{
					_seqwence.setFrame(_currentFrame, new SingleFrame(_source, _currentFrame+1));
					_renderer.render(_vFrames[_currentFrame]);					
				}
				else
				{
					_seqwence.setFrame(_currentFrame, new SingleFrame(_source, _currentFrame+1));
				}
			}
			else
			{
				_renderer.render(_vFrames[_currentFrame]);		
			}
		}
		
		/**
		 * Cache in progress, displayed is cached bitmap
		 */
		protected function onEnterFrame_cacheDirect():void
		{
			if (!_seqwence.isDefined(_currentFrame))
			{
				if (_seqwence.leftFrames > 1)
				{
					_seqwence.setFrame(_currentFrame, new SingleFrame(_source, _currentFrame+1));
					_renderer.render(_vFrames[_currentFrame]);					
				}
				else
				{
					_seqwence.setFrame(_currentFrame, new SingleFrame(_source, _currentFrame+1));
				}
			}
			else
			{
				_renderer.render(_vFrames[_currentFrame]);		
			}
		}
		
		public override function gotoAndStop(frame:Object, scene:String = null):void 
		{
			_currentFrame = getFrameInt(frame) - 1;
			_totalSpendTime = _frameTime * _currentFrame;
			
			_nextFrame = (_currentFrame + 1) % _totalFrames;
			currentOnFrameFunction();
			stop();
		}

		public override function gotoAndPlay(frame:Object, scene:String = null):void 
		{
			_currentFrame = getFrameInt(frame) - 1;
			_nextFrame = (_currentFrame + 1) % _totalFrames
			_totalSpendTime = _frameTime * _currentFrame;
			
			currentOnFrameFunction();
			play();
		}
		
		public override function play():void 
		{
			if (!_played && _totalFrames > 1)
			{
				SEnterFrameJuggler.register(this);
				_played = true;
				if (_cachemode == CACHE_MODE_DIRECT)
				{
					if (_currentCached >= MAX_CACHEING_THREADS)
					{
						if (_isCacheing) _currentCached--;
						_isCacheing = false;
						currentOnFrameFunction = onEnterFrame_pendingToCacheSelectorRender;
					}
					else
					{
						_currentCached++;
						_isCacheing = true;
					}
				}
				else if (_cachemode == CACHE_MODE_ON_COMPLETE)
				{
					if (_currentCached >= MAX_CACHEING_THREADS)
					{
						if (_isCacheing) _currentCached--;
						_isCacheing = false;
						currentOnFrameFunction = onEnterFrame_pendingToCache;
						displaySource();
					}
					else
					{
						_currentCached++;
						_isCacheing = true;
					}
				}
			}
		}
		
		public override function stop():void 
		{
			if (_played)
			{
				SEnterFrameJuggler.unregister(this);
				if (_isCacheing)
				{
					_currentCached--;
					_isCacheing = false;
				}
				_played = false;
			}
		}
		
		/**
		 * This is unofficial function from Adobe package. 
		 * @param	... rest : you have to pass <code>frame</code> and <code>callbacks</code>, you can pass more than one pair in the same time. Please note that frameNumber is 0 - based system. So first frame has 0, in oposition to Flash IDE, where first frame has number 1
		 * @example
		 * <code> addFrameScript(0, dispatchStartCallback, 10, callbackJointSomePoint)</code>
		 */
		override public function addFrameScript(... rest):void
		{
			for (var i:int = 0; i < rest.length; i = i + 2)
			{
				if (_aFrameScripts[rest[i]] == undefined)
				{
					_aFrameScripts[rest[i]] = new Vector.<Function>();
				}
				_aFrameScripts[rest[i]].push(rest[i + 1]);
				
			}
		}
		
		public override function nextFrame():void 
		{
			// why +2: normal _currentFrame in one less than playHed frame in normal MovieClip. so +1 is jum to current frame, +2 in next frame
			gotoAndStop(_currentFrame + 2);
			
		}
		
		public override function prevFrame():void 
		{
			gotoAndStop(_currentFrame);
		}
		
		override public function get totalFrames():int 
		{
			return _totalFrames;
		}
				
		override public function get currentFrame():int 
		{
			return _currentFrame + 1;
		}
		
		public function update(offestTime:int):void 
		{
			// teporaly solution to prevent skipping frames (never more frames than framerate)
			if (_fpsMode) 
			{
				if (offestTime > _frameTime) offestTime = _frameTime;
				{
					_totalSpendTime += offestTime;
				}
				_currentFrame = _totalSpendTime * _frameTimeInvert;
			}
			else _currentFrame++;
			_currentFrame %= _totalFrames;
			
			currentOnFrameFunction();
			runFrameScript(_currentFrame);
			_nextFrame = (_currentFrame + 1) % _totalFrames;
		}
		
		/**
		 * you can invoke frame script if exist
		 * @param	frame - 0 based system
		 */
		public function runFrameScript(frame:int):void 
		{
			if (_aFrameScripts[frame])
				for each (var frameFunction:Function in _aFrameScripts[frame])
					frameFunction();
			if (_dispatchCompleteOnEnd && (frame +1) == _totalFrames) dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function get enableJuggler():Boolean 
		{
			return !_pause;
		}
		
		public function get pause():Boolean 
		{
			return _pause;
		}
		
		public function set pause(value:Boolean):void 
		{
			_pause = value;
		}
		
		public function get source():Sprite 
		{
			return _source;
		}
		
		public function get renderer():Renderer 
		{
			return _renderer;
		}
		
		/**
		 * after last frame dispatch Event.COMPLETE
		 */
		public function get dispatchCompleteOnEnd():Boolean 
		{
			return _dispatchCompleteOnEnd;
		}
		
		public function set dispatchCompleteOnEnd(value:Boolean):void 
		{
			_dispatchCompleteOnEnd = value;
		}
		
		public function get fps():int 
		{
			return _fps;
		}
		
		public function set fps(value:int):void 
		{
			_fps = value;
			_frameTime = 1000 / _fps;
			_frameTimeInvert = _fps / 1000;
			_fpsMode = true
		}
	}

}