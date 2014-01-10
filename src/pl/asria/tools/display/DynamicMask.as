package pl.asria.tools.display 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public class DynamicMask extends Sprite
	{
		private var _rectangleUnmasced:Rectangle;
		private var _boundsRectangle:Rectangle= new Rectangle();
		private var _width:Number;
		private var _height:Number;
		private var colorFill:uint;
		private var alphaFill:Number;
		
		public function DynamicMask(width:Number, height:Number, rectangleUnmasced:Rectangle) 
		{
			setFillStyle();
			this.height = height;
			this.width = width;
			_rectangleUnmasced = rectangleUnmasced;
			mouseChildren = false;
			mouseEnabled = false;
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedHandler);
			
		}
		
		public function setFillStyle(colorFill:uint = 0x00FFCC,alphaFill:Number=0.3):void 
		{
			this.alphaFill = alphaFill;
			this.colorFill = colorFill;
			
		}
		
		private function onAddedHandler(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedHandler);
			draw();
		}
		
		public function draw():void
		{
			graphics.clear();
			graphics.beginFill(colorFill, alphaFill);
			
			// lodic and on rectangle
			var intersection:Rectangle = _boundsRectangle.intersection(_rectangleUnmasced);
		//	if (!intersection.isEmpty())
		//	{
				if (intersection.left > 0)
				{
					graphics.drawRect(0, 0, intersection.left, _height);
				}
				
				if (intersection.right < _width)
				{
					graphics.drawRect(intersection.right, 0, _width - intersection.right, _height);
				}
				
				if (intersection.top > 0)
				{
					graphics.drawRect(intersection.left, 0, intersection.width, intersection.top);
				}
				
				if (intersection.bottom < _height)
				{
					graphics.drawRect(intersection.left, intersection.bottom, intersection.width, _height - intersection.bottom);
				}
		//	}
			
		}
		override public function get width():Number 
		{
			return _width;
		}
		
		override public function set width(value:Number):void 
		{
			_width = value;
			_boundsRectangle.width = value;
		}
		
		override public function get height():Number 
		{
			return _height;
		}
		
		override public function set height(value:Number):void 
		{
			_height = value;
			_boundsRectangle.height = value;
		}
		
		/**
		 * To get efect, you must to use draw() function
		 */
		public function get rectangleUnmasced():Rectangle 
		{
			return _rectangleUnmasced;
		}
	}

}