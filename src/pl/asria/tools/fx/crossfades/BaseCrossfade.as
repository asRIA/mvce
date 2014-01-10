package pl.asria.tools.fx.crossfades 
{
	import com.greensock.TweenLite;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public class BaseCrossfade 
	{
		private var _graphic:Sprite = new Sprite();
		private var _content:DisplayObjectContainer;
		private var _onCompleteHide:Function;
		private var _isFadeIn:Boolean;
		private var _aCompleteIn:Array = [];
		private var _aCompleteOut:Array = [];
		public var dimenision:Point;
		
		public function BaseCrossfade():void
		{
			_graphic.graphics.beginFill(0x000000);
			_graphic.graphics.drawRect(0, 0, 100, 100);
			_graphic.cacheAsBitmap = true;
		}
		
		public function setCrossFadeGraphic(content:DisplayObjectContainer, graphic:Sprite = null, widthHeight:Point = null):void
		{
			dimenision = widthHeight;
			_content = content;
			_graphic = graphic || _graphic;
		}
		
		public function fadeIn(onComplete:Function = null, time:Number = 0.4, toAlpha:Number = 1, delay:Number = 0):void
		{
			_aCompleteIn.push(onComplete);
			//if (_isFadeIn)return;
			_isFadeIn = true;
			_graphic.alpha = 0;
			_content.addChild(_graphic);
			
			if (!dimenision)
			{
				_graphic.width = (_content is Stage)?_content["stageWidth"]:_content.width;
				_graphic.height = (_content is Stage)?_content["stageHeight"]:_content.height;
			}
			else
			{
				_graphic.width = dimenision.x;
				_graphic.height = dimenision.y;
			}
			TweenLite.killTweensOf(_graphic);
			TweenLite.to(_graphic, time, {alpha:toAlpha, onComplete:onCompleteShow, delay:delay});
		}
		
		private function onCompleteShow():void 
		{
			while(_aCompleteIn.length)
			{
				var f:Function = _aCompleteIn.pop();
				if (f!=null) f();
			}
		}
		
		public function fadeOut(onComplete:Function= null, time:Number = 0.4):void
		{
			_onCompleteHide = onComplete;
			_aCompleteOut.push(onComplete);
			TweenLite.killTweensOf(_graphic);
			TweenLite.to(_graphic, time, {alpha:0, onComplete:onCompleteHide});
		}
		
		private function onCompleteHide():void 
		{
			if (!_isFadeIn) return;
			_isFadeIn = false;
			_content.removeChild(_graphic);
			
			while(_aCompleteOut.length)
			{
				var f:Function = _aCompleteOut.pop();
				if (f!=null) f();
			}
			//if (_onCompleteHide != null) {
				//_onCompleteHide();
				//_onCompleteHide = null;
			//}
		}
	}

}