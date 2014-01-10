package pl.asria.tools.performance
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getTimer;
	import pl.asria.tools.managers.IJugglable;
	import pl.asria.tools.managers.SEnterFrameJuggler;
	import pl.asria.tools.performance.IChunk;
	
	/**
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	
	[Event(name="complete",type="flash.events.Event")]
	[Event(name="cancel", type="flash.events.Event")]
	public final class Chunk extends EventDispatcher implements IJugglable
	{
		public static const STATUS_IDLE:uint = 0x01;
		public static const STATUS_PAUSED:uint = 0x02;
		public static const STATUS_IN_PROGRESS:uint = 0x04;
		public static const STATUS_NEVER_CALCULATED:uint = 0x08;
		public static const STATUS_BREAKED:uint = 0x0F;
		
		public var status:uint = STATUS_IDLE | STATUS_NEVER_CALCULATED;
		
		private var _dynamicChunk:Boolean;
		private var _chunk:IChunk;
		private var _frameTime:int;
		private var _lastTimeUpdate:int;
		private var _timestamp:int;
		private var _counter:uint= 0;
		private var _startChunkTime:int = 0;
		
		
		/**
		 * 
		 * @param	chunk			Chunked Object
		 * @param	dynamicChunk	If true then, chunks are adaptated to current usage of CPU
		 * @param	frameTime	Max chunk time for calculations 1000/FPS
		 */
		public function Chunk(chunk:IChunk, dynamicChunk:Boolean = true, frameTime:uint = 1000):void
		{
			var fps:int = 30;
			
			_frameTime = frameTime;
			_lastTimeUpdate = _frameTime;
			
			_chunk = chunk;
			_dynamicChunk = dynamicChunk;
			
			//_addIntervaleHandler();
		}
		
		private function _addIntervaleHandler():void
		{
			_startChunkTime = getTimer() - _startChunkTime;
			SEnterFrameJuggler.register(this);
			
		}
		private function _removeIntervaleHandler():void
		{
			_startChunkTime = getTimer() - _startChunkTime;
			SEnterFrameJuggler.unregister(this);
		}

		
		public function update(offestTime:int):void 
		{
			_counter++;
			var stopValue:int;
			if (_dynamicChunk)
			{
				if (offestTime > _frameTime && _lastTimeUpdate > 1)
				{		
					_lastTimeUpdate--;
				}
				else
				{
					_lastTimeUpdate = _lastTimeUpdate < _frameTime ? _lastTimeUpdate + 1 : _lastTimeUpdate;
				}
				stopValue = _lastTimeUpdate;
			}
			else
				stopValue = _frameTime;
				
			_timestamp = getTimer();
			while (_chunk.updateChunk())
			{
				if (getTimer() - _timestamp > stopValue)
				{
					return;
				}
			}
			_removeIntervaleHandler();
			complete();
		}
		
		protected function complete():void 
		{
			trace("Chunk complete in:", _startChunkTime , "ms, splitted on", _counter, "chunks,\nChunk name:\t" + _chunk.chunkName);
			
			dispatchEvent(new Event(Event.COMPLETE));
			status &= ~(STATUS_PAUSED | STATUS_IN_PROGRESS | STATUS_BREAKED);
			status |= STATUS_IDLE;
		}
		
		public function start():Chunk
		{
			status &= ~(STATUS_IDLE | STATUS_PAUSED | STATUS_BREAKED | STATUS_NEVER_CALCULATED);
			status |= STATUS_IN_PROGRESS;
			
			_chunk.resetChunk();
			_timestamp = getTimer();
			_addIntervaleHandler();
			_counter = 0;
			return this;
		}
		
		/**
		 * Pause currenc calc process
		 * @return
		 */
		public function pause():Chunk
		{
			status &= ~(STATUS_IDLE | STATUS_BREAKED);
			status |= (STATUS_PAUSED | STATUS_IN_PROGRESS);
			_removeIntervaleHandler();
			return this;
		}
		
		/**
		 * resuma calc progres after pause
		 * @return
		 */
		public function resume():Chunk
		{
			if (status & STATUS_PAUSED)
			{
				status &= ~(STATUS_IDLE | STATUS_BREAKED | STATUS_PAUSED);
				status |= STATUS_IN_PROGRESS;
				
				_addIntervaleHandler();
				_timestamp = getTimer();
			}
			return this;
		}
		
		
		/**
		 * break calculate process, dispatch 
		 * @return
		 */
		public function stop():Chunk
		{
			status &= ~(STATUS_IN_PROGRESS | STATUS_PAUSED);
			status |= (STATUS_BREAKED | STATUS_IDLE);
			_chunk.resetChunk();
			_removeIntervaleHandler();
			_counter = 0;
			dispatchEvent(new Event(Event.CANCEL));
			_startChunkTime = 0;
			return this;
		}
		
		/* INTERFACE pl.asria.tools.managers.IJugglable */
		
		public function get enableJuggler():Boolean 
		{
			return true;
		}
		
		
		/**
		 * Variabe shoudn't be editable when calc process is in progress.
		 */
		public function get editable():Boolean 
		{
			return !(status & STATUS_IN_PROGRESS);
		}
		
		public function get chunkTime():int 
		{
			return _startChunkTime;
		}
		
		public function get frameTime():int 
		{
			return _frameTime;
		}
		
		public function set frameTime(value:int):void 
		{
			_frameTime = value;
		}
		
		public function get dynamicChunk():Boolean 
		{
			return _dynamicChunk;
		}
		
		public function set dynamicChunk(value:Boolean):void 
		{
			_dynamicChunk = value;
		}
		
	}
}