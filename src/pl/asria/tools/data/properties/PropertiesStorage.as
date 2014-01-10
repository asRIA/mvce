/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-11-14 08:49</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.data.properties 
{
	import flash.utils.Dictionary;
	import pl.asria.tools.utils.getClass;
	import pl.asria.tools.utils.getSuperClass;
	
	public class PropertiesStorage 
	{
		protected static const _dPropDetails:Dictionary = new Dictionary();
		protected static const _dPropContext:Dictionary = new Dictionary();
		public static function setDetails(description:PropertiesDetalis, classType:Class, propertyPath:String, dependiesPath:String = null, dependiesData:* = null):void
		{
			if (dependiesData && typeof(dependiesData) == "object") throw TypeError("propertyDependiesData have to be simple value like: Boolen, String, int, Number, uint");
			
			// crate dependies path
			if (!_dPropDetails[classType]) _dPropDetails[classType] = { };
			if (!_dPropDetails[classType][propertyPath]) _dPropDetails[classType][propertyPath] = { };
			
			_dPropDetails[classType][propertyPath][dependiesData] = description;
			
			// create context path
			//if (dependiesPath)
			{
				if (!_dPropContext[classType]) _dPropContext[classType] = { };
				_dPropContext[classType][propertyPath] = dependiesPath;
			}
		}
		
		/**
		 * 
		 * @param	classType	class of searched elements
		 * @param	property	name of property, or property.subproperty
		 * @param	recursive	recursive search over superclass chain
		 * @return
		 */
		public static function retriveAllFromObject(object:*, recursive:Boolean = false):Object
		{
			var classType:Class = getClass(object);
			var result:Object = { };
			var loop:Boolean = true;
			while (loop)
			{
				for (var propertyPath:String in _dPropContext[classType]) 
				{
					if (result[propertyPath]) continue;
					var descryption:PropertiesDetalis = _retriveFromObjectClass(object, classType, propertyPath);
					if (descryption) result[propertyPath] = descryption;
				}
				
				if (recursive)
				{
					classType = getSuperClass(classType);
					loop = classType != Object;
				}
				else
				{
					loop = false;
				}
			}
			return result;
		}
		
		public static function retriveFromObject(object:*, propertyPath:String):PropertiesDetalis
		{
			var classType:Class = getClass(object);
			return _retriveFromObjectClass(object, classType, propertyPath);
		}
		
		public static function validObjectPath(object:*, propertyPath:String, recursive:Boolean = false):void 
		{
			var _descryptions:Object = retriveAllFromObject(object, recursive);
			//for (var propertyPath:String in _descryptions) 
			//{
			var details:PropertiesDetalis = _descryptions[propertyPath];
			//}
			if (details) details.process(object, propertyPath);
		}
		
		protected static function _retriveFromObjectClass(object:*, classType:Class, propertyPath:String):PropertiesDetalis
		{
			var result:PropertiesDetalis;
			// get dependies path
			var dependiesPath:String;
			var dependiesData:* = null;
			if (_dPropContext[classType] && _dPropContext[classType][propertyPath])
			{
				dependiesPath = _dPropContext[classType][propertyPath];
				dependiesData = retrivePoperty(object, dependiesPath);
			}
			
			if (_dPropDetails[classType] && _dPropDetails[classType][propertyPath] && _dPropDetails[classType][propertyPath][dependiesData])
			{
				result = _dPropDetails[classType][propertyPath][dependiesData];
			}
			
			return result;
		}
		
		protected static function retrivePoperty(object:*, dependiesPath:String):* 
		{
			var result:* = object;
			var path:Array = dependiesPath.split(".");
			for (var i:int = 0, i_max:int = path.length; i < i_max; i++) 
			{
				result = result[path[i]];
			}
			return result;
		}
		
	}
}
