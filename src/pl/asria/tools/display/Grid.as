package pl.asria.tools.display 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Piotr Paczkowski - trzeci.eu
	 */
	public class Grid extends Sprite
	{
		protected var _scale:Number = 1;
		private var _offsetX:Number;
		private var _countX:int;
		private var _offsetY:Number;
		private var _countY:int;
		private var _interspaceX:int;
		private var _interspaceY:int;
		private var _width:Number = 100;
		private var _height:Number = 100;
		private var _thickness:int;
		private var _color:uint;
		private var _alpha:Number;
		
		public function Grid(width:Number = 100, height:Number = 100, interspaceX:Number= 30, interspaceY:Number= 30, countX:Number= 10, countY:Number = 10, offsetX:Number =0 , offsetY:Number= 0) 
		{
			setLineStyle();
			_offsetX = offsetX;
			_countX = countX;
			_offsetY = offsetY;
			_countY = countY;
			_interspaceX = interspaceX;
			_interspaceY = interspaceY;
			_width = width;
			_height = height;
			
			mouseChildren = false;
			mouseEnabled = false;
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			draw();
		}
		override public function get width():Number 
		{
			return _width;
		}
		
		override public function set width(value:Number):void 
		{
			_width = value;
		}
		
		override public function get height():Number 
		{
			return _height;
		}
		
		override public function set height(value:Number):void 
		{
			_height = value;
		}
		
		/**
		 * Use to set offset between guides. Method do not redraw grid
		 */
		public function set offsetY(value:Number):void
		{
			_offsetY = value;
		}
		/**
		 * Use to set offset between guides. Method do not redraw grid
		 */
		public function set offsetX(value:Number):void
		{
			_offsetX = value;
		}
		
		/**
		 * if <0 then infiniti 
		 */
		public function set countX(value:int):void
		{
			_countX = value;
		}
		
		/**
		 * if <0 then infiniti 
		 */
		public function set countY(value:int):void
		{
			_countY = value;
		}
		
		/**
		 * Set both offsetX and offsetY
		 */
		public function set offset(value:Point):void 
		{
			_offsetX = value.x;
			_offsetY = value.y;
			draw();
		}
		/**
		 * Set both width and height
		 */
		public function setSize(_width:Number,_height:Number):void 
		{
			this._height = _height;
			this._width = _width;
			draw();
		}
		
		public function set interspace(value:Point):void 
		{
			_interspaceX = value.x;
			_interspaceY = value.y;
			draw();
		}
		
		public function set interspaceY(value:int):void 
		{
			_interspaceY = value;
		}
		
		public function set interspaceX(value:int):void 
		{
			_interspaceX = value;
		}
		
		public function get scale():Number 
		{
			return _scale;
		}
		
		public function set scale(value:Number):void 
		{
			_scale = value;
		}

		
		
		
		public function setLineStyle(thickness:int=1, color:uint=0x000000, alpha:Number=1):void
		{
			this._alpha = alpha;
			this._color = color;
			this._thickness = thickness;
		}
		
		public function draw():void
		{
			graphics.clear();
			graphics.lineStyle(_thickness, _color, _alpha);
			var tmpPoz:int;
			var tmpCnt:int;
			var i:int;
			var tmpOffset:int;
			
			// draw vertical
			if (_countX != 0)
			{
				// inifiniti fill
				if (_countX < 0)
				{
					// some optymalization 
					tmpOffset = (_offsetX  % _interspaceX*_scale) - _interspaceX*_scale;
				}
				else // finite fill
				{
					// offset grid space equals canvas offset
					tmpOffset = _offsetX * _scale;
				}
				
				i = 0;
				tmpCnt = _countX;
				while(tmpCnt != 0)
				{
					tmpPoz = i * _interspaceX*_scale + tmpOffset;
					i++;
					if (tmpPoz < 0) {
						tmpCnt--;
						continue;
					}
					if (tmpPoz > _width) break;
					graphics.moveTo(tmpPoz, 0);
					graphics.lineTo(tmpPoz, _height);
					tmpCnt--;
				}
			}
			
			// draw horizontal
			if (_countY != 0)
			{
				if (_countY < 0)
				{
					tmpOffset = _offsetY  % _interspaceY*_scale - _interspaceY*_scale;
				}
				else
				{
					tmpOffset = _offsetY * _scale
				}
				
				i = 0;
				tmpCnt = _countY;
				while(tmpCnt != 0)
				{
					tmpPoz = i * _interspaceY*_scale + tmpOffset;
					i++;
					if (tmpPoz < 0) 
					{
						tmpCnt--;
						continue;
					}
					if (tmpPoz > _height) break;
					graphics.moveTo(0,tmpPoz);
					graphics.lineTo(_width, tmpPoz);
					tmpCnt--;
				}
			}

		}
	}
	
}