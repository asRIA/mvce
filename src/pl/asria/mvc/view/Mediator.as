/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2013-12-04 15:51</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.mvc.view 
{
	import pl.asria.mvc.interfaces.IComponentMVC;
	import pl.asria.mvc.ns_mvc;
	import pl.asria.mvc.MVCSystem;
	import pl.asria.tools.data.AbstractClass;
	import pl.asria.tools.data.ICleanable;
	
	[Abstract(name="view", type="accessor")]
	public class Mediator extends AbstractClass implements IComponentMVC, ICleanable
	{		
		protected var _view:*;
		protected var _model:*;
		ns_mvc var mSystem:MVCSystem;
		
		protected function get system():MVCSystem { return ns_mvc::mSystem; }

		/**
		 * Mediator - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function Mediator() 
		{
			
		}
		
		public function setup(object:MediatorContext):void
		{
			_view = object.view;
			_model = object.data;
		}
		
		public function start():void
		{
			
		}
		
		public function stop():void
		{
			
		}
		
		public function clean():void 
		{
			_model = null;
			_view = null;
			ns_mvc::mSystem = null;
		}
	}

}