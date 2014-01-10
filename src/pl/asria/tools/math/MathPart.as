/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-04-23 15:24</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.math 
{
	
	public class MathPart 
	{
		public var end:Number;
		public var begin:Number;
	
		/**
		 * MathPart - Abstract representation of part structure
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function MathPart(begin:Number = 0, end:Number= 0) 
		{
			this.end = end;
			this.begin = begin;
		}
		
		public function isIn(position:Number):Boolean
		{
			return position >= begin && position <= end;
		}
		
		
		/**
		 * 
		 * @param	object {begin, end}
		 */
		public static function create(object:Object):MathPart
		{
			return new MathPart(object.begin, object.end);
		}
		
		public static function collapse(arrayParts:Array):Array
		{
			if (!arrayParts || arrayParts.length == 0) return [];
			
			var result:Array = [arrayParts.pop()];
			
			while (arrayParts.length)
			{
				var current:MathPart = arrayParts.pop();
				for each (var item:MathPart in result) 
				{
					if (item.isIn(current.begin))
					{
						if (!item.isIn(current.end))
						{
							item.end = current.end;
						}
					}
					else if (item.isIn(current.end))
					{
						if (!item.isIn(current.begin))
						{
							item.begin = current.begin;
						}
					}
					else
					{
						result.push(current);
					}
				}
			}
			
			return result;
			
		}
	}

}