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
	
	public class VectorUtils 
	{
		/**  **/
		public static const METHOD_QUEUE:String = "methodQueue";
		public static const METHOD_CROSSFADE:String = "methodCrossfade";
	
		public static function mixVectors(vectors:Array, method:String = "methodQueue"):Vector.<*>
		{
			var result:Vector.<*> = new Vector.<*>();
			switch(method)
			{
				case METHOD_QUEUE:
					for (var i:int = 0, i_max:int = vectors.length; i < i_max; i++) 
					{
						result = result.concat(vectors[i]);
					}
					break;
					
				case METHOD_CROSSFADE:
					var permission:Boolean = true;
					var index:int = 0;
					while (permission)
					{
						permission = false;
						for (var j:int = 0, j_max:int = vectors.length; j < j_max; j++) 
						{
							if (vectors[j].length > index)
							{
								permission = true;
								result.push(vectors[j][index]);
							}
						}
						index++;
					}
					break;
			}
			return result;
		}
		public static function randomizeVector():Array
		{
			//var premix:Array = []
			//for (var i:int = 0; i < someVector.length; i++) 
			//{
				//var node:Object = { data:someVector[i], rand:Math.random() };
				//premix.push(node)
			//}
			//premix = premix.sortOn(["rand"], Array.DESCENDING | Array.NUMERIC);
			//var tmpVector:Vector.<*> = new Vector.<*>();
			//for (i = 0; i < premix.length; i++) tmpVector.push(premix[i].data)
		}
	}

}