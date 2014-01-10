/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2013-12-04 15:57</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.mvc.view 
{
	
	public class MediatorContext 
	{
		public var data:*;
		public var view:*;
		/**
		 * MediatorContext - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function MediatorContext(view:* = null, data:* = null) 
		{
			this.data = data;
			this.view = view;
		}
		
	}

}