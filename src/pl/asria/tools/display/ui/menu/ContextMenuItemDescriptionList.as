/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-11-20 10:59</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.display.ui.menu 
{
	public class ContextMenuItemDescriptionList extends ContextMenuItemDescription
	{
		public var enabled:Boolean;
		public var label:String;
	
		/**
		 * ContextMenuItemDescriptionList - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function ContextMenuItemDescriptionList(label:String, enabled:Boolean = true) 
		{
			this.enabled = enabled;
			this.label = label;
		}
		
	}

}