/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2013-10-07 20:49</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>o
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.entity 
{
	import org.osflash.signals.Signal;
	import pl.asria.tools.data.ICleanable;
	
	public class EntityComponent implements ICleanable
	{
		internal var _node:EntityNode;
		protected var _onDetatched:Signal = new Signal(EntityNode);
		protected var _onCleanNode:Signal = new Signal(EntityNode);
		protected var _onCleanNodeStart:Signal = new Signal(EntityNode);
		protected var _onAttached:Signal = new Signal(EntityNode);
		
		public function get node():EntityNode 
		{
			return _node;
		}
		
		public function get onAttached():Signal 
		{
			return _onAttached;
		}
		
		public function get onCleanNodeStart():Signal 
		{
			return _onCleanNodeStart;
		}
		
		public function get onCleanNode():Signal 
		{
			return _onCleanNode;
		}
		
		public function get onDetatched():Signal 
		{
			return _onDetatched;
		}
		
		
		/**
		 * EntityComponent - Main controler of entities in system
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function EntityComponent() 
		{
			_onAttached.add(onAttachedFunction);
			_onDetatched.add(onDetachedFunction);
			_onCleanNode.add(onCleanNodeFunction);
			_onCleanNodeStart.add(onCleanNodeStartFunction);
		}
		
		protected function onCleanNodeStartFunction(node:EntityNode):void 
		{
			
		}
		
		protected function onCleanNodeFunction(node:EntityNode):void 
		{
			
		}
		
		protected function onDetachedFunction(node:EntityNode):void 
		{
			
		}
		
		protected function onAttachedFunction(node:EntityNode):void 
		{
			
		}
		
		/**
		 * Auto unregister from parent
		 */
		public function unregister():void
		{
			if (_node) _node.removeComponent(this);
		}
		
		/* INTERFACE pl.asria.tools.data.ICleanable */
		
		public function clean():void 
		{
			_onAttached.removeAll();
			_onDetatched.removeAll();
			_onCleanNodeStart.removeAll();
			_onCleanNode.removeAll();
			
			_onCleanNodeStart = null;
			_onCleanNode = null;
			_onDetatched = null;
			_onAttached = null;
		}
		
	}

}