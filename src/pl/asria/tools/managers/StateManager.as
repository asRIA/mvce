package pl.asria.tools.managers 
{
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	[Event(name="change", type="pl.asria.tools.managers.StateManagerEvent")]
	[Event(name="partState", type="pl.asria.tools.managers.StateManagerEvent")]
	[Event(name="joinState", type="pl.asria.tools.managers.StateManagerEvent")]
	public class StateManager extends EventDispatcher
	{
		private var _vStates:Vector.<String> = new Vector.<String>();
		
		
		/**
		 * ...
		 * @author Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function StateManager(...initStates) 
		{
			if (initStates.length) $addStates(initStates);
		}
		
		public function $addStates(states:Array):void
		{
			for (var i:int = 0, i_max:int = states.length; i < i_max; i++) 
			{
				$addState(states[i]);
			}
		}
		public function $addState(state:String):void
		{
			if(_vStates.indexOf(state)<0)_vStates.push(state);
		}
		public function $setState(state:String):void
		{
			if (_vStates.indexOf(state) < 0)
			{
				_vStates.push(state);
				dispatchEvent(new StateManagerEvent(StateManagerEvent.JOIN_STATE,state));
				dispatchEvent(new StateManagerEvent(StateManagerEvent.CHANGE,null));
			}
		}
		
		public function $removeState(state:String):Boolean
		{
			var index:int = _vStates.indexOf(state) 
			if (index < 0) return false
			else
			{
				_vStates.splice(index, 1);
				dispatchEvent(new StateManagerEvent(StateManagerEvent.PART_STATE,state));
				dispatchEvent(new StateManagerEvent(StateManagerEvent.CHANGE, null));
			}
			return true
		}
		
		public function $isState(state:String):Boolean
		{
			return _vStates.indexOf(state) >= 0;
		}
		
		
		/**
		 * Templaraty usage of state, not care about remove this state anymore
		 * @param	state
		 * @return
		 */
		
		public function $impulsState(state:String):StateManager
		{
			var index:int = _vStates.indexOf(state) 
			if (index < 0) _vStates.push(state);
			dispatchEvent(new StateManagerEvent(StateManagerEvent.CHANGE, null));
			dispatchEvent(new StateManagerEvent(StateManagerEvent.JOIN_STATE, state));
			if (index < 0) _vStates.pop();
			return this;
		}
		
		public function $clear():StateManager
		{
			_vStates = new Vector.<String>();
			dispatchEvent(new StateManagerEvent(StateManagerEvent.CHANGE,null));
			return this;
		}
		
		public function $length():int
		{
			return _vStates.length;
		}
		
		
		public function $currentStates():Array 
		{
			var states:Array = [];
			for (var i:int = 0; i < _vStates.length; i++) 
			{
				states[i] = _vStates[i];
			}
			return states;
		}
	}

}