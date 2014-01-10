/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2013-04-12 22:35</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.performance 
{
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import pl.asria.tools.utils.getClass;
	
	public class ReferenceDetector 
	{
		protected static var __count:int;
	
		private static const _lib:Dictionary = new Dictionary(false);
		/**
		 * ReferenceDetector - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function ReferenceDetector(ref:* = null) 
		{
			ref ||= this;
			var base:Class = getClass(ref);
			var dict:Dictionary = _lib[base];
			if (!dict)
			{
				dict = new Dictionary(true);
				_lib[base] = dict;
			}
			else
			{
				dict[ref] = new Error().getStackTrace();
			}
			__count++;
		}
		
		public static function printState(baseClass:Class = null):void
		{
			if (!baseClass)
			{
				// full print
				trace("5:Full print Refernece Detector\n>>START");
				for (var key:Object in _lib) 
				{
					printState(Class(key));
				}
				trace("5:>>>END");
			}
			else
			{
				var lib:Dictionary = _lib[baseClass];
				if (lib)
				{
					var i:int;
					trace("3:" + getQualifiedClassName(baseClass));
					for each (var item:String in lib) 
					{
						trace("[" + i + "]" + item);
						i++;
					}
				}
			}
		}
		
	}

}