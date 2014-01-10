/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-10-03 19:57</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.display.ui.drag 
{
	import flash.display.Sprite;
	import pl.asria.tools.data.ICleanable;
	
	public class DragDescription implements ICleanable
	{
		public var type:String;
		public var view:Sprite;
		public var data:*;
	
		/**
		 * DragDescription - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function DragDescription() 
		{
			
		}
		
		/* INTERFACE pl.asria.tools.data.ICleanable */
		
		public function clean():void 
		{
			data = null
			view = null
			type = null
		}
		
	}

}