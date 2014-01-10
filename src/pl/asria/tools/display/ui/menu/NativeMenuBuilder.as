/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2013-05-07 12:42</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.display.ui.menu 
{
	import flash.display.NativeMenu;
	import pl.asria.tools.factory.AbstractMegaFactoryBuilder;
	
	public class NativeMenuBuilder extends AbstractMegaFactoryBuilder
	{
	
		/**
		 * NativeMenuBuilder - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function NativeMenuBuilder() 
		{
			
		}
		
		/**
		 * 
		 * @param	description  {
				label:"level texture",
				onSelect:null,
				onPreparating:null,
				onDisplaying:null,
				isSeparator:false,
				sumMenu:[
					
				]
			}
		 * @return
		 */
		public function create(description:Object):NativeMenu
		{
			var result:NativeMenu = new NativeMenu();
			return result;
		}
	}

}