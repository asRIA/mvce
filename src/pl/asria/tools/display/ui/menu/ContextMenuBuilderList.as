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
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import pl.asria.tools.display.buttons.SingleFrameBlockButton;
	import pl.asria.tools.event.display.buttons.BlockButtonEvent;
	
	public class ContextMenuBuilderList extends ContextMenuBuilder
	{
		protected static var _graphicConstructorClass:Class;
		protected var _blockButton:SingleFrameBlockButton;
	
		/**
		 * ContextMenuBuilderList - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function ContextMenuBuilderList() 
		{
			
		}
		
		public static function initGraphicConstructor(graphicConstructorClass:Class):void
		{
			_graphicConstructorClass = graphicConstructorClass;
			
		}
		
		public override function build(item:ContextMenuItem):void 
		{
			super.build(item);
			var description:ContextMenuItemDescriptionList = ContextMenuItemDescriptionList(item.description);
			
			_content = new _graphicConstructorClass() as Sprite;
			_blockButton = new SingleFrameBlockButton(_content as MovieClip);
			_blockButton.labelText = description.label;
			_blockButton.autoblock = false;
			_blockButton.autounregister = false;
			if (!description.enabled)_blockButton.$block();
			_blockButton.addEventListener(BlockButtonEvent.BUTTON_CLICK, clickBlockButtonHandler)
		}
		
		protected function clickBlockButtonHandler(e:BlockButtonEvent):void 
		{
			_item.invoke();
		}
		
		public override function clean():void 
		{
			_blockButton.clean();
			_blockButton.removeEventListener(BlockButtonEvent.BUTTON_CLICK, clickBlockButtonHandler);
			_blockButton = null;
			super.clean();
		}
		
	}

}