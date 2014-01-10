/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-04-18 08:48</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.display.ui 
{
	import com.greensock.plugins.BlurFilterPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/** 
	* Dispatched when ... 
	**/
	[Event(name="showEnd", type="pl.asria.tools.display.ui.BaloonTipEvent")]
	/** 
	* Dispatched when ... 
	**/
	[Event(name="showBegin", type="pl.asria.tools.display.ui.BaloonTipEvent")]
	/** 
	* Dispatched when ... 
	**/
	[Event(name="hideEnd", type="pl.asria.tools.display.ui.BaloonTipEvent")]
	/** 
	* Dispatched when ... 
	**/
	[Event(name="hideBegin", type="pl.asria.tools.display.ui.BaloonTipEvent")]
	
	public class BaloonTip extends Sprite
	{
		public static const STATE_HIDE_END:int = 0;
		public static const STATE_HIDE_START:int = 1;
		public static const STATE_HIDE_PROCESS:int = 2;
		public static const STATE_SHOW_END:int = 3;
		public static const STATE_SHOW_START:int = 4;
		public static const STATE_SHOW_PROCESS:int = 5;

		protected var _view:Sprite;
		protected var _content:DisplayObject;
		protected var _body:Sprite;
		protected var _state:int = STATE_HIDE_END;
		protected var _pendingContent:DisplayObject;
		protected var _offset:Point;
		protected var _visible:Boolean;
		
		
		/**
		 * BaloonTip - Base baloon tip behawior like: appear, disappear, swap content
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function BaloonTip() 
		{
			TweenPlugin.activate([BlurFilterPlugin]);
			mouseChildren = false;
			mouseEnabled = false;
		}
		
		public function setView(view:Sprite, offset:Point = null):void
		{
			_offset = offset || new Point();
			_view = view;
			_body = new Sprite();
			prepareView();
			addChild(_body);
			_body.addChild(_view);
		}
		
		protected function prepareView():void 
		{
			_view.mouseEnabled = false;
			_view.mouseChildren = false;
		}
		
		public function setContent(content:DisplayObject, inmediatly:Boolean = false):void
		{
			//_content = content;
			
			_pendingContent = content;
			if (_pendingContent is Sprite)
			{
				(_pendingContent as Sprite).mouseEnabled = false;
				(_pendingContent as Sprite).mouseChildren = false;
			}
			
			if (inmediatly)
			{
				injectPendingContent()
			}
		}
		
		protected function injectPendingContent():void 
		{
			if (_pendingContent)
			{
				cleanContent();
				_body.alpha = 0;
				_content = _pendingContent;
				
				_body.addChild(_content);
				// placement content
				contentPlacement();
				
				// fit graphic to content
				fitBackgrountToContent();
				_pendingContent = null;
			}
		}
		
		protected function contentPlacement():void 
		{
			_content.x = 0;
			_content.y = 0;
		}
		
		protected function fitBackgrountToContent():void 
		{
			var bounds:Rectangle = _content.getBounds(this);
			_view.width = _offset.x  + bounds.width;
			_view.height = _offset.y  + bounds.height;
			
		}
		
		public function hide():void
		{
			if (_visible)
			{
				_visible = false;
				hideProcessBegin();
				hideProcessExecutive();
				//hideProcessEnd();
			}
		}
		
		protected function hideProcessBegin():void
		{
			dispatchEvent(new BaloonTipEvent(BaloonTipEvent.HIDE_BEGIN));
			_state = STATE_SHOW_START;
		}
		
		private function hideProcessExecutive():void
		{
			_state = STATE_HIDE_PROCESS;
			//_content.x = -10;
			TweenLite.to(_body, 0.15, {alpha:0, x:10, blurFilter:{blurX:20}, onComplete:hideProcessEnd} );
		}
		
		protected function hideProcessEnd():void
		{
			dispatchEvent(new BaloonTipEvent(BaloonTipEvent.HIDE_END));
			_state = STATE_HIDE_END;
			cleanContent();
		}
		
		protected function cleanContent():void 
		{
			if (_content)
			{
				if (_content.parent == _body)
				{
					_body.removeChild(_content);
				}
				_content = null;
			}
		}
		
		
		public function show():void
		{
			if (!_visible)
			{
				_visible = true;
				showProcessBegin();
				showProcessExecutive();
				//showProcessEnd();
			}
		}
		
		protected function showProcessBegin():void
		{
			dispatchEvent(new BaloonTipEvent(BaloonTipEvent.SHOW_BEGIN));
			_state = STATE_SHOW_START;
			injectPendingContent();
		}
		
		private function showProcessExecutive():void
		{
			_state = STATE_SHOW_PROCESS;
			_body.x = -10;
			TweenLite.to(_body, 0.2, { alpha:1, x:0, blurFilter:{blurX:0}, onComplete:showProcessEnd } );
		}
		
		protected function showProcessEnd():void
		{
			dispatchEvent(new BaloonTipEvent(BaloonTipEvent.SHOW_END));
			_state = STATE_SHOW_END;
		}
	}

}