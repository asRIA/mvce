/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-06-06 10:17</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.utils 
{
	
	public class ArrayUtils 
	{
		/**  **/
		public static const METHOD_QUEUE:String = "methodQueue";
		public static const METHOD_CROSSFADE:String = "methodCrossfade";
	
		
		public static function getRandomIndexes(capacity:uint, count:uint):Vector.<int> 
		{
			count > capacity ? count = capacity : null;
			var result:Array = [];
			
			var input:Vector.<int> = new Vector.<int>(capacity, true);
			if (capacity == 0) return input;
			
			for (var i:int = 0; i < capacity; i++) 
			{
				input[i] = i;
			}
			
			for (i = 0; i < count; i++)
			{
				// rand index
				var rand:int = input[randomIntTo(capacity)];
				// tmp copu
				var tmp:int = input[rand];
				
				// move last available index to rand place
				// decrease capacity -> reserve place for rand 
				input[rand] = input[--capacity];
				
				// move rand index to reserved place
				input[capacity] = tmp;
			}
			
			return input.slice(capacity); // return reserved idexys
		}
		
		/**
		 * 
		 * @param	source source have to be sorted before
		 * @return
		 */
		public static function uniqueFilter(source:Array):Array 
		{
			if (source.length)
			{
				var result:Array = [source[0]];
				var result_i:int = 0;
				
				for (var i:int = 1, i_max:int = source.length; i < i_max; i++) 
				{
					if(result[result_i] != source[i]) result[++result_i] = source[i]
				}
				return result;
			}
			return [];
		}
		
		public static function mixArrays(arrays:Array, method:String = "methodQueue"):Array
		{
			var result:Array = [];
			switch(method)
			{
				case METHOD_QUEUE:
					for (var i:int = 0, i_max:int = arrays.length; i < i_max; i++) 
					{
						result = result.concat(arrays[i]);
					}
					break;
					
				case METHOD_CROSSFADE:
					var permission:Boolean = true;
					var index:int = 0;
					while (permission)
					{
						permission = false;
						for (var j:int = 0, j_max:int = arrays.length; j < j_max; j++) 
						{
							if (arrays[j].length > index)
							{
								permission = true;
								result.push(arrays[j][index]);
							}
						}
						index++;
					}
					break;
			}
			return result;
		}
	}

}