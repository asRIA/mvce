package pl.asria.tools.display 
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Piotr Paczkowski
	 */
	public class Hud extends Sprite
	{
		protected var panelContener:Sprite = new Sprite();
		protected var vPanels:Vector.<Sprite> = new Vector.<Sprite>();
		protected var currnetSelected:Sprite;
		protected var _vStartState:Vector.<Object> = new Vector.<Object>();
		protected var _vStopState:Vector.<Object> = new Vector.<Object>();
		protected var vShowedFlags:Vector.<Boolean> = new Vector.<Boolean>();
		protected var dPaneldHided:Dictionary = new Dictionary(true);
		protected var _dTimes:Dictionary = new Dictionary(true);
		protected var _dPanels:Dictionary = new Dictionary(true);
		
		/**
		 * Default time if any parameter (in call or state definiton) is not set.
		 */
		public var $defaultTime:Number = 0.3;
		public function Hud() 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
			addChild(panelContener);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		/**
		 * 
		 * @param	definition
		 * @param	startStateTween accept any TweenLite, and TweenMax definition object, in addiction you can add parameter "time"
		 * @param	stopStateTween
		 * @param	noHideAll
		 * @return
		 */
		public function $addObject(definition:Sprite, startStateTween:Object, stopStateTween:Object, noHideAll:Boolean = false):Hud
		{
			
			if (undefined == _dPanels[definition])
			{
				_dPanels[definition]
			}
			if (vPanels.indexOf(definition) < 0)
			{
				//panelContener.addChild(definition);
				dPaneldHided[definition] = noHideAll;
				vPanels.push(definition);
				_vStartState.push(startStateTween);
				_vStopState.push(stopStateTween);
				vShowedFlags.push(false);
				
				if (undefined != stopStateTween.time)
					_dTimes[stopStateTween] = stopStateTween.time;
				
				if (undefined != startStateTween.time)
					_dTimes[startStateTween] = startStateTween.time;
					
				delete stopStateTween.time;
				delete startStateTween.time;
					
				for (var row:String in startStateTween)
				{
					if(definition.hasOwnProperty(row))
						definition[row] = startStateTween[row];
				}
			}		
			return this;
		}
		
		/**
		 * 
		 * @param	object
		 * @param	delay
		 * @param	time time is not required, in first order, this parameter is geting from state definition
		 * @return	instance Hud, 
		 * @usage	please add panel to Hud at first
		 */
		public function $show(object:Sprite, delay:Number=0, time:Number = NaN):Hud
		{
			
			if (vPanels.indexOf(object) < 0) 
			{
				trace( "Hud.show > not defined object in Hud object : " + object);
				return this;// throw new Error("Please add at first!");
			}
			panelContener.addChild(object);

			if (!vShowedFlags[vPanels.indexOf(object)]) 
			{
				_vStopState[vPanels.indexOf(object)].delay = delay;
				runTween(object, _vStopState[vPanels.indexOf(object)],time);
				_vStopState[vPanels.indexOf(object)].delay = 0;
				vShowedFlags[vPanels.indexOf(object)] = true;
			}
			currnetSelected = object;
			return this;
		}
		
		public function $hide(object:Sprite, time:Number = NaN):Hud
		{
			if (vPanels.indexOf(object) < 0) 
			{
				trace( "Hud.hide > not defined object in Hud object : " + object);
				return this;// throw new Error("Please add at first!");
			}
			if (vShowedFlags[vPanels.indexOf(object)]) 
			{
				runTween(object, _vStartState[vPanels.indexOf(object)],time);
				vShowedFlags[vPanels.indexOf(object)] = false;
			}
			return this;
		}
		
		
		public function $hideAll():Hud
		{
			for each (var cur:Sprite in vPanels)
			{
				if(dPaneldHided[cur] == false) $hide(cur);
			}
			return this;
		}
		
		public function $togleCurrent():void
		{
			if (vShowedFlags[vPanels.indexOf(currnetSelected)])
				runTween(currnetSelected, _vStopState[vPanels.indexOf(currnetSelected)]);
			else
				runTween(currnetSelected, _vStartState[vPanels.indexOf(currnetSelected)]);
		}
		
		
		
		/**
		 * 
		 * @param	object
		 * @param	tweeenParameters
		 * @param	time param time is not required because in default its take from state parameters(atribute "time"), but if you declarate wana to set special time, then you can use this parameter
		 * @usage	runTween(myHud, myHudStartState) // get all params from myHudStartState object, if myHudStartState.time is undefined, then set default value this.defaultTime
		 * 			runTween(myHud, myHudStartState, 10) get 10s to time animation
		 * @return
		 */
		protected function runTween(object:DisplayObject, tweeenParameters:Object, time:Number = NaN):TweenLite
		{
			if (isNaN(time) && _dTimes[tweeenParameters]!= undefined)
			{
				time = _dTimes[tweeenParameters];
			}
			else
			{
				time = $defaultTime;
			}
			return TweenMax.to(object, time, tweeenParameters);
		}
	}

}