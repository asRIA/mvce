/**
* CHANGELOG:
*
* 2011-11-03 10:08: Create file
*/
package pl.asria.tools.display.catche 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	import pl.asria.tools.Tool;
	import pl.asria.tools.utils.ceilInt;
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public class SingleFrame 
	{
		protected var _frame:Object;
		protected var _clipRectangle:Rectangle;
		protected var _transformation:Matrix;
		protected var _includeBorder:Boolean;
		protected var _smoothing:Boolean;
		protected var _quaity:String;
		protected var _debugRect:Boolean;
		protected var _blendMode:String;
		protected var _colorTransform:ColorTransform;
		protected var _object:DisplayObject;
		protected var _fillColor:uint = 0x00FFFFFF;
		protected var _transparent:Boolean = true;
		
		public var handler:Point;
		public var bitmap:BitmapData;
		/**
		 * 
		 * @param	animation
		 * @param	frame null -> current frame
		 */
		public function SingleFrame(animation:DisplayObject = null,frame:Object = null, clipRectangle:Rectangle = null, transformation:Matrix = null, includeBorder:Boolean = true) 
		{
			if (animation) dump.apply(this, arguments);
			_debugRect = Tool.debugMode;
		}
		
		
		
		public function dump(animation:DisplayObject, frame:Object = null, clipRectangle:Rectangle = null, transformation:Matrix = null, includeBorder:Boolean = true):void
		{
			this.setObject(animation)
				.setFrame(frame)
				.setClipRectangle(clipRectangle)
				.setTransform(transformation)
				.setIncludeBorder(includeBorder)
				.execute();
		}
		
		public function execute():SingleFrame
		{
			//var _ts:uint;
			CONFIG::debug
			{
				var _ts:uint = getTimer();
			}
			
			if (bitmap) bitmap.dispose();
			
			var _lastParent:DisplayObjectContainer;
			var _lastParentIndex:int;
			var _renredPlace:Sprite = new Sprite();
			
			_lastParent = _object.parent;
			if (_lastParent) _lastParentIndex = _lastParent.getChildIndex(_object);
			_renredPlace.addChild(_object);
			
			
			if (_frame != null && _object is MovieClip) 
			{
				var _saveFrame:int = (_object as MovieClip).currentFrame;
				(_object as MovieClip).gotoAndStop(_frame);
			}
			
			var transformPoint:Point = new Point(_object.x, _object.y);
			var rectangle:Rectangle = _clipRectangle || (_includeBorder ? _renredPlace.getBounds(_renredPlace) : _renredPlace.getRect(_renredPlace) );
			var clipper:Function = Math.round;
			
			rectangle.x = clipper(rectangle.x);
			rectangle.y = clipper(rectangle.y);
			rectangle.width = clipper(rectangle.width);
			rectangle.height = clipper(rectangle.height);
			handler = new Point(rectangle.x - _object.x, rectangle.y - _object.y);
			handler.x = clipper(handler.x);
			handler.y = clipper(handler.y);
			
			if (rectangle.width == rectangle.height && rectangle.height == 0)
			{
				bitmap = new BitmapData(1,1,_transparent, _fillColor);
			}
			else 
			{
				bitmap = new BitmapData(rectangle.width, rectangle.height, _transparent, _fillColor);
				_object.x -= rectangle.x;
				_object.y -= rectangle.y;
				
				bitmap.lock();
				if (bitmap["drawWithQuality"] is Function)
				{
					//bitmap.drawWithQuality(_renredPlace, _transformation, _colorTransform, _blendMode, _clipRectangle, _smoothing, _quaity);
					bitmap["drawWithQuality"](_renredPlace, _transformation, _colorTransform, _blendMode, _clipRectangle, _smoothing, _quaity);
				}
				else
				{
					bitmap.draw(_renredPlace, _transformation, _colorTransform, _blendMode, _clipRectangle, _smoothing);
				}
				
				if(_debugRect)
				{
					drawDebugRectangle();
				}
					
				bitmap.unlock();
			}
			_object.x = transformPoint.x;
			_object.y = transformPoint.y;
			if (_frame != null && _object is MovieClip) 
			{
				(_object as MovieClip).gotoAndStop(_saveFrame);
			}
			
			if (_lastParent)
				_lastParent.addChildAt(_object, _lastParentIndex);
				
				
			CONFIG::debug 
			{
				_ts = getTimer() - _ts;
				trace("0:SingleFrame executeTime:\t" + _ts + "ms (" + _object + ")");
			}
			return this;
			
		}
		
		
		public function clone():SingleFrame
		{
			var result:SingleFrame = new SingleFrame();
			if(bitmap) result.bitmap = bitmap.clone();
			if(handler) result.handler = handler.clone();
			return result;
		}
		
		
		public function clean():void
		{
			if (bitmap)
			{
				bitmap.dispose();
				bitmap = null;
			}
			
			_frame = null;
			_clipRectangle = null;
			_transformation = null;
			_quaity = null;
			_blendMode = null;
			_colorTransform = null;
			_object = null;
		}
		
		public static function injectDebigRectangle(bitmapData:BitmapData):void
		{
			bitmapData.lock();
			bitmapData.fillRect(		new Rectangle(0, 					0, 						4, 						4						), 0x1FFF0000);
			bitmapData.fillRect(		new Rectangle(0, 					bitmapData.height - 4, 	4, 						4						), 0x1FFF0000);
			bitmapData.fillRect(		new Rectangle(bitmapData.width - 4, 0, 						4, 						4						), 0x1FFF0000);
			bitmapData.fillRect(		new Rectangle(bitmapData.width - 4, bitmapData.height - 4, 	4, 						4						), 0x1FFF0000);
			
			bitmapData.fillRect(		new Rectangle(0, 					1, 						1, 						bitmapData.height-1		), 0x1FFFF000);
			bitmapData.fillRect(		new Rectangle(1, 					bitmapData.height - 1,	bitmapData.width - 1, 	1						), 0x1F0FFF00);
			bitmapData.fillRect(		new Rectangle(bitmapData.width - 1, 0, 						1, 						bitmapData.height - 1	), 0x1F00FFF0);
			bitmapData.fillRect(		new Rectangle(0, 					0, 						bitmapData.width - 1, 	1						), 0x1F000FFF);
			bitmapData.unlock();
		}
		
		public function setObject(object:DisplayObject):SingleFrame 
		{
			_object = object;
			return this;
		}
		
		public function setFrame(frame:Object):SingleFrame 
		{
			_frame = frame;
			return this;
		}
		public function setClipRectangle(clipRectangle:Rectangle):SingleFrame 
		{
			_clipRectangle = clipRectangle;
			return this;
		}
		public function setTransform(transformation:Matrix):SingleFrame
		{
			_transformation = transformation;
			return this;
		}
		public function setIncludeBorder(includeBorder:Boolean):SingleFrame
		{ 
			_includeBorder = includeBorder;
			return this;
		}
		public function setSmoothing(smoothing:Boolean):SingleFrame
		{ 
			_smoothing = smoothing;
			return this;
		}
		public function setTransparent(transparent:Boolean):SingleFrame
		{ 
			_transparent = transparent;
			return this;
		}
		public function setFillColor(color:uint):SingleFrame
		{ 
			_fillColor = color;
			return this;
		}
		public function setQuality(quaity:String):SingleFrame
		{ 
			_quaity = quaity;
			return this;
		}
		public function setDebugRect(debugRect:Boolean):SingleFrame
		{ 
			_debugRect = debugRect;
			return this;
		}
		public function setBlendMode(blendMode:String):SingleFrame
		{ 
			_blendMode = blendMode;
			return this;
		}
		public function setColorTransform(colorTransform:ColorTransform):SingleFrame 
		{ 
			_colorTransform = colorTransform;
			return this;
		}
		
		public function drawDebugRectangle():void 
		{
			injectDebigRectangle(bitmap);
		}
		
		public function getMemoryRaport():XML 
		{
			var memoryRaport:XML = <SingleFrame />;
			
			if (bitmap && bitmap.width && bitmap.height)
			{
				// 4 bytes per color * 8 bits * dimmesions
				memoryRaport.@size = 4 * bitmap.width * bitmap.height;
				memoryRaport.@width = bitmap.width;
				memoryRaport.@height = bitmap.height;
			}
			else
			{
				memoryRaport.@size = 0;
				memoryRaport.@width = 0;
				memoryRaport.@height = 0;
			}
			return memoryRaport;
		}
		
		public function get fillColor():uint 
		{
			return _fillColor;
		}
		
		public function set fillColor(value:uint):void 
		{
			_fillColor = value;
		}
		
		public function get transparent():Boolean 
		{
			return _transparent;
		}
		
		public function set transparent(value:Boolean):void 
		{
			_transparent = value;
		}
		
		
	}

}