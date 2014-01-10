package pl.asria.tools.utils
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.events.EventPhase;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	import pl.asria.tools.data.ICleanable;
	import pl.asria.tools.event.utils.ShortkeysDetectorEvent;
	import pl.asria.tools.utils.trace.dtrace;
	
	/**
	 * ...
	 * @inspired by Andys KonamiCode detector
	 * @author Piotr Paczkowski
	 */
	
	[Event(name="matchSeqwence", type="pl.asria.tools.event.utils.ShortkeysDetectorEvent")]
	[Event(name="overTime", type="pl.asria.tools.event.utils.ShortkeysDetectorEvent")]
	public class ShortkeysDetector extends EventDispatcher implements ICleanable
	{
		public static var KOONAMI_CODE:Array = [Keyboard.UP, Keyboard.UP, Keyboard.DOWN, Keyboard.DOWN, Keyboard.LEFT, Keyboard.RIGHT, Keyboard.LEFT, Keyboard.RIGHT, 'BA'];
		private var stage:Stage;	
		private var _dCommands:Dictionary = new Dictionary();
		private var _dSeqwences:Dictionary = new Dictionary();
		private var _currentSeqwence:Vector.<uint> = new Vector.<uint>();
		private var maximumLag:uint;
		private var _ts:int = -1;
		
		/**
		 * 
		 * @param	stage
		 * @param	maximumLag	time between keys
		 */
		public function ShortkeysDetector(stage:Stage =null, maximumLag:uint = 1000) 
		{
			if (stage) initStage(stage, maximumLag);
		}
		
		public function initStage(stage:Stage, maximumLag:uint):void 
		{
			this.maximumLag = maximumLag;
			this.stage = stage;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, sequenceCodeHandler,false,int.MAX_VALUE);
		}
		
		public function registerCommand(name:String, key:uint, altKey:Boolean, shiftKey:Boolean, ctrlKey:Boolean):void
		{
			if (_dCommands[name] != undefined)
			{
				dtrace("Seqwence already exists", name, _dSeqwences[name]);
				return;
			}
			_dCommands[name] = [key, altKey, shiftKey, ctrlKey];
		}
		/**
		 * 
		 * @param	name
		 * @param	seqwence separated seqwence atomic like: "K", Keyboard.UP, "P", or string, you have preinited seqwences in static variables
		 */
		public function registerSeqwence(name:String, seqwence:Array):void
		{
			if (_dSeqwences[name] != undefined)
			{
				dtrace("Seqwence already exists", name, _dSeqwences[name]);
				return;
			}
			
			var seqwenceCode:Vector.<uint> = new Vector.<uint>();
			for (var i:int = 0; i < seqwence.length; i++) 
			{
				if (seqwence[i] is String) 
				{
					var splited:Array = String(seqwence[i]).split('');
					for (var j:int = 0; j < splited.length; j++) 
						seqwenceCode.push(String(splited[j]).toUpperCase().charCodeAt(0) as uint);
				}
				else if (seqwence[i] is uint)
				{
					seqwenceCode.push(seqwence[i] as uint);
				}
				else
				{
					dtrace("Incorrect atomic seqwence:", seqwence[i], "Only single char or uint (from Keyboard Class)");
					return;
				}
			}
			_dSeqwences[name] = seqwenceCode;
		}
		
		/* INTERFACE pl.asria.tools.data.ICleanable */
		
		public function clean():void 
		{
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, sequenceCodeHandler);
		}
		
		private function sequenceCodeHandler(e:KeyboardEvent):void 
		{
			//trace( "ShortkeysDetector.sequenceCodeHandler > e : " , e.keyCode, e.charCode );
			if (e.eventPhase != EventPhase.AT_TARGET) return;
			if (_ts < 0) _ts = getTimer()
			else
			{
				var _tmpTs:int = getTimer();
				if (_tmpTs - _ts > maximumLag)
				{
					_ts = getTimer();
					_currentSeqwence = new Vector.<uint>();
					dispatchEvent(new ShortkeysDetectorEvent(ShortkeysDetectorEvent.OVER_TIME, null));
				}
				else
				{
					_ts = _tmpTs;
				}
			}
			
 			_currentSeqwence.push(e.keyCode);
			
			var matchDraw:Boolean = false;
			for (var key:String in _dSeqwences)
			{
				var seqwence:Vector.<uint> = _dSeqwences[key] as Vector.<uint>;
				var match:Boolean = true;
				for (var i:int = 0; i < _currentSeqwence.length; i++) 
				{
					if (i > seqwence.length-1 || seqwence[i] != _currentSeqwence[i])
					{
						match = false;
						break;
					}
				}
				if (match && seqwence.length == _currentSeqwence.length)
				{
					dispatchEvent(new ShortkeysDetectorEvent(ShortkeysDetectorEvent.MATCH_SEQWENCE,key));
					match = false; // protect to blocade
				}
				matchDraw = matchDraw || match;
			}
			if (!matchDraw) 
			{
				_currentSeqwence = new Vector.<uint>();
				_ts = -1;
			}
		}
		
	}

}