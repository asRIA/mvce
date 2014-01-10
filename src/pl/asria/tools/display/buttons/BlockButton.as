package pl.asria.tools.display.buttons 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.utils.getTimer;
	import pl.asria.tools.BlockTool;
	import pl.asria.tools.data.ICleanable;
	import pl.asria.tools.display.block.IBlockContainer;
	import pl.asria.tools.display.block.IBlockIteam;
	import pl.asria.tools.event.display.buttons.BlockButtonEvent;

	/**
	 * ...
	 * @author Piotr Paczkowski
	 */
	[Event(name="buttonClick", type="pl.asria.tools.event.display.buttons.BlockButtonEvent")]
	[Event(name="removeFromStageEvent", type="pl.asria.tools.event.display.buttons.BlockButtonEvent")]
	/** 
	* Dispatched when button is blocked, useful to add some FX from code 
	**/
	[Event(name="buttonBlocked", type="pl.asria.tools.event.display.buttons.BlockButtonEvent")]
	/** 
	* Dispatched When button is unblocked, useful to add some FX from code 
	**/
	[Event(name="buttonUnblocked", type="pl.asria.tools.event.display.buttons.BlockButtonEvent")]
	public class BlockButton extends BlockButtonView/*extends BaseButton*/ implements IBlockIteam, ICleanable
	{
		/**
		 * Blokada wielopoziomowa, 0 - odblokowany, > 0 zablokowany
		 */
		protected var _block:Boolean = false;
		private var _autoblock:Boolean = true;
		private var _autounregister:Boolean = false;
		private var _blockOnInit:Boolean;
		private var _mouseOverButton:Boolean = false;
		private var _forceControl:Boolean = true;
		
		public static var FRAME_OFF:String = "idle"
		public static var FRAME_ON:String = "on";
		public static var FRAME_CLICK:String = "click";
		
		
		private var _labelText:String = '';
		protected var _target:MovieClip;
		protected var _label:TextField;
		
		protected var _enableBlockFX:Boolean = true;
		protected var _baseOn:String = "";
		protected var _baseOff:String = "";
		protected var _multistateMode:Boolean;
		protected var _subState:String = "idle";
		protected var _baseState:String = "";
		public function BlockButton(view:MovieClip = null) 
		{
			_target = view  || this;
			autounregister = false;
			_target.stop();
			_target.buttonMode = true;
			_target.addEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
			_target.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler, false, int.MAX_VALUE);
			
			_target.addEventListener(MouseEvent.ROLL_OUT, _rollOutHandler);
			_target.addEventListener(MouseEvent.ROLL_OVER, _rollOverHandler);
			_target.addEventListener(MouseEvent.MOUSE_DOWN, _downHandler);
			_target.addEventListener(MouseEvent.MOUSE_UP, _upHandler);
			_target.addEventListener(MouseEvent.CLICK, clickGrabber,false,int.MAX_VALUE);
			
			_label = _target.getChildByName("label") as TextField;
			if (!_label)
			{
				var _lc:Sprite = _target.getChildByName("labelContent") as Sprite;
				if (_lc)
				{
					_label = _lc.getChildByName("label") as TextField;
				}
			}
			
			if (_label)
			{
				_label.mouseEnabled = false;
				_label.selectable = false;
			}
			
			gotoCurrentState();
		}
		
		
		public function setMultistateStates(baseOn:String, baseOff:String):void
		{
			_multistateMode = true;

			_baseOff = baseOff;
			_baseOn = baseOn;
			_baseState = _block ? _baseOff : _baseOn;
			gotoCurrentState()
		}
		
		protected function checkAutoblock():void
		{
			if (_mouseOverButton) 
			{
				clickHandlerBlock();
			}
		}
		protected function _upHandler(e:MouseEvent):void 
		{
			checkAutoblock();
			
			if(_block)
			{
				_subState = FRAME_OFF;
				gotoCurrentState();
				
			}
			else
			{
				_subState = FRAME_ON;
				gotoCurrentState();
				
				
			}
			
		}
		
		protected function _downHandler(e:MouseEvent):void 
		{
			_subState = FRAME_CLICK;
			gotoCurrentState();
			
		}
		
		protected function _rollOverHandler(e:MouseEvent):void 
		{
			_mouseOverButton = true;
			_subState = FRAME_ON;
			gotoCurrentState();
			
		}
		
		protected function _rollOutHandler(e:MouseEvent):void 
		{
			_subState = FRAME_OFF;
			gotoCurrentState();
			
			_mouseOverButton = false;
		}
		
		override public function gotoAndStop(frame:Object, scene:String = null):void 
		{
			//trace( "BlockButton.gotoAndStop > frame : " + frame + ", scene : " + scene, target.name, target);
			_target.mouseChildren = false;
			if (this == _target)
			{
				super.gotoAndStop(frame, scene);
			} 
			else
			{
				_target.gotoAndStop(frame, scene);
			}
		}
		private function removedFromStageHandler(e:Event):void 
		{
			e.stopImmediatePropagation();
			_target.removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			if (_autounregister) BlockTool.unregisterButton(this);
			dispatchEvent(new BlockButtonEvent(BlockButtonEvent.REMOVE_FROM_STAGE_EVENT));
			
		}
		
		public function clean():void 
		{
			if (_target)
			{
				_target.addEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
				_target.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
				_target.addEventListener(MouseEvent.ROLL_OUT, _rollOutHandler);
				_target.addEventListener(MouseEvent.ROLL_OVER, _rollOverHandler);
				_target.addEventListener(MouseEvent.MOUSE_DOWN, _downHandler);
				_target.addEventListener(MouseEvent.MOUSE_UP, _upHandler);
				_target.addEventListener(MouseEvent.CLICK, clickGrabber);
			}
			_target = null;
			BlockTool.unregisterButton(this);
			
		}
		
		public function checkPathToStageAndRegisterInIBlockConteiner():void
		{
			var _parent:DisplayObject = _target.parent;
			while (_parent != null && !(_parent is Stage))
			{
				if (_parent is IBlockContainer)
				{
					IBlockContainer(_parent).$registerBlockIteam(this);
					return;
				}
				else
					_parent = _parent.parent;
			}
		}
		
		protected function addToStageHandler(e:Event):void 
		{
			_target.removeEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
			BlockTool.registerButton(this);
			checkPathToStageAndRegisterInIBlockConteiner();
			if (_blockOnInit) $block();
		}
		
		
		/* INTERFACE pl.asria.utils.display.buttons.IBlockButton */
		
		public function $block():void 
		{
			_block = true;
			_blockFX();
		}
		
		protected function _blockFX():void 
		{
			if (_multistateMode)
			{
				_baseState = _baseOff;
				gotoCurrentState();
			}
			else
			{
				_target.mouseEnabled = false; 
				_target.mouseChildren = false;
				_target.buttonMode = false;
				dispatchEvent(new BlockButtonEvent(BlockButtonEvent.BUTTON_BLOCKED));
			}
			
			if(_enableBlockFX) _target.transform.colorTransform = new ColorTransform(0.6,0.6,0.6,1);
		}
		
		private function clickGrabber(e:MouseEvent):void 
		{
			if((_block && !_multistateMode) || !BlockTool.globalEnable) e.stopImmediatePropagation();
		}
		
		public function $unblock():void 
		{
			_block = false;
			//alpha = 1;
			dispatchEvent(new BlockButtonEvent(BlockButtonEvent.BUTTON_UNBLOCKED));
			_unblockFX();
		}
		
		protected function _unblockFX():void 
		{
			if (_multistateMode)
			{
				_baseState = _baseOn;
				gotoCurrentState();
			}
			else
			{
				_target.buttonMode = true;
				_target.mouseEnabled = true; 
				_target.mouseChildren = true;
			}
			if(_enableBlockFX) _target.transform.colorTransform = new ColorTransform(1,1,1,1);
		}
		
		protected function gotoCurrentState():void 
		{
			try
			{
				gotoAndStop(_baseState + _subState);
			}
			catch (e:Error) { };
		}
		
		public function clickHandlerBlock():void 
		{
			var clickPermisstion:Boolean = (!$isBlocked || _multistateMode) && BlockTool.globalEnable;
			if(_autoblock && BlockTool.globalEnable) $block()
			if (clickPermisstion) dispatchEvent(new BlockButtonEvent(BlockButtonEvent.BUTTON_CLICK, true));
		}
		
		/* INTERFACE pl.asria.tools.display.buttons.IBlockButton */
		
		public function $forceUnblock():void 
		{
			if(_forceControl) $unblock();
		}
		
		/* INTERFACE pl.asria.tools.data.ICleanable */
		
		
		
		public function get $isBlocked():Boolean 
		{
			return _block;
		}
		
		[Inspectable (name = "autoblock", variable = "autoblock", type = "Boolean", defaultValue = 'true')]
		public function get autoblock():Boolean 
		{
			return _autoblock;
		}
		
		public function set autoblock(value:Boolean):void 
		{
			_autoblock = value;
		}
		
		[Inspectable (name = "blockOnInit", variable = "blockOnInit", type = "Boolean", defaultValue = 'false', category = 'Other')]
		public function get blockOnInit():Boolean 
		{
			return _blockOnInit;
		}
		
		public function set blockOnInit(value:Boolean):void 
		{
			_blockOnInit = value;
			if(stage && value) $block();
		}
		
		[Inspectable (name = "autounregister", variable = "autounregister", type = "Boolean", defaultValue = 'false', category = 'Other')]
		public function get autounregister():Boolean 
		{
			return _autounregister;
		}
		
		public function set autounregister(value:Boolean):void 
		{
			_autounregister = value;
		}
		
		[Inspectable (name = "labelText", variable = "labelText", type = "String", defaultValue = '', category = 'Other')]
		public function get labelText():String 
		{
			return _labelText;
		}
		
		public function set labelText(value:String):void 
		{
			_labelText = value;
			if (_label) _label.text = value;
		}
		
		[Inspectable (name = "forceControl", variable = "forceControl", type = "Boolean", defaultValue = 'true', category = 'Other')]
		public function get forceControl():Boolean 
		{
			return _forceControl;
		}
		
		public function set forceControl(value:Boolean):void 
		{
			_forceControl = value;
		}	
		
		public function get target():MovieClip 
		{
			return _target;
		}
		
		public function get enableBlockFX():Boolean 
		{
			return _enableBlockFX;
		}
		
		public function set enableBlockFX(value:Boolean):void 
		{
			_enableBlockFX = value;
		}
	}

}