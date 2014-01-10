/**
* CHANGELOG:
*
* 2011-11-09 08:48: Create file
*/
package pl.asria.tools.display.windows 
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import pl.asria.tools.display.DraggableObject;
	import pl.asria.tools.display.IWorkspace;
	
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public class WindowSkin extends Sprite implements IWorkspace
	{
		public var topbar:TopBarWindow;
		public var workspace:Sprite;
		public var contentSpace:Sprite;
		public var background:Sprite;
		
		public function WindowSkin() 
		{
			
		}
		
		public function getWorkspace():Rectangle 
		{
			return workspace.getBounds(this);
		}
		
		override public function get height():Number
		{
			return super.height;
		}
	
		override public function set height(value:Number):void
		{
			background.height = value
			contentSpace.height = Math.max(0, value - 12);
			
		}
	
		override public function get width():Number
		{
			return getWorkspace().width;
		}
	
		override public function set width(value:Number):void
		{
			background.width =value
			contentSpace.width = Math.max(0, value - 12);
			topbar.width = value;
		}
		
		override public function get scaleY():Number 
		{
			return 1;
		}
		
		override public function set scaleY(value:Number):void 
		{
		}
		
		override public function get scaleX():Number 
		{
			return 1;
		}
		
		override public function set scaleX(value:Number):void 
		{
		}
		
	}

}