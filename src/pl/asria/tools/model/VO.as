/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-08-24 17:09</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.model 
{
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import org.osflash.signals.Signal;
	import pl.asria.tools.data.ICleanable;
	import pl.asria.tools.performance.memorize;
	import pl.asria.tools.utils.getClass;
	import pl.asria.tools.utils.getClassAlias;
	
	public class VO
	{
		protected var _rawData:Object;
		protected var _versionVO:int;
		protected var _class:String;
		protected var _onChange:Signal = new Signal(VO);
		protected var _onChangeValue:Signal = new Signal(String, VO);
		protected var _xmlPrototype:XML;
		/**
		 * VO - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function VO() 
		{
			//_className = getQualifiedClassName(this);
		}
		
		protected function _setupEnumerables():void 
		{
			
		}
		
		
		/**
		 * 
		 * @param	source
		 * @param	key
		 * @param	defaultValue	function return those value, or directly value
		 * @return
		 */
		protected function getValue(source:Object, key:String, defaultValue:* = null):*
		{
			
			return source[key] == undefined ? ((defaultValue is Function) ? defaultValue() : defaultValue) : source[key];
		}
		
		
		/**
		 * 
		 * @param	target	result object
		 * @param	vectors	names of vectors/arrays (expect VO based obejcts inside)
		 */
		protected function dumpVectors(target:Object, vectors:Array):void
		{
			for each (var vector:String in vectors) 
			{
				target[vector] = [];
				for (var j:int = 0, j_max:int = this[vector].length; j < j_max; j++) 
				{
					target[vector].push(this[vector][j].toJSON(vector));
				}
			}
		}
		
		/**
		 * 
		 * @param	target	result object
		 * @param	name - vector name
		 * @param	translator	function(item:T):Object 
		 */
		protected function dumpVectorNonVO(target:Object, name:String, translator:Function):void
		{
			var source:* = this[name];
			if (!target[name]) target[name] = [];
			target = target[name];
			
			for each (var element:Object in source) 
			{
				target.push(translator(element))
			}
		}
		
		/**
		 * dumpo dictionaries with VO based elements
		 * @param	target	result object
		 * @param	dictNames	names of dicts/objects (expect VO based obejcts inside)
		 */
		protected function dumpDictionaties(target:Object, dictNames:Array):void
		{
			for each (var dict:String in dictNames) 
			{
				target[dict] = { };
				
				for (var dictItem:String in this[dict]) 
				{
					target[dict][dictItem] = this[dict][dictItem].toJSON(dict)
				}
			}
		}
		
		public function fromJSON(loadData:Object):* 
		{
			_rawData = loadData;
			return this;
		}
		
		public function fromXML(xml:XML):*
		{
			_xmlPrototype = xml;
			return this;
		}
		
		public function toJSON(k:String = null):Object
		{
			return {};
		}
		
		public function toXML(k:String = null):XML
		{
			return new XML("<" + (k || getClassAlias(this)) + "/>");
		}
		
		public function touchValue(name:String):void
		{
			_onChangeValue.dispatch(name, this[name]);
		}
		
		public function touch():void 
		{
			_onChange.dispatch(this);
		}
		
		public function setValue(name:String, value:*):void
		{
			if (this[name] != value)
			{
				this[name] = value;
				_onChange.dispatch(this);
			}
		}
		
		/**
		 * Determines that current model has non default properties
		 * @return
		 */
		public function isNotDefault():Boolean
		{
			return true;
		}
		
		public function template():*
		{
			fromJSON( { } );
			return this;
		}
		
		public function clone():*
		{
			var result:VO = new (getClass(this))();
			result.fromJSON(this.toJSON());
			return result;
		}
		
		protected function cloneObject(source:Object):Object
		{
			if (typeof(source) == "object")
			{
				var result:Object;
				if (source is Array)
				{
					result = []
				}
				else
				{
					result = {}
				}
				
				for (var name:String in source) 
				{
					result[name] = cloneObject(source[name]);
				}
				return result;
			}
			return source
		}
		
		public function get className():String 
		{
			return _class == null ? _class = getQualifiedClassName(this) : _class;
		}
		
		public function get classInstanceName():String 
		{
			return className.split("::").pop();
		}
		
		public function get versionVO():int 
		{
			return _versionVO;
		}
		
		public function set versionVO(value:int):void 
		{
			_versionVO = value;
		}
		
		/**
		 * Instantine model as class. Required is define class name definition in jsonData.className
		 * @param	jsonData
		 * @return
		 */
		public static function createFullVO(jsonData:Object):*
		{
			if (!jsonData || !(jsonData.cN|| jsonData.className)) throw new ArgumentError("jsonData havet to be not null, and className have to be set inside jsonData");
			try {
				var classData:Class = fastGetDefinitionByName(jsonData.cN || jsonData.className) as Class;
			}
			catch (e:Error)
			{
				return null;
			}
			var model:VO = new classData() as VO;
			model.fromJSON(jsonData);
			return model;
		}
		
		protected function createVO(classDefinition:Class, jsonData:Object):* 
		{
			var model:VO = new classDefinition() as VO;
			model.fromJSON(jsonData);
			return model;
		}
		
		protected function createArrayVO(classDefinition:Class, array:Array):* 
		{
			var result:Array = [];
			if (array)
			{
				for (var i:int = 0, i_max:int = array.length; i < i_max; i++) 
				{
					result[i] = createVO(classDefinition, array[i]);
				}
			}
			
			return result;
		}
		
		protected function storeClassName(target:Object, className:String):void 
		{
			target.cN = className;
		}
		
		protected static const fastGetDefinitionByName:Function = memorize(getDefinitionByName);
		
		
		[Inline]
		static protected function getClassNameLUT(originClassName:String):String 
		{
			if (lut[originClassName]) 
			{
				return lut[originClassName];
			}
			return originClassName;
		}
		
		
		private static const lut:Object = { };
	}
	
}

