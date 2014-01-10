/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2013-12-07 14:07</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.mvc.controller 
{
	import pl.asria.mvc.interfaces.IComponentMVC;
	import pl.asria.mvc.ns_mvc;
	import pl.asria.mvc.MVCSystem;
	
	public class Controller implements IComponentMVC
	{
	
		ns_mvc var mSystem:MVCSystem;
		protected function get system():MVCSystem { return ns_mvc::mSystem; }
		
		/**
		 * Controller - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function Controller() 
		{
			
		}
		
	}

}