package pl.asria.tools.display.ui
{
	import com.greensock.plugins.*;
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import pl.asria.tools.event.ExtendEventDispatcher;
	
	/** 
	* Dispatched when ... 
	**/
	[Event(name="showBaloontip", type="pl.asria.tools.display.ui.BaloonTipManagerEvent")]
	/** 
	* Dispatched when mouse focused on some target, you can switch default register content to some condytion one. You can catch this event and replece PARAM_CONTENT; in PARAM_TARGET is current target. If it is not catched, thent content is default from BalonTip Settings
	**/
	[Event(name="preparateBaloontipContent", type="pl.asria.tools.display.ui.BaloonTipManagerEvent")]
	public class BaloonTipManager extends ExtendEventDispatcher
	{
		protected var _visible:Boolean;
		protected var _delayTime:int;
		
		
		public var delayTime:int = 1000;
		public var _dObjects:Dictionary = new Dictionary(true);
		
		public var _timer:Timer;
		protected var _currentFocused:DisplayObject;
		protected var _currentFocusedSettings:SettingsBaloonTip;
		protected var _stage:Stage;
		protected var _baloonTip:BaloonTip;
		protected var _enabled:Boolean;
		protected var _debug:Boolean = false;
		protected var _name:String;
		protected static const _dManagers:Dictionary = new Dictionary();
		
		public static function getManager(name:String):BaloonTipManager 
		{
			return _dManagers[name];
		}
		
		public function BaloonTipManager(delayTime:int, name:String = "default")
		{
			_name = name;
			var _counter:int = 0;
			while (undefined != _dManagers[_name])
			{
				_name = name + _counter.toString();
				_counter++;
			}
			_dManagers[_name] = this;
			
			_delayTime = delayTime;
			initTimmer();
			TweenPlugin.activate([BlurFilterPlugin]);
		}
		
		protected function initTimmer():void 
		{
			if(_debug) trace( "BaloonTipManager.initTimmer" );
			_timer = new Timer(_delayTime, 1);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteEvent);
			
		}
		
		protected function timerCompleteEvent(e:TimerEvent):void 
		{
			if(_debug) trace( "4:BaloonTipManager.timerCompleteEvent > e : " + e );
			_timer.stop();
			_baloonTip.show();
		}
		
		public function setBaloonTip(baloonTip:BaloonTip):void
		{
			if(_debug) trace( "BaloonTipManager.setBaloonTip > baloonTip : " + baloonTip );
			_baloonTip = baloonTip;
			_baloonTip.addEventListener(BaloonTipEvent.SHOW_BEGIN, beginShowBaloonTipHandler);
			_baloonTip.addEventListener(BaloonTipEvent.HIDE_BEGIN, hideShowBaloonTipHandler);
			_baloonTip.addEventListener(BaloonTipEvent.HIDE_END, endHideBaloonTipHandler);
			
		}
		
		protected function hideShowBaloonTipHandler(e:BaloonTipEvent):void 
		{
			if(_debug) trace( "BaloonTipManager.hideShowBaloonTipHandler > e : " + e );
			_visible = false;
		}
		
		protected function endHideBaloonTipHandler(e:BaloonTipEvent):void 
		{
			if(_debug) trace( "BaloonTipManager.endHideBaloonTipHandler > e : " + e );
			if(_baloonTip.parent)_baloonTip.parent.removeChild(_baloonTip);
		}
		
		protected function beginShowBaloonTipHandler(e:BaloonTipEvent):void 
		{
			_visible = true;
			if(_debug) trace( "BaloonTipManager.beginShowBaloonTipHandler > e : " + e );
			dispatchEvent(new BaloonTipManagerEvent(BaloonTipManagerEvent.SHOW_BALOONTIP));
			placementBaloontip();
		}
		
		protected function moveBaloontip():void 
		{
			if(_debug) trace( "BaloonTipManager.moveBaloontip" );
			_stage.addChild(_baloonTip);
			var position:Point = _currentFocusedSettings.getCoordinates(new Point(_stage.mouseX, _stage.mouseY));
			_baloonTip.x = position.x;
			_baloonTip.y = position.y;
		}
		
		protected function placementBaloontip():void 
		{
			if(_debug) trace( "BaloonTipManager.placementBaloontip" );
			_stage.addChild(_baloonTip);
			var position:Point = _currentFocusedSettings.getCoordinates(new Point(_stage.mouseX, _stage.mouseY));
			_baloonTip.x = position.x;
			_baloonTip.y = position.y;
		}
		
		public function clean():void
		{
			if(_debug) trace( "BaloonTipManager.clean" );
			if(_stage)
			{
				_stage.removeEventListener(MouseEvent.CLICK, clickTargetHandler);
				_stage = null;
			}
			
			for (var target:Object in _dObjects) 
			{
				if(target) unregisterTarget(target as DisplayObject);
			}
			delete _dManagers[_name];
			
		}
		
		public function registerTarget(target:DisplayObject, settings:SettingsBaloonTip):void
		{
			if(_debug) trace( "BaloonTipManager.registerTarget > target : " + target + ", settings : " + settings );
			if (_dObjects[target] != undefined)
			{
				unregisterTarget(target);
			}
			
			target.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler, false, 1, true);
			target.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler, false, 1, true);
			target.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler, false, 1, true);
			target.addEventListener(MouseEvent.MOUSE_MOVE, mauseMoveHandler, false, 1, true);
			_dObjects[target] = settings;
			
			if (settings.showNow)
			{
				rollOverHandler(null, target)
			}
			
		}
		
		private function removedFromStageHandler(e:Event):void 
		{
			if(_debug) trace( "BaloonTipManager.removedFromStageHandler > e : " + e );
			if (e.currentTarget == _currentFocused)
			{
				if (_visible) _baloonTip.hide();
				else _timer.stop();
				
				if (_currentFocusedSettings.unregisterAfterHide) unregisterTarget(_currentFocused);
				_enabled = false;
			}
		}
		
		public function unregisterTarget(target:DisplayObject):void
		{
			if(_debug) trace( "BaloonTipManager.unregisterTarget > target : " + target );
			if (_dObjects[target] != undefined)
			{
				target.removeEventListener(MouseEvent.ROLL_OVER, rollOverHandler, false);
				target.removeEventListener(MouseEvent.ROLL_OUT, rollOutHandler, false);
				target.removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler, false);
				target.removeEventListener(MouseEvent.MOUSE_MOVE, mauseMoveHandler, false);
				delete _dObjects[target];
			}
		}
		
		
		
		protected function restartTimmer():void
		{
			if(_debug) trace( "BaloonTipManager.restartTimmer" );
			_timer.reset();
			_timer.start();
			_timer.start();
		}
		
		protected function rollOutHandler(e:MouseEvent):void 
		{
			if (_debug) trace( "BaloonTipManager.rollOutHandler > e : " + e );
			
			if (_currentFocusedSettings.unregisterAfterHide) unregisterTarget(_currentFocused);
			
			_enabled = false;
			_currentFocused = null;
			_currentFocusedSettings = null;
			_baloonTip.hide();
			_timer.stop();
		}
		
		
		private function rollOverHandler(e:MouseEvent, forcedTarget:DisplayObject = null):void
		{
			if (_debug) trace( "BaloonTipManager.rollOverHandler > e : " + e );
			var _target:DisplayObject = forcedTarget || e.currentTarget as DisplayObject;
			if (!_stage) 
			{
				_stage = _target.stage;
				_stage.addEventListener(MouseEvent.CLICK, clickTargetHandler);
			}
			restartTimmer();
			_enabled = true;
			//_currentFocused = (e.target as DisplayObject);
			_currentFocused = _target;
			_currentFocusedSettings = _dObjects[_currentFocused];
			_currentFocused.dispatchEvent(new BaloonTipManagerEvent(BaloonTipManagerEvent.TARGET_START_DELAY));
			
			var event:BaloonTipManagerEvent = new BaloonTipManagerEvent(BaloonTipManagerEvent.PREPARATE_BALOONTIP_CONTENT);
			event.addParameter(BaloonTipManagerEvent.PARAM_TARGET, _target);
			event.addParameter(BaloonTipManagerEvent.PARAM_CONTENT, _currentFocusedSettings.content);
			_target.dispatchEvent(event);
			
			dispatchEvent(event);
			
			
			_baloonTip.setContent(event.getParameter(BaloonTipManagerEvent.PARAM_CONTENT));
		}
		
		protected function mauseMoveHandler(e:MouseEvent):void 
		{
			if(_debug) trace( "BaloonTipManager.mauseMoveHandler > e : " + e);
			if (_currentFocused == e.currentTarget && _enabled)
			{
				if (_visible)
				{
					var settings:SettingsBaloonTip = _dObjects[e.currentTarget];
					if (settings.hideOnMove)
					{
						_baloonTip.hide();
						_enabled = false;
					}
					
					if (settings.movable)
					{
						// update position of baloon tip
						moveBaloontip();
					}
				}
				else
				{
					restartTimmer();
				}
			}
			
		}
		
		
		private function clickTargetHandler(e:MouseEvent):void
		{
			if(_debug) trace( "BaloonTipManager.clickTargetHandler > e : " + e );
			_enabled = false;
			_timer.stop();
			if(_visible) _baloonTip.hide();
		}

		
	}
	
	
	
}