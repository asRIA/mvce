/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-10-09 17:25</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.display.ui.menu 
{
	import flash.geom.Point;
	import pl.asria.tools.data.ICleanable;
	
	public class ContextMenuDescription implements ICleanable
	{
		internal var _vItems:Vector.<ContextMenuItem>;
		public var globalPoint:Point;
	
		/**
		 * ContextMenuDescription - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function ContextMenuDescription() 
		{
			_vItems = new Vector.<ContextMenuItem>();
		}
		
		/* INTERFACE pl.asria.tools.data.ICleanable */
		
		public function clean():void 
		{
			for (var i:int = 0, i_max:int = _vItems.length; i < i_max; i++) 
			{
				_vItems[i].clean();
			}
			_vItems = null;
			globalPoint = null;
		}
		
		
		public function addContextMenuItem(item:ContextMenuItem):void
		{
			_vItems.push(item)
		}
		
		public function addContextMenuItemAt(item:ContextMenuItem, index:int):void
		{
			index = index < 0 ? 0 : index > _vItems.length ? _vItems.length : index;
			_vItems.splice(index, 0, item);
		}
		
		public function getIndex(item:ContextMenuItem):int
		{
			return _vItems.indexOf(item)
		}
		
		public function removeItem(item:ContextMenuItem):void
		{
			var index:int = _vItems.indexOf(item);
			if (index >= 0)
			{
				removeItemFrom(index);
			}
		}
		
		public function removeItemFrom(index:int):void 
		{
			if (index >= 0 && index < _vItems.length)
			{
				_vItems.splice(index, 1);
			}
		}
		
		public function get length():int
		{
			return _vItems.length;
		}
	}

}