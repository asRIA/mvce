package pl.asria.tools.event.display 
{
	import flash.display.MovieClip;
	import pl.asria.tools.display.IMultiState;
	/**
	 * ...
	 * @author Piotr Paczkowski
	 */
	public class MultiStateMovieClip extends MovieClip implements IMultiState
	{
		protected var _target:MovieClip;
		private var _baseState:String="";
		private var _subState:String="";
		public function MultiStateMovieClip(target:MovieClip = null) 
		{
			_target = target || this;
			_target.stop();
		}
		
		/* INTERFACE pl.asria.utils.display.IMultiState */
		
		public function set baseState(baseState:String):void
		{
			this._baseState = baseState;
		//	gotoCurrentState();
		}
		
		public function set subState(subState:String):void
		{
			this._subState = subState;
		//	gotoCurrentState();
		}
		
		public function gotoCurrentState():void
		{
			//trace("goto:", baseState + subState);
			_target.gotoAndStop(_baseState + _subState);
		}
		
		/* INTERFACE pl.asria.tools.display.IMultiState */
		
		
		public function get baseState():String 
		{
			return _baseState;
		}
		
		public function get subState():String 
		{
			return _subState;
		}
		
		public function get target():MovieClip 
		{
			return _target;
		}
		
	}

}