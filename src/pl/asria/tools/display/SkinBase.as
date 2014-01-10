/**
* CHANGELOG
* 2011-11-04 16:53:	Adopt new interface ISkin
* 2011-11-04 16:34:	fill skinOver method
* 2011-11-03 14:18: Create file
*/
package pl.asria.tools.display 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.display.DisplayObjectContainer;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	import pl.asria.tools.utils.trace.dtrace;
	
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public class SkinBase extends Sprite implements ISkin
	{
		public var workspace:DisplayObject;
		public var layerOver:Sprite = new Sprite();
		public var layerUnder:Sprite = new Sprite();
		private var _currentTarget:DisplayObjectContainer;
		private var _dDump:Dictionary = new Dictionary(true);
		private var lock:Boolean;
		private var _scaleY:Number;
		private var _scaleX:Number;
		private var _width:Number;
		private var _height:Number;
		
		public function SkinBase() 
		{
			workspace.visible = false;
			var below:Boolean = true;
			// layerize this skin
			var under:Array = [];
			var over:Array = [];
			for (var i:int = 0; i < numChildren; i++) 
			{
				// avoid add workspace object
				if (getChildAt(i) == workspace)
				{
					below = false;
					continue;
				}
				if (below)
					under.push(getChildAt(i));
				else
					over.push(getChildAt(i));
			}
			
			while (under.length) layerUnder.addChild(under.shift() as DisplayObject);
			while (over.length) layerOver.addChild(over.shift() as DisplayObject);
			
			addChildAt(layerUnder,0);
			addChild(layerOver);
			
			_dDump[workspace] = workspace.transform.matrix;
			_dDump[layerOver] = layerOver.transform.matrix;
			_dDump[layerUnder] = layerUnder.transform.matrix;
			lock = true;
			
		}
		override public function addChild(child:DisplayObject):flash.display.DisplayObject 
		{
			if (!lock) return super.addChild(child);
			dtrace("Please to add some children direct into layers: layerOver, layerUnder")
			return null;
		}
		override public function addChildAt(child:DisplayObject, index:int):flash.display.DisplayObject 
		{
			if (!lock) return super.addChildAt(child, index);
			dtrace("Please to add some children direct into layers: layerOver, layerUnder")
			return null;
		}
		
		
		public function injectSkin(target:DisplayObjectContainer):SkinBase
		{
			target.addChild(layerOver);
			target.addChildAt(layerUnder, 0);
			_currentTarget = target;
			return this;
		}
		
		
		/**
		 * Works ony for targets implements IWorkspace. After this, parameters are adopted to target workspace. 
		 * @return Returns <code>true</code> if target has IWorkspace interface otherwise <code>false</code>.
		 */
		public function adoptToTarget():Boolean
		{
			if (!(_currentTarget && _currentTarget is IWorkspace) ) return false;
			
			var targer:IWorkspace = _currentTarget as IWorkspace;
			var _wsTar:Rectangle = targer.getWorkspace();
			var _ws:Rectangle = getWorkspace();
			//trace(_ws, _wsTar);
			scaleX =  targer.getWorkspace().width / getWorkspace().width;
			scaleY =  targer.getWorkspace().height / getWorkspace().height;
			
			_wsTar = targer.getWorkspace();
			_ws = getWorkspace();
			//trace(_ws, _wsTar);
			
			x += targer.getWorkspace().x -  getWorkspace().x;
			y += targer.getWorkspace().y -  getWorkspace().y;
			return true;
		}
		
		public function removeSkin():Boolean
		{
			if (_currentTarget)
			{
				if (layerOver.parent == _currentTarget) _currentTarget.removeChild(layerOver);
				if (layerUnder.parent == _currentTarget) _currentTarget.removeChild(layerUnder);
				return true;
			}
			return false;
		}
		
		public function restore(remove:Boolean):SkinBase
		{
			if (remove) removeSkin();
			for each (var layer:Sprite in [layerOver, layerUnder, workspace])
			{
				layer.transform.matrix = _dDump[layer]
			}
			return this;
		}
		
		override public function get rotationZ():Number 
		{
			return layerOver.rotationZ;
		}
		
		override public function set rotationZ(value:Number):void 
		{
			workspace.rotationZ = value;
			layerOver.rotationZ = value;
			layerUnder.rotationZ = value;
		}
		
		override public function get rotation():Number 
		{
			return layerUnder.rotation;
		}
		
		override public function set rotation(value:Number):void 
		{
			workspace.rotation = value;
			layerUnder.rotation = value;
			layerOver.rotation = value;
		}
		
		override public function get y():Number 
		{
			return layerOver.y;
		}
		
		override public function set y(value:Number):void 
		{
			workspace.y = value;
			layerOver.y = value;
			layerUnder.y = value;
		}
		override public function get x():Number 
		{
			return layerUnder.x;
		}
		
		override public function set x(value:Number):void 
		{
			workspace.x = value;
			layerUnder.x = value;
			layerOver.x = value;
		}
		override public function get scaleX():Number 
		{
			//return layerOver.scaleX;
			return _scaleX;
		}
		
		override public function set scaleX(value:Number):void 
		{
			_scaleX = value;
			workspace.scaleX = value;
			layerOver.scaleX = value;
			layerUnder.scaleX = value;
		}
		
		override public function get scaleY():Number 
		{
			return _scaleY;
		}
		
		override public function set scaleY(value:Number):void 
		{
			_scaleY = value;
			workspace.scaleY = value;
			layerUnder.scaleY = value;
			layerOver.scaleY = value;
		}
		
		override public function get width():Number 
		{
			//return layerOver.width;
			return _width;
		}
		
		override public function set width(value:Number):void 
		{
			_width = value;
			workspace.width = value;
			layerOver.width = value;
			layerUnder.width = value;
		}
		
		override public function get height():Number 
		{
			//return layerUnder.height;
			return _height;
		}
		
		override public function set height(value:Number):void 
		{
			_height = value;
			workspace.height = value;
			layerUnder.height = value;
			layerOver.height = value;
		}

		public function getWorkspace():Rectangle 
		{
			return workspace.getBounds(this);
		}
		
		public function get currentTarget():DisplayObjectContainer 
		{
			return _currentTarget;
		}
		
	}
}
