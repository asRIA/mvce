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
	import flash.events.EventDispatcher;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import pl.asria.tools.performance.memorize;
	import pl.asria.tools.utils.getClass;
	
	/** 
	* Dispatched when ... 
	**/
	[Event(name="change", type="pl.asria.tools.model.ModelEvent")]
	public class Model extends EventDispatcher
	{
		protected var _rawData:Object;
		protected var _versionModel:int;
		protected var _class:String;
		
		/**
		 * Model - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function Model() 
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
		 * @param	vectors	names of vectors/arrays (expect Model based obejcts inside)
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
		protected function dumpVectorNonModel(target:Object, name:String, translator:Function):void
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
		 * dumpo dictionaries with Model based elements
		 * @param	target	result object
		 * @param	dictNames	names of dicts/objects (expect Model based obejcts inside)
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
		
		public function toJSON(k:String = null):Object
		{
			return {};
		}
		
		public function touchValue(name:String):void
		{
			dispatchEvent(new ModelEvent(ModelEvent.CHANGE, name, this[name]));
		}
		
		public function touch():void 
		{
			dispatchEvent(new ModelEvent(ModelEvent.CHANGE, null, null));
		}
		
		public function setValue(name:String, value:*):void
		{
			if (this[name] != value)
			{
				this[name] = value;
				dispatchEvent(new ModelEvent(ModelEvent.CHANGE, name, value))
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
			var result:Model = new (getClass(this))();
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
		
		public function get versionModel():int 
		{
			return _versionModel;
		}
		
		public function set versionModel(value:int):void 
		{
			_versionModel = value;
		}
		
		/**
		 * Instantine model as class. Required is define class name definition in jsonData.className
		 * @param	jsonData
		 * @return
		 */
		public static function createFullModel(jsonData:Object):*
		{
			// TODO: Nie znaduje ForceFieldPoint, nie wiem czemu, viariable not found error http://active.tutsplus.com/tutorials/actionscript/quick-tip-understanding-getdefinitionbyname/
			if (!jsonData || !(jsonData.cN|| jsonData.className)) throw new ArgumentError("jsonData havet to be not null, and className have to be set inside jsonData");
			try {
				var classData:Class = fastGetDefinitionByName(jsonData.cN || jsonData.className) as Class;
			}
			catch (e:Error)
			{
				return null;
			}
			var model:Model = new classData() as Model;
			model.fromJSON(jsonData);
			return model;
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

