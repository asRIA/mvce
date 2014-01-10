/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2013-12-06 22:44</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.mvc 
{
	import flash.utils.Dictionary;
	import pl.asria.entity.EntityNode;
	import pl.asria.mvc.controller.Controller;
	import pl.asria.mvc.interfaces.IComponentMVC;
	import pl.asria.mvc.model.Model;
	import pl.asria.mvc.view.Decorator;
	import pl.asria.mvc.view.Mediator;
	import pl.asria.tools.data.ICleanable;
	import pl.asria.tools.factory.MegaFactory;
	import pl.asria.tools.managers.commands.CommandManager;
	import pl.asria.tools.model.ProxyMap;
	
	public class MVCSystem extends EntityNode
	{
	
		protected var _factory:MegaFactory;
		protected var _command:CommandManager;
		protected var _proxyMap:ProxyMap;
		
		internal var _uidClass:Class;
		
		private static var _uidLUT:Dictionary = new Dictionary(false);
		private static var lock:Boolean = true;
		
		/**
		 * MVCSystem - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function MVCSystem() 
		{
			if (lock)
			{
				throw new Error("Can not create direct MVCSystem by 'new' operator. Please use MVCSystem.create() instead");
			}
			
			_factory = new MegaFactory();
			_command = new CommandManager();
			_proxyMap = new ProxyMap();
		}
		
		override public function clean():void 
		{
			_factory = null;
			_command = null;
			_proxyMap = null;
			delete _uidLUT[_uidClass];
			super.clean();
		}
		
		public function get factory():MegaFactory 
		{
			return _factory;
		}
		
		public function get proxyMap():ProxyMap 
		{
			return _proxyMap;
		}
		
		public function get command():CommandManager 
		{
			return _command;
		}
		
		public function createMVC(def:Class):*
		{
			var result:* = new def();
			
			if (result is IComponentMVC)
			{
				use namespace ns_mvc;
				if (result is Model)
				{
					
				}
				//else if (result is View)
				//{
					//result.mSystem = this;
					//result.createView();
				//}
				else if (result is Mediator)
				{
					result.mSystem = this;
				}
				else if (result is Controller)
				{
					result.mSystem = this;
				}
				else if (result is Decorator)
				{
					result.mSystem = this;
				}
				use namespace AS3;
			}
			
			return result;
		}
		
		static public function create(classUID:Class):MVCSystem 
		{
			var system:MVCSystem = _uidLUT[classUID];
			if (!system)
			{
				lock = false;
				system = new MVCSystem();
				system._uidClass = classUID;
				_uidLUT[classUID] = system;
				lock = true;
			}
			return system;
		}
	}
}