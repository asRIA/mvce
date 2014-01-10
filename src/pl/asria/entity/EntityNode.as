/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2013-07-19 23:48</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.entity 
{
	import adobe.utils.CustomActions;
	import flash.utils.describeType;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	import pl.asria.tools.data.ICleanable;
	import pl.asria.tools.utils.getClass;
	import pl.asria.tools.utils.isBasedOn;
	
	public class EntityNode implements ICleanable
	{
		static protected var dCacheCollectAliasys:Dictionary = new Dictionary();
	
		internal var _parent:EntityNode;
		
		protected var dEntities:Dictionary = new Dictionary();
		protected var vEntities:Vector.<EntityComponent> = new Vector.<EntityComponent>();
		protected var profiling:Boolean = false;
		protected var _exist:Boolean = true;
		/**
		 * EntityNode - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function EntityNode() 
		{
			
		}
		
		/**
		 * Propagate method only in childer 
		 * @param	T - Bace class
		 * @param	method
		 * @param	...params
		 */
		public function propagate(T:Class, method:String, ...params):void
		{
			CONFIG::debug
			{
				if (profiling)
				{
					var __time:int = getTimer();
				}
			}
			//retrieve all entitis with T
			var entities:Vector.<EntityComponent> = getChildComponents(T);
			
			// propagate method
			for (var i:int = 0, i_max:int = entities.length; i < i_max; i++) 
			{
				 entities[i][method].apply(this, params);
			}
			
			CONFIG::debug
			{
				if(profiling)
				{
					trace(this+" time propagation["+method+"]: ", getTimer()-__time);
				}
			}
			
		}
		
		/**
		 * Propagate some methow in all insances of specyfic class
		 * @param	T
		 * @param	method
		 * @param	...params
		 */
		public function boardcast(T:Class, method:String, ...params):void
		{
			var entities:Vector.<EntityComponent> = findComponents(T);
			for (var i:int = 0, i_max:int = entities.length; i < i_max; i++) 
			{
				entities[i][method].apply(this, params);
			}
		}
		
		
		/**
		 * Inject entity of class definition
		 * @param	entityClass class must extends EntityNode
		 */
		public final function injectComponent(entityClass:Class):EntityComponent
		{
			var resutl:EntityComponent;
			if(isBasedOn(entityClass, EntityComponent))
			{
				resutl = new entityClass() 
				addComponent(resutl);
			}
			
			return resutl;
		}
		
		/**
		 * Add sub node component
		 * @param	entity
		 */
		public final function addComponent(entity:EntityComponent):void
		{
			trace( "EntityNode.addComponent > entity : " + entity );
			if (entity._node) entity._node.removeComponent(entity);
			
			entity._node = this;
			preparateEntity(entity);
			var def:Class = getClass(entity);
			var aliasys:Vector.<String> = collectAliasys(def);
			for (var i:int = 0, i_max:int = aliasys.length; i < i_max; i++) 
			{
				var collection:Vector.<EntityComponent> = dEntities[aliasys[i]];
				if (!collection)
				{
					dEntities[aliasys[i]]  = Vector.<EntityComponent>([entity]);
				}
				else if(collection.indexOf(entity) < 0)
				{
					collection.push(entity);
				}
			}
			vEntities.push(entity);
			entity.onAttached.dispatch(this);
		}
		
		/**
		 * Place for preparation some internal elements
		 * @param	entity
		 */
		protected function preparateEntity(entity:EntityComponent):void 
		{
			
		}
		
		/**
		 * Private method to detect all aliasys of class (in general chain inheritable)
		 * @param	T
		 * @return
		 */
		private function collectAliasys(T:Class):Vector.<String> 
		{
			var result:Vector.<String> = dCacheCollectAliasys[T];
			if (!result)
			{
				result = Vector.<String>([getQualifiedClassName(T)]);
				var descriptionSubclass:XML = describeType(T);
				for each (var mImplements:XML in descriptionSubclass.factory.implementsInterface) 
				{
					result.push(mImplements.@type);
					
				}
				for each (var mExtends:XML in descriptionSubclass.factory.extendsClass) 
				{
					result.push(mExtends.@type);
				}
				result.pop(); // remove 'Object'
				dCacheCollectAliasys[T] = result;
			}
			
			return result;
		}
		
		/**
		 * Remove child component
		 * @param	entity
		 */
		public final function removeComponent(entity:EntityComponent):void
		{
			trace( "EntityNode.removeComponent > entity : " + entity );
			if (entity._node == this)
			{
				var aliasys:Vector.<String> = collectAliasys(getClass(entity));
				for (var i:int = 0, i_max:int = aliasys.length; i < i_max; i++) 
				{
					var collection:Vector.<EntityComponent> = dEntities[aliasys[i]];
					if (collection && collection.length)
					{
						var index:int = collection.indexOf(entity);
						if (index >= 0)
						{
							collection.splice(index, 1);
						}
					}
				}
			
				index = vEntities.indexOf(entity);
				if (index >= 0)
				{
					vEntities.splice(index, 1);
				}
				entity._node = null;
				entity.onDetatched.dispatch(this);
			}
		}
		
		/**
		 * remove all component by class
		 * @param	T
		 */
		public function removeComponents(T:Class):void
		{
			var list:Vector.<EntityComponent> = getChildComponents(T);
			for (var i:int = 0, i_max:int = list.length; i < i_max; i++) 
			{
				removeComponent(list[i]);
			}
		}
		
		
		/**
		 * Get first entity node by class in child components 
		 * @param	T
		 * @return
		 */
		public final function getChildComponent(T:Class):*
		{
			var tClass:String = getQualifiedClassName(T);
			if (dEntities[tClass] && dEntities[tClass].length) return dEntities[tClass][0];
			return null;
		}
		
		/**
		 * Get all components by class, looking in child nodes - not recursive!
		 * @param	T
		 * @return
		 */
		public final function getChildComponents(T:Class):Vector.<EntityComponent>
		{
			var tClass:String = getQualifiedClassName(T);
			return dEntities[tClass] ? dEntities[tClass].slice() : new Vector.<EntityComponent>();
		}
		
		/**
		 * Try to find component by specific class / alisa. This method looking recursive
		 * @param	T
		 * @return
		 */
		public final function findComponent(T:Class):EntityComponent
		{
			var tClass:String = getQualifiedClassName(T);
			var result:EntityComponent;
			if (dEntities[tClass] && dEntities[tClass].length) return dEntities[tClass][0];
			
			return result;
		}
		
		/**
		 * Find all list of component
		 * @param	T
		 * @return
		 */
		public final function findComponents(T:Class):Vector.<EntityComponent>
		{
			var tClass:String = getQualifiedClassName(T);
			
			var result:Vector.<EntityComponent> = dEntities[tClass];
			if (result) result = result.slice();
			else result = new Vector.<EntityComponent>();
			
			return result;
		}
		
		
		public final function get parentNode():EntityNode 
		{
			return _parent;
		}
		
		/**
		 * Clean is pretty consuming method, because this operation have to clean every sub-child of three. 
		 */
		public function clean():void 
		{
			// helper, cleanLocals remove _parent reference
			//var _parentTmp:EntityNode = _parent;
			
			cleanLocal();
			
			// remove component after ensure that every entity in childs is cleaned 
			//if (_parentTmp) _parentTmp.removeComponent(this); 
			_exist = false;
			
		}
		
		/**
		 * this function clean up sub nodes, and itself, but not clean reference in parent. 
		 * Omit remove from parent helps to improve performance.
		 * Ensure that: beforeClean, onClean, onDetached are evaluated. 
		 */
		internal function cleanLocal():void
		{
			beforeClean();
			for (var i:int = 0, i_max:int = vEntities.length; i < i_max; i++) 
			{
				vEntities[i].onCleanNode.dispatch(this);
				vEntities[i].onDetatched.dispatch(this);
				vEntities[i].clean();
				
			}
			vEntities = new Vector.<EntityComponent>();
			dEntities = new Dictionary();
			_parent = null;
		}
		
		protected function beforeClean():void 
		{
			
		}
		
		public function get exist():Boolean 
		{
			return _exist;
		}
		
	}

}