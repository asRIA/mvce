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
package pl.asria.asmvc.factory 
{
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import pl.asria.utils.isBasedOn;
	import pl.asria.tools.data.ICleanable;
	
	public class Factory implements ICleanable
	{
		
		protected var _dBuilders:Dictionary = new Dictionary(true);
		/**
		 * Factory - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function Factory() 
		{
			
		}
		
		public final function create(definition:Object):*
		{
			var builderSource:* = _dBuilders[definition.constructor];
			var builder:AbstractFactoryBuilder = builderSource as AbstractFactoryBuilder;
			if (!builder && builderSource is Class) builder = new builderSource();
			if (!builder)
			{
				throw new Error("[Factory] unsupported create definition: " + definition);
			}
			return builder.create(definition);
		}
		
		public final function unregisterType(definitionClass:Class):void
		{
			delete _dBuilders[definitionClass];
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
		public final function getBuilder(definitionClass:Class):AbstractFactoryBuilder
		{
			return _dBuilders[definitionClass] as AbstractFactoryBuilder;
		}
		
		public final function registerBuilderClass(definitionClass:Class, builderClass:Class):void
		{
			if (isBasedOn(builderClass, AbstractFactoryBuilder))
			{
				_dBuilders[definitionClass] = builderClass;
			}
			else
			{
				throw new ArgumentError("Factory.registerBuilderClass: BuilderClass do not extends AbstractFactoryBuilder")
			}
		}
		
		public final function registerBuilder(definitionClass:Class, builder:AbstractFactoryBuilder):void
		{
			if (builder) _dBuilders[definitionClass] = builder;
			else throw new ArgumentError("Factory.registerBuilder: builder can not be null")
		}
		
		public function clean():void 
		{
			trace( "2:Factory.clean");
			for (var item:Object in _dBuilders) 
			{
				trace( "0:- " +getQualifiedClassName(item), "\n0:\t", _dBuilders[item]);
				delete _dBuilders[item];
			}
			_dBuilders = new Dictionary(true)
		}
	}

}