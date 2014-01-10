package pl.asria.tools.performance.example 
{
	import flash.utils.getTimer;
	import pl.asria.tools.performance.IChunk;
	import pl.asria.tools.performance.Memorize;
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public class ChunkCalcExample implements IChunk
	{
		private var __array:Array;
		private var _lengthDimm:int;
		private var _i:int = 0;
		private var _call:Function;
		
		public function ChunkCalcExample(leng:int = 100000) 
		{
			_lengthDimm = leng;
			__array = [];
			for (var i:int = 0; i < leng; i++) 
			{
				__array.push(i%200);
			}
			//_call =powSilnia;
			_call = Memorize.memoize(powSilnia);
			//referenceTest();
		}
		
		/* INTERFACE pl.asria.tools.performance.IChunk */
		
		public function resetChunk():void 
		{
			_i = 0;
		}
		
		public function updateChunk():Boolean 
		{
			_call(__array[_i++]);
			return _i < _lengthDimm;
		}
		private function powSilnia(n:int):int
		{
			var ret:int;
			while (n--)
				ret += silnia(n);
			return ret;
		}
		
		private function silnia(n:int):int
		{
			return n==0?silnia(n-1)*n:1;
		}
		
		private function referenceTest():void
		{
			var __time:int = getTimer();
			for (var i:int = 0; i < _lengthDimm; i++) 
			{
				powSilnia(__array[i]);
			}
			trace("reference time: ", getTimer()-__time);
		}
	}

}