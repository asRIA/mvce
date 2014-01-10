/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-09-27 20:02</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.model 
{
	import flash.utils.describeType;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import pl.asria.tools.data.ICleanable;
	import pl.asria.tools.utils.getClass;
	
	public dynamic class ProxyMap extends Dictionary implements ICleanable
	{
		/**
		 * ProxyMap - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function ProxyMap() 
		{
			super(true);
		}
		
		public function addProxy(instance:Object, alias:Class = null):void 
		{
			if (alias)
			{
				var valided:Boolean = false;
				if (instance is Class)
				{
					var description:XML = describeType(instance);
					var descriptionAliasClass:String = getQualifiedClassName(alias);
					valided = description.factory.extendsClass.(@type == descriptionAliasClass).length() || description.factory.implementsInterface.(@type == descriptionAliasClass).length();
				}
				else if (instance is alias)
				{
					valided = true;
					
				}
				if (!valided) ArgumentError("ProxyMap.addProxy : not connected class '" + instance + "' and alias '" +alias + "'");
			}
			else
			{
				alias = getClass(instance);
			}
			
			if(!alias) throw new ArgumentError("can not to get constructor class from", instance);
			if (this[alias] == undefined)
			{
				this[alias] = instance;
			}
			else
			{
				throw new Error("Already exist proxy on this alias");
			}
		}
		
		public function removeProxy(instance:Object):void 
		{
			var alias:Class = getClass(instance);
			if (!alias) throw new ArgumentError("can not to get constructor class");
			if (this[alias])
			{
				delete this[alias];
			}
		}
		
		public function removeProxyAlias(alias:Class):void 
		{
			if (alias && this[alias])
			{
				delete this[alias];
			}
		}
		
		/**
		 * 
		 * @param	alias	alias class of proxy
		 * @param	createOnDemand	if <code>true</code> and behind alias is Class, then content of proxy map is autorepleace by instance of class
		 * @return
		 */
		public function getProxy(alias:Class, createOnDemand:Boolean = false):*
		{
			if (this[alias])
			{
				var result:* = this[alias];
				if (result is Class && createOnDemand)
				{
					result = new result();
					this[alias] = result; // mape singleton style, created object on demand;
				}
				return this[alias];
			}
			return null;
		}
		
		/* INTERFACE pl.asria.tools.data.ICleanable */
		
		public function clean():void 
		{
			var dirty:Boolean = false;
			for (var key:Object in this) 
			{
				if (key is Class)
				{
					if (!dirty)
					{
						trace( "2:ProxyMap: uncleaned values" );
						dirty = true;
					}
					trace("0:\t- ", getQualifiedClassName(key))
					delete this[key];
				}
			}
		}
	}

}