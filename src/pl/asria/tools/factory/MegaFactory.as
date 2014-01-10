/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-10-25 08:28</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.factory 
{
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import pl.asria.tools.data.ICleanable;
	import pl.asria.tools.utils.getClass;
	import pl.asria.tools.utils.isBasedOn;
	
	public class MegaFactory implements ICleanable
	{
		
		protected var _dBuilders:Dictionary = new Dictionary(true);
		/**
		 * MegaFactory - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function MegaFactory() 
		{
			
		}
		
		public final function createAsync(definition:Object, alias:Class = null):MegaFactoryResult
		{
			if (!alias) alias = definition.constructor;
			var builderSource:Object = _dBuilders[alias];
			if (builderSource == null)
			{
				throw new Error("Builder is not registred for ", alias);
				return null;
			}
			
			// get builder
			var builder:AbstractMegaFactoryBuilder = builderSource as AbstractMegaFactoryBuilder;
			if (!builder)
			{
				builder = new builderSource() as AbstractMegaFactoryBuilder;
				builder.ns_factory::factory = this;
				builder.ns_factory::unregister = false;
				builder.ns_factory::cleanup = true;
			}
			
			// get result
			var result:MegaFactoryResult;
			var resultObject:Object;
			if (builder)
			{
				resultObject = builder.create(definition);
				if (resultObject is MegaFactoryResult)
				{
					result = resultObject as MegaFactoryResult;
				}
				else
				{
					// wrap into MegaFactoryResult class
					result = new MegaFactoryResult();
					result.setDataAsync(resultObject);
				}
				
				// cleanup
				if (builder.ns_factory::cleanup)
				{
					builder.clean();
				}
				
				if (builder.ns_factory::unregister)
				{
					unregisterType(alias);
				}
			}
			return result;
		}
		
		public function hasBuilder(definitionClass:Class):Boolean
		{
			return _dBuilders[definitionClass];
		}
		
		public final function create(definition:Object):*
		{
			var result:*;
			var builderSource:* = _dBuilders[definition.constructor];
			var builder:AbstractMegaFactoryBuilder = builderSource as AbstractMegaFactoryBuilder;
			if (builder)
			{
				result = builder.create(definition);
				if (builder.ns_factory::unregister)
				{
					unregisterType(getClass(definition));
				}
				return result;
			}
			
			if (builderSource is Class) 
			{
				builder = new builderSource();
				
				// create on demand
				builder.ns_factory::factory = this;
				result = builder.create(definition);
				builder.clean();
				return result;
			}
			
			throw new Error("[MegaFactory] unsupported create definition: " + definition);
			
			return null;
		}
		
		/**
		 * 
		 * @param	definitionClass
		 * @param	builderClass	optional param, if is set, delete will be processed only if builder match type
		 */
		public final function unregisterType(definitionClass:Class, builderClass:Class = null):void
		{
			if (builderClass)
			{
				if (getClass(_dBuilders[definitionClass]) == builderClass)
				{
					delete _dBuilders[definitionClass];
				}
			}
			else
			{
				delete _dBuilders[definitionClass];
			}
		}
		
		/**
		 * 
		 * @param	definitionClass
		 * @return	Class registred by registerBuilderClass method
		 */
		public final function getBuilderClass(definitionClass:Class):Class
		{
			return _dBuilders[definitionClass] as Class;
		}
		
		/**
		 * 
		 * @param	definitionClass
		 * @return	instance of builder registred by registerBuilder method
		 */
		public final function getBuilder(definitionClass:Class):AbstractMegaFactoryBuilder
		{
			return _dBuilders[definitionClass] as AbstractMegaFactoryBuilder;
		}
		
		public final function registerBuilderClass(definitionClass:Class, builderClass:Class):void
		{
			if (isBasedOn(builderClass, AbstractMegaFactoryBuilder))
			{
				_dBuilders[definitionClass] = builderClass;
			}
			else
			{
				throw new ArgumentError("MagaFactory.registerBuilderClass: BuilderClass do not extends AbstractMegaFactoryBuilder")
			}
		}
		
		public final function registerBuilder(definitionClass:Class, builder:AbstractMegaFactoryBuilder, once:Boolean = false):void
		{
			if (builder) 
			{
				_dBuilders[definitionClass] = builder;
				builder.ns_factory::factory = this;
				builder.ns_factory::unregister = once;
			}
			else throw new ArgumentError("MagaFactory.registerBuilder: builder can not be null")
		}
		
		public function clean():void 
		{
			trace( "2:MegaFactory.clean");
			for (var item:Object in _dBuilders) 
			{
				var builder:AbstractMegaFactoryBuilder = _dBuilders[item] as AbstractMegaFactoryBuilder;
				trace( "0:- " + getQualifiedClassName(item), "\n0:\t", builder);
				if (builder) builder.clean();
				delete _dBuilders[item];
			}
			_dBuilders = new Dictionary(true)
		}
	}
}

