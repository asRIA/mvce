/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2013-05-24 16:17</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.display 
{
	import flash.geom.Point;
	
	public class DisturbeArrayCollectionXYPages 
	{
		/**  **/
		static public const VERTICAL:String = "vertical";
		/**  **/
		static public const HORIZONTAL:String = "horizontal";
	
		/**
		 * DisturbeArrayCollectionXYPages - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function DisturbeArrayCollectionXYPages() 
		{
			
		}
		
		public static function getPosition(offsetX:Number, offsetY:Number, pagesOffset:Number, cRows:int, cCols:int, index:int, orientation:String = "vertical", displayObject:Object = null):PlacementArrayCollection
		{
			var result:PlacementArrayCollection = new PlacementArrayCollection();
			var capacity:int = cRows * cCols;
			var pageSize:Number = cCols * offsetX + pagesOffset;
			
			var page:int = index / capacity;
			var localIndex:int = index % capacity;
			
			
			var collumnIndex:int = localIndex % cCols;
			var rowIndex:int = localIndex / cCols;
			
			
			var position:Point = new Point(offsetX * collumnIndex, offsetY * rowIndex);
			
			result.point = position;
			result.page = page;
			result.totalIndex = index;
			result.localIndex = localIndex;
			
			result.localCollumnIndex = collumnIndex;
			result.localRowIndex = rowIndex;
			
			
			switch(orientation)
			{
				case VERTICAL:
					result.rowIndex = rowIndex + page * cRows;
					result.collumnIndex = collumnIndex;
					position.y += page * pageSize;
					break;
				case HORIZONTAL:
					result.rowIndex = rowIndex;
					result.collumnIndex = collumnIndex + page * cCols;
					position.x += page * pageSize;
					break;
			}
			
			if (displayObject) 
			{
				displayObject.x = position.x;
				displayObject.y = position.y;
			}
			
			
			return result;
		}
		
	}
}
import flash.geom.Point;

internal class PlacementArrayCollection
{
	public var point:Point;
	public var page:int;
	public var totalIndex:int;
	public var localIndex:int;
	public var localCollumnIndex:int;
	public var localRowIndex:int;
	public var rowIndex:int;
	public var collumnIndex:int;
	
	public function PlacementArrayCollection()
	{
		
	}
}