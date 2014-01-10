/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-05-23 11:05</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.display 
{
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import pl.asria.tools.event.ExtendEventDispatcher;
	
	/** 
	* Dispatched when target (data) animation hide is finished 
	**/
	[Event(name="endHide", type="pl.asria.tools.display.HudControllerEvent")]
	/** 
	* Dispatched when target (data) animation show is finished 
	**/
	[Event(name="endShow", type="pl.asria.tools.display.HudControllerEvent")]
	public class HudController extends ExtendEventDispatcher
	{
		//protected var panelContener:Sprite = new Sprite();
		//protected var vPanels:Vector.<Sprite> = new Vector.<Sprite>();
		//protected var currnetSelected:Sprite;
		//protected var _vStartState:Vector.<Object> = new Vector.<Object>();
		//protected var _vStopState:Vector.<Object> = new Vector.<Object>();
		//protected var vShowedFlags:Vector.<Boolean> = new Vector.<Boolean>();
		//protected var dPaneldHided:Dictionary = new Dictionary(true);
		//protected var _dTimes:Dictionary = new Dictionary(true);
		protected var _dPanels:Dictionary;
		protected var _content:Sprite;
		protected var _aQueue:Array;
		
		/**
		 * Default time if any parameter (in call or state definiton) is not set.
		 */
		public var $defaultTime:Number = 0.3;
		/**  **/
		public static const STATE_UNDEFINED:int = 0;
		public static const STATE_SHOWED:int = 1;
		public static const STATE_HIDED:int = 2;
		/**  **/
		public static const PROCESS_PENDING:String = "processPending";
	
		/**
		 * HudController - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function HudController() 
		{
			_dPanels = new Dictionary(true);
			_aQueue = [];
			initContent();
		}
		
		protected function initContent():void 
		{
			_content = new Sprite();
		}
			
		public function $addObject(target:Sprite, hideStateTween:Object, hideTime:Number, showStateTween:Object, showTime:Number,  noHideAll:Boolean = false):HudController
		{
			
			if (undefined == _dPanels[target])
			{
				_dPanels[target] = {
						showState:showStateTween,
						hideState:hideStateTween,
						hideTime:hideTime,
						showTime:showTime,
						noHideAll:noHideAll,
						state:STATE_UNDEFINED,
						onCompleteHide:hideStateTween.onComplete,
						onCompleteHideParams:hideStateTween.onCompleteParams,
						onCompleteShow:showStateTween.onComplete,
						onCompleteShowParams:showStateTween.onCompleteParams,
					};
				showStateTween.onComeplete = onComepleteShowHandler;
				showStateTween.onCompleteParams = [target];
				
				hideStateTween.onComeplete = onComepleteHideHandler;
				hideStateTween.onCompleteParams = [target];
			}

			return this;
		}
		
		protected function onComepleteHideHandler(target:Sprite):void 
		{
			var object:Object = _dPanels[target];
			
			if (object.onCompleteHide != null)
			{
				object.onCompleteHide.apply(null, object.onCompleteHideParams);
			}
			
			dispatchEvent(new HudControllerEvent(HudControllerEvent.END_HIDE, target));
		}
		
		protected function onComepleteShowHandler(target:Sprite):void 
		{
			var object:Object = _dPanels[target];
			
			if (object.onCompleteShow != null)
			{
				object.onCompleteShow.apply(null, object.onCompleteShowParams);
			}
			
			dispatchEvent(new HudControllerEvent(HudControllerEvent.END_SHOW, target));
		}
		
		
		
		protected function adoptState(target:Object, tweenState:Object):void
		{
			for (var row:String in tweenState)
				{
					if(target.hasOwnProperty(row))
						target[row] = tweenState[row];
				}
		}
		

		public function $show(object:Sprite):Hud
		{
			
			if (undefined != _dPanels[object])
			{
				var data:Object = _dPanels[object];
				if (data.state == STATE_UNDEFINED)
				{
					adoptState(object, data.hideState);
					data.state = STATE_HIDED;
				}
				_content.addChild(object);
				
				if (data.state == STATE_HIDED)
				{
					// add to queye
					_aQueue.push( {state:STATE_SHOWED, target:object, process:PROCESS_PENDING} );
					
					// flush queye
					checkQueue();
				}
			}
			return this;
		}
		
		protected function checkQueue():void 
		{
			//if()
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