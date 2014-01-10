/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-05-21 09:31</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.display.arrayColection 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import pl.asria.tools.display.IWorkspace;
	
	/** 
	* Dispatched when ... 
	**/
	[Event(name="change", type="flash.events.Event")]
	public class ArrayCollectionContentView extends Sprite
	{
		protected var _lock:Boolean;
		protected var _vCollection:Vector.<IWorkspace>;
		protected var _heightArrayCollection:Number;
		protected var _dirtyHeight:Boolean;
		protected var _changed:Boolean;
	
		/**
		 * ArrayCollectionContentView - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function ArrayCollectionContentView() 
		{
		}
		
		
		public function cleanUp():void
		{
			// remove visual content
			if (_vCollection)
			{
				for (var i:int = 0, i_max:int = _vCollection.length; i < i_max; i++) 
				{
					removeChild(_vCollection[i] as DisplayObject);
				}
				
				_vCollection = null;
				
				
				_dirtyHeight = false;
				_heightArrayCollection = 0;
				
				_changed = true;
				if (!lock) 
				{
					dispatchEvent(new Event(Event.CHANGE));
					_changed = false;
				}
			}
			
		}
		
		public function push(iteam:IWorkspace):void
		{
			if (!_vCollection) _vCollection = new Vector.<IWorkspace>();
			var _doIteam:DisplayObject = iteam as DisplayObject;
			
			
			// correct according to workspace
			_doIteam.y = heightArrayCollection - iteam.getWorkspace().y;
			
			
			// add logic
			_vCollection.push(iteam);
			_dirtyHeight = true;
			
			
			// add visual process
			addChild(_doIteam);
			
			
			_changed = true;
			if (!lock) 
			{
				dispatchEvent(new Event(Event.CHANGE));
				_changed = false;
			}
		}
		
		public function get heightArrayCollection():Number 
		{
			var result:Number = 0;
			if (!_dirtyHeight) return _heightArrayCollection;
			
			for (var i:int = 0, i_max:int = _vCollection.length; i < i_max; i++) 
			{
				result += _vCollection[i].getWorkspace().height;
			}
			_heightArrayCollection = result;
			_dirtyHeight = false;
			
			
			return result;
		}
		
		// lock update eny contents lincked to this content
		public function get length():int
		{
			if (_vCollection) return _vCollection.length;
			return -1;
		}
		
		public function get lock():Boolean 
		{
			return _lock;
		}
		
		public function set lock(value:Boolean):void 
		{
			_lock = value;
			if (!_lock && _changed)
			{
				dispatchEvent(new Event(Event.CHANGE));
				_changed = false;
			}
		}
		
		public function getPositionOf(index:int):Number
		{
			if (_vCollection.length <= index) return -1;
			
			// recompensate WS
			return _vCollection[index].getWorkspace().y + (_vCollection[index] as DisplayObject).y;
		}
		
		
		
		
		
		
	}

}