/**
* CHANGELOG:
*
* 2011-12-28 18:20: Create file
*/
package pl.asria.tools.display.catche 
{
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public class Renderer extends Bitmap
	{
		private var _improvePixelSnapping:Boolean;
		
		public function Renderer() 
		{
			super();
		}
		public function render(singleFrame:SingleFrame):void
		{
			x = singleFrame.handler.x;
			y = singleFrame.handler.y;
			bitmapData = singleFrame.bitmap;
			if (_improvePixelSnapping)
			{
				smoothing = true;
			}
		}
		
		public function clean():void 
		{
			bitmapData = null;
		}
		
		public function get improvePixelSnapping():Boolean 
		{
			return _improvePixelSnapping;
		}
		
		public function set improvePixelSnapping(value:Boolean):void 
		{
			_improvePixelSnapping = value;
			if (value)
			{
				pixelSnapping = "never"
				smoothing = true;
				scaleX = 1.01;
				scaleY = 1.01;
			}
			else
			{
				scaleX = 1;
				scaleY = 1;
			}
		}
	}

}