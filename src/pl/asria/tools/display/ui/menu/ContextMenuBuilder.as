/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-10-09 17:06</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.display.ui.menu 
{
	import flash.display.Sprite;
	import pl.asria.tools.data.ICleanable;
	
	public class ContextMenuBuilder implements ICleanable
	{
	
		protected var _content:Sprite;
		protected var _item:ContextMenuItem;
		/**
		 * ContextMenuBuilder - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function ContextMenuBuilder() 
		{
			
		}
		
		/* INTERFACE pl.asria.tools.data.ICleanable */
		
		public function clean():void 
		{
			_content = null;
			_item = null;
		}
		
		public function build(item:ContextMenuItem):void 
		{
			_item = item;
			_item.builder = this;
		}
		
		public function get content():Sprite 
		{
			return _content;
		}
		
		
	}

}