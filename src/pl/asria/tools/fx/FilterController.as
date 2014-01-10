/**
 * CHANGELOG:
 *
 * <ul>
 * <li><b>1.0</b> - 2012-04-23 10:02</li>
 *	<ul>
 *		<li>Create file</li>
 *	</ul>
 * </ul>
 * @author Piotr Paczkowski - kontakt@trzeci.eu
 */
package pl.asria.tools.fx
{
	import com.greensock.TweenLite;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import pl.asria.tools.display.catche.Renderer;
	
	/**
	 * Dispatched when show animation is done
	 **/
	[Event(name="completeShow",type="flash.events.Event")]
	/**
	 * Dispatched when hide animation is done
	 **/
	[Event(name="completeHide",type="flash.events.Event")]
	
	/** 
	* Dispatched when ... 
	**/
	[Event(name="startHide", type="flash.events.Event")]
	/** 
	* Dispatched when ... 
	**/
	[Event(name="startShow", type="flash.events.Event")]
	public class FilterController extends EventDispatcher
	{
		/** dispatched after complete show animation **/
		public static const COMPLETE_SHOW:String = "completeShow";
		/** dispatched after complete hid animation  **/
		public static const COMPLETE_HIDE:String = "completeHide";
		/**  **/
		public static const START_HIDE:String = "startHide";
		/**  **/
		public static const START_SHOW:String = "startShow";
		
		protected var _target:Sprite;
		protected var _renderer:Renderer
		protected var _filtredBitmap:BitmapData;;
		protected var _tnShow:TweenLite;
		protected var _tnHide:TweenLite;
		protected var _filters:Array;
		protected var _filterBounds:Rectangle;
		protected var _colorTransform:ColorTransform;
		
		/**
		 * FilterController - Fx to repleace some content with blurred mirror
		 * @usage -
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function FilterController(target:Sprite)
		{
			_target = target;
			_renderer = new Renderer();
		}
		
		public function show(time:Number ):void
		{
			dispatchEvent(new Event(FilterController.START_SHOW));
			// stop source
			//_target.stop(); by listener
			
			// make blur mirror
			
			if (!_filtredBitmap) // reuse cached bitmap (scenarion, when during hide process is started show process)
			{
				
				var bitmapData:BitmapData = new BitmapData(_filterBounds.width, _filterBounds.height, true, 0x00FFFFFF);
				bitmapData.lock();
				bitmapData.draw(_target, new Matrix(1, 0, 0, 1, _filterBounds.x, _filterBounds.y), _colorTransform, null, null, true);
				
				
				if (!_filters || !_filters.length) // omnit adopt filters
				{
					_filtredBitmap = bitmapData;
				}
				else
				{
					_filtredBitmap = new BitmapData(bitmapData.width, bitmapData.height, true, 0x00FFFFFF);
					_filtredBitmap.lock();
					for (var i:int = 0, i_max:int = _filters.length; i < i_max; i++) 
					{
						_filtredBitmap.applyFilter(bitmapData, new Rectangle(0,0,bitmapData.width, bitmapData.height), new Point(), _filters[i]);
					}
					
					bitmapData.dispose();
				}
				
				// for sure is needed, only when is created new one, no more.
				_renderer.bitmapData = _filtredBitmap;
				_filtredBitmap.unlock();
			}
			
			
			
			// start repleace animation
			
			if (_tnHide)
			{
				time = time * (1 - _tnHide.currentTime / _tnHide.duration);
				_tnHide.kill();
				_tnHide = null;
			}
			else
			{
				_renderer.alpha = 0;
			}
			
			_tnShow = TweenLite.to(_renderer, time, {alpha: 1, onComplete: completeShowAnimation});
		}
		
		public function hide(time:Number):void
		{
			//_renderer.alpha = 0;
			dispatchEvent(new Event(FilterController.START_HIDE));
			if (_tnShow)
			{
				time = time * (1 - _tnShow.currentTime / _tnShow.duration);
				_tnShow.kill();
				_tnShow = null;
			}
			_tnHide = TweenLite.to(_renderer, time, {alpha: 0, onComplete: completeHideAnimation});
		}
		
		protected function completeHideAnimation():void
		{
			_tnHide = null;
			dispatchEvent(new Event(FilterController.COMPLETE_HIDE));
			disposeCache();
			//_target.play(); by listener
		
		}
		
		public function disposeCache():void
		{
			if (_filtredBitmap)
			{
				_filtredBitmap.lock();
				_filtredBitmap.dispose();
				_filtredBitmap = null;
			}
		}
		
		public function initFilter(filterBounds:Rectangle, filters:Array, colorTransform:ColorTransform = null):void 
		{
			_colorTransform = colorTransform;
			_filterBounds = filterBounds;
			_filters = filters;
		}
		
		protected function completeShowAnimation():void
		{
			_tnShow = null;
			dispatchEvent(new Event(FilterController.COMPLETE_SHOW));
		}
		
		public function get renderer():Renderer
		{
			return _renderer;
		}
	}

}