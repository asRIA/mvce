/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-10-11 14:59</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.display.ui.menu 
{
	import flash.display.Sprite;
	
	public class ContextMenuBuilderSeparator extends ContextMenuBuilder
	{
		protected static var _graphicConstructorClass:Class;
	
		/**
		 * ContextMenuBuilderSeparator - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function ContextMenuBuilderSeparator() 
		{
			
		}
		
		public static function initGraphicConstructor(graphicConstructorClass:Class):void
		{
			_graphicConstructorClass = graphicConstructorClass;
			
		}
		
		public override function build(item:ContextMenuItem):void 
		{
			super.build(item);
			var description:ContextMenuItemDescriptionSeparator = ContextMenuItemDescriptionSeparator(item.description);
			_content = new _graphicConstructorClass() as Sprite;
		}
		
		public override function clean():void 
		{
			super.clean();
		}
		
	}

}