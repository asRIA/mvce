/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-05-23 10:18</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.display 
{
	import flash.display.Sprite;
	
	public class SpriteConstSize extends Sprite
	{
		protected var _width:Number;
		protected var _height:Number;
	
		/**
		 * SpriteConstSize - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function SpriteConstSize(target:Sprite) 
		{
			
			height = target.height;
			width = target.width;
			
			while (target.numChildren)
			{
				addChild(target.getChildAt(0));
			}
		}
		
		override public function get height():Number 
		{
			return _height;
		}
		
		public override function set height(value:Number):void 
		{
			_height = value;
		}
		
		override public function get width():Number 
		{
			return _width;
		}
		
		public override function set width(value:Number):void 
		{
			_width = value;
		}
	}

}