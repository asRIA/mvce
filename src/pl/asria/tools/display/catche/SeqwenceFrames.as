/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-06-24 18:42</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.display.catche 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getTimer;
	import pl.asria.tools.performance.GarbageCollector;
	
	/** 
	* Dispatched when when cached seqwence is completed 
	**/
	[Event(name="complete", type="flash.events.Event")]
	/** 
	* Dispatched when source data chenged, request re-cache animation
	**/
	[Event(name="removed", type="flash.events.Event")]
	public final class SeqwenceFrames extends EventDispatcher
	{
		protected var _length:int;
		protected var _vFrames:Vector.<SingleFrame>;
		protected var _cachedFrames:int;
		protected static const _pendingToFlush:Vector.<SingleFrame> = new Vector.<SingleFrame>();
		protected var _completed:Boolean;
		protected var _leftFrames:int;
		
		
		{
			GarbageCollector.registerFlushGarbages(flushGC);
		}
		
		private static function flushGC():void
		{
			while (_pendingToFlush.length)
			{
				var _frames:SingleFrame = _pendingToFlush.pop();
				if(_frames) _frames.clean();
			}
		}
	
		/**
		 * SeqwenceFrames - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function SeqwenceFrames(length:int) 
		{
			_length = length;
			_leftFrames = length;
			_vFrames = new Vector.<SingleFrame>(length);
		}
		
		public function setFrame(frame:int, data:SingleFrame):void
		{
			if (!_vFrames[frame])
			{
				_vFrames[frame] = data;
				
				if (data != null)
				{
					_cachedFrames++;
					_leftFrames = _length - _cachedFrames;
					_completed = _leftFrames == 0;
					if (_completed) dispatchEvent(new Event(Event.COMPLETE));					
				}
			}
			else
			{
				_pendingToFlush.push(_vFrames[frame]);
				_vFrames[frame] = data;
			}
		}
		
		public function isDefined(frame:int):Boolean
		{
			return _vFrames[frame] != null;
		}
		
		public function getFrame(frame:int):SingleFrame
		{
			frame = frame < 0 ? 0 : frame >= _length ? _length-1:frame;
			return _vFrames[frame];
		}
		
		public function cleanFrames():void
		{
			_completed = false;
			_cachedFrames = 0;
			
			// move frames to GC pending
			for (var i:int = 0, i_max:int = _vFrames.length; i < i_max; i++) 
			{
				if (_vFrames[i])
				{
					_pendingToFlush.push(_vFrames[i]);
					_vFrames[i] = null;
				}
			}
			
			dispatchEvent(new Event(Event.REMOVED));
		}
		
		public function destroy():void
		{
			for (var i:int = 0, i_max:int = _vFrames.length; i < i_max; i++) 
			{
				if(_vFrames[i]) _vFrames[i].clean();
			}
			_vFrames = null;
		}
		
		public function get completed():Boolean 
		{
			return _completed;
		}
		
		public function get vFrames():Vector.<SingleFrame> 
		{
			return _vFrames;
		}
		
		public function get leftFrames():int 
		{
			return _leftFrames;
		}
		
		
		public function clone():SeqwenceFrames
		{
			var result:SeqwenceFrames = new SeqwenceFrames(_length);
			for (var i:int = 0, i_max:int = _vFrames.length; i < i_max; i++) 
			{
				if (null != _vFrames[i])
				{
					result.setFrame(i, _vFrames[i].clone());
				}
			}
			return result;
		}
		
		public function getMemoryRaport():XML 
		{
			var memoryRaport:XML = <SeqwenceFrames ts={getTimer()}/>;
			var count:int = 0;
			var size:Number = 0;
			
			for (var i:int = 0, i_max:int = _vFrames.length; i < i_max; i++) 
			{
				var sf:SingleFrame = _vFrames[i];
				if (sf)
				{
					var sfRaport:XML = sf.getMemoryRaport();
					memoryRaport.appendChild(sfRaport);
					count++;
					size += parseFloat(sfRaport.@size);
					if (isNaN(size))
						trace("da"+1);
				}
			}
			memoryRaport.@count = count;
			memoryRaport.@size = size;
			return memoryRaport;
		}
	}

}