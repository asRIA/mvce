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
	import pl.asria.tools.data.ICleanable;
	import pl.asria.tools.utils.getClass;
	
	public class EntityNode implements ICleanable
	{
		static protected var dCacheCollectAliasys:Dictionary = new Dictionary();
	
		private var dEntities:Dictionary = new Dictionary();
		private var vEntities:Vector.<EntityNode> = new Vector.<EntityNode>();
		internal var _parent:EntityNode;
		
		/**
		 * EntityNode - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function EntityNode() 
		{
			
		}
		
		public function propagate(T:Class, method:String, ...params):void
		{
			var entities:Array = getChildComponents(T);
			for (var i:int = 0, i_max:int = entities.length; i < i_max; i++) 
			{
				entities[i][method].apply(this, params);
			}
		}
		public function boardcast(T:Class, method:String, ...params):void
		{
			var entities:Array = findComponents(T);
			for (var i:int = 0, i_max:int = entities.length; i < i_max; i++) 
			{
				entities[i][method].apply(this, params);
			}
		}
		
		public final function addComponent(entity:EntityNode):void
		{
			if (entity.parentNode) entity.parentNode.removeComponent(entity);
			entity._parent = this;
			
			var def:Class = getClass(entity);
			var aliasys:Vector.<String> = collectAliasys(def);
			for (var i:int = 0, i_max:int = aliasys.length; i < i_max; i++) 
			{
				var collection:Array = dEntities[aliasys[i]];
				if (!collection)
				{
					dEntities[aliasys[i]]  = [entity];
				}
				else if(collection.indexOf(entity) < 0)
				{
					collection.push(entity);
				}
			}
			vEntities.push(entity);
			entity.onAttached();
		}
		
		
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
		
		
		public final function removeComponent(entity:EntityNode):void
		{
			if (entity.parentNode == this)
			{
				var aliasys:Vector.<String> = collectAliasys(getClass(entity));
				for (var i:int = 0, i_max:int = aliasys.length; i < i_max; i++) 
				{
					var collection:Array = dEntities[aliasys[i]];
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
				entity._parent = null;
				entity.onDetatched();
			}
		}
		
		public function removeComponents(T:Class):void
		{
			var list:Array = getChildComponents(T);
			for (var i:int = 0, i_max:int = list.length; i < i_max; i++) 
			{
				removeComponent(list[i]);
			}
		}
		
		protected function onDetatched():void 
		{
			
		}
		
		public final function getChildComponent(T:Class):*
		{
			var tClass:String = getQualifiedClassName(T);
			if (dEntities[tClass] && dEntities[tClass].length) return dEntities[tClass][0];
			return null;
		}
		public final function getChildComponents(T:Class):Array
		{
			var tClass:String = getQualifiedClassName(T);
			return dEntities[tClass] ? dEntities[tClass].slice() : [];
		}
		
		public final function findComponent(T:Class):*
		{
			var tClass:String = getQualifiedClassName(T);
			var result:*;
			if (dEntities[tClass] && dEntities[tClass].length) return dEntities[tClass][0];
			for (var i:int = 0, i_max:int = vEntities.length; i < i_max; i++) 
			{
				result = vEntities[i].findComponent(T);
				if (result) return result;
			}
			return result;
		}
		
		public final function findComponents(T:Class):Array
		{
			var tClass:String = getQualifiedClassName(T);
			var result:Array = dEntities[tClass] || [];
			for (var i:int = 0, i_max:int = vEntities.length; i < i_max; i++) 
			{
				result = result.concat(vEntities[i].findComponents(T));
			}
			return result.slice();
		}
		
		protected function onAttached():void 
		{
			
		}
		
		public function clean():void 
		{
			onClean();
			if (_parent) _parent.removeComponent(this);
			for (var i:int = 0, i_max:int = vEntities.length; i < i_max; i++) 
			{
				vEntities[i].clean();
			}
			vEntities = new Vector.<EntityNode>();
			dEntities = new Dictionary();
		}
		
		protected function onClean():void 
		{
			
		}
		
		public final function get parentNode():EntityNode 
		{
			return _parent;
		}
	}

}