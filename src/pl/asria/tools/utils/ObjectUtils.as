/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-05-18 16:02</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.utils 
{
	
	public class ObjectUtils 
	{
	
		/**
		 * ObjectUtils - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function ObjectUtils() 
		{
			
		}
		
		public static function getRandomFrom(source:Object, count:int):Array
		{
			// get all rows
			var rows:Array = [];
			
			for (var key:Object in source) 
			{
				rows.push({data:source[key], id:Math.random()});
			}
			
			rows = rows.sortOn(["id"],Array.NUMERIC);
			
			// prepare result
			var result:Array = [];
			count = Math.min(count, rows.length);
			

			for (var i:int = 0; i < count; i++) 
			{
				result.push(rows[i].data);
			}
			
			return result;
			
		}
		
		public static function countRows(source:Object):int 
		{
			var count:int = 0;
			
			for (var key:Object in source) 
			{
				count++;
			}
			
			return count
		}
		
		public static function simpleInject(target:Object, source:Object):*
		{
			if (source)
			{
				for (var key:Object in source) 
				{
					target[key] = source[key];
				}
			}
			
			return target;
		}
		
		public static function simpleDump(source:Object):Object
		{
			var result:Object = { };
			for (var key:Object in source) 
			{
				result[key] = source[key];
			}
			return result;
		}
		
	}

}