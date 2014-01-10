package pl.asria.tools.display.proxy 
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	
	public class ProxyObject extends Sprite
	{
		private var _useProxy:Boolean = true;
		
		private var _proxyMode:Boolean = false;
		
		private var _target:DisplayObjectContainer;
		public function ProxyObject(view:DisplayObjectContainer = null) 
		{
			_target = view || this;
			if(_target.stage) onAddedToStageHandler();
			else _target.addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
		}
		
		private function onAddedToStageHandler(e:Event = null):void 
		{
			_target.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
			if (!_proxyMode && _useProxy)
			{
				use namespace proxy;
				ProxyManager.request(this, _target);
				use namespace AS3;
			}
		}
		
		[Inspectable (name = "useProxy", variable = "useProxy", type = "Boolean", defaultValue = 'true', category = 'Other')]
		public function get useProxy():Boolean 
		{
			return _useProxy;
		}
		
		public function set useProxy(value:Boolean):void 
		{
			_useProxy = value;
		}
		
		proxy function adoptObject(reference:DisplayObject):void
		{
			var _rect:Rectangle;
			if (_target.getChildByName("ws"))
			{
				_rect = _target.getChildByName("ws").getBounds(_target);
			}
			else
			{
				_rect = _target.getBounds(_target);
			}
			_target.addChild(reference);
			reference.alpha = 0;
			if (checkProtectedSwap(_target))
			{
				TweenLite.to(reference, 0.3, { alpha:1, onComplete:proxy::removeMocupsAdnim, onCompleteParams:[reference]});
			}
			else
			{
				TweenLite.to(reference, 0.3, { alpha:1, onComplete:proxy::removeMocups});
			}
			
			reference.x = _rect.x;
			reference.y = _rect.y;
		}
		
		proxy function removeMocupsAdnim(avoid:DisplayObject = null):void
		{
			var childs:Array = [];
			var child:DisplayObject;
			for (var i:int = 0; i < _target.numChildren; i++) 
			{
				child = _target.getChildAt(i)
				if(child != avoid)
					childs.push(child);
			}
			TweenMax.allTo(childs, 1, {alpha:0, onComplete:proxy::removeMocups});
		}
		proxy function removeMocups():void
		{
			while (_target.numChildren > 1) _target.removeChildAt(0);
		}
		
		static private function checkProtectedSwap(obejct:Object):Boolean
		{
			var _class:String = getQualifiedClassName(obejct);
			return _class.indexOf("protected")>=0;
		}
	}

}