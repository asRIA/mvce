/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-12-17 15:10</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.display 
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import pl.asria.tools.data.ICleanable;
	
	public class BitmapSprite extends Sprite implements ICleanable
	{
		protected var _bitmap:BitmapData;
	
		/**
		 * BitmapSprite - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function BitmapSprite() 
		{
			
		}
		
		public function connect(bitmap:BitmapData):void 
		{
			_bitmap = bitmap;
			
		}
		
		/* INTERFACE pl.asria.tools.data.ICleanable */
		
		public function clean():void 
		{
			_bitmap.dispose();
		}
		
	}

}